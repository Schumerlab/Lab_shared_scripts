#can be run after running plink with a command line similar to this:
#../../bin/plink --file all-CHAF-focal-chr --ld-window-kb 2000 --ld-window 20000 --r d --hardy --hwe 0.001 --out CHAF_October_2018_group21_ld-decay

arrArgs <- commandArgs(trailingOnly = TRUE)

if(length(arrArgs)<3){
stop("usage is: Rscript plink_output_admixture_age_estimate.R plink_output.ld window_size_bp window_size_cM")
}

file<-as.character(arrArgs[1])
command=paste("perl -pi -e 's/ +/\t/g' ",file,sep="")
system(command)
window_size<-as.numeric(arrArgs[2])
cM_per_window<-as.numeric(arrArgs[3])

data<-read.csv(file=file,sep="\t",head=TRUE)
dist<-abs(data[,2] - data[,5])
bins<-{}
start=1
stop=window_size
cM_start=0
cM_stop=cM_per_window
max_cM=5
num_its=(max_cM/cM_per_window)

for(x in 0:num_its){
focal<-subset(data,dist>start & dist<stop)
meanD<-mean(focal[,7],na.rm=TRUE)
countD<-length(focal[,7])
SumD<-sum(focal[,7],na.rm=TRUE)
BinNum<-x
Dist_cM<-mean(c(cM_start,cM_stop))
bins<-rbind(bins,cbind(BinNum,start,stop,cM_start,cM_stop,Dist_cM,SumD,countD,meanD))
start=start+window_size
stop=stop+window_size
cM_start=cM_start+cM_per_window
cM_stop=cM_stop+cM_per_window
}
write.table(bins,file=paste(file,"_admixture_ld_decay",sep=""),row.names=FALSE,quote=FALSE,sep="\t")
