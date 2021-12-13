#####
library(seqLogo)

arrArgs<-commandArgs(trailingOnly = TRUE);
myfile<-as.character(arrArgs[1])
species<-as.character(arrArgs[2])

#pwm.stuff = function(species = species, myfile=file) {
  fl = paste(myfile,sep="")
  pwm = read.table(fl)
  pwm = pwm[2:5,2:length(pwm[1,])]
  #return(pwm)
  #fl = paste(species,".PWM.txt",sep="")
  pwm
  write.table(pwm,paste(fl,"_tmp",sep=""),row.names = FALSE,col.names = FALSE)
  pwm = cbind(c("A:","C:","G:","T:"),pwm)
  colnames(pwm) = NULL
  rownames(pwm)=NULL
  out = paste(species,".PWM.txt",sep="")
  out
  #pwm
  #return(out)
  write.table(pwm,file=out,row.names = FALSE,col.names = FALSE,quote=FALSE,sep="\t")
  pwm = pwm[,2:length(pwm[1,])]
  #pwm = makePWM(pwm=pwm)
  #seqLogo(pwm,xaxis=F,yaxis=F)
#}

#pwm.stuff(species)
#print(species)
#pwm.names = read.table("/Users/Zbaker/Documents/Przeworski-Lab/Recombination/znf-dnds/meme-PWMs/zf.princeton/names-to-read.txt")
#pwn.names = as.character(pwm.names[,1])
#for (spec in pwn.names) {
#  pwm.stuff(spec)
#  print(spec)
#}


