######perform admixture mapping given a genotypes file, a file with hybrid index (expects hybrid index to be in the second column, a phenotypes file, and a column number for the phenotype of interest
#####NOTE: individual order *must* be identical across files!!!

args <- commandArgs(TRUE)
if(length(args)<6){
stop("usage is Rscript perform_glm_admixture_mapping_v2.R genotypes_file hybrid_index_file phenotypes_file focal_column_number name_tag num_sims")
}

infile <- as.character(args[1])

data<-read.csv(file=infile,head=T,as.is=T,sep="\t")

hybrid_index<-as.character(args[2])

pheno<-as.character(args[3])

pheno_column<-as.numeric(args[4])

phenotypes<-read.csv(file=pheno,sep="\t",head=FALSE)

index<-read.csv(file=hybrid_index,sep="\t",head=FALSE)

tag<-as.character(args[5])

num_sims<-as.numeric(args[6])

for(y in 1:num_sims){

out<-paste(infile,"_results_binomial_",tag,"_",y,sep="")
file.remove(out)

names<-colnames(data)
null_phenos<-sample(phenotypes[,pheno_column])

track=0
for (x in 2:length(data[1,])){

dat<-cbind(null_phenos,index$V2,data[,x])
dat<-na.omit(dat)
dat<-subset(dat,dat[,2]>0.2 & dat[,2]<0.9)

if(length(dat[,1]) >= (length(data[,1])*0.5) & length(unique(dat[,3]))>1){

model2<-glm(as.numeric(dat[,1])~as.numeric(dat[,2]),family="binomial")

null<-logLik(model2)[1]

model1<-glm(as.numeric(dat[,1])~as.numeric(dat[,2]) + as.numeric(dat[,3]),family="binomial")

focal<-logLik(model1)[1]

like_diff<-focal-null

p <- summary(model1)$coef[, "Pr(>|z|)"]
p<-t(p)
results<-cbind(names[x],p,(summary(model1)$coef[,"z value"])[3],like_diff)
if(track==0){
write.table(results,file=out,append=TRUE,col.names=c("chrom.marker","intercept","mixture_prop","site","z-value","likelihood-diff"),row.names=F,sep="\t",quote=FALSE)
track=1
} else{
write.table(cbind(names[x],p,(summary(model1)$coef[,"z value"])[3],like_diff),file=out,append=TRUE,col.names=FALSE,row.names=F,sep="\t",quote=FALSE)

}

}#if half the data

}#for all lines

}#all sims

#warnings()