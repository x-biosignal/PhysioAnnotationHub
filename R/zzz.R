#' @importFrom stats phyper
#' @importFrom utils read.csv
NULL

.hub_cache <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  rm(list = ls(envir = .hub_cache), envir = .hub_cache)
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "PhysioAnnotationHub v", utils::packageVersion(pkgname),
    " - Anatomical Knowledge Graph for Physio-Ecosystem"
  )
}
