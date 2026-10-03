# Get bone annotations

Get bone annotations

## Usage

``` r
getBoneAnnotation(bones = NULL, hub = NULL, fuzzy = TRUE)
```

## Arguments

- bones:

  Character vector of bone names (NULL for all)

- hub:

  AnnotationHub object

- fuzzy:

  Logical; use fuzzy matching (default TRUE)

## Value

data.frame of bone annotations

## Examples

``` r
getBoneAnnotation("Occipital")
#>                         bone_name body_region sub_region bone_type
#> 1 External Occipital Protuberance        head    cranium  landmark
#> 2                  Occipital Bone        head    cranium      flat
#>   parent_structure
#> 1   Occipital Bone
#> 2          cranium
```
