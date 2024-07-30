#' @title Calculate AUC for Cell Types.
#'
#' @param ids A vector of all cell type ids to be analyzed.
#' @param anno The annotation table with two columns. The first column: cell_id; The second column: cell_type annotation.
#' @param cells_rankings The table containing the rankings of all cells, generated from buildRankings() function.
#' @param percent The top-rank threshold used for calculating AUC.
#'
#' @return AUC values for all cell type ids imported.
#' @export
#'
#' @examples
#' \donnttest{
#' calc.AUC2(id, anno, ranking, 0.05)
#' }
calc.AUC2 <- function(ids, anno,  cells_rankings, percent){
  res <- data.frame(lapply(ids, function(x){
    sub <- getset(x, anno)
    res <- AUC.cellSet2(cellSet=sub, rankings=cells_rankings, aucMaxRank=ceiling(percent*nrow(cells_rankings)))
    return(res)
  }))
  colnames(res) <- ids
  res <- data.frame(t(res))
  return(res)
}
