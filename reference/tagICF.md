# Tag a metric or instrument with ICF categories

Returns the WHO ICF category codes linked to a physiological metric or
clinical instrument, using the packaged metric-to-ICF map (built with
the Cieza 2005 ICF linking rules). Matching is case-insensitive.

## Usage

``` r
tagICF(metric, hub = NULL)
```

## Arguments

- metric:

  A metric / instrument identifier (e.g. `"gait_speed"`, `"FMA_UE"`,
  `"HRV"`).

- hub:

  Optional `PhysioAnnotationHub` (loaded on demand otherwise).

## Value

A character vector of ICF codes (empty, with a warning, if unmapped).

## References

WHO ICF; Cieza et al. 2005 (ICF linking rules).

## See also

\[linkInstrumentToICF()\], \[getCoreSet()\], \[icfCategories()\]

## Examples

``` r
tagICF("gait_speed")
#> [1] "d450"
tagICF("FMA_UE")
#> [1] "b730" "b760"
```
