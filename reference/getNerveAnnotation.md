# Get nerve annotations

Get nerve annotations

## Usage

``` r
getNerveAnnotation(nerves = NULL, hub = NULL)
```

## Arguments

- nerves:

  Character vector of nerve names (NULL for all)

- hub:

  AnnotationHub object

## Value

data.frame of nerve annotations

## Examples

``` r
getNerveAnnotation("Accessory")
#>             nerve_name spinal_levels    type body_region         plexus
#> 1 Accessory Nerve (XI)         C3-C4 cranial        neck cranial_nerves
```
