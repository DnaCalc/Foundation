Here are 10 improvements that look especially high-leverage if the aim is to serve the Foundation charter rather than just grow code volume.

1. **Make the host ladder an explicit conformance ladder.**
   Right now the host progression is useful as a development path, but it becomes much more powerful if each host is defined by the exact semantic surface it is supposed to stabilize and the exact packs/artifacts it must emit before the next host may rely on it. That fits the charter’s “profiles are the semantics spine,” “spec-first,” and “computed obligations” doctrine, and it keeps pathfinders from turning into vague demos. Concretely: DNA VbCalc should certify OxVba host/runtime seams, DNA OneCalc should certify single-node formula/value/function semantics, DNA TreeCalc should certify non-grid dependency and recalculation semantics, and DNA PreCalc should certify first tree-grid-hybrid semantics.  

2. **Create a repo-level dependency constitution.**
   You already clarified one important rule: OxVba is independent of OxFunc and OxFml. I would formalize this for the whole program in one small normative table: who may depend on whom, and in what direction only. That reduces ownership drift and prevents accidental coupling that would later make verification and substitution harder. This is directly aligned with the architecture’s lane split and the charter’s design-for-evolution principle.  

3. **Introduce a mandatory “promotion gate” between pathfinder findings and Foundation doctrine.**
   The operations docs already distinguish prompt/research/synthesis/reference runs, but the overall program would benefit from a stricter rule that no host-repo insight becomes Foundation architecture or doctrine until it is promoted with exact target text, evidence, open questions, and pack impact. That prevents architecture drift caused by attractive implementation discoveries.  

4. **Separate semantic truth from runtime strategy everywhere, not just in core-engine research.**
   This is one of the biggest long-term risk reducers. The program should consistently define semantics independently from scheduling or optimization choices, so that OxCalc can evolve from simple recompute to more advanced incremental methods without semantic churn. The DAG research synthesis is very strong on this point, and it matches the charter’s requirement for stable, evolvable interfaces.  

5. **Make invalidation and staleness first-class across all hosts.**
   One recurring failure mode in spreadsheet engines is that “dirty,” “stale,” “necessary,” “pending,” and similar states remain implicit. If Foundation wants correctness under concurrency and explainable recalc, the whole family should standardize a small shared invalidation vocabulary early, even if each host only uses part of it. This will pay off immediately in TreeCalc and PreCalc, and later in UI/API trustworthiness.  

6. **Invest earlier in shared trace schemas and replay artifacts.**
   The charter and operations model are already oriented around deterministic replay, minimized regressions, and artifact-based readiness. A major improvement would be to define shared trace families now for host actions, eval actions, dependency observations, structural rewrites, and external update envelopes, even if some fields stay optional at first. That creates continuity from OneCalc through PreCalc instead of reinventing traces at each level.   

7. **Define a minimal cross-repo identity model before deeper implementation expands.**
   Even with the core engine design still under review, the project would benefit from an early shared stance on stable identities versus display/address projections. The existing architecture already points toward ID-based identity rather than coordinate-string identity. Locking a minimal identity doctrine now will reduce churn later in OxFml bind results, OxCalc graph nodes, persistence, traces, and structural-rewrite semantics.  

8. **Promote “degradation class” to a first-class planning axis for every host.**
   The charter is clear that unsupported behavior must degrade explicitly and never crash. A practical improvement is to require each host charter to declare, by major feature family, whether unsupported behavior is expected to be Native, Lowered, Opaque, or Rejected. That will make early hosts much cleaner because incompleteness becomes structured rather than ad hoc.  

9. **Create a small “host acceptance matrix” for the Excel-compatibility surface.**
   Not everything needs full parity at once, but each host should declare which Excel behaviors are in-scope as semantic commitments, which are experimental, and which are intentionally deferred. That sharpens charters, improves pack computation, and avoids the common trap where a pathfinder is judged against the full future vision. The current architecture and pathfinder notes already hint at this style through explicit non-goals and required obligations; extending that discipline across all new hosts would materially improve execution.  

10. **Stand up one canonical “theory-to-pack” register owned by Foundation.**
    The project has strong theory inputs—SCC scheduling, fixed-point semantics, dynamic dependency safety, replay determinism—but they become most valuable when every theorem-like idea is mapped to either a proof obligation, a conformance row, an empirical pack, or an explicitly deferred item. That keeps the project faithful to the charter’s coupled assurance stack and prevents beautiful theory from floating above implementation reality.   

The three I would elevate above the rest are: the **repo dependency constitution**, the **host-as-conformance-ladder model**, and the **shared trace/replay schema**. Those would improve clarity, reduce accidental coupling, and make later formalization much easier.
