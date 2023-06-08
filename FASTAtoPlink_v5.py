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
    description="Convert fasta to plink inputs (ped, map, and nosex). Designed to take a single chromosome pulled from pseudo ref files.")
parser.add_argument('--fastaName', help="chromosome FASTA file, required", required=True)
parser.add_argument('--outputPrefix', help="Output prefix, optional, will default to fasta name")
parser.add_argument('--famInput', help="Fam file, optional")
parser.add_argument('--propMissing', help="Proportion of samples that can have an N for a SNP to be found, required", required=True)
args = parser.parse_args()

fastaName = args.fastaName
if args.outputPrefix:
    outPrefix = args.outputPrefix
else:
    outPrefix = fastaName
pedFileName = outPrefix + ".ped"
mapFileName = outPrefix + ".map"
famFileName = outPrefix + ".fam"
if args.famInput: famInput = args.famInput
#ignoreN = float(sys.argv[3])
ignoreN = float(args.propMissing)
print(str(ignoreN))

chrID = ""
snpDict = {}
sampleDict = {}
sampleList = list()
chrLength = int()
fasta = open(fastaName, 'r')
for seq_record in SeqIO.parse(fasta, "fasta"):
    sampleName = seq_record.id
    sampleList.append(sampleName)
    sampleDict[sampleName] = seq_record.seq
    sampleNameSplit = sampleName.split(":")
    chrID = sampleNameSplit[-1]
    chrLength = len(seq_record.seq)
    snpDict[sampleName] = str()

print(len(sampleList))

#Family ID  Individual ID   Paternal ID Maternal ID Sex (1=male; 2=female; other=unknown)   Phenotype
famDict = {}
if os.path.isfile(famInput):
    famKey = open(famInput, 'r')
    lines = famKey.read().splitlines()
    for line in lines:
        spampleInfo = line.split()
        famID = spampleInfo[0]
        sampleName = spampleInfo[1] + ":" + chrID
        fatherID = spampleInfo[2]
        if re.match('0', fatherID):
            fatherID = fatherID
        else:
            fatherID = fatherID + ":" + chrID
        motherID = spampleInfo[3]
        if re.match('0', motherID):
            motherID = motherID
        else:
            motherID = motherID + ":" + chrID
        famDict[sampleName] = famID + " " + sampleName + " " + fatherID + " " + motherID + " " + spampleInfo[4] + " " + spampleInfo[5]
else:
    for sample in sampleList:
        famDict[sample] = "NA " + sample + " 0 0 0 -9"

SNPpos = str()
first = sampleList[0]
refMissing = 0
start = time.time()
posOutFile = open(mapFileName, 'w')
for i in xrange(0, chrLength): #go through the genome position by position
    compare = sampleDict[first][i]
    if re.match('A|T|C|G|M|R|W|S|Y|K|N', compare, re.IGNORECASE):
        matches = 0
        missing = 0
        SNP = 0
        propMiss = 0.0
        newComp = 'N'
        if re.match('N', compare):
            missing = 1
            for sample in sampleList[1: len(sampleList)]:
                if re.match('A|T|C|G|M|R|W|S|Y|K', sampleDict[sample][i], re.IGNORECASE):
                    newComp = sampleDict[sample][i]
        else:
            newComp = compare
        if re.match('A|T|C|G|M|R|W|S|Y|K', newComp, re.IGNORECASE):
            for sample in sampleList[1: len(sampleList)]:
                if re.match(newComp, sampleDict[sample][i], re.IGNORECASE):
                    matches += 1
                else:
                    if re.match('A|T|C|G|M|R|W|S|Y|K', sampleDict[sample][i], re.IGNORECASE):
                        SNP += 1
                    elif re.match('N', sampleDict[sample][i]):
                        missing += 1
        else:
            missing = len(sampleList)
        propMiss = float(missing)/len(sampleList)
        if SNP>0 and propMiss<=ignoreN:
            #posOutFile.write("\n"+str(i+))
            endTime = time.time()-start
            if 60 < endTime < 3600:
                min = int(endTime)/60
                sec = int(endTime-(min*60))
                elapsedTime = str(min) + " mins " + str(sec) + " secs"
            elif 3600 < endTime < 86400:
                hr = int(endTime)/3600
                min = int((endTime - (hr*3600))/60)
                sec = int(endTime - ((hr*60)*60 + (min*60)))
                elapsedTime = str(hr) + " hrs " + str(min) + " mins " + str(sec) + " secs"
            elif 86400 < endTime < 604800:
                day = int(endTime)/86400
                hr = int((endTime-(day*86400))/3600)
                min = int((endTime - (hr*3600+day*86400))/60)
                sec = int(endTime - ((day*86400) + (hr*3600) + (min*60)))
                elapsedTime = str(day)  + " days " + str(hr) + " hrs " + str(min) + " mins " + str(sec) + " secs"
            else:
                elapsedTime = str(int(endTime)) + " secs"
            print("%.5f" % ((i/float(chrLength))*100) + "%" + "\tElapsed time: " + elapsedTime)
            chrNum = 1
            #SNPid = str()
            truPos = i+1
            #chrInfo = str()
            chrPos = truPos
            SNPid = chrID + "_" + str(chrPos)
            #SNPid = SNP
            chrInfo = str(chrID) + "\t" + str(SNPid) + "\t0\t" + str(truPos) + "\n"
            SNPpos += chrInfo
            posOutFile.write(chrInfo)
            for sample in sampleList:
                SNPcode = sampleDict[sample][i]
                if (re.match('A|T|C|G', SNPcode, re.IGNORECASE)):
                    snpDict[sample] = snpDict[sample] + SNPcode + SNPcode + " "
                elif (re.match('M', SNPcode)):
                    snpDict[sample] = snpDict[sample] + "AC "
                elif (re.match('R', SNPcode)):
                    snpDict[sample] = snpDict[sample] + "AG "
                elif (re.match('W', SNPcode)):
                    snpDict[sample] = snpDict[sample] + "AT "
                elif (re.match('S', SNPcode)):
                    snpDict[sample] = snpDict[sample] + "CG "
                elif (re.match('Y', SNPcode)):
                    snpDict[sample] = snpDict[sample] + "CT "
                elif (re.match('K', SNPcode)):
                    snpDict[sample] = snpDict[sample] + "GT "
                else:
                    snpDict[sample] = snpDict[sample] + "00 "


#posOutFile = open(mapFileName, 'w')
#posOutFile.write(SNPpos)
posOutFile.close()

outFile = open(pedFileName, 'w')
for sample in sampleList:
    print(sample)
    sampleLine = famDict[sample]
    outFile.write(sampleLine + "\t" +snpDict[sample] + "\n")

outFile.close()

famOutFile = open(famFileName, 'w')
for sample in sampleList:
    #print(sample)
    sampleLine = famDict[sample]
    famOutFile.write(sampleLine + "\n")

famOutFile.close()