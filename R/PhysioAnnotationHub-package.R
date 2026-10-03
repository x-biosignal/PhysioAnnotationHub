#' PhysioAnnotationHub: anatomical and clinical knowledge graph for the ecosystem
#'
#' A lightweight, dependency-free (base-R only) annotation hub for the
#' [PhysioExperiment](https://github.com/x-biosignal/PhysioExperiment) ecosystem.
#' It bundles curated anatomical ontology data -- muscles, bones, nerves -- plus
#' clinical codes (ICD-10, ICF) and an anatomical knowledge graph, and exposes
#' them through a small query interface. All data ships as CSVs under
#' `inst/extdata`; nothing is downloaded at run time.
#'
#' @section Loading the hub:
#' * [loadAnnotationHub()] -- read all bundled datasets into one cached hub object
#'   (printing it gives a one-line summary of what is available).
#'
#' @section Anatomical queries:
#' * [getMuscleAnnotation()], [getBoneAnnotation()], [getNerveAnnotation()] --
#'   look up muscle / bone / nerve metadata by name or pattern (all rows if no
#'   name is given).
#' * [getClinicalCodes()] -- ICD-10 or ICF codes that reference a set of muscles.
#'
#' @section Knowledge graph:
#' * [queryKG()] -- match subject-predicate-object triples.
#' * [kgNeighbors()] -- triples within N hops of an entity.
#' * [kgShortestPath()] -- shortest path between two entities.
#' * [kgEnrichment()] -- over-representation of an annotation in a muscle set.
#'
#' @section ICF classification:
#' * [tagICF()], [linkInstrumentToICF()] -- map a metric / instrument to ICF codes.
#' * [getCoreSet()] -- a published WHO ICF Core Set for a condition.
#' * [icfCategories()] -- resolve ICF codes to their titles.
#'
#' @section Where to go next:
#' `vignette("annotation-hub", package = "PhysioAnnotationHub")` walks an
#' end-to-end query. Other ecosystem packages (e.g. PhysioMSKNet) import this hub
#' for anatomical metadata and knowledge-graph enrichment.
#'
#' @keywords internal
"_PACKAGE"
