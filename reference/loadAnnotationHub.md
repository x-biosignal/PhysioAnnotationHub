# Load the PhysioAnnotationHub

Loads all annotation data into a cached environment for fast repeated
queries.

## Usage

``` r
loadAnnotationHub(reload = FALSE)
```

## Arguments

- reload:

  Logical; force reload even if cached (default FALSE)

## Value

An AnnotationHub object (list) with muscle, bone, nerve, kg, clinical
data
