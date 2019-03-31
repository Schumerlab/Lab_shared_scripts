arrArgs<-commandArgs(trailingOnly = TRUE);

chr<-as.character(arrArgs[1])

data<-read.csv(file=paste("LD_map_xbirchmanni-COAC-10x-",chr,".post.txt_mod",sep=""),sep="\t",head=FALSE)
data<-subset(data,data$V3<0.4)
cM_bychr<-read.csv(file="cM_lengths_birchmanni10x",sep="\t",head=FALSE)
cM<-subset(cM_bychr[,2],cM_bychr[,1]==chr)
cM_rate<-(data$V3/sum(data$V3))*cM
perbp_cM<-cM_rate/(data$V2-data$V1)
data<-cbind(data,perbp_cM)

window_size=0.05
window_current=0
start=data$V1[1]
stop=0
results<-{}
supporting_snps=0
for(x in 1:length(data$V1)){
focal_dist=(data$V2-data$V1)[x]
stop=data$V1[x]
supporting_snps=supporting_snps+1
for(y in 1:focal_dist){
stop=stop+1
window_current=window_current+data$perbp_cM[x]
if(window_current>=window_size){
results<-rbind(results,cbind(start,stop,window_current,supporting_snps))
window_current=0
start=stop+1
supporting_snps=0
}#slow but most correct
}#step through bp by bp
}#go through all intervals
write.table(cbind(rep(as.character(chr),length(results[,1])),results),file=paste("cM_windows_",window_size,"xbirchmanni10x_",chr,sep=""),row.names=FALSE,col.names=FALSE,quote=FALSE,sep="\t")
