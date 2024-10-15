#' @title Generate N random control AUCs for each cell type.
#'
#' @param id A vector of all cell type ids to be analyzed.
#' @param num Provide the number of cells within each cell type.
#' @param n The number of control AUCs for each cell type.
#' @param anno The annotation table with two columns. The first column: cell_id; The second column: cell_type annotation.
#' @param rankscore The table containing the rankings of all cells, generated from buildRankings() function.
#' @param percent The top-rank threshold used for calculating AUC.
#'
#' @return Random AUC files in RData format.
#' @export
#'
#' @examples
perm_cal2 <- function(id, num, n, anno, rankscore, percent,mydir){
  res <- list()
  for (k in 1:n){
    rannum <- round(runif (num[id,"num"], min = 1, max = nrow(rankscore)))
    ranid <- anno$cell_id[rannum]
    res[[k]] <- round(calc.AUC_ram2(ranid, rankscore, percent),5)
  }
  res <- data.frame(res)
  colnames(res) <- paste("ramd",c(1:n), sep = "")
  save(res, file=paste(mydir, id ,"_ramd_auc.RData", sep=""))
}



#' calc.AUC_ram2
#'
#' @param ids
#' @param cells_rankings
#' @param percent
#'
#' @return
#' @export
#'
#' @examples
calc.AUC_ram2 <- function(ids,  cells_rankings, percent){
  res <- AUC.cellSet2(cellSet=ids, rankings=cells_rankings, aucMaxRank=ceiling(percent*nrow(cells_rankings)))
  return(res)
}



