#!/bin/bash
#SBATCH --account=OD-220926
#SBATCH --job-name AIV_pipe
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 8
#SBATCH --mem 32gb
#SBATCH --time 12:00:00

snakemake -s AIV_pipe.snakefile -j 8
