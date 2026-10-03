library(testthat)
library(PhysioAnnotationHub)

test_that("loadAnnotationHub returns expected structure", {
  hub <- loadAnnotationHub(reload = TRUE)

  expect_s3_class(hub, "PhysioAnnotationHub")
  expect_true(is.list(hub))
  expect_true(all(c("muscles", "bones", "nerves", "triples", "icd10", "icf") %in% names(hub)))
  expect_equal(nrow(hub$muscles), 270)
  expect_equal(nrow(hub$bones), 173)
  expect_true(nrow(hub$nerves) >= 50)
  expect_true(nrow(hub$triples) >= 1000)
  expect_true(nrow(hub$icd10) >= 50)
  expect_true(nrow(hub$icf) >= 30)
})

test_that("loadAnnotationHub caches results", {
  hub1 <- loadAnnotationHub()
  hub2 <- loadAnnotationHub()
  expect_identical(hub1, hub2)
})

test_that("print.PhysioAnnotationHub works", {
  hub <- loadAnnotationHub()
  output <- capture.output(print(hub))
  expect_true(any(grepl("PhysioAnnotationHub", output)))
  expect_true(any(grepl("Muscles: 270", output)))
  expect_true(any(grepl("Bones: 173", output)))
})

test_that("getMuscleAnnotation with known muscles", {
  hub <- loadAnnotationHub()

  # Get specific muscle
  ann <- getMuscleAnnotation("Biceps Brachii", hub)
  expect_equal(nrow(ann), 1)
  expect_equal(ann$muscle_name, "Biceps Brachii")
  expect_equal(ann$body_region, "upper_limb")
  expect_equal(ann$action_primary, "elbow_flexion")

  # Fuzzy matching
  ann <- getMuscleAnnotation("biceps", hub)
  expect_true(nrow(ann) >= 2)  # Biceps Brachii and Biceps Femoris

  # All muscles
  all_ann <- getMuscleAnnotation(hub = hub)
  expect_equal(nrow(all_ann), 270)

  # Expected columns
  expect_true(all(c("muscle_name", "body_region", "sub_region", "action_primary",
                     "nerve", "spinal_level") %in% names(all_ann)))
})

test_that("getBoneAnnotation with known bones", {
  hub <- loadAnnotationHub()

  ann <- getBoneAnnotation("Femur", hub)
  expect_equal(nrow(ann), 1)
  expect_equal(ann$bone_name, "Femur")
  expect_equal(ann$body_region, "lower_limb")

  ann <- getBoneAnnotation("Humerus", hub)
  expect_equal(nrow(ann), 1)
  expect_equal(ann$bone_type, "long")

  # All bones
  all_ann <- getBoneAnnotation(hub = hub)
  expect_equal(nrow(all_ann), 173)
})

test_that("getNerveAnnotation works", {
  hub <- loadAnnotationHub()

  ann <- getNerveAnnotation("Median", hub)
  expect_true(nrow(ann) >= 1)
  expect_true(any(grepl("Median", ann$nerve_name)))

  all_ann <- getNerveAnnotation(hub = hub)
  expect_true(nrow(all_ann) >= 50)
})

test_that("queryKG with pattern matching", {
  hub <- loadAnnotationHub()

  # Query by subject
  triples <- queryKG(subject = "Biceps Brachii", hub = hub)
  expect_true(nrow(triples) > 0)
  expect_true(all(grepl("Biceps Brachii", triples$subject, ignore.case = TRUE)))

  # Query by predicate
  triples <- queryKG(predicate = "innervated_by", hub = hub)
  expect_true(nrow(triples) > 0)
  expect_true(all(triples$predicate == "innervated_by"))

  # Query by object
  triples <- queryKG(object = "elbow_flexion", hub = hub)
  expect_true(nrow(triples) > 0)

  # Combined query
  triples <- queryKG(subject = "Biceps Brachii", predicate = "innervated_by", hub = hub)
  expect_true(nrow(triples) >= 1)
  expect_true(any(grepl("Musculocutaneous", triples$object)))

  # Exact match
  triples_exact <- queryKG(subject = "Biceps Brachii", hub = hub, exact = TRUE)
  expect_true(all(triples_exact$subject == "Biceps Brachii"))
})

test_that("kgNeighbors works", {
  hub <- loadAnnotationHub()

  neighbors <- kgNeighbors("Biceps Brachii", depth = 1, hub = hub)
  expect_true(nrow(neighbors) > 0)
  expect_true("Biceps Brachii" %in% c(neighbors$subject, neighbors$object))

  # Depth 2 should return more triples
  neighbors_d2 <- kgNeighbors("Biceps Brachii", depth = 2, hub = hub)
  expect_true(nrow(neighbors_d2) >= nrow(neighbors))
})

test_that("kgShortestPath finds path between related entities", {
  hub <- loadAnnotationHub()

  # Biceps Brachii and Triceps Brachii are connected via antagonist_of
  result <- kgShortestPath("Biceps Brachii", "Triceps Brachii", hub = hub)
  expect_true(result$found)
  expect_true(length(result$path) >= 2)
  expect_equal(result$path[1], "Biceps Brachii")
  expect_equal(result$path[length(result$path)], "Triceps Brachii")

  # Non-existent path
  result <- kgShortestPath("Biceps Brachii", "NONEXISTENT_ENTITY", hub = hub, max_depth = 2)
  expect_false(result$found)
})

test_that("kgEnrichment works", {
  hub <- loadAnnotationHub()

  # Hamstring muscles - should be enriched for knee_flexion
  hamstrings <- c("Semitendinosus", "Semimembranosus", "Biceps Femoris")
  result <- kgEnrichment(hamstrings, annotation_type = "action", hub = hub)

  expect_true(nrow(result) > 0)
  expect_true(all(c("term", "count", "expected", "fold_enrichment", "p_value") %in% names(result)))
  expect_true("knee_flexion" %in% result$term)

  # Check enrichment for body region
  result_region <- kgEnrichment(hamstrings, annotation_type = "body_region", hub = hub)
  expect_true(nrow(result_region) > 0)
  expect_true("lower_limb" %in% result_region$term)

  # Warning for no matches
  expect_warning(kgEnrichment("NONEXISTENT_MUSCLE", hub = hub), "No muscles matched")
})

test_that("getClinicalCodes works", {
  hub <- loadAnnotationHub()

  # ICD-10 codes for rotator cuff muscles
  codes <- getClinicalCodes("Supraspinatus", system = "icd10", hub = hub)
  expect_true(nrow(codes) > 0)
  expect_true(any(grepl("M75", codes$icd10_code)))

  # ICF codes for gait muscles
  codes_icf <- getClinicalCodes("Gluteus Maximus", system = "icf", hub = hub)
  expect_true(nrow(codes_icf) > 0)
})

test_that("muscle names match PhysioMSKNet", {
  hub <- loadAnnotationHub()

  # Check some specific muscles that have tricky naming
  expect_true("Palmar Interossei  3" %in% hub$muscles$muscle_name)
  expect_true("Thryohyoid" %in% hub$muscles$muscle_name)
  expect_true("Cricothryoid" %in% hub$muscles$muscle_name)
  expect_true("Subcostalis 6" %in% hub$muscles$muscle_name)
  expect_true("Abductor Ossis Metatarsi Quinti" %in% hub$muscles$muscle_name)
})
