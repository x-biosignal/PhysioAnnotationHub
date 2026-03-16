#' Functional enrichment analysis for a set of muscles
#'
#' Tests whether a set of muscles is enriched for specific annotations
#' (actions, innervation, body regions) compared to the full set.
#'
#' @param muscles Character vector of muscle names (query set)
#' @param annotation_type Character; "action", "nerve", "body_region", "spinal_level"
#' @param hub AnnotationHub object
#' @return data.frame with term, count, expected, fold_enrichment, p_value
#' @export
kgEnrichment <- function(muscles, annotation_type = c("action", "nerve",
                                                       "body_region", "spinal_level"),
                          hub = NULL) {
  if (is.null(hub)) hub <- loadAnnotationHub()
  annotation_type <- match.arg(annotation_type)

  col <- switch(annotation_type,
    action = "action_primary",
    nerve = "nerve",
    body_region = "body_region",
    spinal_level = "spinal_level"
  )

  all_ann <- hub$muscles
  query_ann <- getMuscleAnnotation(muscles, hub)

  if (nrow(query_ann) == 0) {
    warning("No muscles matched in annotation hub")
    return(data.frame(term = character(0), count = integer(0),
                      expected = numeric(0), fold_enrichment = numeric(0),
                      p_value = numeric(0)))
  }

  N <- nrow(all_ann)  # total muscles
  n <- nrow(query_ann)  # query size

  # Count terms in query
  query_terms <- table(query_ann[[col]])
  all_terms <- table(all_ann[[col]])

  results <- data.frame(
    term = names(query_terms),
    count = as.integer(query_terms),
    total_in_background = as.integer(all_terms[names(query_terms)]),
    stringsAsFactors = FALSE
  )

  results$expected <- n * results$total_in_background / N
  results$fold_enrichment <- results$count / pmax(results$expected, 0.001)

  # Fisher's exact test (one-sided)
  results$p_value <- sapply(seq_len(nrow(results)), function(i) {
    k <- results$count[i]
    K <- results$total_in_background[i]
    # Hypergeometric test
    stats::phyper(k - 1, K, N - K, n, lower.tail = FALSE)
  })

  results <- results[order(results$p_value), ]
  rownames(results) <- NULL
  results
}
