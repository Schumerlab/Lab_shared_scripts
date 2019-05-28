arrArgs <- commandArgs(trailingOnly = TRUE);
infile<-as.character(arrArgs[1])
dist<-as.numeric(arrArgs[2])
phys_thresh<-as.numeric(arrArgs[3])

#marker list format is:
#chrom\tpos\n

if(length(arrArgs)<3){
stop("usage is: Rscript calculate_genetic_distance_and_thin_adjacent_markers.R marker_list thin_dist_cM physical_distance_threshold\n")
}

lddata<-read.csv(file=infile,sep="\t",head=FALSE)
whole_genome<-{}

cM_bychr<-read.csv(file="/home/groups/schumer/shared_bin/shared_resources/Xbirchmanni_LD_recombination_map_10xgenome_March2019/cM_lengths_birchmanni10x",sep="\t",head=FALSE)
for(k in 1:length(cM_bychr[,1])){

chrom=as.character(cM_bychr[,1][k])

data<-read.csv(file=paste("/home/groups/schumer/shared_bin/shared_resources/Xbirchmanni_LD_recombination_map_10xgenome_March2019/block_penalty_50_version/LD_map_xbirchmanni-COAC-10x-",chrom,".post.txt_mod",sep=""),sep="\t",head=FALSE)
data<-subset(data,data$V3<0.1)
cM<-subset(cM_bychr[,2],cM_bychr[,1]==chrom)
cM_rate<-(data$V3/sum(data$V3))*cM
perbp_cM<-cM_rate/(data$V2-data$V1)
data<-cbind(data,perbp_cM)

ldfocal<-subset(lddata,lddata[,1]==chrom)

totalcM=0
pairsbycM<-cbind(ldfocal[1,],totalcM)
start=ldfocal[,2][1]
for (x in 2:length(ldfocal[,1])){

stop<-ldfocal[,2][x]

focalrate<-subset(data,data[,1]>=start & data[,1]<=stop)

if((length(focalrate[,1])==1) & (stop-start > phys_thresh)){

totalcM<-sum((stop-start)*focalrate$perbp_cM)
if(totalcM>= 0.98*dist){
pairsbycM<-rbind(pairsbycM,cbind(ldfocal[x,],totalcM))
start=stop
}#only save if passes genetic distance thresh, allow some wiggle room for intervals just below the threshold
}#only calculate if sites are present
if((length(focalrate[,1])>1) & (stop-start > phys_thresh)){
totalcM<-sum((focalrate$V2-focalrate$V1)*focalrate$perbp_cM)
if(totalcM>= 0.98*dist){
pairsbycM<-rbind(pairsbycM,cbind(ldfocal[x,],totalcM))
start=stop
}#only save if passes genetic distance thresh, allow some wiggle room for intervals just below the threshold
}#if more than length 1

}#all sites

whole_genome<-rbind(whole_genome,pairsbycM)

if(sum(pairsbycM[,3]) > cM){
print(paste("WARNING: inferred length ",sum(pairsbycM[,3])," exceeds actual chromosome size of ",cM,sep=""))
}

}#all chroms

write.table(whole_genome,file=paste(infile,"_cMdistances_thinned_",dist,sep=""),sep="\t",row.names=FALSE,quote=FALSE,col.names=FALSE)
