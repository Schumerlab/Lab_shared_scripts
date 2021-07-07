###usage

#infile format (bed with extra info):
#ScyDAA6-1508-HRSCAF-1794      607	3291929	2	HUEX.XI.19.20.R1.fastq
#ScyDAA6-1508-HRSCAF-1794       3291930	3348153	1	HUEX.XI.19.20.R1.fastq
#ScyDAA6-1508-HRSCAF-1794       3348154	3793517	2	HUEX.XI.19.20.R1.fastq 

#recfile format (bed formatted LD helmet output):
#ScyDAA6-1508-HRSCAF-1794      1077	 2400	1.3225e-05	1.2915e-05	1.3140e-05	1.3587e-05
#ScyDAA6-1508-HRSCAF-1794       2400	 4221	1.3225e-05	1.2915e-05	1.3140e-05	1.3587e-05

arrArgs<-commandArgs(trailingOnly = TRUE);
infile<-as.character(arrArgs[1])
recfile<-as.character(arrArgs[2])

overlap=paste("overlap_",infile,sep="")
cmd=paste("bedtools intersect -a ",infile," -b ",recfile," -wo > ",overlap,sep="")

system(cmd)

data<-read.csv(file=overlap,sep="\t",head=FALSE)
bins<-read.csv(file=infile,sep="\t",head=FALSE)
cMs<-read.csv(file="/home/groups/schumer/shared_bin/shared_resources/Xbirchmanni_LD_recombination_map_10xgenome_March2019/cM_lengths_birchmanni10x",sep="\t",head=FALSE)
rate<-read.csv(file=recfile,sep="\t",head=FALSE)

total<-subset(cMs$V2,as.character(cMs$V1)==as.character(data$V1[1]))

cM_lengths<-{}
for(x in 1:length(bins$V1)){

focal<-subset(data,data$V1==bins$V1[x] & data$V2==bins$V2[x] & data$V3==bins$V3[x] & as.character(data$V5)==as.character(bins$V5[x]))
total_rho=sum(rate$V4*(rate$V3-rate$V2))
cM_lengths<-rbind(cM_lengths,cbind(as.character(bins$V1[x]),bins$V2[x],bins$V3[x],total*(sum(focal$V9*focal$V13)/total_rho),focal$V4[1],as.character(focal$V5[1])))

}

outfile<-paste(infile,"_cM_lengths",sep="")

write.table(cM_lengths,file=outfile,sep="\t",row.names=FALSE,col.names=FALSE,quote=FALSE)
