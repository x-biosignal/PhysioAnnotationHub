# Get clinical codes for muscles

Get clinical codes for muscles

## Usage

``` r
getClinicalCodes(muscles, system = c("icd10", "icf"), hub = NULL)
```

## Arguments

- muscles:

  Character vector of muscle names

- system:

  Character; "icd10" or "icf" (default "icd10")

- hub:

  AnnotationHub object

## Value

data.frame of matching clinical codes

## Examples

``` r
getClinicalCodes("Rectus abdominis", system = "icd10")
#>    icd10_code                   description
#> 1       M62.0 Diastasis of muscle - general
#> 33      M79.1             Myalgia - general
#>                                  affected_muscles body_region severity_class
#> 1                                Rectus abdominis       trunk       moderate
#> 33 Trapezius;Sternocleidomastoid;Rectus abdominis     general           mild
```
