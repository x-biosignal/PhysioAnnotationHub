# Query the Knowledge Graph by triple pattern

Query the Knowledge Graph by triple pattern

## Usage

``` r
queryKG(subject = NULL, predicate = NULL, object = NULL, hub = NULL, exact = FALSE)
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
