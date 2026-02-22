*Posted by Codex agent on behalf of @govert*

# Prompt Pack Run: 09_canvas_grid_reliability_test_strategy

## Source-truth check
- Documents used: `CHARTER.md`, `OPERATIONS.md`, `ARCHITECTURE_AND_REQUIREMENTS.md`, `notes/BRAINSTORM_NOTES.md`.
- Direct contradiction found: none.
- Ambiguity to resolve: `ARCHITECTURE_AND_REQUIREMENTS.md` section 3.10 says view state is partly document-backed and partly session state, while `notes/BRAINSTORM_NOTES.md` section N leaves the split open.
- Coherent resolution: define a fixed ownership matrix now (below), and encode persistence policy as explicit fields in the reducer schema.

## 1) Minimal view-state reducer model

### State shape (minimum viable)

```ts
type UIMode =
  | 'select'
  | 'edit'
  | 'formula_ref_pick'
  | 'fill_drag'
  | 'resize_drag'
  | 'scroll_drag';

type ViewState = {
  sheetId: string;
  mode: UIMode;
  selection: RectRef;            // model coordinate rect
  activeCell: CellRef;           // always inside selection
  viewport: {
    scrollX: number;
    scrollY: number;
    widthPx: number;
    heightPx: number;
    zoom: number;
    frozenRows: number;
    frozenCols: number;
  };
  editor: {
    visible: boolean;
    text: string;
    caret: number;
    imeComposing: boolean;
  };
  drag: null | {
    kind: 'fill' | 'resize_row' | 'resize_col' | 'select';
    start: PointPx;
    current: PointPx;
  };
  formulaPick: null | {
    baseCell: CellRef;
    hoveredRef: RectRef | null;
  };
  staleOverlay: {
    enabled: boolean;
    stabilizedEpoch: number;
    committedEpoch: number;
  };
};
```

### Transition table (key events)

| Event | From | Guard | To | Notes |
|---|---|---|---|---|
| `PointerDownCell(cell)` | `select` | none | `select` | set `activeCell`, start selection anchor |
| `PointerDragCell(cell)` | `select` | pointer captured | `select` | update selection rect |
| `DoubleClickCell(cell)` | `select` | editable target | `edit` | show DOM editor |
| `KeyEnter` | `select` | none | `edit` | edit active cell |
| `KeyEscape` | `edit` | none | `select` | cancel pending editor text |
| `EditorCommit` | `edit` | parse ok or text accepted | `select` | dispatch op via adapter |
| `FormulaRefStart` | `edit` | editor text starts with `=` | `formula_ref_pick` | track live ref insertion |
| `FormulaRefApply(rect)` | `formula_ref_pick` | none | `edit` | inserts ref token, keep editor open |
| `FillHandleDown` | `select` | selection has fill handle | `fill_drag` | begin fill preview |
| `FillHandleUp` | `fill_drag` | none | `select` | dispatch fill op |
| `ResizeHandleDown` | `select` | over header boundary | `resize_drag` | start row/col resize |
| `ResizeHandleUp` | `resize_drag` | none | `select` | dispatch resize op |
| `Scroll(delta)` | any | none | same | viewport shift, no mode mutation |

### Reducer invariants
- `activeCell` is always contained in `selection`.
- `mode === 'edit'` implies `editor.visible === true`.
- `mode === 'formula_ref_pick'` implies `editor.visible === true` and `formulaPick != null`.
- `drag != null` iff mode in `{fill_drag, resize_drag}`.
- `committedEpoch >= stabilizedEpoch` always holds in `staleOverlay`.

ASCII mode map:

```text
select -> edit -> formula_ref_pick
  ^        |            |
  |        v            v
  +----- commit/cancel <-+

select -> fill_drag -> select
select -> resize_drag -> select
```

## 2) Geometry/hit-test functions + property-test invariants

### Pure functions
- `xToCol(layout, xPx) -> ColIndex`
- `yToRow(layout, yPx) -> RowIndex`
- `cellRect(layout, row, col) -> RectPx`
- `visibleRange(layout, viewport) -> RectRef`
- `hitTest(layout, viewport, pointPx) -> HitTarget`
- `normalizeSelection(anchor, head) -> RectRef`
- `headerResizeHit(layout, pointPx, tolerancePx) -> ResizeTarget | null`

### Property-test invariants (for `PACK.ui.viewport`)
| ID | Invariant | Property idea |
|---|---|---|
| `UI-GEO-001` | No gaps/overlaps in visible row/col spans | Adjacent rect edges are contiguous; intersection area of distinct cells is 0 |
| `UI-GEO-002` | Hit-test/draw consistency | `point` sampled inside `cellRect(r,c)` returns that cell |
| `UI-GEO-003` | Monotonic mapping | if `x1 < x2` then `xToCol(x1) <= xToCol(x2)` (same for rows) |
| `UI-GEO-004` | Round-trip containment | `x in [rect.left, rect.right)` for `col = xToCol(x)` |
| `UI-GEO-005` | Frozen pane precedence | hits in frozen bands resolve to frozen cells regardless of scroll offset |
| `UI-GEO-006` | Scroll translation law | hit at `(x,y)` with `scroll+s` equals hit at `(x+s,y)` before scroll (non-frozen area) |
| `UI-GEO-007` | Selection normalization | normalized rect always has `r1<=r2`, `c1<=c2`, idempotent |

