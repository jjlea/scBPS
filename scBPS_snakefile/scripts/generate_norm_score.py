import os
import pandas as pd
import argparse


# Argument parsing
parser = argparse.ArgumentParser(description="generate_norm_score")
parser.add_argument("infile", type=str, help="Path to the input file (tab-separated).")
parser.add_argument("outfile", type=str, help="Path to the output folder.")
args = parser.parse_args()


# Read the list of gene score files
df_gs = pd.read_csv(args.infile, header=None)

# Read each gene score file and store it in a dictionary
dict_df_stats = {
    trait: pd.read_csv(trait, sep="\t", index_col=0)
    for trait in df_gs.iloc[:, 0]
}

# Get the list of traits (column names)
trait_list = list(dict_df_stats.keys())

# Concatenate the norm_score columns into a single DataFrame
df_norm = pd.concat(
    [dict_df_stats[trait]["norm_score"] for trait in trait_list], axis=1
)

# Set column names to the list of traits

df_norm.columns = trait_list
df_norm.columns = [os.path.basename(col).replace(".score", "") for col in df_norm.columns]



# Save the result to the specified output file
df_norm.to_csv(args.outfile, sep="\t")

