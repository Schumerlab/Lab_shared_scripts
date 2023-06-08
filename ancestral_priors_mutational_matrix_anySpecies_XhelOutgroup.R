options(stringsAsFactors = F)
args <- commandArgs(TRUE)
chrName <- args[1]
focalSpecies <- args[2]
#chrName <- "ScPPXeE-431-HRSCAF-766"

if (file.exists(paste("allsamples_mendelRemoved_", chrName, ".shapeit2.phased.haps", sep=""))) {
  haps <- read.table(paste("allsamples_mendelRemoved_", chrName, ".shapeit2.phased.haps", sep=""), header=F)
} else if (file.exists(paste("allSNPs_allsamples_mendelRemoved_", chrName, ".shapeit2.phased.haps", sep=""))) {
  haps <- read.table(paste("allSNPs_allsamples_mendelRemoved_", chrName, ".shapeit2.phased.haps", sep=""), header=F)
} else {
  haps <- read.table(paste("allSNPs_allsamples_", chrName, ".shapeit2.phased.haps", sep=""), header=F)
}
#snpPos <- read.table(paste("snp_positions_birchmanni_", chrName, ".txt", sep=""), header=F)
anc <- read.table(paste("ancestral.", focalSpecies, "_", chrName, "-Xhel_", chrName, ".probs", sep=""), header=F)
colnames(anc) <- c("A", "C", "G", "T")
anc$posBase1 <- seq(1,nrow(anc),1)
anc$posBase0 <- seq(0,(nrow(anc)-1),1)

ancSnps <- subset(anc, posBase1 %in% haps$V3)

ancPriors <- data.frame(ancSnps$posBase0, ancSnps$A, ancSnps$C, ancSnps$G, ancSnps$T)
#write.table(ancPriors, paste("ancestral_", focalSpecies, "_", chrName, ".probs_snps_probs", sep=""), row.names = F, col.names = F, quote = F, sep="\t")

###LDhelemet doesn't seem to like 0s in the ancestral priors file so editing that now
if (nrow(ancPriors[which(ancPriors$ancSnps.A==0),])>0) {
  ancPriors$ancSnps.A[which(ancPriors$ancSnps.A==0)] <- 0.0000001
}
if (nrow(ancPriors[which(ancPriors$ancSnps.C==0),])>0) {
  ancPriors$ancSnps.C[which(ancPriors$ancSnps.C==0)] <- 0.0000001
}
if (nrow(ancPriors[which(ancPriors$ancSnps.G==0),])>0) {
  ancPriors$ancSnps.G[which(ancPriors$ancSnps.G==0)] <- 0.0000001
}
if (nrow(ancPriors[which(ancPriors$ancSnps.T==0),])>0) {
  ancPriors$ancSnps.T[which(ancPriors$ancSnps.T==0)] <- 0.0000001
}

write.table(format(ancPriors, scientific=FALSE), paste("ancestral_", focalSpecies, "_", chrName, ".probs_snps_probs.mod", sep=""), row.names = F, col.names = F, quote = F, sep="\t")

snpsBase0 <- ancSnps$posBase0
write.table(format(snpsBase0, scientific=FALSE), paste("snp_positions_base0_", focalSpecies, "_", chrName, ".txt", sep=""), row.names = F, col.names = F, quote = F, sep="\t")

anc$maxProb <- apply(anc[,1:4], 1, max, na.rm=T)
ancHiConf <- subset(anc, maxProb>0.95)
ancHiConf$ancNT <- colnames(ancHiConf)[apply(ancHiConf[,1:4],1,which.max)]

#write.table(ancHiConf, paste("ancestral_", focalSpecies, "_", chrName, ".probs_hiconf_ancNT", sep=""), row.names = F, quote = F, sep="\t")

ancSnpsHiConf <- subset(ancHiConf, posBase1 %in% haps$V3)
hapsHiConf <- subset(haps, V3 %in% ancSnpsHiConf$posBase1)

transDF <- data.frame(chr=hapsHiConf$V1, pos=hapsHiConf$V3, curNT1=hapsHiConf$V4, curNT2=hapsHiConf$V5, ancProb=ancSnpsHiConf$maxProb, ancNT=ancSnpsHiConf$ancNT) 

