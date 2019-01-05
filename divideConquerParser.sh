#!/bin/bash

#Divides an input Illumina readset into n parts
#then parses the parts using n cores
#and finally combines the n parts of each parsed dataset

##NOTE: assumes that barcode_splitter.py is in the same directory, if it is not then edit the path below!

if [[ -z "$1" ]]; then
   echo "Usage:"
   echo " divideConquerParser.sh [# read files] [List of FASTQs IN QUOTES] [# cores to use] [barcode file] [which position in FASTQ list is index read]"
   exit
fi
#Read in the command line arguments:
NUMFILES=$1
read -r -a READFILES <<< "$2"
NUMPARTS=$3
BCFILE=$4
IDXREAD=$5
if [[ $1 -lt 2 ]]; then
   echo "Error: Not enough read files specified, there must be at least 2 (R1 and I1)"
   exit
fi
if [[ ${NUMFILES} -ne ${#READFILES[@]} ]]; then
   echo "Error: Number of files (${NUMFILES}) does not match length of list of filenames (${#READFILES[@]})."
   exit
fi
for READFILE in $READFILES; do
   if [[ ! -e "${READFILE}" ]]; then
      echo "Error: ${READFILE} does not exist."
      exit
   fi
done
if [[ -z "$3" || $3 -lt 1 ]]; then
   echo "Error: No number of parts to split into specified."
   exit
fi
if [[ ! -e "$4" ]]; then
   echo "Error: Barcode file not specified or does not exist."
   exit
fi
if [[ $5 -lt 1 || $5 -gt ${NUMFILES} ]]; then
   echo "Error: Invalid index read position specified."
   exit
fi
if [[ -z "$6" ]]; then
   MISMATCHES=0
else
   MISMATCHES=$6
fi

#Specify the path to barcode_splitter.py:
BCSPLIT="/home/groups/schumer/shared_bin/Lab_shared_scripts/barcode_splitter.py"

#Construct the template barcode_splitter.py command:
#"--mismatches=${MISMATCHES} --idxread=${IDXREAD} --gzip --suffix=.fastq.gz --bcfile=${BCFILE} ${READFILES}"
FIRSTARGSET="--mismatches=${MISMATCHES} --idxread=${IDXREAD} --gzip --suffix=.fastq.gz --bcfile=${BCFILE}"

#Determine the number of reads per part:
NUMLINES=`gzip -dcf ${READFILES[${IDXREAD}-1]} | wc -l`
(( NUMREADS = NUMLINES / 4 ))
(( READSPERPART = NUMREADS / NUMPARTS + 1 ))
echo "Splitting read files into parts with ${READSPERPART} reads or less."
(( LINESPERPART = READSPERPART * 4 ))

#Split the files into parts with names similar to the input filename (using a 2 digit number to indicate the part):
for READFILE in "${READFILES[@]}"; do
   FILEPREFIX=${READFILE//.fastq.gz/_}
   gzip -dcf ${READFILE} | split -d -l ${LINESPERPART} - ${FILEPREFIX}
   echo "gzip -dcf ${READFILE} | split -d -l ${LINESPERPART} - ${FILEPREFIX}"
   #Make sure to gzip the split output so that barcode_splitter.py doesn't whine:
   for ((i=0;i<NUMPARTS;i++)); do
      printf -v I "%02d" ${i}
      gzip ${FILEPREFIX}${I}
      echo "gzip ${FILEPREFIX}${I}"
   done
   #To be more general, we might want to add the -a argument to split
   #However, splitting into up to 99 parts should be more than enough
   #for most use cases
done

echo "Running ${NUMPARTS} instances of barcode_splitter.py."

#Running barcode_splitter.py on each of the parts in parallel:
for ((i=0;i<NUMPARTS;i++)); do
   printf -v I "%02d" ${i}
   BCSPLITCMD="${BCSPLIT} ${FIRSTARGSET} --prefix=Part${I}_"
#   for PREFIX in "${PREFIXES[@]}"; do
#      BCSPLITCMD="${BCSPLITCMD} ${PREFIX}${I}.gz"
#   done
   for READFILE in "${READFILES[@]}"; do
      FILEPREFIX=${READFILE//.fastq.gz/_}
      BCSPLITCMD="${BCSPLITCMD} ${FILEPREFIX}${I}.gz"
   done
   ${BCSPLITCMD} 2>&1 > Part${i}.log & 
   echo "${BCSPLITCMD} 2>&1 > Part${i}.log &"
done
wait

echo "Coalescing the parsed reads file parts."
while read -r -a fields; do
   for ((i=1;i<=NUMFILES;i++)); do
      JOINCMD="cat"
      RMCMD="rm -f"
      for ((j=0;j<NUMPARTS;j++)); do
         printf -v J "%02d" ${j}
         JOINCMD="${JOINCMD} Part${J}_${fields[0]}_read_${i}.fastq.gz"
         RMCMD="${RMCMD} Part${J}_${fields[0]}_read_${i}.fastq.gz"
      done
      ${JOINCMD} > ${fields[0]}_read_${i}.fastq.gz
      echo "${JOINCMD} > ${fields[0]}_read_${i}.fastq.gz"
      #Remove the subset files after successfully merging:
      ${RMCMD}
      echo "${RMCMD}"
   done
done < ${BCFILE}
#Don't forget to coalesce the unmatched reads files!:
for ((i=1;i<=NUMFILES;i++)); do
   JOINCMD="cat"
   RMCMD="rm -f"
   for ((j=0;j<NUMPARTS;j++)); do
      printf -v J "%02d" ${j}
      JOINCMD="${JOINCMD} Part${J}_unmatched_read_${i}.fastq.gz"
      RMCMD="${RMCMD} Part${J}_unmatched_read_${i}.fastq.gz"
   done
   ${JOINCMD} > unmatched_read_${i}.fastq.gz
   echo "${JOINCMD} > unmatched_read_${i}.fastq.gz"
   #Remove the subset unmatched reads files after succesfully merging:
   ${RMCMD}
   echo "${RMCMD}"
done

#Clean up the split original read files:
for READFILE in "${READFILES[@]}"; do
   FILEPREFIX=${READFILE//.fastq.gz/_}
   for ((i=0;i<NUMPARTS;i++)); do
      printf -v I "%02d" ${i}
      rm -f ${FILEPREFIX}${I}.gz
      echo "rm -f ${FILEPREFIX}${I}.gz"
   done
done

exit
