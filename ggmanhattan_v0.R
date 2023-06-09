library(tidyverse)

ggmanhattanFormat <- function(df,
                              LR1_cutoff=0.01,
                              addchr=6000000){
  
  df <- df %>%
    filter(LR1 < LR1_cutoff) 
  
  don <- df %>%
    # Compute chromosome size
    group_by(group) %>%
    summarise(chr_len=max(pos)+addchr) %>%
    
    # Calculate cumulative position of each chromosome
    mutate(tot=cumsum(chr_len)-chr_len) %>%
    select(-chr_len) %>%
    
    # Add this info to the initial dataset
    left_join(df, ., by=c("group"="group")) %>%
    
    # Add a cumulative position of each SNP
    arrange(group, pos) %>%
    mutate(pos2=pos+tot) %>%
    
    # Add a cumulative position of each SNP
    arrange(group, pos) %>%
    mutate(pos2=pos+tot)
  
  return(don)
}

ggmanhattanPlot <- function(df,
                            species="",
                            colors=c("grey","black"),
                            sigThresh=6,
                            chr_num=24){
  
  # create label locations for x-axis
  axisdf <- df %>%
    group_by(group) %>% 
    summarize(center=(max(pos2)+min(pos2))/2)
  
  # create ggplot object
  p <- ggplot(df, aes(x=pos2, y=-log10(LR1))) +
    # Show all points
    geom_point(aes(color=as.factor(group)), alpha=0.9, size=1.3) +
    scale_color_manual(values = rep(colors, chr_num)) +
    
    # custom X axis:
    scale_x_continuous(label = subset(axisdf, axisdf$group %% 2 == 1)$group,
                       breaks = subset(axisdf, axisdf$group %% 2 == 1)$center) +
    
    # remove space between plot area and x axis
    scale_y_continuous(expand = c(0, 0),
                       limits = c(min(-log10(df$LR1)),
                                  max(-log10(df$LR1)) + 0.5)) +     
    
    # significance line
    geom_hline(yintercept=sigThresh, size = 0.5, lty = "dashed") +
   
    # Custom the theme:
    theme_classic(base_size = 12) +
    theme(legend.position="none",
          panel.border = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank()) +
    xlab(expr(paste(italic(!!species)," chromosome",sep=""))) +
    ylab(expression(paste("-log"[10],"(",italic(""*P*""),"-value)",sep="")))

  p
}