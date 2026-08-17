# Changelog

## PhysioAnnotationHub 0.2.0

- Add free-living physical-behaviour metric -\> ICF Activities &
  Participation mappings (`steps_per_day` -\> d450, `mvpa_min` /
  `sedentary_min` / `physical_activity_volume` -\> d570, `walking_bouts`
  -\> d455) so
  [`tagICF()`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/tagICF.md)
  resolves accelerometry-derived measures.

## PhysioAnnotationHub 0.1.0

Initial release as a standalone package in the physio-ecosystem.
Provides a centralized anatomical and clinical knowledge hub — muscle,
bone, and nerve metadata, clinical code mappings, and a queryable
knowledge graph — bundled as curated reference data for downstream
musculoskeletal and rehabilitation analyses.

### New Features

- Bundled annotation reference data, loaded on demand into a cached hub
  via
  [`loadAnnotationHub()`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/loadAnnotationHub.md)
  with a [`print()`](https://rdrr.io/r/base/print.html) method
  summarizing the loaded tables:
  - Muscle annotations (body region, primary/secondary action,
    innervating nerve, spinal level, muscle type, joint crossed).
  - Bone annotations (body region, bone type, parent structure).
  - Nerve annotations (spinal levels, type, body region, plexus).
  - Clinical code tables mapping ICD-10 and ICF codes to
    affected/related muscles, body regions, and functional domains.
- Annotation lookup functions with fuzzy (exact-then-substring)
  matching:
  - [`getMuscleAnnotation()`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/getMuscleAnnotation.md),
    [`getBoneAnnotation()`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/getBoneAnnotation.md),
    and
    [`getNerveAnnotation()`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/getNerveAnnotation.md)
    retrieve records by name, or return the full table when called with
    no query.
  - [`getClinicalCodes()`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/getClinicalCodes.md)
    resolves ICD-10 or ICF codes referencing a given set of muscles.
- Knowledge graph query and traversal over subject–predicate–object
  triples:
  - [`queryKG()`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/queryKG.md)
    filters triples by any combination of subject, predicate, and object
    using grep or exact matching.
  - [`kgNeighbors()`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/kgNeighbors.md)
    returns all triples within a given number of hops of an entity,
    following both outgoing and incoming edges.
  - [`kgShortestPath()`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/kgShortestPath.md)
    finds the shortest path between two entities via breadth-first
    search, reporting the entity path, the relations traversed (with
    inverse edges flagged), and the path depth.
- [`kgEnrichment()`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/kgEnrichment.md)
  performs over-representation analysis of a muscle set against the full
  background, testing enrichment of actions, innervation, body regions,
  or spinal levels with fold-enrichment and hypergeometric p-values.

### Documentation

- Roxygen2 documentation and examples for all exported functions, plus a
  package README and pkgdown reference site.
- Bundled `CITATION` metadata for citing the package.
