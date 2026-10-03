# Query the Knowledge Graph by triple pattern

Query the Knowledge Graph by triple pattern

## Usage

``` r
queryKG(
  subject = NULL,
  predicate = NULL,
  object = NULL,
  hub = NULL,
  exact = FALSE
)
```

## Arguments

- subject:

  Character or NULL; entity name pattern (grep)

- predicate:

  Character or NULL; relation type (exact or grep)

- object:

  Character or NULL; target entity pattern (grep)

- hub:

  AnnotationHub object (loaded if NULL)

- exact:

  Logical; use exact matching instead of grep (default FALSE)

## Value

data.frame of matching triples

## Examples

``` r
# All triples with Trapezius as the subject:
head(queryKG(subject = "Trapezius"))
#>     subject   predicate                          object    evidence_type
#> 1 Trapezius attaches_to External Occipital Protuberance anatomy_textbook
#> 2 Trapezius attaches_to               Ligamentum Nuchae anatomy_textbook
#> 3 Trapezius attaches_to                              C7 anatomy_textbook
#> 4 Trapezius attaches_to                              T1 anatomy_textbook
#> 5 Trapezius attaches_to                              T2 anatomy_textbook
#> 6 Trapezius attaches_to                              T3 anatomy_textbook
```
