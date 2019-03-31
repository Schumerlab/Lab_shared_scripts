#!/bin/sh

#SBATCH --ntasks=1 
#SBATCH --mem=32000
#SBATCH --cpus-per-task=1
#SBATCH -p schumer
#SBATCH --time=48:00:00
#SBATCH --job-name=gatk-indel-hc
#SBATCH --mail-user=schumer@stanford.edu

module load biology
module load samtools
module load java
