# Get KG neighbors of an entity

Get KG neighbors of an entity

## Usage

``` r
kgNeighbors(entity, depth = 1, hub = NULL)
```

## Arguments

- entity:

  Character; entity name

- depth:

  Integer; traversal depth (default 1)

- hub:

  AnnotationHub object

## Value

data.frame of all triples within depth hops
