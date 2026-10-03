# ICF metric-tagging + Rehabilitation Core Sets. Links physiological metrics and
# clinical instruments to WHO ICF categories (via the packaged metric_icf_map,
# following the Cieza 2005 ICF linking rules) and serves the published ICF Core
# Sets (metric_icf_map.csv, icf_core_sets.csv). No ICF codes are fabricated: the
# Core-Set categories are the officially published lists (e.g. the Brief ICF Core
# Set for Stroke, Geyh 2004 / ICF Research Branch).

# Canonical ICF code -> title lookup, merged across the hub's ICF tables.
.icf_titles <- function(hub) {
  lut <- character(0)
  add <- function(codes, titles) {
    keep <- !is.na(codes) & nzchar(codes)
    v <- titles[keep]; names(v) <- codes[keep]
    v[!(names(v) %in% names(lut))]
  }
  lut <- c(lut, add(hub$icf_core_sets$icf_code, hub$icf_core_sets$category_title))
  lut <- c(lut, add(hub$metric_icf$icf_code, hub$metric_icf$icf_title))
  if (!is.null(hub$icf$icf_code)) {
    lut <- c(lut, add(hub$icf$icf_code, hub$icf$description))
  }
  lut
}

#' Tag a metric or instrument with ICF categories
#'
#' Returns the WHO ICF category codes linked to a physiological metric or
#' clinical instrument, using the packaged metric-to-ICF map (built with the
#' Cieza 2005 ICF linking rules). Matching is case-insensitive.
#'
#' @param metric A metric / instrument identifier (e.g. \code{"gait_speed"},
#'   \code{"FMA_UE"}, \code{"HRV"}).
#' @param hub Optional \code{PhysioAnnotationHub} (loaded on demand otherwise).
#' @return A character vector of ICF codes (empty, with a warning, if unmapped).
#' @references WHO ICF; Cieza et al. 2005 (ICF linking rules).
#' @seealso [linkInstrumentToICF()], [getCoreSet()], [icfCategories()]
#' @examples
#' tagICF("gait_speed")
#' tagICF("FMA_UE")
#' @export
tagICF <- function(metric, hub = NULL) {
  if (length(metric) != 1L || is.na(metric) || !nzchar(metric)) {
    stop("'metric' must be a single non-empty identifier.", call. = FALSE)
  }
  if (is.null(hub)) hub <- loadAnnotationHub()
  tbl <- hub$metric_icf
  hit <- tolower(tbl$metric_or_instrument_id) == tolower(metric)
  if (!any(hit)) {
    warning("no ICF link for metric '", metric, "'.", call. = FALSE)
    return(character(0))
  }
  unique(tbl$icf_code[hit])
}

#' Link a clinical instrument to its ICF categories
#'
#' Like [tagICF()] but returns a data frame with the ICF code and its title,
#' suitable for annotating a clinical outcome measure.
#'
#' @param instrument_id A clinical instrument identifier (e.g. \code{"berg"},
#'   \code{"fma_ue"}).
#' @param hub Optional \code{PhysioAnnotationHub}.
#' @return A data frame with \code{instrument_id}, \code{icf_code},
#'   \code{icf_title} (zero rows, with a warning, if unmapped).
#' @seealso [tagICF()]
#' @examples
#' linkInstrumentToICF("berg")
#' @export
linkInstrumentToICF <- function(instrument_id, hub = NULL) {
  if (is.null(hub)) hub <- loadAnnotationHub()
  codes <- suppressWarnings(tagICF(instrument_id, hub = hub))
  if (!length(codes)) {
    warning("no ICF link for instrument '", instrument_id, "'.", call. = FALSE)
    return(data.frame(instrument_id = character(0), icf_code = character(0),
                      icf_title = character(0), stringsAsFactors = FALSE))
  }
  titles <- .icf_titles(hub)
  data.frame(instrument_id = instrument_id, icf_code = codes,
             icf_title = unname(titles[codes]), stringsAsFactors = FALSE)
}

#' Retrieve a published ICF Core Set
#'
#' Returns the categories of a published WHO ICF Core Set for a health
#' condition. Currently the Brief ICF Core Set for Stroke (Geyh 2004) is
#' bundled; the data are the officially published category lists, not derived.
#'
#' @param condition Condition name (e.g. \code{"Stroke"}); case-insensitive.
#' @param level \code{"brief"} or \code{"comprehensive"} (default
#'   \code{"brief"}).
#' @param hub Optional \code{PhysioAnnotationHub}.
#' @return A data frame of ICF categories (\code{icf_code}, \code{category_title},
#'   \code{component}, ...) for the requested Core Set.
#' @references Geyh et al. 2004, ICF Core Sets for Stroke; ICF Research Branch.
#' @seealso [icfCategories()], [tagICF()]
#' @examples
#' getCoreSet("Stroke")
#' @export
getCoreSet <- function(condition, level = c("brief", "comprehensive"),
                       hub = NULL) {
  level <- match.arg(level)
  if (is.null(hub)) hub <- loadAnnotationHub()
  cs <- hub$icf_core_sets
  conds <- unique(cs$condition)
  hit <- tolower(cs$condition) == tolower(condition)
  if (!any(hit)) {
    stop("unknown condition '", condition, "'. Available: ",
         paste(conds, collapse = ", "), ".", call. = FALSE)
  }
  out <- cs[hit & tolower(cs$brief_vs_comprehensive) == level, , drop = FALSE]
  if (!nrow(out)) {
    avail <- unique(cs$brief_vs_comprehensive[hit])
    warning("no '", level, "' Core Set for '", condition,
            "'; available level(s): ", paste(avail, collapse = ", "), ".",
            call. = FALSE)
  }
  rownames(out) <- NULL
  out
}

#' Look up ICF category titles
#'
#' Resolves ICF category codes to their titles (across the hub's Core-Set,
#' metric-link, and clinical ICF tables).
#'
#' @param codes A character vector of ICF codes (e.g. \code{c("b730", "d450")}).
#' @param hub Optional \code{PhysioAnnotationHub}.
#' @return A data frame with \code{icf_code} and \code{title} (\code{NA} title
#'   for an unknown code).
#' @seealso [getCoreSet()], [tagICF()]
#' @examples
#' icfCategories(c("b730", "d450"))
#' @export
icfCategories <- function(codes, hub = NULL) {
  if (is.null(hub)) hub <- loadAnnotationHub()
  codes <- as.character(codes)
  titles <- .icf_titles(hub)
  data.frame(icf_code = codes, title = unname(titles[codes]),
             stringsAsFactors = FALSE)
}
