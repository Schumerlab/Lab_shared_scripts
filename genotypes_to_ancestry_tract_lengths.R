arrArgs<-commandArgs(trailingOnly = TRUE);

if(length(arrArgs)<4){
stop("Rscript genotypes_to_ancestry_tract_lengths.R genos_file chromname idlist_with_header outfile_name\n");
}
options(scipen=999)

infile<-as.character(arrArgs[1])
chr<-as.character(arrArgs[2])
ids<-as.character(arrArgs[3])
outfile<-as.character(arrArgs[4])
reformatcmd<-paste("perl -pi -e 's/-/./g' ",ids,sep="")
system(reformatcmd)
indivs<-read.table(file=ids,sep="\t",head=TRUE)
indivs<-indivs[,1]

cmd0=paste("perl /home/groups/schumer/shared_bin/Lab_shared_scripts/transpose_nameout.pl ",infile,sep="");

system(cmd0)

infile_trans=paste(infile,"_transposed",sep="");
newinfile=paste(infile,"_plot.txt",sep="");
cmd1=paste("cp ",infile_trans," ",newinfile);

system(cmd1);

cmd2=paste("perl -pi -e 's/:/\t/g' ",newinfile,sep="");

system(cmd2)

cmd3=paste("perl -pi -e 's/id/chrom\tpos/g' ",newinfile,sep="");

system(cmd3)

data<-read.table(file=newinfile,sep="\t",head=TRUE,as.is=T)

focalchr<-subset(data,data[,1]==chr)

alltracts<-{}

for(y in 1:length(indivs)){

focalid=as.character(indivs[y])
indiv<-na.omit(cbind(focalchr$pos,focalchr[focalid]))

tract_lengths<-{}
geno_curr=indiv[,2][1]
start=indiv[,1][1]

#write.table(cbind(geno_curr,start))

for(x in 1:length(indiv[,1])){
focal=indiv[,2][x]

if(geno_curr != focal){
stop=indiv[,1][x]-1
tract_lengths<-rbind(tract_lengths,cbind(start,stop,geno_curr,focalid))
start=indiv[,1][x]
geno_curr=focal
}
}

stop=indiv[,1][x]
tract_lengths<-rbind(tract_lengths,cbind(start,stop,geno_curr,focalid))

alltracts<-rbind(alltracts,tract_lengths)

}



write.table(cbind(rep(chr,length(alltracts[,1])),alltracts),file=outfile,sep="\t",row.names=FALSE,col.names=c("chr","start","stop","ancestry","indiv"),quote=FALSE)