# Find shortest path between two entities in the KG

Find shortest path between two entities in the KG

## Usage

``` r
kgShortestPath(from, to, hub = NULL, max_depth = 5)
```

## Arguments

- from:

  Character; source entity name

- to:

  Character; target entity name

- hub:

  AnnotationHub object

- max_depth:

  Integer; maximum search depth (default 5)

## Value

List with path (entities), predicates, and depth
