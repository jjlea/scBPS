

import scdrs
from anndata import AnnData
from scipy import stats
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import os
import warnings
import scanpy as sc
import gc
from sklearn.externals import joblib
import argparse
import logging


# Argument parsing
parser = argparse.ArgumentParser(description="compute-score")
parser.add_argument("input_file", type=str, help="Path to the input file (tab-separated).")
parser.add_argument("out_folder", type=str, help="Path to the output folder.")
parser.add_argument("adata_file", type=str, help="Path to the adata preprocessed file.")  

args = parser.parse_args()




# Set up logging
logfile = args.out_folder + "compute_score.log"
logging.basicConfig(filename=logfile, level=logging.INFO, 
                    format="%(asctime)s - %(levelname)s - %(message)s")

# Function to output log
def log_message(message):
    logging.info(message)
    print(message)




ff1= ['%s','%.5f','%.8f',"%.4e","%.4e",'%.5f','%.6f']
ff2=['%.5f']*1000
ff = ff1 + ff2

def df2csv(df,fname,myformats=[],sep='\t'):
  """
    # function is faster than to_csv
    # 7 times faster for numbers if formats are specified, 
    # 2 times faster for strings.
    # Note - be careful. It doesn't add quotes and doesn't check
    # for quotes or separators inside elements
    # We've seen output time going down from 45 min to 6 min 
    # on a simple numeric 4-col dataframe with 45 million rows.
  """
  if len(df.columns) <= 0:
    return
  Nd = len(df.columns)
  Nd_1 = Nd - 1
  formats = myformats[:] # take a copy to modify it
  Nf = len(formats)
  # make sure we have formats for all columns
  if Nf < Nd:
    for ii in range(Nf,Nd):
      coltype = df[df.columns[ii]].dtype
      ff = '%s'
      if coltype == np.int64:
        ff = '%d'
      elif coltype == np.float64:
        ff = '%f'
      formats.append(ff)
  fh=open(fname,'w')
  fh.write('\t'.join(df.columns) + '\n')
  for row in df.itertuples(index=False):
    ss = ''
    for ii in range(Nd):
      ss += formats[ii] % row[ii]
      if ii < Nd_1:
        ss += sep
    fh.write(ss+'\n')
  fh.close()
  
  # Assign the output folder to OUT_FOLDER
OUT_FOLDER = args.out_folder
if not os.path.exists(OUT_FOLDER):
    os.makedirs(OUT_FOLDER)


# Load the data
df_gs = scdrs.util.load_gs(args.input_file)
ls = pd.read_csv(args.input_file, sep="\t", index_col=0)
adata_file_path = args.adata_file
adata = sc.read_h5ad(adata_file_path)
scdrs.preprocess(adata)


for i in range(len(ls)):
    trait=ls.index[i]
    gene_list = df_gs[trait][0]
    gene_weight = df_gs[trait][1]
    df_res = scdrs.score_cell(adata, gene_list, gene_weight=gene_weight, n_ctrl=1000, return_ctrl_norm_score=False, copy=True)
    df_res.insert(0, "cell_id", df_res.index)
    df2csv(df_res.iloc[:, 0:7],
           os.path.join(OUT_FOLDER, "%s.score" % trait),
           myformats=ff1) 
    del df_res
    gc.collect()

# Log the end of the process
log_message("Compute score finished")
