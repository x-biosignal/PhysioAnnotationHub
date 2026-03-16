#' Query the Knowledge Graph by triple pattern
#'
#' @param subject Character or NULL; entity name pattern (grep)
#' @param predicate Character or NULL; relation type (exact or grep)
#' @param object Character or NULL; target entity pattern (grep)
#' @param hub AnnotationHub object (loaded if NULL)
#' @param exact Logical; use exact matching instead of grep (default FALSE)
#' @return data.frame of matching triples
#' @export
queryKG <- function(subject = NULL, predicate = NULL, object = NULL,
                    hub = NULL, exact = FALSE) {
  if (is.null(hub)) hub <- loadAnnotationHub()

  triples <- hub$triples

  if (!is.null(subject)) {
    if (exact) {
      triples <- triples[triples$subject == subject, ]
    } else {
      triples <- triples[grep(subject, triples$subject, ignore.case = TRUE), ]
    }
  }
  if (!is.null(predicate)) {
    if (exact) {
      triples <- triples[triples$predicate == predicate, ]
    } else {
      triples <- triples[grep(predicate, triples$predicate, ignore.case = TRUE), ]
    }
  }
  if (!is.null(object)) {
    if (exact) {
      triples <- triples[triples$object == object, ]
    } else {
      triples <- triples[grep(object, triples$object, ignore.case = TRUE), ]
    }
  }

  triples
}

#' Get KG neighbors of an entity
#'
#' @param entity Character; entity name
#' @param depth Integer; traversal depth (default 1)
#' @param hub AnnotationHub object
#' @return data.frame of all triples within depth hops
#' @export
kgNeighbors <- function(entity, depth = 1, hub = NULL) {
  if (is.null(hub)) hub <- loadAnnotationHub()

  visited <- character(0)
  frontier <- entity
  all_triples <- data.frame()

  for (d in seq_len(depth)) {
    new_triples <- do.call(rbind, lapply(frontier, function(e) {
      as_subj <- hub$triples[hub$triples$subject == e, ]
      as_obj <- hub$triples[hub$triples$object == e, ]
      rbind(as_subj, as_obj)
    }))

    if (is.null(new_triples) || nrow(new_triples) == 0) break

    all_triples <- rbind(all_triples, new_triples)
    visited <- c(visited, frontier)

    neighbors <- unique(c(new_triples$subject, new_triples$object))
    frontier <- setdiff(neighbors, visited)
  }

  unique(all_triples)
}

#' Find shortest path between two entities in the KG
#'
#' @param from Character; source entity name
#' @param to Character; target entity name
#' @param hub AnnotationHub object
#' @param max_depth Integer; maximum search depth (default 5)
#' @return List with path (entities), predicates, and depth
#' @export
kgShortestPath <- function(from, to, hub = NULL, max_depth = 5) {
  if (is.null(hub)) hub <- loadAnnotationHub()

  # BFS
  queue <- list(list(node = from, path = from, preds = character(0)))
  visited <- from

  for (iter in seq_len(max_depth * 100)) {
    if (length(queue) == 0) {
      return(list(path = character(0), predicates = character(0),
                  depth = Inf, found = FALSE))
    }

    current <- queue[[1]]
    queue <- queue[-1]

    # Get neighbors
    as_subj <- hub$triples[hub$triples$subject == current$node, ]
    as_obj <- hub$triples[hub$triples$object == current$node, ]

    # Check outgoing edges
    if (nrow(as_subj) > 0) {
      for (i in seq_len(nrow(as_subj))) {
        neighbor <- as_subj$object[i]
        pred <- as_subj$predicate[i]

        if (neighbor == to) {
          return(list(
            path = c(current$path, neighbor),
            predicates = c(current$preds, pred),
            depth = length(current$path),
            found = TRUE
          ))
        }

        if (!neighbor %in% visited && length(current$path) < max_depth) {
          visited <- c(visited, neighbor)
          queue <- c(queue, list(list(
            node = neighbor,
            path = c(current$path, neighbor),
            preds = c(current$preds, pred)
          )))
        }
      }
    }

    # Check incoming edges (reverse direction)
    if (nrow(as_obj) > 0) {
      for (i in seq_len(nrow(as_obj))) {
        neighbor <- as_obj$subject[i]
        pred <- paste0("inv:", as_obj$predicate[i])

        if (neighbor == to) {
          return(list(
            path = c(current$path, neighbor),
            predicates = c(current$preds, pred),
            depth = length(current$path),
            found = TRUE
          ))
        }

        if (!neighbor %in% visited && length(current$path) < max_depth) {
          visited <- c(visited, neighbor)
          queue <- c(queue, list(list(
            node = neighbor,
            path = c(current$path, neighbor),
            preds = c(current$preds, pred)
          )))
        }
      }
    }
  }

  list(path = character(0), predicates = character(0),
       depth = Inf, found = FALSE)
}
