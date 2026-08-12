# Look up ICF category titles

Resolves ICF category codes to their titles (across the hub's Core-Set,
metric-link, and clinical ICF tables).

## Usage

``` r
icfCategories(codes, hub = NULL)
```

## Arguments

- codes:

  A character vector of ICF codes (e.g. `c("b730", "d450")`).

- hub:

  Optional `PhysioAnnotationHub`.

## Value

A data frame with `icf_code` and `title` (`NA` title for an unknown
code).

## See also

\[getCoreSet()\], \[tagICF()\]

## Examples

``` r
icfCategories(c("b730", "d450"))
#>   icf_code                  title
#> 1     b730 Muscle power functions
#> 2     d450                Walking
```
