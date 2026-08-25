test_that("tagICF links metrics to the expected ICF categories", {
  expect_equal(tagICF("gait_speed"), "d450")
  expect_true("b730" %in% tagICF("FMA_UE"))          # acceptance: FMA_UE hits b730
  expect_equal(tagICF("HRV"), "b410")
  expect_equal(tagICF("EEG_band"), "b110")
  expect_setequal(tagICF("BBS"), c("b710", "b755"))
})

test_that("tagICF matching is case-insensitive and validates its input", {
  expect_equal(tagICF("GAIT_SPEED"), tagICF("gait_speed"))
  expect_error(tagICF(c("a", "b")), "single")
  expect_error(tagICF(NA_character_), "single")
  expect_error(tagICF(""), "single")
})

test_that("an unmapped metric returns nothing with a warning", {
  expect_warning(res <- tagICF("no_such_metric"), "no ICF link")
  expect_length(res, 0L)
})

test_that("getCoreSet returns the published Brief ICF Core Set for Stroke", {
  cs <- getCoreSet("Stroke")
  expect_equal(nrow(cs), 18L)                         # Geyh 2004: 18 categories
  expect_equal(as.integer(table(cs$component)[
    c("body_functions", "body_structures",
      "activities_participation", "environmental_factors")]),
    c(6L, 2L, 7L, 3L))
  # spot-check published members across all four components
  expect_true(all(c("b110", "b730", "s110", "d450", "d550", "e310", "e580")
                  %in% cs$icf_code))
  expect_true(all(cs$brief_vs_comprehensive == "brief"))
})

test_that("getCoreSet is case-insensitive and errors on an unknown condition", {
  expect_equal(nrow(getCoreSet("stroke")), 18L)
  expect_error(getCoreSet("NotACondition"), "unknown condition")
  # only the Brief set is bundled -> comprehensive warns
  expect_warning(getCoreSet("Stroke", level = "comprehensive"), "comprehensive")
})

test_that("icfCategories resolves titles and NA for unknown codes", {
  ic <- icfCategories(c("b730", "d450", "e580", "zz999"))
  expect_equal(ic$icf_code, c("b730", "d450", "e580", "zz999"))
  expect_equal(ic$title[1], "Muscle power functions")
  expect_equal(ic$title[2], "Walking")
  expect_true(is.na(ic$title[4]))
})

test_that("linkInstrumentToICF returns codes with titles, or warns when unmapped", {
  lk <- linkInstrumentToICF("berg")
  expect_setequal(lk$icf_code, c("b710", "b755"))
  expect_true(all(nzchar(lk$icf_title)))
  expect_true(all(lk$instrument_id == "berg"))
  expect_warning(empty <- linkInstrumentToICF("no_such_instrument"), "no ICF link")
  expect_equal(nrow(empty), 0L)
})

test_that("loadAnnotationHub loads the ICF Core-Set and metric-link tables", {
  hub <- loadAnnotationHub()
  expect_true(nrow(hub$icf_core_sets) >= 18L)
  expect_true(nrow(hub$metric_icf) >= 1L)
  expect_true(all(c("condition", "icf_code", "category_title") %in%
                    names(hub$icf_core_sets)))
})
