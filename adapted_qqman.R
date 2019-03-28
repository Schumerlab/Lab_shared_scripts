# Stephen Turner
# http://StephenTurner.us/
# http://GettingGeneticsDone.blogspot.com/

# Daniel Capurso
# UCSF
# http://www.linkedin.com/in/dcapurso

######MS: slight modifications made by Schumer lab for plotting likelihood differences in our datasets 10/9/18

# Last major update: June 10, 2013
# R code for making manhattan plots and QQ plots from plink output files. 

### This is for testing purposes. ######################################
# 	set.seed(42)
# 	nchr=22
# 	nsnps=1000
# 	d = data.frame(
# 		SNP=sapply(1:(nchr*nsnps), function(x) paste("rs",x,sep='')),
# 		CHR=rep(1:nchr,each=nsnps), 
# 		BP=rep(1:nsnps,nchr), 
# 		P=runif(nchr*nsnps)
# 	)
# 	### d[d$SNP=='rs20762',]$P = 1e-29
# 	top_snps = c('rs13895','rs20762')
# 	surrounding_snps = list(	as.character(d$SNP[13795:13995]),
# 							as.character(d$SNP[20662:20862]))
# 	
# 	pvector = d$P
# 	names(pvector) = d$SNP
# 	
# 	#CALL:
# 	#manhattan(d,annotate=top_snps,highlight=surrounding_snps)
# 	#qq(pvector,annotate=top_snps,highlight=top_snps)
#########################################################################

