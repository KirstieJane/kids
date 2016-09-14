library(ggplot2)
library(knitr)
#check how percent and mean fd are related:
aDF <- read.csv('./Phenotypic_V1_0b_preprocessed1.csv')
aplot <- ggplot(aDF, aes(y=func_mean_fd, x=func_perc_fd))+
	geom_point(alpha=.3)+
	geom_smooth()
print(aplot)
ggsave(aplot, filename='mean_by_perc_fd.png',  width=10, height=10, units='in', dpi=150) 

#+ "load-data"

rsqDF <- read.csv('./RESULTS/SummaryRsqs.csv', stringsAsFactors=F)

head(rsqDF) 

#+ "freq_check"
#Check frequencies and distributions
table(rsqDF$motion_thresh)
table(rsqDF$n)
table(rsqDF$age_l-rsqDF$age_u)
table(rsqDF[,c('motion_thresh', 'n')])
table(rsqDF[,c('age_l', 'n')])
table(rsqDF[,c('motion_thresh', 'age_l')])

qplot(rsqDF$med_rsq)

#+ "fun_plots"
#Plot the fun stuff

n_color_age_facet <- ggplot(rsqDF, aes(x=motion_thresh, y=med_rsq, group=(n), color=(n)))+
	geom_errorbar(aes(ymin=med_rsq-CI_95/2, 
			  ymax=med_rsq+CI_95/2), 
		      width=0, alpha=.6)+
	facet_wrap(~age_l)+
	coord_cartesian(y=c(.5, 1))+
	scale_color_gradient(low='gray', high='darkblue')

age_color_n_facet <- ggplot(rsqDF, aes(x=motion_thresh, y=med_rsq, group=factor(age_l), color=factor(age_l)))+
	geom_errorbar(aes(ymin=med_rsq-CI_95/2, 
			  ymax=med_rsq+CI_95/2), 
		      width=0, alpha=.2)+
	coord_cartesian(y=c(.8, 1))+
	facet_wrap(~n)

plotThing <- function(aPlot){
	aPlot + 
		geom_point(alpha=.2)+
		geom_line(alpha=.5)+
		scale_x_continuous(trans='identity')+
		scale_y_continuous(trans='identity')
}

plotThing(n_color_age_facet)

plotThing(age_color_n_facet)
