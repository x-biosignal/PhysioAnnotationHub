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
install.packages("PhysioAnnotationHub",
                  repos = c("https://x-biosignal.r-universe.dev",
                            "https://cloud.r-project.org"))
```

### From GitHub

```r
# install.packages("remotes")
remotes::install_github("x-biosignal/PhysioExperiment",
                        subdir = "physio-ecosystem/PhysioAnnotationHub")
```

## Quick Start

```r
library(PhysioAnnotationHub)

# --- Load the annotation hub ---
hub <- loadAnnotationHub()
print(hub)
#> PhysioAnnotationHub
#>   Muscles: 320 entries
#>   Bones:   206 entries
#>   Nerves:  58 entries
#>   ICD-10:  245 codes
#>   ICF:     189 codes
#>   KG:      1284 triples

# --- Query muscle annotations ---
getMuscleAnnotation("biceps_brachii")
#>             name          origin    insertion   innervation          action
#> 1 biceps_brachii scapula (short) radius (tub) musculocutan elbow_flexion...

getMuscleAnnotation("quadriceps")
# Returns all muscles matching the pattern

# --- Query bone annotations ---
getBoneAnnotation("femur")

# --- Query nerve annotations ---
getNerveAnnotation("median")

# --- Look up clinical codes ---
getClinicalCodes("M54")        # ICD-10 dorsalgia codes
getClinicalCodes("b710")       # ICF joint mobility

# --- Knowledge graph: find neighbors ---
kgNeighbors("femur", radius = 1)
#>           subject       predicate          object
#> 1  vastus_medialis  originates_from         femur
#> 2  vastus_lateralis originates_from         femur
#> 3  rectus_femoris   inserts_on           patella
#> ...

# --- Knowledge graph: shortest path ---
kgShortestPath("scapula", "radius")
#> scapula -> biceps_brachii -> radius

# --- Knowledge graph: SPARQL-like query ---
queryKG(predicate = "innervated_by", object = "median_nerve")

# --- Knowledge graph: enrichment analysis ---
my_muscles <- c("biceps_brachii", "brachialis", "pronator_teres")
kgEnrichment(my_muscles, category = "innervation")
#> Enriched for: musculocutaneous_nerve (p = 0.003), median_nerve (p = 0.012)
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
