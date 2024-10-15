args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
anno <- args[2]
outfile <- args[3] 
outfile_AUC <- args[4] 
outfile_abs <- normalizePath(outfile)
rand_dir <- file.path(dirname(outfile_abs), "tmp/")


# Check if the 'rand' directory exists; if not, create it
if (!dir.exists(rand_dir)) {
  dir.create(rand_dir, recursive = TRUE)
  print(paste("Created directory:", rand_dir))
}

# Load necessary libraries
library(scBPS)
library(DelayedArray)
library(data.table)
library(reshape2)
myanno <- fread(file=anno, header=TRUE, stringsAsFactors=FALSE)
ids <- as.character(unique(myanno$cell_annotation))
ids <- ids[which(ids != "other")]

# Read norm_score file from the first command-line argument
score <- data.table::fread(file=infile, header = TRUE, stringsAsFactors = FALSE)
score <- data.frame(score)
rownames(score) <- score$cell_id
score$cell_id <- NULL

# Generate rank score
rankscore <- buildRankings(score)

# Calculate AUC
df <- calc.AUC2(ids, myanno, rankscore, 0.05)

# Perform random AUC calculation and save results to the 'rand' directory
num <- reshape2::dcast(myanno, cell_annotation ~ "num", fun.aggregate = function(x) {length(x)})
rownames(num) <- num[, 1]
lapply(ids, function(x) {
  perm_cal2(x, num, 1000, myanno, rankscore, 0.05, mydir = rand_dir)
})

# Calculate p-values and save to the output file
p_df <- pvalue_AUC(df, rand_dir)
fwrite(p_df, file=outfile, sep="\t", row.names=TRUE, col.names=TRUE)
fwrite(df, file=outfile_AUC, sep="\t", row.names=TRUE, col.names=TRUE)
