######perform admixture mapping given a genotypes file, a file with hybrid index (expects hybrid index to be in the second column, a phenotypes file, and a column number for the phenotype of interest
#####NOTE: individual order *must* be identical across files!!!

args <- commandArgs(TRUE)
if(length(args)<6){
stop("usage is Rscript perform_glm_admixture_mapping_v2_binomialtrait_interactionmodel.R genotypes_file hybrid_index_file phenotypes_file focal_column_number interaction_marker tag_name")
}

infile <- as.character(args[1])
data<-read.csv(file=infile,head=T,as.is=T,sep="\t")

hybrid_index<-as.character(args[2])

pheno<-as.character(args[3])

pheno_column<-as.numeric(args[4])

interaction_marker<-as.character(args[5])

phenotypes<-read.csv(file=pheno,sep="\t",head=FALSE)

index<-read.csv(file=hybrid_index,sep="\t",head=FALSE)

tag<-as.character(args[6])

out<-paste(infile,"_results_binomial_interaction_model_",interaction_marker,"_",tag,sep="")
file.remove(out)

names<-colnames(data)

track=0
for (x in 2:length(data[1,])){

dat<-cbind(phenotypes[,pheno_column],index$V2,data[,x],data[,interaction_marker])
dat<-na.omit(dat)
dat<-subset(dat,dat[,2]>0.2 & dat[,2]<0.9)

if(length(dat[,1]) >= (length(data[,1])*0.5) & length(unique(dat[,3]))>1 & length(unique(dat[,4]))>1){

model2<-glm(as.numeric(dat[,1])~as.numeric(dat[,2])+as.numeric(dat[,3])+as.numeric(dat[,4]),family="binomial")

null<-logLik(model2)[1]

model1<-glm(as.numeric(dat[,1])~as.numeric(dat[,2]) + as.numeric(dat[,3])*as.numeric(dat[,4]),family="binomial")

focal<-logLik(model1)[1]

like_diff<-focal-null

p <- summary(model1)$coef[, "Pr(>|z|)"]
p<-t(p)
results<-cbind(names[x],p,(summary(model1)$coef[,"z value"])[4],like_diff,length(dat[,1]))

if(length(results) == 9){
if(track==0){
write.table(results,file=out,append=TRUE,col.names=c("chrom.marker","intercept","mixture_prop","site1","site2","interaction","z-value","likelihood-diff","num_ind"),row.names=F,sep="\t",quote=FALSE)
track=1
} else{
write.table(cbind(names[x],p,(summary(model1)$coef[,"z value"])[4],like_diff,length(dat[,1])),file=out,append=TRUE,col.names=FALSE,row.names=F,sep="\t",quote=FALSE)
}#quick fix to exclude fixed markers

}

}#if half the data

}#for all lines

warnings()
