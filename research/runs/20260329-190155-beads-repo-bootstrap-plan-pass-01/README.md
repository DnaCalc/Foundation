## 20260329-190155 Beads Repo Bootstrap Plan Pass 01

### Purpose
Review the current beads-based repo doctrine in `OxVba` and `C:\Work\WinTermDriver`, compare it to Foundation's current repo-bootstrap pattern, and define the recommended bootstrap model for future DnaCalc repos starting with `DnaOneCalc`.

### Scope
This is a planning pass only.

It does not update Foundation source-of-truth guidance yet.
It defines the intended direction and the concrete repo ingredients needed for a new repo bootstrap under the beads method.

### Outputs
1. `outputs/01_beads_doctrine_review.md`
2. `outputs/02_foundation_repo_creation_guidance_changes.md`
3. `outputs/03_dnaonecalc_repo_bootstrap_ingredients.md`
4. `outputs/source_list.csv`

### Main conclusion
The right DnaCalc default is the newer `OxVba` model:
1. engineering spec remains the broad design authority,
2. worksets remain the umbrella planning unit,
3. active execution proceeds through a serialized `workset -> epic -> bead` graph,
4. one living all-worksets register replaces the idea of one document per workset,
5. `br` is mandatory for bead mutation,
6. `bv` is useful and should be supported, but it is optional rather than constitutive,
7. WinTermDriver contributes useful `bv` and runner ideas, but its auto-runner assumptions should not become Foundation-wide doctrine.
