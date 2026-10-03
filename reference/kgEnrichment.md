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

## Examples

``` r
kgEnrichment(
  c("Trapezius", "Latissimus Dorsi", "Serratus Posterior Superior"),
  annotation_type = "body_region"
)
#>    term count total_in_background  expected fold_enrichment     p_value
#> 1 trunk     3                  47 0.5222222        5.744681 0.004998243
```
