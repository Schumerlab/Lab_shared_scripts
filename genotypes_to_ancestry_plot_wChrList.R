arrArgs<-commandArgs(trailingOnly = TRUE);

if(length(arrArgs)<3){
  stop("Rscript genotypes_to_ancestry_plot.R genos_file chromnameList idlist_with_header\n");
}
options(scipen=999)

infile<-as.character(arrArgs[1])
chrFile<-as.character(arrArgs[2])
ids<-as.character(arrArgs[3])
reformatcmd<-paste("perl -pi -e 's/-/./g' ",ids,sep="")
system(reformatcmd)
indivs<-read.table(file=ids,sep="\t",head=TRUE)
indivs<-indivs[,1]
chromsNames <- read.table(chrFile, header=F, sep="\t")
chroms <- chromsNames[,1]


#indivs

cmd0=paste("perl /home/groups/schumer/shared_bin/Lab_shared_scripts/transpose_nameout.pl ",infile,sep="");

system(cmd0)

infile_trans=paste(infile,"_transposed",sep="");
newinfile=paste(infile,"_plot.txt",sep="");
cmd1=paste("cp ",infile_trans," ",newinfile);

system(cmd1);

cmd2=paste("perl -pi -e 's/:/\t/g' ",newinfile,sep="");

system(cmd2)

cmd3=paste("perl -pi -e	's/id/chrom\tpos/g' ",newinfile,sep="");

system(cmd3)

data<-read.csv(file=newinfile,sep="\t",head=TRUE,as.is=T)

for(x in 1:length(indivs)){
  
  focalid=as.character(indivs[x])
  pdf(paste(focalid,".pdf",sep=""),width=5.5,height=3)
  #focalid
  if (grepl("^[[:digit:]]+", focalid)) {
    focalid <- paste("X",focalid,sep="")
  }
  for (chr in chroms) {
    focalchr<-subset(data,data[,1]==chr)
    genos<-na.omit(cbind(focalchr[,2],focalchr[,focalid]))
    if(length(genos[,1])>100){
      xName <- paste(chr, "Position (Mb)", sep=" ")
      plot(genos[,1]/1e6,genos[,2],type="l",lwd=2,col="blue",ylim=c(0,2),xlab=xName,ylab="Number of parent2 alleles")
      
    }#only plot w/sufficient data
  }
  dev.off()
}