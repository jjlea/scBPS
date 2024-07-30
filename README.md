# scBPS

Bacteria Polygenic Score in  Single-cell data.
Description: a computational framework (scBPS) to incorporate microbial GWAS summary data with human single-cell transcriptomic data for the discovery of critical cellular contexts that are highly associated with gut microbial taxon.
## install

```R
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("DelayedMatrixStats")
devtools::install_github("sulab-wmu/scBPS")
```

## Simple test

```R
library(scBPS)
load("/Users/chunyudeng/Library/CloudStorage/OneDrive-共享的库-Onedrive/RPakage/scBPS/Test/test_data.RData")
rankscore <- buildRankings(myscore)
df <- calc.AUC2(ids, myanno, rankscore, 0.05)
# random AUC
num <- reshape2::dcast(myanno, free_annotation2~"num", fun.aggregate = function(x){length(x)})
rownames(num) <- num[,1]
lapply(ids, function(x){
    perm_cal2(x,num, 1000, myanno, rankscore, 0.05,mydir="./test/")})
# pvalue
p_df <- pvalue_AUC(df,"./test/")
```