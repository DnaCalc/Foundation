# VBA Program Test Corpus

Curated VBA programs for cross-environment conformance comparison between Excel VBA and OxVBA. Each program can run in both environments, producing identical `Debug.Print` output.

## Layout

- `CORPUS_MANIFEST.json`: aggregate statistics and metadata.
- `packets/VTC-NNNN/`: one directory per test packet, each containing:
  - `metadata.json`: per-packet metadata (schema below).
  - `main.bas`: primary standard module (always present).
  - Additional `.bas` or `.cls` files for multi-module packets.

## Packet Schema (metadata.json, v1.0.0)

| Field | Type | Req | Description |
|---|---|---|---|
| `test_id` | string | yes | `VTC-NNNN` (zero-padded 4-digit) |
| `title` | string | yes | Short human-readable name |
| `description` | string | yes | What the program does |
| `category` | string | yes | Category slug (see taxonomy below) |
| `subcategory` | string | yes | Finer grouping within category |
| `tags` | string[] | yes | Searchable feature tags |
| `complexity` | enum | yes | `trivial` / `simple` / `moderate` / `complex` / `expert` |
| `language_features` | string[] | yes | VBA language features exercised |
| `stdlib_functions` | string[] | yes | Built-in functions used |
| `modules` | object[] | yes | `[{filename, kind, description}]` where kind is `standard` or `class` |
| `entry_point` | string | yes | Entry sub, e.g. `"Main"` |
| `requires_com` | boolean | yes | Whether COM interop is needed |
| `requires_host_objects` | boolean | yes | Whether Excel/host object model is needed |
| `deterministic` | boolean | yes | Whether output is deterministic |
| `source_ids` | string[] | no | `R-SRC-*` provenance links into `research/sources.csv` |
| `provenance` | enum | yes | `authored` / `adapted` |
| `provenance_detail` | string | yes | Human-readable provenance explanation |
| `notes` | string | no | Additional context |

## Category Taxonomy

| Slug | Description |
|---|---|
| `string_manipulation` | String processing, parsing, formatting |
| `math_numeric` | Mathematical computations, numeric algorithms |
| `sorting_searching` | Sort and search algorithms |
| `data_structures` | Collections, arrays, stacks, queues |
| `control_flow` | Loops, conditionals, GoSub, Select Case |
| `error_handling` | On Error, Err object, Resume patterns |
| `type_coercion` | Implicit/explicit type conversion |
| `class_oop` | Class modules, properties, lifecycle |
| `stdlib_exercise` | Exercising VBA built-in library functions |
| `financial` | Financial functions (PV, FV, PMT) |
| `array_processing` | Array operations, ReDim, multi-dimensional |

## Dual-Environment Compatibility Rules

All programs in this corpus follow these rules to ensure they run in both Excel VBA and OxVBA:

- Always use `Sub Main()` as entry point.
- Use `Debug.Print` for output (Immediate Window in Excel, stdout in OxVBA).
- No `MsgBox`, `InputBox`, or GUI calls.
- No Excel object model references (Application, Range, Worksheet, etc.).
- No `CreateObject` / COM unless `requires_com` is true.
- No file I/O statements, no `Declare` (FFI).
- `Option Explicit` is used in all modules.

## Governance

- **Clean-room rule applies**: all test material derives from public documentation, published algorithm descriptions, or adaptation of attributed open-source test suites.
- **Provenance is mandatory**: every packet tracks its source via `source_ids` linking to `research/sources.csv` (`R-SRC-*`).

## Relationship to OxVBA Conformance Tests

The OxVBA repo has 213 low-level conformance tests at `../OxVba/conformance/tests/` that probe individual language features using slot-based verification. This Foundation corpus is complementary: higher-level programs that produce `Debug.Print` output, with richer metadata and a dual-environment guarantee.

Some packets are adapted from OxVBA conformance tests (tracked via `provenance: "adapted"` and `source_ids`), rewritten into natural program style with meaningful variable names and `Debug.Print` output.
