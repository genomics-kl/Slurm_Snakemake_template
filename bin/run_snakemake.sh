#!/bin/bash
#SBATCH --export=NONE
#SBATCH -J hello_workflow
#SBATCH -o hello_workflow.o
#SBATCH -e hello_workflow.e
#SBATCH --ntasks 1
#SBATCH --time 24:00:00
#SBATCH --mem=8G

cd $SLURM_SUBMIT_DIR

snakemake_module="bbc2/snakemake/snakemake-7.25.0"

module load $snakemake_module

# make logs dir if it does not exist already. 
logs_dir="logs/"
[[ -d $logs_dir ]] || mkdir -p $logs_dir


echo "Start snakemake workflow." >&1                   
echo "Start snakemake workflow." >&2     

snakemake \
-p \
--latency-wait 20 \
--snakefile 'Snakefile' \
--use-envmodules \
--jobs 100 \
--cluster "ssh ${SLURM_JOB_USER}@access.hpc.vai.org 'module load $snakemake_module; cd $SLURM_SUBMIT_DIR; mkdir -p \`dirname {params.stdout}\`; sbatch \
-p ${SLURM_JOB_PARTITION} \
--export=ALL \
--ntasks {threads} \
--mem={resources.mem_gb}G \
-t 48:00:00 \
-o {params.stdout} \
-e {params.stderr}'" # SLURM hangs if output dir does not exist, so we create it before running sbatch on the snakemake jobs.
#--slurm \
#--default-resources slurm_account=${SLURM_JOB_USER} slurm_partition=${SLURM_JOB_PARTITION}

echo "snakemake workflow done." >&1                   
echo "snakemake workflow done." >&2                   
