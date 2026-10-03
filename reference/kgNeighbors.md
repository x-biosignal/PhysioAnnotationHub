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

## Examples

``` r
head(kgNeighbors("Trapezius"))
#>     subject   predicate                          object    evidence_type
#> 1 Trapezius attaches_to External Occipital Protuberance anatomy_textbook
#> 2 Trapezius attaches_to               Ligamentum Nuchae anatomy_textbook
#> 3 Trapezius attaches_to                              C7 anatomy_textbook
#> 4 Trapezius attaches_to                              T1 anatomy_textbook
#> 5 Trapezius attaches_to                              T2 anatomy_textbook
#> 6 Trapezius attaches_to                              T3 anatomy_textbook
```
