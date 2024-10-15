
#' getset
#'
#' @param x
#' @param mat
#'
#' @return
#'
#' @examples
getset <- function(x, mat){
  cells <- mat[which(mat[,2]==x),1]
  return(cells)
}




#' AUC.cellSet2
#'
#' @param cellSet
#' @param rankings
#' @param aucMaxRank
#'
#' @return
#' @export
#'
#' @examples
AUC.cellSet2 <- function(cellSet, rankings, aucMaxRank){
  cellSet <- unique(cellSet)
  ncells <- length(cellSet)
  cellSet <- cellSet[which(cellSet %in% rownames(rankings))]
  missing <- ncells-length(cellSet)

  gSetRanks <- rankings[which(rownames(rankings) %in% cellSet),,drop=FALSE]
  rm(rankings)

  aucThreshold <- round(aucMaxRank)
  #NEW version
  x_th <- 1:nrow(gSetRanks)
  x_th <- sort(x_th[x_th<aucThreshold])
  y_th <- seq_along(x_th)
  maxAUC <- sum(diff(c(x_th, aucThreshold)) * y_th)

  # Apply by columns (i.e. to each ranking)
  auc <- apply(gSetRanks, 2, auc, aucThreshold, maxAUC)

  return(c(auc, missing=missing, ncells=ncells))
}




#' auc
#'
#' @param oneRanking
#' @param aucThreshold
#' @param maxAUC
#'
#' @return
#'
#' @examples
auc <- function(oneRanking, aucThreshold, maxAUC)
{
  x <- unlist(oneRanking)
  x <- sort(x[x<aucThreshold])
  y <- seq_along(x)
  sum(diff(c(x, aucThreshold)) * y)/maxAUC
}

