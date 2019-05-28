arrArgs <- commandArgs(trailingOnly = TRUE);
infile<-as.character(arrArgs[1])
chrom<-as.character(arrArgs[2])

if(length(arrArgs)<2){
stop("usage is: Rscript convert_plink_LD_genetic_distance_xbir10x.R plink.ld chromosomename\n")
}

outfile<-paste(infile,".",chrom,".ld",sep="")
grepcmd<-paste("grep -w	",chrom," ",infile," > ",outfile,sep="")
system(grepcmd)

command=paste("perl -pi -e 's/ +/\t/g' ",outfile,sep="")
system(command)

lddata<-read.csv(file=outfile,sep="\t",head=FALSE)

data<-read.csv(file=paste("/home/groups/schumer/shared_bin/shared_resources/Xbirchmanni_LD_recombination_map_10xgenome_March2019/block_penalty_50_version/LD_map_xbirchmanni-COAC-10x-",chrom,".post.txt_mod",sep=""),sep="\t",head=FALSE)
data<-subset(data,data$V3<0.4)
cM_bychr<-read.csv(file="/home/groups/schumer/shared_bin/shared_resources/Xbirchmanni_LD_recombination_map_10xgenome_March2019/cM_lengths_birchmanni10x",sep="\t",head=FALSE)
cM<-subset(cM_bychr[,2],cM_bychr[,1]==chrom)
cM_rate<-(data$V3/sum(data$V3))*cM
perbp_cM<-cM_rate/(data$V2-data$V1)
data<-cbind(data,perbp_cM)

ldfocal<-subset(lddata,lddata[,1]==chrom)

pairsbycM<-{}

for (x in 1:length(ldfocal[,1])){

start<-ldfocal[,2][x]
stop<-ldfocal[,5][x]

focalrate<-subset(data,data[,1]>=start & data[,2]<=stop)
if(length(focalrate[,1])>0){
addstart<-(focalrate$V1[1] - start)*(focalrate$perbp_cM[1])
addend<-(stop-focalrate$V2[length(focalrate$V2)])*(focalrate$perbp_cM[length(focalrate$V2)])
middle<-sum((focalrate$V2-focalrate$V1)*focalrate$perbp_cM)
totalcM<-addstart+addend+middle
pairsbycM<-rbind(pairsbycM,cbind(ldfocal[x,],totalcM))
}#only calculate if sites are present

}#all sites

write.table(pairsbycM,file=paste(infile,"_",chrom,"_cMdistances",sep=""),sep="\t",row.names=FALSE,quote=FALSE)

cleanup<-paste("rm ",outfile,sep="")
system(cleanup)
