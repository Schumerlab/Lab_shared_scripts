#can be run converting plink output to cM format with a command line similar to this:
#Rscript convert_plink_LD_genetic_distance_xbir10x.R TLMC.ld ScyDAA6-2-HRSCAF-26

arrArgs <- commandArgs(trailingOnly = TRUE)

if(length(arrArgs)<2){
stop("usage is: Rscript convert_cM_version_plink_admixture_decay.R converted_plink_output.ld window_size_cM")
}

file<-as.character(arrArgs[1])

cM_per_window<-as.numeric(arrArgs[2])

data<-read.csv(file=file,sep="\t",head=TRUE)
bins<-{}
start=0
stop=cM_per_window
max_cM=20
num_its=(max_cM/cM_per_window)

print(num_its)

for(x in 0:num_its){
focal<-subset(data,data[,10]>start & data[,10]<stop)
meanD<-mean(focal[,7],na.rm=TRUE)
countD<-length(focal[,7])
SumD<-sum(focal[,7],na.rm=TRUE)
BinNum<-x
Dist_cM<-mean(c(start,stop))
cM_start=start
cM_stop=stop
bins<-rbind(bins,cbind(BinNum,cM_start,cM_stop,Dist_cM,SumD,countD,meanD))
start=start+cM_per_window
stop=stop+cM_per_window
cM_start=cM_start+cM_per_window
cM_stop=cM_stop+cM_per_window
}
write.table(bins,file=paste(file,"_admixture_ld_decay_cMdist",sep=""),row.names=FALSE,quote=FALSE,sep="\t")
