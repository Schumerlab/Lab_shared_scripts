options(stringsAsFactors = F)
args <- commandArgs(TRUE)
chrNameFile <- args[1]


chrNameDF <- read.table(chrNameFile, header=F)

for (i in 1:nrow(chrNameDF)) {
  chrName <- chrNameDF$V1[i]
  print(chrName)
  mendel <- read.table(paste("allSNPs_allsamples_", chrName, ".mendel", sep=""), skip = 1, header = F)
  colnames(mendel) <-  c("FID", "KID", "CHR", "SNP", "CODE", "ERROR1", "ERROR2", "ERROR3", "ERROR4", "ERROR5")
  print(length(unique(mendel$SNP)))
  
  lmendel <- read.table(paste("allSNPs_allsamples_", chrName, ".lmendel", sep=""), header = T)
  print(nrow(subset(lmendel, N>0)))
  uniErrors <- subset(lmendel, N>0)$SNP
  write.table(uniErrors, paste("allSNPs_allsamples_", chrName, ".uniMendelSNPs", sep=""), row.names = F, col.names = F, quote = F)
}


