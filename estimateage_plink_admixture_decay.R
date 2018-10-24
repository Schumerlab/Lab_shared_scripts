#use with the output of plink_output_admixture_age_estimate.R 

arrArgs <- commandArgs(trailingOnly = TRUE)
if(length(arrArgs)<1){
stop("usage is Rscript estimateage_plink_admixture_decay.R output_of:plink_output_admixture_age_estimate.R");
}
sIn<-as.character(arrArgs[1])

oDat <- read.table(sIn , header=TRUE);

attach(oDat);
pdf(paste(sIn,"_lddecay.pdf"))
plot(Dist_cM, meanD,pch=20,cex.lab=1.3,cex.axis=1.2);

fit <- nls( meanD ~ a * exp( -b * Dist_cM), start=list(a=1,b=1));
#lines( Dist_cM, predict( fit, list(x=Dist_cM)), col='red');

Dist_Morgan <- Dist_cM / 100;
fit <- nls( meanD ~ a * exp( -b * (Dist_Morgan)), start=list(a=1,b=1));
summary(fit);
dev.off()

