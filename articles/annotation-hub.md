# Querying the anatomical and clinical annotation hub

PhysioAnnotationHub is a lightweight, base-R-only annotation hub for the
PhysioExperiment ecosystem. It bundles curated anatomical ontology data
(muscles, bones, nerves), clinical codes (ICD-10, ICF), and an
anatomical knowledge graph as CSV files under `inst/extdata`. Everything
here runs offline – nothing is downloaded at run time.

``` r

library(PhysioAnnotationHub)
#> PhysioAnnotationHub v0.2.1 - Anatomical Knowledge Graph for Physio-Ecosystem
```

## Load the hub

[`loadAnnotationHub()`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/loadAnnotationHub.md)
reads all bundled datasets into one cached object; printing it
summarises what is available.

``` r

hub <- loadAnnotationHub()
hub
#> PhysioAnnotationHub
#> ===================
#> Muscles: 270 
#> Bones: 173 
#> Nerves: 66 
#> KG Triples: 2005 
#> ICD-10 Codes: 82 
#> ICF Codes: 41 
#> ICF Core-Set Categories: 18 
#> Metric-ICF Links: 27
```

## Anatomical queries

Look up a muscle, bone, or nerve by name (matching is case-insensitive
and fuzzy); call a getter with no arguments to get the whole table.

``` r

getMuscleAnnotation("Trapezius")[, c("muscle_name", "body_region",
                                     "action_primary", "nerve")]
#>   muscle_name body_region     action_primary                nerve
#> 1   Trapezius       trunk scapular_elevation Accessory Nerve (XI)
getNerveAnnotation("Accessory")
#>             nerve_name spinal_levels    type body_region         plexus
#> 1 Accessory Nerve (XI)         C3-C4 cranial        neck cranial_nerves
```

Clinical codes that reference a muscle:

``` r

getClinicalCodes("Rectus abdominis", system = "icd10")[, c("icd10_code",
                                                            "description")]
#>    icd10_code                   description
#> 1       M62.0 Diastasis of muscle - general
#> 33      M79.1             Myalgia - general
```

## The knowledge graph

Anatomical relationships are stored as subject-predicate-object triples.
Query them by any combination of the three slots:

``` r

head(queryKG(subject = "Trapezius"))
#>     subject   predicate                          object    evidence_type
#> 1 Trapezius attaches_to External Occipital Protuberance anatomy_textbook
#> 2 Trapezius attaches_to               Ligamentum Nuchae anatomy_textbook
#> 3 Trapezius attaches_to                              C7 anatomy_textbook
#> 4 Trapezius attaches_to                              T1 anatomy_textbook
#> 5 Trapezius attaches_to                              T2 anatomy_textbook
#> 6 Trapezius attaches_to                              T3 anatomy_textbook
```

Traverse the graph – neighbours within N hops, or the shortest path
between two entities:

``` r

nrow(kgNeighbors("Trapezius"))
#> [1] 27
kgShortestPath("Trapezius", "External Occipital Protuberance")
#> $path
#> [1] "Trapezius"                       "External Occipital Protuberance"
#> 
#> $predicates
#> [1] "attaches_to"
#> 
#> $depth
#> [1] 1
#> 
#> $found
#> [1] TRUE
```

Over-representation analysis asks whether a muscle set is enriched for
an annotation (here, body region) relative to the full hub:

``` r

kgEnrichment(
  c("Trapezius", "Latissimus Dorsi", "Serratus Posterior Superior"),
  annotation_type = "body_region"
)
#>    term count total_in_background  expected fold_enrichment     p_value
#> 1 trunk     3                  47 0.5222222        5.744681 0.004998243
```

## ICF classification

Map a physiological metric or clinical instrument to WHO ICF categories,
or pull a published ICF Core Set:

``` r

tagICF("gait_speed")
#> [1] "d450"
icfCategories(c("b730", "d450"))
#>   icf_code                  title
#> 1     b730 Muscle power functions
#> 2     d450                Walking
```

## Where to go next

- [`?loadAnnotationHub`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/loadAnnotationHub.md)
  – the hub object and its tables.
- [`?queryKG`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/queryKG.md),
  [`?kgShortestPath`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/kgShortestPath.md),
  [`?kgEnrichment`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/kgEnrichment.md)
  – graph queries.
- [`?tagICF`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/tagICF.md),
  [`?getCoreSet`](https://x-biosignal.github.io/PhysioAnnotationHub/reference/getCoreSet.md)
  – ICF linking.

This hub is designed to be imported by other ecosystem packages (e.g.
PhysioMSKNet) that need anatomical metadata without carrying their own
copy.