# manhattan plot using base graphics
manhattan <- function(dataframe, limitchromosomes=NULL,pt.col=c('gray10','gray50'),pt.bg=c('gray10','gray50'),
	pt.cex=0.45,pch=21,cex.axis=0.95,gridlines=F,gridlines.col='gray83',gridlines.lty=1,gridlines.lwd=1,ymax=8, ymax.soft=T, annotate=NULL,annotate.cex=0.7,annotate.font=3,
	suggestiveline=10, suggestiveline.col='blue', suggestiveline.lwd=1.5, suggestiveline.lty=1, 
	genomewideline=10, genomewideline.col='red', genomewideline.lwd=1.5, genomewideline.lty=1, 
	highlight=NULL,highlight.col=c('green3','magenta'),highlight.bg=c('green3','magenta'),  ...) {
	#============================================================================================
	######## Check data and arguments
    d = na.omit(dataframe) # omit NAs
    
    if (!("CHR" %in% names(d) & "BP" %in% names(d) & "P" %in% names(d))) stop("Make sure your data frame contains columns CHR, BP, and P")
    if (TRUE %in% is.na(suppressWarnings(as.numeric(d$CHR)))) warning('non-numeric, non-NA entries in CHR column of dataframe. attempting to remove..')
    if (TRUE %in% is.na(suppressWarnings(as.numeric(d$BP)))) warning('non-numeric, non-NA entries in BP column of dataframe. attempting to remove..')
	if (TRUE %in% is.na(suppressWarnings(as.numeric(d$P)))) warning('non-numeric, non-NA entries in P column of dataframe. attempting to remove..')
    
	d = d[!is.na(suppressWarnings(as.numeric(d$CHR))),] # remove rows with non-numeric, non-NA entries
    d = d[!is.na(suppressWarnings(as.numeric(d$BP))),]
    d = d[!is.na(suppressWarnings(as.numeric(d$P))),]
    
	
	if (!is.null(annotate)){
		if ('SNP' %in% names(d)){
			if (FALSE %in% (annotate %in% d$SNP)) stop ("D'oh! Annotate vector must be a subset of the SNP column.")
		} else {
			stop("D'oh! Dataframe must have a column $SNP with rs_ids to use annotate feature.")
		}
	}
	if (!is.numeric(annotate.cex) | annotate.cex<0) annotate.cex=0.7
	if (!is.numeric(annotate.font)) annotate.font=3
	
	if (is.character(gridlines.col[1]) & !(gridlines.col[1] %in% colors())) gridlines.col = 'gray83'
	if (!is.numeric(pt.cex) | pt.cex<0) pt.cex=0.45
	if (is.character(pt.col) & (FALSE %in% (pt.col %in% colors()))) pt.col = c('gray10','gray50')
	if (is.character(pt.bg) & (FALSE %in% (pt.bg %in% colors()))) pt.bg = F
	if (is.character(highlight.col) & (FALSE %in% (highlight.col %in% colors()))) highlight.col = c('green3','magenta')
	if (is.character(highlight.bg) & (FALSE %in% (highlight.bg %in% colors()))) highlight.bg = F
	if (is.character(suggestiveline.col[1]) & !(suggestiveline.col[1] %in% colors())) suggestiveline.col = 'blue'
	if (is.character(genomewideline.col[1]) & !(genomewideline.col[1] %in% colors())) genomewideline.col = 'red'
		
    if(!is.null(limitchromosomes)){
    	if (TRUE %in% is.na(suppressWarnings(as.numeric(limitchromosomes)))){
    		stop('limitchromosomes argument is not numeric') 
    	} else {  
    		d = d[d$CHR %in% as.numeric(limitchromosomes), ]
    	}
    }
    

    ######################
    
    # Set positions, ticks, and labels for plotting
    d=subset(d[order(d$CHR, d$BP), ], (P> -1)) # sort, and keep only 0<P<=1 #reset because we aren't plotting Ps
    d$logp = (d$P)
    d$pos=NA
    
    
    # Ymax
    if(is.na(suppressWarnings(as.numeric(ymax)))){  # not numeric
    	ymax = ceiling(max((d$P)))
    	warning('non-numeric ymax argument.')
    } else if (as.numeric(ymax) < 0){ 			# negative
    	ymax = ceiling(max((d$P)))
    	warning('negative ymax argument.')
    }
    if (ymax.soft==T){ #if soft, ymax is just the lower limit for ymax
    	ymax = max(ymax, ceiling(max((d$P))))
    	
    	# make ymax larger if top annotate SNP is very high
    	if (!is.null(annotate)){
    		annotate.max = max(d[which(d$SNP %in% annotate),]$logp)
    		if ((ymax - annotate.max) < 0.18*ymax){
    			ymax = annotate.max + 0.18*ymax
    		}
    	}
    } #else, ymax = ymax
	
	## Fix for the bug where one chromosome is missing. Adds index column #####
	d$index=NA
	ind = 0
	for (i in unique(d$CHR)){
		ind = ind + 1
		d[d$CHR==i,]$index = ind
	}
	########
	
    nchr=length(unique(d$CHR))
    if (nchr==1) {
        d$pos=d$BP
        ticks=floor(length(d$pos))/2+1
        xlabel = paste('Chromosome',unique(d$CHR),'position')
        labs = ticks
    } else {
    	ticks = rep(NA,length(unique(d$CHR))+1)
    	ticks[1] = 0
        for (i in 1:max(d$index)) {
          	d[d$index==i, ]$pos   =    (d[d$index==i, ]$BP - d[d$index==i,]$BP[1]) +1 +ticks[i]
    		ticks[i+1] = max(d[d$index==i,]$pos)
    	}
    	xlabel = 'Chromosome'
    	labs = append(unique(d$CHR),'')
	}
    
    # Initialize plot
    xmax = max(d$pos) * 1.03
    xmin = max(d$pos) * -0.03
    ymax = ceiling(ymax * 1.03)
    ymin = -ymax*0.03
    plot(0,col=F,xaxt='n',bty='n',xaxs='i',yaxs='i',xlim=c(xmin,xmax), ylim=c(ymin,ymax),
    		xlab=xlabel,ylab=expression(LOD),las=1,cex.axis=cex.axis)
	
	# stagger labels
	blank = rep('',length(labs))
	lowerlabs = rep('',length(labs))
	upperlabs = rep('',length(labs))
	
	for (i in 1:length(labs)){
		if (i %% 2 == 0){
			lowerlabs[i] = labs[i]
		} else{
			upperlabs[i] = labs[i]
		}
	}
	
	axis(1,at=ticks,labels=blank,lwd=0,lwd.ticks=1,cex.axis=cex.axis)
	axis(1,at=ticks,labels=upperlabs,lwd=0,lwd.ticks=0,cex.axis=cex.axis,line=-0.25)
	axis(1,at=ticks,labels=lowerlabs,lwd=0,lwd.ticks=0,cex.axis=cex.axis,line=0.25)
	
	yvals = par('yaxp')
	yinterval = par('yaxp')[2] / par('yaxp')[3]
	axis(2,at= (seq(0,(ymax+yinterval/2),yinterval) - yinterval/2),labels=F,lwd=0,lwd.ticks=1,cex.axis=cex.axis)
	
    # Gridlines
	if (isTRUE(gridlines)){
		
		#abline(v=ticks,col=gridlines.col[1],lwd=gridlines.lwd,lty=gridlines.lty) #at ticks
		#abline(h=seq(0,ymax,yinterval),col=gridlines.col[1],lwd=gridlines.lwd,lty=gridlines.lty) # at labeled ticks
		#abline(h=(seq(0,ymax,yinterval) - yinterval/2),col=gridlines.col[1],lwd=1.0) # at unlabeled ticks
	}
	
    # Points, with optional highlighting
    pt.col = rep(pt.col,max(d$CHR))[1:max(d$CHR)]
	pt.bg = rep(pt.bg,max(d$CHR))[1:max(d$CHR)]
    d.plain = d
    if (!is.null(highlight)) {
    	if(class(highlight)!='character' & class(highlight)!='list'){
    		stop('"highlight" must be a char vector (for 1 color) or list (for multi color).')
    	}
    	
    	if (class(highlight)=='character'){ #if char vector, make list for consistency in plotting below
    		highlight = list(highlight)
    	}
    	
    	if ('SNP' %in% names(d)){
    		for (i in 1:length(highlight)){
				if (FALSE %in% (highlight[[i]] %in% d$SNP)) stop ("D'oh! Highlight vector/list must be a subset of the SNP column.")
			}
		} else {
			stop("D'oh! Dataframe must have a column $SNP with rs_ids to use highlight feature.")
		}
    	
    	highlight.col = rep(highlight.col,length(highlight))[1:length(highlight)]
		highlight.bg = rep(highlight.bg,length(highlight))[1:length(highlight)]
    	
    	for (i in 1:length(highlight)){
    		d.plain = d.plain[which(!(d.plain$SNP %in% highlight[[i]])), ]
    	}
    }
    
    icol=1
    for (i in unique(d.plain$CHR)) {
        with(d.plain[d.plain$CHR==i, ],points(pos, logp, col=pt.col[icol],bg=pt.bg[icol],cex=pt.cex,pch=pch,...))
        icol=icol+1
    }
    
    if (!is.null(highlight)){	
    	for (i in 1:length(highlight)){
    		d.highlight=d[which(d$SNP %in% highlight[[i]]), ]
    		with(d.highlight, points(pos, logp, col=highlight.col[i],bg=highlight.bg[i],cex=pt.cex,pch=pch,...)) 
    	}
    }
    
    # Significance lines
   if (is.numeric(suggestiveline)) abline(h=suggestiveline, col=suggestiveline.col[1],lwd=suggestiveline.lwd,lty=suggestiveline.lty)
   if (is.numeric(genomewideline)) abline(h=genomewideline, col=genomewideline.col[1],lwd=genomewideline.lwd,lty=genomewideline.lty)

	# Annotate
	if (!is.null(annotate)){
		d.annotate = d[which(d$SNP %in% annotate),]
		text(d.annotate$pos,(d.annotate$logp + 0.019*ymax),labels=d.annotate$SNP,srt=90,cex=annotate.cex,adj=c(0,0.48),font=annotate.font)		
	}

	# Box
	box()
}






