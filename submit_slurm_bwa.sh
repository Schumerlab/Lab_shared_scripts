#!/bin/sh

#SBATCH --ntasks=1 
#SBATCH --mem=64000
#SBATCH --cpus-per-task=1
#SBATCH -p hns,normal,schumer,owners
#SBATCH --time=48:00:00
#SBATCH --job-name=bwa-mem

module load biology
module load bwa
module load java
