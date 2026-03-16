#' Load the PhysioAnnotationHub
#'
#' Loads all annotation data into a cached environment for fast repeated queries.
#'
#' @param reload Logical; force reload even if cached (default FALSE)
#' @return An AnnotationHub object (list) with muscle, bone, nerve, kg, clinical data
#' @export
loadAnnotationHub <- function(reload = FALSE) {
  if (!reload && exists("hub", envir = .hub_cache)) {
    return(get("hub", envir = .hub_cache))
  }

  extdata <- system.file("extdata", package = "PhysioAnnotationHub")

  hub <- list(
    muscles = read.csv(file.path(extdata, "muscle_annotations.csv"),
                       stringsAsFactors = FALSE),
    bones = read.csv(file.path(extdata, "bone_annotations.csv"),
                     stringsAsFactors = FALSE),
    nerves = read.csv(file.path(extdata, "nerve_annotations.csv"),
                      stringsAsFactors = FALSE),
    triples = read.csv(file.path(extdata, "kg_triples.csv"),
                       stringsAsFactors = FALSE),
    icd10 = read.csv(file.path(extdata, "clinical_icd10.csv"),
                     stringsAsFactors = FALSE),
    icf = read.csv(file.path(extdata, "clinical_icf.csv"),
                   stringsAsFactors = FALSE)
  )
  class(hub) <- "PhysioAnnotationHub"
  assign("hub", hub, envir = .hub_cache)
  hub
}

#' Print method for PhysioAnnotationHub
#'
#' @param x A PhysioAnnotationHub object
#' @param ... Additional arguments (ignored)
#' @return Invisibly returns x
#' @export
print.PhysioAnnotationHub <- function(x, ...) {
  cat("PhysioAnnotationHub\n")
  cat("===================\n")
  cat("Muscles:", nrow(x$muscles), "\n")
  cat("Bones:", nrow(x$bones), "\n")
  cat("Nerves:", nrow(x$nerves), "\n")
  cat("KG Triples:", nrow(x$triples), "\n")
  cat("ICD-10 Codes:", nrow(x$icd10), "\n")
  cat("ICF Codes:", nrow(x$icf), "\n")
  invisible(x)
}
