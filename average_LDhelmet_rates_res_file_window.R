arrArgs<-commandArgs(trailingOnly = TRUE);

if(length(arrArgs)<4){
stop("usage is: Rscript average_LDhelmet_rates_res_file_window.R modified_LD_helmet_output chromosome_name window_size_bps chrom_length_file\n")
}

infile<-as.character(arrArgs[1]) #modified LDhelmet output files, example: shared_bin/shared_resources/Xbirchmanni_LD_recombination_map_10xgenome_March2019/block_penalty_50_version
chrom<-as.character(arrArgs[2]) #chromosome name
win_size<-as.numeric(arrArgs[3]) #window size bps
chrom_lengths<-as.character(arrArgs[4]) #example: xbir10x_chrlengths in shared_bin/shared_resources

data<-read.csv(file=infile,sep="\t",head=FALSE) 
data<-subset(data,data$V3<=0.4)
lengths<-read.csv(file=chrom_lengths,sep="\t",head=FALSE)

options(scipen=999)

focal_length<-subset(lengths,lengths$V1==chrom)$V2
#focal_length

start<-1
stop<-win_size
last_marker<-focal_length
window_means<-{}
counter=0

while(stop < last_marker){
counter=counter+1

#print(counter)

focal<-subset(data,data$V1 <= stop & data$V2 >= start)

if(length(focal$V1)>0){
window_means<-rbind(window_means,cbind(chrom,start,stop,sum((focal$V2-focal$V1)*focal$V3)/sum(focal$V2-focal$V1) ))

}

start=stop+1
stop=start+win_size-1

}#average all windows

if(stop > last_marker){
counter=counter+1

last_window<-subset(data,data$V1 >= start & data$V1<=stop)
if(length(last_window$V1)>0){
window_means<-rbind(window_means,cbind(chrom,start,stop,sum((focal$V2-focal$V1)*focal$V3)/sum(focal$V2-focal$V1) ))
}

}#deal with last window

colnames(window_means)<-c("group","start","stop","average_rho_bp")
results<-na.omit(window_means)

outfile=paste(infile,"_",win_size/1000,"kb_windows.txt",sep="")
write.table(results,file=outfile,sep="\t",row.names=FALSE,col.names=FALSE,quote=FALSE)
