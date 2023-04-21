#!/bin/bash
#SBATCH --export=NONE
#SBATCH -J hello_workflow
#SBATCH -o logs/hello_workflow.o
#SBATCH -e logs/hello_workflow.e
#SBATCH --ntasks 1
#SBATCH --time 24:00:00
#SBATCH --mem=8G

cd $SLURM_SUBMIT_DIR

snakemake_module="bbc2/snakemake/snakemake-7.25.0"

module load $snakemake_module

echo "Start snakemake workflow." >&1                   
echo "Start snakemake workflow." >&2     

snakemake \
-p \
--latency-wait 20 \
--snakefile 'Snakefile' \
--use-envmodules \
--jobs 100 \
--cluster "ssh ${SLURM_JOB_USER}@access.hpc.vai.org 'module load $snakemake_module; cd $SLURM_SUBMIT_DIR; sbatch \
-p ${SLURM_JOB_PARTITION} \
--export=ALL \
--ntasks {threads} \
--mem={resources.mem_gb}G \
-t 48:00:00 \
-o {log.stdout} \
-e {log.stderr}'"

echo "snakemake workflow done." >&1                   
echo "snakemake workflow done." >&2                   
