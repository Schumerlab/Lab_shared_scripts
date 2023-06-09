__author__ = 'Quinn'

from Bio import SeqIO
import sys
import re
import argparse
from Bio.Seq import MutableSeq
from Bio.Alphabet import IUPAC
import time
import os.path

parser = argparse.ArgumentParser(
    description="Convert output of phasing with shapeit2 to create haplotype fa file and SNP sequence file and SNP position file.")
parser.add_argument('--inputFASTA', help="chromosome FASTA pseduoref file, required", required=True)
parser.add_argument('--outputPrefix', help="Output prefix, optional, will default to haplotype_inputFASTA")
parser.add_argument('--shapeitInput', help="Shapeit output prefix", required=True)
parser.add_argument('--mendelInput', help="List of mendelian error SNPs to mask")
args = parser.parse_args()

inputFASTA = args.inputFASTA
shapeitInput = args.shapeitInput
if args.outputPrefix:
    outPrefix = args.outputPrefix
    outHapFa = "haplotype_" + outPrefix + ".fa"
    outSNPfa = "snpSeq_" + outPrefix + ".fa"
    outSNPpos = "snpPos_" + outPrefix + ".fa.txt"
else:
    outHapFa = "haplotype_" + inputFASTA
    outSNPfa = "snpSeq_" + inputFASTA
    outSNPpos = "snpPos_" + inputFASTA + ".txt"

shapeitSample = shapeitInput + ".sample"
shapeitHaps = shapeitInput + ".haps"

sampleList = list()
with open(shapeitSample) as samples:
    lines = samples.readlines()[2:]
    for line in lines:
        sampleInfo = line.split()
        sampleID = sampleInfo[1]
        sampleList.append(sampleID)

snpDict = {}
faDict = {}
sampleDict = {}
faOutSampleList = list()
chrLength = int()
fasta = open(inputFASTA, 'r')
for seq_record in SeqIO.parse(fasta, "fasta"):
    sampleName = seq_record.id
    sampleDict[sampleName] = seq_record.seq
    sampleNameSplit = sampleName.split("_")
    chrID = sampleNameSplit[-1]
    chrLength = len(seq_record.seq)
    if not (re.search('offspring', sampleName)):
        faOutSampleList.append(sampleName)
        snpDict[sampleName] = dict(hap1=str(), hap2=str())
        faDict[sampleName] = dict(hap1=seq_record.seq.tomutable(), hap2=seq_record.seq.tomutable())

print(len(faOutSampleList))

if args.mendelInput:
    mendelMaskFile = args.mendelInput
    mendelMask = open(mendelMaskFile, 'r')
    mLines = mendelMask.read().splitlines()
    for mLine in mLines:
        mLineInfo = mLine.split("_")
        pos1 = int(mLineInfo[-1])
        pos0 = pos1 - 1
        for sampleID in sampleList:
            if not (re.search('offspring', sampleID)):
                faDict[sampleID]['hap1'][pos0] = 'N'
                faDict[sampleID]['hap2'][pos0] = 'N'

posOutFile = open(outSNPpos, 'w')
hapsKey = open(shapeitHaps, 'r')
lines = hapsKey.read().splitlines()
for line in lines:
    lineInfo = line.split()
    chrom = lineInfo[0]
    snpID = lineInfo[1]
    snpBase1pos = int(lineInfo[2])
    snpPos = snpBase1pos - 1
    #print(snpPos)
    posOutFile.write(str(snpPos) + "\n")
    nt0 = lineInfo[3]
    nt1 = lineInfo[4]
    count = 5
    for sampleID in sampleList:
        sampleHap1key = int(lineInfo[count])
        sampleHap2key = int(lineInfo[count + 1])
        if sampleHap1key == 0:
            sampleHap1nt = nt0
        elif sampleHap1key == 1:
            sampleHap1nt = nt1
        if sampleHap2key == 0:
            sampleHap2nt = nt0
        elif sampleHap2key == 1:
            sampleHap2nt = nt1
        if not (re.search('offspring', sampleID)):
            curNT = faDict[sampleID]['hap1'][snpPos]
            if re.match('N', curNT):
                snpDict[sampleID]['hap1'] = snpDict[sampleID]['hap1'] + 'N'
                snpDict[sampleID]['hap2'] = snpDict[sampleID]['hap2'] + 'N'
            else:
                #print(sampleID + " newNT1 " + sampleHap1nt + " newNT2 " + sampleHap2nt)
                snpDict[sampleID]['hap1'] = snpDict[sampleID]['hap1'] + sampleHap1nt
                snpDict[sampleID]['hap2'] = snpDict[sampleID]['hap2'] + sampleHap2nt
                #print(sampleID + " oldNT1 " + faDict[sampleID]['hap1'][snpPos] + " oldNT2 " + faDict[sampleID]['hap2'][snpPos])
                faDict[sampleID]['hap1'][snpPos] = sampleHap1nt
                faDict[sampleID]['hap2'][snpPos] = sampleHap2nt
        count = count + 2

posOutFile.close()

hapOutFile = open(outHapFa, 'w')
snpOutFile = open(outSNPfa, 'w')
for sampleID in faOutSampleList:
    snpOutFile.write(">" + sampleID + "_hap1\n" +  snpDict[sampleID]['hap1'] + "\n>" + sampleID + "_hap2\n" +  snpDict[sampleID]['hap2'] + "\n")
    hapOutFile.write(">" + sampleID + "_hap1\n" +  str(faDict[sampleID]['hap1']) + "\n>" + sampleID + "_hap2\n" +  str(faDict[sampleID]['hap2']) + "\n")

hapOutFile.close()
snpOutFile.close()


