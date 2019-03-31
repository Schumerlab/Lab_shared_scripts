arrArgs<-commandArgs(trailingOnly = TRUE);
bed<-as.character(arrArgs[1])
gtf<-as.character(arrArgs[2])
path<-as.character(arrArgs[3])
outfile<-as.character(arrArgs[4])

if(length(arrArgs)<4){
	stop("usage is: Rscript calculate_features_per_window.R bins.bed features.gtf_or_features.bed path_to_bedtools_bin/0 for global install outfile_name")
}

tmp_file=paste("overlap_tmp_",bed,sep="")

if(nchar(path)>1){
command=paste(path,"/bedtools intersect -a ",bed," -b ",gtf," -wo > ",tmp_file,sep="")
} else{
command=paste("bedtools intersect -a ",bed," -b ",gtf," -wo > ",tmp_file,sep="")
}

system(command)

bins<-read.csv(file=bed,sep="\t",head=FALSE)
overlap<-read.csv(file=tmp_file,sep="\t",head=FALSE)

chrs<-unique(as.character(bins$V1))
ncol<-length(overlap[1,])

whole_genome<-{}

for(y in 1:length(chrs)){

bins_focal<-subset(bins,as.character(bins$V1)==chrs[y])
overlap_focal<-subset(overlap,as.character(overlap$V1)==chrs[y])
coding_per_window<-{}

for(x in 1:length(bins_focal[,1])){

current_win<-subset(overlap_focal,overlap_focal$V2==bins_focal$V2[x] & overlap_focal$V3==bins_focal$V3[x])	
bp_per_win<-sum(current_win[,ncol])

coding_per_window<-rbind(coding_per_window,cbind(bins_focal[x,],bp_per_win))
	
}# all bins

whole_genome<-rbind(whole_genome,coding_per_window)

}#all chrs
file.remove(tmp_file)

write.table(whole_genome,file=outfile,sep="\t",row.names=FALSE,col.names=FALSE,quote=FALSE)
