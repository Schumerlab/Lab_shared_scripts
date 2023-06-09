###takes a bed file of intervals and an ancestry by site file to calculate average ancestry per window

arrArgs <- commandArgs(trailingOnly = TRUE);

if(length(arrArgs)<2){
stop("usage is: Rscript average_ancestry_bybedintervals.R infile bins.bed\n") 
}

infile<-as.character(arrArgs[1])
binsfile<-as.character(arrArgs[2])
#group<-as.character(arrArgs[3])

data<-read.csv(file=infile,sep="\t",head=TRUE)
allBins<-read.csv(file=binsfile,sep="\t",head=FALSE)
groups <- unique(allBins$V1)

options(scipen=999)
whole_genome<-{}

for (group in groups) {
  #print(group)
  focal<-data[which(data$group==as.character(group)),]
  bins<-subset(allBins,as.character(allBins$V1)==as.character(group))
  
  avgs<-{}
  for (x in 1:length(bins$V1)){
    window_start=bins$V2[x]
    window_stop=bins$V3[x]
    indivs<-focal[which(focal$position < window_stop & focal$position > window_start),]$indivs_cov
    avgs<-rbind(avgs,cbind(group,window_start,window_stop,mean(focal[which(focal$position < window_stop & focal$position > window_start),]$hybrid_index,na.rm=TRUE),mean(indivs),length(indivs)))
    #print(paste(x, "meanIndivs", mean(indivs), "numAIMs", length(indivs)))
  }
  
  whole_genome<-rbind(whole_genome,avgs)
  
}

write.table(whole_genome,file=paste("average_",infile,"_ancestry_",binsfile,"_WG",sep=""),sep="\t",row.names=FALSE,col.names=FALSE,quote=FALSE)

