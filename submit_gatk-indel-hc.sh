#!/bin/sh

#SBATCH --ntasks=1 
#SBATCH --mem=32000
#SBATCH --cpus-per-task=1
#SBATCH -p hns,normal,schumer,owners
#SBATCH --time=48:00:00
#SBATCH --job-name=gatk-indel-hc

module load biology
module load samtools
module load java
