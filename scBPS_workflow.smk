

############ Top-level rule 
rule all:
    input:
        config["outdir"] + "/tmp/compute_score.log",
        config["outdir"] + "/tmp/list",             
	config["outdir"] + "/norm_score.tsv",
	config["outdir"] + "/pvalue_AUC.txt",
        config["outdir"] + "/BPS_AUC.txt"


############ Rule 1: Compute scores
rule compute_score:
    input:
        zscore=config["zscore_file"], 
        adata=config["scfile"] 
    output:
        log=config["outdir"] + "/tmp/compute_score.log",
        list=config["outdir"] + "/tmp/list"
    params:
        outdir=config["outdir"] + "/tmp/"
    shell:
        """
        python {workflow.basedir}/scripts/compute-score.py {input.zscore} {params.outdir} {input.adata}
        tail -n +2 {input.zscore} | cut -f1 | awk '{{print "{params.outdir}"$1".score"}}' | xargs realpath > {output.list}
        """

############# Rule 2: Generate merged score file
rule generate_norm_score:
    input:
        list=config["outdir"] + "/tmp/list"
    output:
        norm_score=config["outdir"] + "/norm_score.tsv",
    params:
        outdir=config["outdir"] 
    shell:
        """
        python {workflow.basedir}/scripts/generate_norm_score.py {input.list} {output.norm_score}
        """

############# Rule 3: Calculate AUC and p-value
rule calculate_AUC_pvalue:
    input:
        norm_score=config["outdir"] + "/norm_score.tsv",
        myanno=config["anno"]
    output:
        pauc=config["outdir"] + "/pvalue_AUC.txt",
        bpsauc=config["outdir"] + "/BPS_AUC.txt"
    shell:
        """
        Rscript {workflow.basedir}/scripts/calculate_AUC.R {input.norm_score} {input.myanno} {output.pauc} {output.bpsauc}
        """
