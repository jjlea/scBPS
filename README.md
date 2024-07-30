# scBPS

## install
```R
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("DelayedMatrixStats")
```

```R

load("/Users/chunyudeng/Library/CloudStorage/OneDrive-共享的库-Onedrive/RPakage/scBPS/Test/test_data.RData")
rankscore <- buildRankings(myscore)
df <- calc.AUC2(ids, myanno, rankscore, 0.05)
# 产生随机AUC
num <- reshape2::dcast(myanno, free_annotation2~"num", fun.aggregate = function(x){length(x)})
rownames(num) <- num[,1]
lapply(ids, function(x){
    perm_cal2(x,num, 1000, myanno, rankscore, 0.05)})


# 计算p值
p_df <- pvalue_AUC(df,"./test")

```