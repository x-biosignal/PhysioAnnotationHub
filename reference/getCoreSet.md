# Retrieve a published ICF Core Set

Returns the categories of a published WHO ICF Core Set for a health
condition. Currently the Brief ICF Core Set for Stroke (Geyh 2004) is
bundled; the data are the officially published category lists, not
derived.

## Usage

``` r
getCoreSet(condition, level = c("brief", "comprehensive"), hub = NULL)
```

## Arguments

- condition:

  Condition name (e.g. `"Stroke"`); case-insensitive.

- level:

  `"brief"` or `"comprehensive"` (default `"brief"`).

- hub:

  Optional `PhysioAnnotationHub`.

## Value

A data frame of ICF categories (`icf_code`, `category_title`,
`component`, ...) for the requested Core Set.

## References

Geyh et al. 2004, ICF Core Sets for Stroke; ICF Research Branch.

## See also

\[icfCategories()\], \[tagICF()\]

## Examples

``` r
getCoreSet("Stroke")
#>     core_set_id condition icf_code
#> 1  stroke_brief    Stroke     b110
#> 2  stroke_brief    Stroke     b114
#> 3  stroke_brief    Stroke     b140
#> 4  stroke_brief    Stroke     b144
#> 5  stroke_brief    Stroke     b167
#> 6  stroke_brief    Stroke     b730
#> 7  stroke_brief    Stroke     s110
#> 8  stroke_brief    Stroke     s730
#> 9  stroke_brief    Stroke     d310
#> 10 stroke_brief    Stroke     d330
#> 11 stroke_brief    Stroke     d450
#> 12 stroke_brief    Stroke     d510
#> 13 stroke_brief    Stroke     d530
#> 14 stroke_brief    Stroke     d540
#> 15 stroke_brief    Stroke     d550
#> 16 stroke_brief    Stroke     e310
#> 17 stroke_brief    Stroke     e355
#> 18 stroke_brief    Stroke     e580
#>                                      category_title                component
#> 1                           Consciousness functions           body_functions
#> 2                             Orientation functions           body_functions
#> 3                               Attention functions           body_functions
#> 4                                  Memory functions           body_functions
#> 5                      Mental functions of language           body_functions
#> 6                            Muscle power functions           body_functions
#> 7                                Structure of brain          body_structures
#> 8                      Structure of upper extremity          body_structures
#> 9  Communicating with - receiving - spoken messages activities_participation
#> 10                                         Speaking activities_participation
#> 11                                          Walking activities_participation
#> 12                                  Washing oneself activities_participation
#> 13                                        Toileting activities_participation
#> 14                                         Dressing activities_participation
#> 15                                           Eating activities_participation
#> 16                                 Immediate family    environmental_factors
#> 17                             Health professionals    environmental_factors
#> 18            Health services, systems and policies    environmental_factors
#>    brief_vs_comprehensive
#> 1                   brief
#> 2                   brief
#> 3                   brief
#> 4                   brief
#> 5                   brief
#> 6                   brief
#> 7                   brief
#> 8                   brief
#> 9                   brief
#> 10                  brief
#> 11                  brief
#> 12                  brief
#> 13                  brief
#> 14                  brief
#> 15                  brief
#> 16                  brief
#> 17                  brief
#> 18                  brief
```
