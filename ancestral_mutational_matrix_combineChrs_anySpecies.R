options(stringsAsFactors = F)
args <- commandArgs(TRUE)
speciesName <- args[1]
chrNameFile <- args[2]

chrList <- read.table(chrNameFile, header=F)

wgCounts <- data.frame()
for (chrName in chrList$V1) {
  chrCount <- read.table(paste(chrName, "_ancestral_counts_transitions_counts.txt", sep=""), header=T)
  wgCounts <- rbind(wgCounts, chrCount)
}

f_a <- sum(wgCounts$ancA)
f_c <- sum(wgCounts$ancC)
f_g <- sum(wgCounts$ancG)
f_t <- sum(wgCounts$ancT)

a_to_c <- sum(wgCounts$a_to_c)
a_to_g <- sum(wgCounts$a_to_g)
a_to_t <- sum(wgCounts$a_to_t)

c_to_a <- sum(wgCounts$c_to_a)
c_to_g <- sum(wgCounts$c_to_g)
c_to_t <- sum(wgCounts$c_to_t)

g_to_a <- sum(wgCounts$g_to_a)
g_to_c <- sum(wgCounts$g_to_c)
g_to_t <- sum(wgCounts$g_to_t)

t_to_a <- sum(wgCounts$t_to_a)
t_to_c <- sum(wgCounts$t_to_c)
t_to_g <- sum(wgCounts$t_to_g)

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

#write.table(mutMatDF, "ancestral_Xbir2023_allChrs.probs_mutation_matrix", row.names = F, col.names = F, quote=F, sep="\t")
write.table(mutMatDF, paste("ancestral_", speciesName, "_allChrs.probs_mutation_matrix", sep=""), row.names = F, col.names = F, quote=F, sep="\t")

