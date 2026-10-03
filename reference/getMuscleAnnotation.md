# Get muscle annotations

Get muscle annotations

## Usage

``` r
getMuscleAnnotation(muscles = NULL, hub = NULL, fuzzy = TRUE)
```

## Arguments

- muscles:

  Character vector of muscle names (NULL for all)

- hub:

  AnnotationHub object

- fuzzy:

  Logical; use fuzzy matching (default TRUE)

## Value

data.frame of muscle annotations

## Examples

``` r
getMuscleAnnotation("Trapezius")
#>   muscle_name body_region sub_region     action_primary    action_secondary
#> 1   Trapezius       trunk       back scapular_elevation scapular_retraction
#>                  nerve spinal_level muscle_type joint_crossed
#> 1 Accessory Nerve (XI)        C3-C4    skeletal      shoulder
nrow(getMuscleAnnotation())   # the whole muscle table
#> [1] 270
```
