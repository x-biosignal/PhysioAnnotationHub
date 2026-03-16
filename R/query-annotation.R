#' Get muscle annotations
#'
#' @param muscles Character vector of muscle names (NULL for all)
#' @param hub AnnotationHub object
#' @param fuzzy Logical; use fuzzy matching (default TRUE)
#' @return data.frame of muscle annotations
#' @export
getMuscleAnnotation <- function(muscles = NULL, hub = NULL, fuzzy = TRUE) {
  if (is.null(hub)) hub <- loadAnnotationHub()

  if (is.null(muscles)) return(hub$muscles)

  if (fuzzy) {
    idx <- unlist(lapply(muscles, function(m) {
      exact <- which(tolower(hub$muscles$muscle_name) == tolower(m))
      if (length(exact) > 0) return(exact)
      grep(m, hub$muscles$muscle_name, ignore.case = TRUE)
    }))
    idx <- unique(idx)
  } else {
    idx <- which(hub$muscles$muscle_name %in% muscles)
  }

  hub$muscles[idx, ]
}

#' Get bone annotations
#'
#' @param bones Character vector of bone names (NULL for all)
#' @param hub AnnotationHub object
#' @param fuzzy Logical; use fuzzy matching (default TRUE)
#' @return data.frame of bone annotations
#' @export
getBoneAnnotation <- function(bones = NULL, hub = NULL, fuzzy = TRUE) {
  if (is.null(hub)) hub <- loadAnnotationHub()

  if (is.null(bones)) return(hub$bones)

  if (fuzzy) {
    idx <- unlist(lapply(bones, function(b) {
      exact <- which(tolower(hub$bones$bone_name) == tolower(b))
      if (length(exact) > 0) return(exact)
      grep(b, hub$bones$bone_name, ignore.case = TRUE)
    }))
    idx <- unique(idx)
  } else {
    idx <- which(hub$bones$bone_name %in% bones)
  }

  hub$bones[idx, ]
}

#' Get nerve annotations
#'
#' @param nerves Character vector of nerve names (NULL for all)
#' @param hub AnnotationHub object
#' @return data.frame of nerve annotations
#' @export
getNerveAnnotation <- function(nerves = NULL, hub = NULL) {
  if (is.null(hub)) hub <- loadAnnotationHub()

  if (is.null(nerves)) return(hub$nerves)

  idx <- unlist(lapply(nerves, function(n) {
    grep(n, hub$nerves$nerve_name, ignore.case = TRUE)
  }))
  hub$nerves[unique(idx), ]
}

#' Get clinical codes for muscles
#'
#' @param muscles Character vector of muscle names
#' @param system Character; "icd10" or "icf" (default "icd10")
#' @param hub AnnotationHub object
#' @return data.frame of matching clinical codes
#' @export
getClinicalCodes <- function(muscles, system = c("icd10", "icf"), hub = NULL) {
  if (is.null(hub)) hub <- loadAnnotationHub()
  system <- match.arg(system)

  codes <- if (system == "icd10") hub$icd10 else hub$icf

  # Column name differs between ICD-10 and ICF
  muscle_col <- if (system == "icd10") "affected_muscles" else "related_muscles"

  # Find codes that reference any of the given muscles
  idx <- unlist(lapply(muscles, function(m) {
    grep(m, codes[[muscle_col]], ignore.case = TRUE)
  }))

  codes[unique(idx), ]
}
