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

## Examples

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
