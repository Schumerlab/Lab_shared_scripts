arrArgs<-commandArgs(trailingOnly = TRUE);
rec_file<-as.character(arrArgs[1])
out_file<-as.character(arrArgs[2])
chr_length<-as.character(arrArgs[3])
chr_num<-as.character(arrArgs[4])

file.remove(out_file)

if(length(arrArgs)<4){
stop("usage is: Rscript LDres_to_admixem_rec_map.R LDresmod_file out_file_name chr_length_bp_for_simulation chr_number_for_simulation\n")
}#print usage

data<-read.csv(file=rec_file,sep="\t",head=FALSE)

data<-subset(data,data$V2<=chr_length & data$V3<0.4)
male<-data$V3
female<-data$V3

male_accumulative<-c(data$V3[1])
prev<-data$V3[1]
for (x in 2:length(data$V3)){

male_accumulative<-c(male_accumulative,data$V3[x]+prev)
prev<-data$V3[x]+prev

}

male_accumulative<-male_accumulative/male_accumulative[length(male_accumulative)]

female_accumulative<-male_accumulative

Male_recombination_fraction<-male/sum(male)
Female_recombination_fraction<-Male_recombination_fraction
Avg_recombination_fraction <- Male_recombination_fraction

Kosambi_male_interval<-Male_recombination_fraction
Kosambi_female_interval<-Female_recombination_fraction
Kosambi_male_pos<-male_accumulative
Kosambi_female_pos<-female_accumulative
Kosambi_both_interval<-Male_recombination_fraction
Kosambi_both_pos<-female_accumulative

write.table(paste(paste(":chr",chr_num,sep=""),":ExpectedMaleRecPerMeiosisArm1 = 1",":ExpectedMaleRecPerMeiosisArm2 = 0",":ExpectedFemaleRecPerMeiosisArm1 = 1",":ExpectedFemaleRecPerMeiosisArm2 = 0",sep="\n"),row.names=FALSE,col.names=FALSE,quote=FALSE,file=out_file,append=TRUE)

write.table(cbind(male,male_accumulative,female,female_accumulative,Male_recombination_fraction,Female_recombination_fraction,Avg_recombination_fraction,Kosambi_male_interval,Kosambi_male_pos,Kosambi_female_interval,Kosambi_female_pos,Kosambi_both_interval,Kosambi_both_pos),row.names=data$V1,quote=FALSE,append=TRUE,file=out_file,sep="\t")

command=paste("perl -pi -e 's/male\tmale_accumulative/\tmale\tmale_accumulative/g' ",out_file,sep="")
system(command)

