#' pvalue_AUC
#'
#' @param df
#' @param permdir
#'
#' @return
#' @export
#'
#' @examples
pvalue_AUC <- function(df, permdir){
  # Check if permdir ends with a "/"
  if (substr(permdir, nchar(permdir), nchar(permdir)) != "/") {
    permdir <- paste0(permdir, "/")
  }

  mcp <- lapply(rownames(df), function(x){
    file <- paste(permdir, x ,"_ramd_auc.RData", sep="")
    load(file)
    res <- res[c(1:(nrow(res)-2)),]
    r <- lapply(colnames(df)[c(1:(ncol(df)-2))], function(y){
      p <- mc_pvalue(df[x,y], res[y,])
      return(p)
    })
    return(r)
  })
  df.mc.p <- data.frame(matrix(unlist(mcp), byrow = T, ncol = length(mcp[[1]]) ))
  colnames(df.mc.p) <- colnames(df)[c(1:(ncol(df)-2))]
  rownames(df.mc.p) <- rownames(df)
  return(df.mc.p)
}


#' mc_pvalue
#'
#' @param observed
#' @param replicates
#'
#' @return
#' @export
#'
#' @examples
mc_pvalue <- function(observed, replicates) {
  replicates <- as.vector(as.matrix(replicates))
  if (length(replicates) == 0) {
    return(NULL)
  } else {
    f <- Vectorize(
      function(y) {
        (1 + sum(replicates > y)) / (1 + length(replicates))
      }
    )

    return(f(observed))
  }
}
