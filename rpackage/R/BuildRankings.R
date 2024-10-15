#' @title Generate Ranking File According to The Cell-level Scores.
#'
#' @param Mat The matrix of the cell-level scores.
#'
#' @return The matrix of rankings
#' @export
#' @importFrom DelayedMatrixStats colRanks
#' @importFrom DelayedArray DelayedArray
#' @examples
#' \donnttest{
#' buildRankings(mydata)
#' }
buildRankings <- function(Mat){
  rowNames <- rownames(Mat)
  colNames <- colnames(Mat)
  Mat <- -Mat # ro rank decreasingly
  Mat2 <- DelayedMatrixStats::colRanks(DelayedArray::DelayedArray(Mat), ties.method="random", preserveShape=TRUE)
  # 检查维度是否一致
  dim_Mat <- dim(Mat)
  dim_Mat2 <- dim(Mat2)
  if (all(dim_Mat == dim_Mat2)) {
    # 维度一致，继续执行
    cat("Consistent dimensions, continue execution.")
    Mat <- Mat2
  } else {
    # 维度不一致，进行转置
    Mat <- t(Mat2)
    cat("The dimensions are not consistent, Mat has been replaced with t(Mat2).
")
  }
  rownames(Mat) <- rowNames
  colnames(Mat) <- colNames
  return(Mat)
}
