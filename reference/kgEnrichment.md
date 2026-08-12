# Functional enrichment analysis for a set of muscles

Tests whether a set of muscles is enriched for specific annotations
(actions, innervation, body regions) compared to the full set.

## Usage

``` r
kgEnrichment(
  muscles,
  annotation_type = c("action", "nerve", "body_region", "spinal_level"),
  hub = NULL
)
```

## Arguments

- muscles:

  Character vector of muscle names (query set)

- annotation_type:

  Character; "action", "nerve", "body_region", "spinal_level"

- hub:

  AnnotationHub object

## Value

data.frame with term, count, expected, fold_enrichment, p_value
