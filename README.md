# PhysioAnnotationHub

<!-- badges: start -->
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![R-universe](https://x-biosignal.r-universe.dev/badges/PhysioAnnotationHub)](https://x-biosignal.r-universe.dev/PhysioAnnotationHub)
<!-- badges: end -->

**Anatomical and Clinical Knowledge Graph for Physiological Data**

PhysioAnnotationHub is a lightweight, centralized annotation hub for the
[PhysioExperiment](https://github.com/x-biosignal/PhysioExperiment) ecosystem.
It bundles curated anatomical ontology data -- muscles, bones, nerves, and
clinical codes -- and exposes them through a simple query interface and a
traversable knowledge graph.

The package has no heavy dependencies (only base R) and is designed to be
imported by other ecosystem packages (such as PhysioMSKNet) that need
anatomical metadata or knowledge graph enrichment without carrying their own
data.

## Features

### Annotation Loading

| Function | Description |
|---|---|
| `loadAnnotationHub()` | Load all bundled annotation datasets into a single hub object |

The hub object aggregates all six bundled CSV datasets into a named list for
convenient access. It prints a concise summary of available annotations.

### Anatomical Queries

| Function | Description |
|---|---|
| `getMuscleAnnotation()` | Query muscle metadata: origin, insertion, innervation, action, fiber type |
| `getBoneAnnotation()` | Query bone metadata: classification, articulations, landmarks |
| `getNerveAnnotation()` | Query nerve metadata: spinal roots, branches, innervation targets |
| `getClinicalCodes()` | Look up ICD-10 and ICF clinical codes |

Each function accepts a character vector of names (or a pattern) and returns a
data frame of matching annotations. When called without arguments, the full
annotation table is returned.

### Knowledge Graph

The knowledge graph stores anatomical relationships as subject-predicate-object
triples (e.g., "biceps_brachii" -- "originates_from" -- "scapula"). It supports
SPARQL-like queries, graph traversal, shortest path computation, and
over-representation analysis.

| Function | Description |
|---|---|
| `queryKG()` | Query triples by subject, predicate, and/or object patterns |
| `kgNeighbors()` | Find all neighbors of a node within a given radius |
| `kgShortestPath()` | Compute the shortest path between two nodes |
| `kgEnrichment()` | Over-representation analysis of a node set against the full graph |

### Bundled Data

All annotation data is stored as CSV files under `inst/extdata/` and loaded
at runtime. No external downloads are required.

| File | Contents |
|---|---|
| `muscle_annotations.csv` | Muscle origin, insertion, innervation, action, fiber type composition |
| `bone_annotations.csv` | Bone classification, articulations, anatomical landmarks |
| `nerve_annotations.csv` | Nerve roots, major branches, motor/sensory innervation targets |
| `clinical_icd10.csv` | ICD-10 diagnostic codes for musculoskeletal conditions |
| `clinical_icf.csv` | ICF codes for body functions, activities, and participation |
| `kg_triples.csv` | Subject-predicate-object triples forming the anatomical knowledge graph |

## Installation

### From R-universe

```r
# the containers build on Bioconductor, so its repositories are needed too
install.packages("BiocManager", repos = "https://cloud.r-project.org")
install.packages("PhysioAnnotationHub",
                  repos = c("https://x-biosignal.r-universe.dev", BiocManager::repositories()))
```

### From GitHub

```r
# install.packages("remotes", repos = "https://cloud.r-project.org")
remotes::install_github("x-biosignal/PhysioAnnotationHub")
```

## Quick Start

```r
library(PhysioAnnotationHub)

# --- Load the annotation hub (bundled CSVs, no download) ---
hub <- loadAnnotationHub()
hub

# --- Query anatomical annotations (names are matched fuzzily) ---
getMuscleAnnotation("Biceps Brachii")   # body region, action, innervation, spinal level
getMuscleAnnotation("Vastus")           # all matching muscles (lateralis/medialis/intermedius)
getBoneAnnotation("Femur")
getNerveAnnotation("Median Nerve")

# --- Clinical codes associated with a muscle ---
getClinicalCodes("Biceps Brachii")                 # ICD-10 (default)
getClinicalCodes("Biceps Brachii", system = "icf") # ICF

# --- Knowledge graph: neighbours within a given depth ---
kgNeighbors("Biceps Brachii", depth = 1)

# --- Knowledge graph: shortest path between two anatomical entities ---
kgShortestPath("Scapula", "Radius")
#> $path: "Scapula" "Humerus" "Radius"; $found: TRUE

# --- Knowledge graph: triple-pattern query ---
queryKG(predicate = "innervated_by", object = "Median Nerve")

# --- Knowledge graph: over-representation analysis ---
my_muscles <- c("Biceps Brachii", "Brachialis", "Pronator Teres")
kgEnrichment(my_muscles, annotation_type = "nerve")
#> Musculocutaneous Nerve over-represented (fold ~60, p ~2e-4)
```

## Dependencies

- **R** (>= 4.1.0)

No external dependencies are required. The package uses only base R functions.

### Optional (Suggests)

| Package | Purpose |
|---|---|
| testthat | Unit testing |
| PhysioMSKNet | MSK network analysis (uses this package for annotations) |

## Ecosystem

PhysioAnnotationHub is part of the
[PhysioExperiment ecosystem](https://github.com/x-biosignal/PhysioExperiment),
a suite of R packages for multi-modal physiological signal analysis.

This package serves as the **shared annotation layer** for the ecosystem.
Other packages depend on it for anatomical metadata:

| Package | How it uses PhysioAnnotationHub |
|---|---|
| [PhysioMSKNet](https://github.com/x-biosignal/PhysioExperiment) | `mskAnnotate()` and `mskEnrichKG()` delegate to this package |
| [PhysioEMG](https://github.com/x-biosignal/PhysioExperiment) | Muscle innervation and fiber type lookup |
| [PhysioMoCap](https://github.com/x-biosignal/PhysioExperiment) | Bone and landmark annotation for marker sets |

## Author

Yusuke Matsui

## License

MIT

## Governance & support

Part of the [Physio ecosystem](https://x-biosignal.r-universe.dev). Community and
policy documents live in the umbrella repository:

- [Code of Conduct](https://github.com/x-biosignal/PhysioExperiment/blob/main/CODE_OF_CONDUCT.md)
- [Contributing](https://github.com/x-biosignal/PhysioExperiment/blob/main/CONTRIBUTING.md)
- [Governance](https://github.com/x-biosignal/PhysioExperiment/blob/main/GOVERNANCE.md)
- [Support](https://github.com/x-biosignal/PhysioExperiment/blob/main/SUPPORT.md)
- [Security policy](https://github.com/x-biosignal/PhysioExperiment/blob/main/SECURITY.md)
- [Deprecation & lifecycle policy](https://github.com/x-biosignal/PhysioExperiment/blob/main/DEPRECATION.md)
