args<-commandArgs(trailingOnly = TRUE)
num_pairs<-as.numeric(args[1])
s<-as.numeric(args[2])
h<-as.numeric(args[3])

write.table(cbind("Phenotypes","Formula"),file="BDMI_part2",row.names=FALSE,col.names=FALSE,sep="\t")

write.table(cbind("name","Chromosome","position","Dominant Allele","Dominant Allele Value","Recessive Allele","Recessive Allele Value Mode Dominant Freq Pop1 Dominant Freq Pop2"),sep="\t",row.names=FALSE,col.names=FALSE,file="BDMI_part1")

write.table(cbind("Population","Gen","Selection"),sep="\t",row.names=FALSE,col.names=FALSE,file="BDMI_part3")

file.remove("selected_pairs_log.bed")

string<-{}

for (x in 1:num_pairs){

number<-runif(1,0,1)
ha<-h
hbc<-h

chr1<-sample(c(1:24),1)
pos1<-round(runif(1,1,25e6))

chr2<-sample(c(1:24),1)
pos2<-round(runif(1,1,25e6))

chr1name<-as.character(paste("chr",chr1,"_",pos1,sep=""))
chr2name<-as.character(paste("chr",chr2,"_",pos2,sep=""))

write.table(cbind(paste("group",chr1,sep=""),pos1,pos1),file="selected_pairs_log.bed",sep="\t",row.names=FALSE,col.names=FALSE,append=TRUE,quote=FALSE)
write.table(cbind(paste("group",chr2,sep=""),pos2,pos2),file="selected_pairs_log.bed",sep="\t",row.names=FALSE,col.names=FALSE,append=TRUE,quote=FALSE)

y=x-1

trait<-as.character(paste("Trait",y,sep=""))
fitness<-as.character(paste("Fitness",y,sep=""))
if(y==0){
string<-fitness
} else{
string<-paste(string,fitness,sep="*")
}
if(number<0.5){
s1<-s
s2<-0
diagonal= (1-((1-ha)*hbc*s1))*(1-(ha*(1-hbc)*s2))
write.table(cbind(trait,"\t",chr1name,"+",chr2name,"\n",fitness,"\t","fIs=",chr1name,"+",chr2name,", ","if(fIs==10 || fIs==20,1, if(fIs==14,",1-(1-hbc)*s2,",if(fIs==18,",1-s2,",if(fIs==11,",1-(1-ha)*s1,",if(fIs==12,",1-s1,",if(fIs==15,",diagonal,",if(fIs==19,",1-ha*s2,",if(fIs==16,",1-hbc*s1,",0))))))))"),sep="",row.names=FALSE,col.names=FALSE,append=TRUE,file="BDMI_part2")

}

if(number>0.5){
s1<-s
s2<-0
diagonal= (1-((1-ha)*hbc*s1))*(1-(ha*(1-hbc)*s2))
write.table(cbind(trait,"\t",chr1name,"+",chr2name,"\n",fitness,"\t","fIs=",chr1name,"+",chr2name,", ","if(fIs==10 || fIs==20,1, if(fIs==14,",1-hbc*s1,",if(fIs==18,",1-s1,",if(fIs==11,",1-ha*s2,",if(fIs==12,",1-s2,",if(fIs==15,",diagonal,",if(fIs==19,",1-(1-ha)*s1,",if(fIs==16,",1-(1-hbc)*s2,",0))))))))"),sep="",row.names=FALSE,col.names=FALSE,append=TRUE,file="BDMI_part2")

}

write.table(cbind(chr1name,"\t",chr1,"\t",pos1,"\t","A","\t",1,"\t","a","\t",2,"\t","Additive","\t","1.00","\t","0.00","\n",chr2name,"\t",chr2,"\t",pos2,"\t","B","\t",4,"\t","b","\t",8,"\t","Additive","\t","1.00","\t","0.00"),sep="",row.names=FALSE,col.names=FALSE,append=TRUE,file="BDMI_part1")



}

write.table(cbind("Sex","chr3_25000000"),sep="\t",file="BDMI_part2",row.names=FALSE,col.names=FALSE,append=TRUE)

write.table(cbind("chr3_25000000","3","25000000","S","1","s","0","Hemizygous","0.50","0.50"),sep="\t",row.names=FALSE,col.names=FALSE,append=TRUE,file="BDMI_part1")

write.table(cbind("malinche","\t","-1","\t",string,"\n","birchmanni","\t","-1","\t",string,"\n","hyb","\t","-1","\t",string,"\n","hyb2","\t","-1","\t",string,"\n","hyb3","\t","-1","\t",string,"\n","hyb4","\t","-1","\t",string,"\n","hyb5","\t","-1","\t",string,"\n","hyb6","\t","-1","\t",string,"\n","hyb7","\t","-1","\t",string,"\n","hyb8","\t","-1","\t",string,"\n","hyb9","\t","-1","\t",string,"\n","hyb10","\t","-1","\t",string,"\n"),sep="",row.names=FALSE,col.names=FALSE,append=TRUE,file="BDMI_part3")

system("perl -pi -e 's/\"//g' BDMI_part*");

system("sort -n -k2 -k3 BDMI_part1 > genes_rand.txt");

system("cp BDMI_part2 phenotypes_rand.txt");

system("cp BDMI_part3 naturalsel_rand.txt");

file.remove("BDMI_part1")
file.remove("BDMI_part2")
file.remove("BDMI_part3")
