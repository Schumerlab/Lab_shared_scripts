###takes a bed file of intervals and an ancestry by site file to calculate average ancestry per window

arrArgs <- commandArgs(trailingOnly = TRUE);

if(length(arrArgs)<2){
stop("usage is: Rscript average_ancestry_bybedintervals.R infile bins.bed\n") 
}

infile<-as.character(arrArgs[1])
binsfile<-as.character(arrArgs[2])
#group<-as.character(arrArgs[3])

data<-read.csv(file=infile,sep="\t",head=TRUE)
allbins<-read.csv(file=binsfile,sep="\t",head=FALSE)

allgroups<-unique(as.character(allbins$V1))

options(scipen=999)

for(b in 1:length(allgroups)){

group=allgroups[b]

print(group)

whole_genome<-{}

focal<-data[which(data$group==as.character(group)),]
bins<-subset(allbins,as.character(allbins$V1)==as.character(group))

avgs<-{}
for (x in 1:length(bins$V1)){

window_start=bins$V2[x]
window_stop=bins$V3[x]

indivs<-focal[which(focal$position < window_stop & focal$position > window_start),]$indivs_cov
if(length(indivs)>0){
avgs<-rbind(avgs,cbind(group,window_start,window_stop,mean(focal[which(focal$position < window_stop & focal$position > window_start),]$hybrid_index,na.rm=TRUE),mean(indivs),length(indivs)))
}

}

whole_genome<-rbind(whole_genome,avgs)

if(length(avgs[,1])>0){
write.table(whole_genome,file=paste("average_",infile,"_ancestry_",binsfile,"_",group,sep=""),sep="\t",row.names=FALSE,col.names=FALSE,quote=FALSE)
}

}