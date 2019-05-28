#use with the output of plink_output_admixture_age_estimate.R 

arrArgs <- commandArgs(trailingOnly = TRUE)
if(length(arrArgs)<1){
stop("usage is Rscript estimateage_plink_admixture_decay.R output_of:plink_output_admixture_age_estimate.R");
}
sIn<-as.character(arrArgs[1])

oDat <- read.table(sIn , header=TRUE);
oDat <-subset(oDat, oDat$cM_start>0.1)
attach(oDat);
pdf(paste(sIn,"_lddecay.pdf",sep=""))
plot(cM_stop, meanD,pch=20,cex.lab=1.3,cex.axis=1.2);

fit <- nls( meanD ~ a * exp( -b * cM_stop), start=list(a=1,b=1));
#lines( cM_stop, predict( fit, list(x=cM_stop)), col='red');

Dist_Morgan <- cM_stop / 100;
fit <- nls( meanD ~ a * exp( -b * (Dist_Morgan)), start=list(a=1,b=1));
summary(fit);
dev.off()

