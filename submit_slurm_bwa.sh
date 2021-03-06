#!/bin/sh

#SBATCH --ntasks=1 
#SBATCH --mem=64000
#SBATCH --cpus-per-task=1
#SBATCH -p schumer
#SBATCH --time=24:00:00
#SBATCH --job-name=bwa-mem
#SBATCH --mail-user=schumer@stanford.edu

module load biology
module load bwa
module load java