### Test method
- Use property-based generators for row/col width distributions, frozen pane settings, zoom buckets, and random points.
- Run in deterministic mode with seeded generators.
- Emit minimized counterexample traces into regression corpus.

## 3) RenderPlan IR and screenshot-free testing

### RenderPlan IR sketch

```ts
type DrawOp =
  | { op: 'clip_rect'; rect: RectPx; layer: Layer }
  | { op: 'fill_rect'; rect: RectPx; color: ColorToken; layer: Layer }
  | { op: 'stroke_rect'; rect: RectPx; color: ColorToken; width: number; layer: Layer }
  | { op: 'text_run'; rect: RectPx; text: string; font: FontToken; color: ColorToken; align: Align; layer: Layer }
  | { op: 'line'; x1: number; y1: number; x2: number; y2: number; color: ColorToken; width: number; layer: Layer };

type RenderPlan = {
  sheetId: string;
  viewport: { x: number; y: number; w: number; h: number; zoom: number };
  epoch: { committed: number; stabilized: number };
  ops: DrawOp[];   // stable order: layer -> z -> row -> col
};
```

### IR invariants
- Stable ordering for same input state (deterministic serialization).
- All op coordinates finite and clip-bounded.
- No `text_run` without resolved font token.
- Selection/stale overlays always in layers above grid content.

### Tests without screenshots
- Golden IR snapshots: compare normalized JSON `RenderPlan` output, not pixels.
- Semantic assertions: op counts by layer, bounding boxes, and required markers (selection border, stale badge).
- Metamorphic tests:
  - Whole-row scroll shift should preserve relative intra-cell geometry.
  - Switching from `select` to `edit` only changes overlay/editor-related ops.
- Cross-check test: `hitTest` on a sampled point over a `text_run` cell maps to the same logical cell.
- Adapter contract test: replay IR to a mock canvas command sink and verify exact command sequence.

## 4) Virtualization and caching plan

### Tile strategy
- Tile size: start `256px` logical tiles; bucket by DPR/zoom.
- Tile key: `(sheetId, zoomBucket, tileX, tileY, styleEpoch, valueEpoch)`.
- Overscan: render viewport + 1 tile margin in each direction.
- Prefetch: prioritize scroll direction edge tiles first.

### Dirty rectangle pipeline
1. Collect dirty cell rects from model deltas.
2. Expand to affected visual artifacts (gridlines, borders, merged spans, overlays).
3. Union/clip into dirty rect set.
4. Map dirty rects to tile keys.
5. Rebuild only invalid tiles and compose.

### Caches
| Cache | Key | Invalidated by | Bound |
|---|---|---|---|
| Text measure | `fontToken + text + zoomBucket` | font/theme/zoom change | LRU by entry count + byte estimate |
| Cell layout | `sheetId + row + col + styleEpoch` | style/format changes | viewport-scoped + small spillover |
| Tile bitmap | tile key above | any dirty overlap or epoch bump | memory budget with LRU eviction |
| Row/col prefix sums | `sheetId + dimensionEpoch` | resize/insert/delete | full recompute on dimension epoch change |

### Reliability constraints
- All caches are optional accelerators; cache miss must produce identical output.
- Cache key includes epochs so stale data cannot be reused across committed changes.
- Memory budget breach triggers deterministic eviction policy.

## 5) Model vs View vs Adapter ownership

| Concern | Model (pure/reducer) | View (Canvas + DOM shell) | Adapter (Tauri/protocol/platform) |
|---|---|---|---|
| Mode transitions | Yes | No | No |
| Selection semantics | Yes | No | No |
| Geometry + hit-test math | Yes | No | No |
| RenderPlan generation | Yes | No | No |
| Frame scheduling (`requestAnimationFrame`) | No | Yes | No |
| Pointer/keyboard event capture | No | Yes | No |
| IME composition events | No | Yes | No |
| Engine op dispatch | No | No | Yes |
| Clipboard/OS integration | No | No | Yes |
| File/protocol I/O | No | No | Yes |

Decision rule:
- Put behavior in model when it must be deterministic/testable without browser APIs.
- Put behavior in view when it is rendering lifecycle or DOM focus plumbing.
- Put behavior in adapter when it crosses process/platform/protocol boundaries.

## Proposed doc edits (exact targets)

| File | Section to edit | Change |
|---|---|---|
| `ARCHITECTURE_AND_REQUIREMENTS.md` | `3.10 UI Architecture (intended stack)` | Add `REAL-UI-001` reducer states/transitions, `REAL-UI-002` geometry invariants, `REAL-UI-003` RenderPlan determinism contract, `REAL-UI-004` model/view/adapter split |
| `OPERATIONS.md` | `4.1 Packs` under `PACK.ui.viewport` | Add explicit check IDs `UI-GEO-001..007`, `UI-RP-001..004`, and required property/golden/metamorphic tests |
| `OPERATIONS.md` | `5. Regression Handling (AAR-driven)` | Require minimized UI counterexample traces (geometry/hit-test/renderplan) to be stored as fixtures |

## Smallest next actions (highest risk reduction)
1. Implement reducer + pure geometry/hit-test module with property tests for `UI-GEO-001..007`.
2. Add RenderPlan serializer and golden test harness (JSON snapshots + metamorphic checks).
3. Wire dirty-rect to tile invalidation path with metrics (`tiles_rebuilt`, `cache_hit_rate`, `text_measure_miss`).
4. Land doc updates in the exact sections above so `PACK.ui.viewport` can gate stabilization.