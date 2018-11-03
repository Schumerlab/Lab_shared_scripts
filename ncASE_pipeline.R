args<-commandArgs(TRUE)

mydist <- function(data, snp1, snp2){
  coord1 <- data$position[data$variant == snp1]
  coord2 <- data$position[data$variant == snp2]
  return(object)
}

myweight <- function(data, snp){
  gene <- data$transcript[data$variant == snp]
  snp_pos <- data$position[data$variant == snp]
  all_pos <- data$position[data$transcript == gene & data$position - snp_pos < 100 & data$position - snp_pos > -100]
  s <- sum(1-abs(all_pos-snp_pos)/100)
  return(1/s)
} 

if(length(args) < 3)
  stop("Need at least one pair of replicate files and output filename")
if(length(args) %% 2 != 1)
  stop("Need two files per replicate")

max_replicate <- (length(args)-1)/2
for(replicate in 1:max_replicate) {

cat("Processing replicate", replicate, "\n")

species_1 <- read.table(args[2*replicate-1], quote="\"")
species_2 <- read.table(args[2*replicate], quote="\"")

species_1$V1 <- gsub("species_1_","",species_1$V1)
species_2$V1 <- gsub("species_2_","",species_2$V1)

x <- data.frame(species_1$V1, species_1$V2, species_1$V3, species_1$V4)
y <- data.frame(species_2$V1, species_2$V2, species_2$V4, species_2$V3)

colnames(x) <- c("V1", "V2", "V3", "V4")
colnames(y) <- c("V1", "V2", "V3", "V4")

z <- rbind(x,y)
duplicates <- z[duplicated(z),]
p <- paste(duplicates$V1, duplicates$V2, sep="_")


species_2_temp <- paste(species_2$V1, species_2$V2, sep="_")
species_2_snps <- data.frame(species_2,species_2_temp)

species_1_temp <- paste(species_1$V1, species_1$V2, sep="_")
species_1_snps <- data.frame(species_1,species_1_temp)

v <- species_1_snps[species_1_snps$species_1_temp %in% p,]
w <- species_2_snps[species_2_snps$species_2_temp %in% p,]


snps <- data.frame(v$species_1_temp,v$V1,as.numeric(as.character(v$V5)),
                   as.numeric(as.character(v$V6)),
                   as.numeric(as.character(w$V5)),
                   as.numeric(as.character(w$V6)),
                   as.numeric(as.character(v$V2)))

snps <- na.omit(snps)

colnames(snps) <- c("variant","transcript", "species_1_species_1","species_1_species_2","species_2_species_2","species_2_species_1","position")

snps <- snps[snps$species_1_species_1/(snps$species_1_species_1 + snps$species_2_species_1) > .475
                   & snps$species_1_species_1/(snps$species_1_species_1 + snps$species_2_species_1) < .525
                   & snps$species_2_species_2/(snps$species_1_species_2 + snps$species_2_species_2) > .475
                   & snps$species_2_species_2/(snps$species_1_species_2 + snps$species_2_species_2) < .525,]

snps$weight <- sapply(snps$variant,myweight,data=snps)

x <- aggregate(snps$species_1_species_1*snps$weight, by=list(snps$transcript), "sum")
y <-  aggregate(snps$species_2_species_1*snps$weight, by=list(snps$transcript), "sum")
w <- aggregate(snps$species_1_species_2*snps$weight, by=list(snps$transcript), "sum")
z <- aggregate(snps$species_2_species_2*snps$weight, by=list(snps$transcript), "sum")

#combined <- data.frame(x$Group.1, x$x, y$x, w$x, z$x)

if (replicate == 1)
  replicate_counts <- list(data.frame(x$Group.1,x$x,z$x))
else
  replicate_counts <- c(replicate_counts, list(data.frame(x$Group.1,x$x,z$x)))

}

temp <- replicate_counts[[1]]$x.Group.1

for(replicate in 2:max_replicate) {
  temp <- replicate_counts[[replicate]]$x.Group.1[replicate_counts[[replicate]]$x.Group.1 %in% temp]
}


for(replicate in 1:max_replicate) {
  i <- replicate_counts[[replicate]][replicate_counts[[replicate]]$x.Group.1 %in% temp,]  
  i <- i[order(as.character(i$x.Group.1)),]
  if(replicate==1) 
    combined_i <- data.frame(i$x.Group.1)
  combined_i <- data.frame(combined_i, i$x.x, i$z.x)
}

labels <- c("transcript")
for(replicate in 1:max_replicate)
  labels <- c(labels, paste("replicate",replicate,"species_1",sep="_"),paste("replicate",replicate,"species_2",sep="_"))

names(combined_i) <- labels

write.table(combined_i, file=args[length(args)], quote=FALSE, sep="\t", row.names=FALSE) 

