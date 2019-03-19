###takes a bed file of intervals and an ancestry by site file to calculate average ancestry per window

arrArgs <- commandArgs(trailingOnly = TRUE);
infile<-as.character(arrArgs[1])
binsfile<-as.character(arrArgs[2])
group<-as.character(arrArgs[3])
window_size<-as.numeric(arrArgs[4])

data<-read.csv(file=infile,sep="\t",head=TRUE)
bins<-read.csv(file=binsfile,sep="\t",head=FALSE)

options(scipen=999)
whole_genome<-{}

focal<-data[which(data$group==group,]

num_wins=ceiling(focal$position[length(focal$group)]/window_size)

avgs<-{}
for (x in 1:length(bins$V1)){

window_start=bins$V2[x]
window_stop=bins$V3[x]

avgs<-rbind(avgs,cbind(group,window_start,window_stop,mean(focal[which(focal$position < window_stop & focal$position > window_start),]$hybrid_index,na.rm=TRUE),length(focal[,1])))

}

whole_genome<-rbind(whole_genome,avgs)

write.table(whole_genome,file=paste("average_ancestry_",infile,"_",binsfile,sep=""),sep="\t",row.names=FALSE,col.names=FALSE,quote=FALSE)

