# Link a clinical instrument to its ICF categories

Like \[tagICF()\] but returns a data frame with the ICF code and its
title, suitable for annotating a clinical outcome measure.

## Usage

``` r
linkInstrumentToICF(instrument_id, hub = NULL)
```

## Arguments

- instrument_id:

  A clinical instrument identifier (e.g. `"berg"`, `"fma_ue"`).

- hub:

  Optional `PhysioAnnotationHub`.

## Value

A data frame with `instrument_id`, `icf_code`, `icf_title` (zero rows,
with a warning, if unmapped).

## See also

\[tagICF()\]

## Examples

``` r
linkInstrumentToICF("berg")
#>   instrument_id icf_code                               icf_title
#> 1          berg     b710             Mobility of joint functions
#> 2          berg     b755 Involuntary movement reaction functions
```
