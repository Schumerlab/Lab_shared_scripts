arrArgs<-commandArgs(trailingOnly = TRUE);
focal_file<-as.character(arrArgs[1]);
data<-read.csv(file=focal_file,sep="\t",head=FALSE)

length(data$V1)

options(scipen=999)

#!data<-na.omit(data)

new_data<-cbind(rep(1,length(data$V1)),paste("snp",1:length(data$V1),sep=""),round(data$V1*2e-08,4),data$V1)

write.table(new_data,file=paste(focal_file,".map",sep=""),row.names=FALSE,col.names=FALSE,quote=FALSE,sep="\t")