f_a <- nrow(subset(ancHiConf, ancNT=='A'))
f_c <- nrow(subset(ancHiConf, ancNT=='C'))
f_g <- nrow(subset(ancHiConf, ancNT=='G'))
f_t <- nrow(subset(ancHiConf, ancNT=='T'))

a_to_c <- nrow(subset(transDF, ancNT=='A' & (curNT1=='C' | curNT2=='C')))
a_to_g <- nrow(subset(transDF, ancNT=='A' & (curNT1=='G' | curNT2=='G')))
a_to_t <- nrow(subset(transDF, ancNT=='A' & (curNT1=='T' | curNT2=='T')))

c_to_a <- nrow(subset(transDF, ancNT=='C' & (curNT1=='A' | curNT2=='A')))
c_to_g <- nrow(subset(transDF, ancNT=='C' & (curNT1=='G' | curNT2=='G')))
c_to_t <- nrow(subset(transDF, ancNT=='C' & (curNT1=='T' | curNT2=='T')))

g_to_a <- nrow(subset(transDF, ancNT=='G' & (curNT1=='A' | curNT2=='A')))
g_to_c <- nrow(subset(transDF, ancNT=='G' & (curNT1=='C' | curNT2=='C')))
g_to_t <- nrow(subset(transDF, ancNT=='G' & (curNT1=='T' | curNT2=='T')))

t_to_a <- nrow(subset(transDF, ancNT=='T' & (curNT1=='A' | curNT2=='A')))
t_to_c <- nrow(subset(transDF, ancNT=='T' & (curNT1=='C' | curNT2=='C')))
t_to_g <- nrow(subset(transDF, ancNT=='T' & (curNT1=='G' | curNT2=='G')))

countDF <- data.frame(chr=transDF$chr[1], ancA=f_a, ancC=f_c, ancG=f_g, ancT=f_t, a_to_c=a_to_c, a_to_g=a_to_g, a_to_t=a_to_t, c_to_a=c_to_a, c_to_g=c_to_g, c_to_t=c_to_t, g_to_a=g_to_a, g_to_c=g_to_c, g_to_t=g_to_t, t_to_a=t_to_a, t_to_c=t_to_c, t_to_g=t_to_g)
write.table(countDF, paste(chrName, "_ancestral_counts_transitions_counts.txt", sep=""), row.names = F, quote = F, sep = "\t")

Ma <- (a_to_c + a_to_g + a_to_t)/f_a
Mc <- (c_to_a + c_to_g + c_to_t)/f_c
Mg <- (g_to_a + g_to_c + g_to_t)/f_g
Mt <- (t_to_a + t_to_c + t_to_g)/f_g
M <- max(Ma, Mc, Mg, Mt)

fAC <- a_to_c/(M*f_a)
fAG <- a_to_g/(M*f_a)
fAT <- a_to_t/(M*f_a)
fAA <- 1-(fAC + fAG + fAT)

fCA <- c_to_a/(M*f_c)
fCG <- c_to_g/(M*f_c)
fCT <- c_to_t/(M*f_c)
fCC <- 1-(fCA + fCG + fCT)

fGA <- g_to_a/(M*f_g)
fGC <- g_to_c/(M*f_g)
fGT <- g_to_t/(M*f_g)
fGG <- 1-(fGA + fGC + fGT)

fTA <- t_to_a/(M*f_t)
fTC <- t_to_c/(M*f_t)
fTG <- t_to_g/(M*f_t)
fTT <- 1-(fTA + fTC + fTG)

mutMatDF <- data.frame(toA=c(fAA, fCA, fGA, fTA), toC=c(fAC, fCC, fGC, fTC), toG=c(fAG, fCG, fGG, fTG), toT=c(fAT, fCT, fGT, fTT))

#write.table(mutMatDF, paste("ancestral_", focalSpecies, "_", chrName, ".probs_mutation_matrix", sep=""), row.names = F, col.names = F, quote=F, sep="\t")



