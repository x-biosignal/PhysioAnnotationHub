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
