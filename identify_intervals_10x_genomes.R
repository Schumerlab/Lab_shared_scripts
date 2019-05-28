arrArgs<-commandArgs(trailingOnly = TRUE);
genos<-as.character(arrArgs[1])
path<-as.character(arrArgs[2])

if(length(arrArgs)<2){
stop("usage is: Rscript identify_intervals_10x_genomes.R genotypes_file_name path_to:transpose_nameout.pl\n");
}#print usage

chroms<-c("ScyDAA6-2-HRSCAF-26","ScyDAA6-7-HRSCAF-50","ScyDAA6-8-HRSCAF-51","ScyDAA6-10-HRSCAF-60","ScyDAA6-11-HRSCAF-73","ScyDAA6-695-HRSCAF-847","ScyDAA6-932-HRSCAF-1100","ScyDAA6-1107-HRSCAF-1306","ScyDAA6-1196-HRSCAF-1406","ScyDAA6-1439-HRSCAF-1708","ScyDAA6-1473-HRSCAF-1750","ScyDAA6-1508-HRSCAF-1794","ScyDAA6-1592-HRSCAF-1896","ScyDAA6-1854-HRSCAF-2213","ScyDAA6-1859-HRSCAF-2221","ScyDAA6-1934-HRSCAF-2318","ScyDAA6-2113-HRSCAF-2539","ScyDAA6-2188-HRSCAF-2635","ScyDAA6-2393-HRSCAF-2888","ScyDAA6-2469-HRSCAF-2980","ScyDAA6-5078-HRSCAF-5686","ScyDAA6-5983-HRSCAF-6649","ScyDAA6-5984-HRSCAF-6694","ScyDAA6-5987-HRSCAF-6712")

command1<-paste("perl ",path,"/transpose_nameout.pl ",genos,sep="")
system(command1)

genos_transposed<-paste(genos,"_transposed",sep="")

for(k in 1:length(chroms)){

command2=paste("grep ",chroms[k]," ",genos_transposed," | perl -p -e ","'","s/:/\t/g","'"," > ",genos_transposed,"_",chroms[k],sep="")
system(command2)

file=paste(genos_transposed,"_",chroms[k],sep="")
data<-read.csv(file=file,sep="\t",head=FALSE,as.is=T)

intervals<-{}
count=0

for(y in 3:(length(data[1,])-1)){

focal_geno=data[,y]
sites<-data[,2]
na_count=0;
geno_prev=subset(focal_geno,!is.na(focal_geno)==TRUE)[1];
first_region=1
last_geno=focal_geno[1]
start=sites[1]

for(x in 1:length(focal_geno)){
geno_current=focal_geno[x];

if(!is.na(geno_current)==TRUE){

	if(geno_current == geno_prev){

	} else{

	if(is.na(last_geno)==TRUE){
	stop=sites[x]
	geno_prev=geno_current

	intervals<-rbind(intervals,cbind(start,stop,y-1))

	}#make sure previous genotype was NA for this mode

	}#geno_current does not equal geno_previous

} else{

if((is.na(geno_current)==TRUE)	&(is.na(last_geno)==FALSE)){
	start=sites[x-1]
}#option 1: this is the first site in the interval region

}#if is/is not NA


if((is.na(geno_current)==FALSE)&(is.na(last_geno)==FALSE)&(geno_current != last_geno)){
	start=sites[x-1]
	stop=sites[x]
	geno_prev=geno_current

	intervals<-rbind(intervals,cbind(start,stop,y-1))
	count=count+1
}#option 2: the interval was between this marker and the last marker


last_geno=geno_current

}#for all sites in the focal individual

write.table(intervals,file=paste(file,"_intervals",sep=""),sep="\t",row.names=FALSE,col.names=FALSE,quote=FALSE)

}#for all individuals

command3<-paste(genos,"_",chroms[k],sep="")
#system(command3)

}#all chroms

