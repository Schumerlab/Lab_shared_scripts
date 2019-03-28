######perform admixture mapping given a genotypes file, a file with hybrid index (expects hybrid index to be in the second column, a phenotypes file, and a column number for the phenotype of interest
#####NOTE: individual order *must* be identical across files!!!

args <- commandArgs(TRUE)
if(length(args)<5){
stop("usage is Rscript perform_glm_admixture_mapping_v2_binomialtrait.R genotypes_file hybrid_index_file phenotypes_file focal_column_number name_tag")
}

infile <- as.character(args[1])

data<-read.csv(file=infile,head=T,as.is=T,sep="\t")

hybrid_index<-as.character(args[2])

pheno<-as.character(args[3])

pheno_column<-as.numeric(args[4])

phenotypes<-read.csv(file=pheno,sep="\t",head=TRUE)

index<-read.csv(file=hybrid_index,sep="\t",head=TRUE)

tag<-as.character(args[5])

out<-paste(infile,"_results_binomial_v2",tag,sep="")
file.remove(out)

names<-colnames(data)

track=0
for (x in 2:length(data[1,])){

dat<-cbind(phenotypes[,pheno_column],index$hybrid_index,data[,x])
dat<-na.omit(dat)

if(length(dat[,1]) >= (length(data[,1])*0.5) & length(unique(dat[,3]))>1){

model2<-glm(as.numeric(dat[,1])~as.numeric(dat[,2]),family="binomial")

null<-logLik(model2)[1]

model1<-glm(as.numeric(dat[,1])~as.numeric(dat[,2]) + as.numeric(dat[,3]),family="binomial")

focal<-logLik(model1)[1]

like_diff<-focal-null

p <- summary(model1)$coef[, "Pr(>|z|)"]
p<-t(p)
results<-cbind(names[x],p,(summary(model1)$coef[,"z value"])[3],like_diff,length(dat[,1]))
if(track==0){
write.table(results,file=out,append=TRUE,col.names=c("chrom.marker","intercept","mixture_prop","site","z-value","likelihood-diff","num_ind"),row.names=F,sep="\t",quote=FALSE)
track=1
} else{
write.table(cbind(names[x],p,(summary(model1)$coef[,"z value"])[3],like_diff,length(dat[,1])),file=out,append=TRUE,col.names=FALSE,row.names=F,sep="\t",quote=FALSE)

}

}#if half the data

}#for all lines

warnings()
