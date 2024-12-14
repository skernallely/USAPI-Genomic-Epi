#gis aid search term
#  /guam,palau/pw,/micronesia,/northern mariana,/american samoa
#

library(tidyverse)
library(readxl)
library(outbreakinfo) 

authenticateUser()

#  Provide GISAID credentials using authenticateUser()
# Get the prevalence of all circulating lineages in California over the past 90 days
plotAllLineagesByLocation(location = c("Guam","Northern Mariana Islands",
                                       "Palau","Micronesia",
                                       "Marshall Islands","American Samoa"), 
                          other_threshold = 0.05
                          )

locationName <- "Northern Mariana Islands"

# The WHO lineages are a Pango lineage with all its sublineages.
# Using `lookupSublineages`, we can lookup all the sublineages associated 
# with the WHO designated sequence, according to the most recent classifications from the Pango team.
alpha_lineages = lookupSublineages("Alpha", returnQueryString = TRUE)
delta_lineages = lookupSublineages("Delta", returnQueryString = TRUE)
omicron_lineages = lookupSublineages("Omicron", returnQueryString = TRUE)

# create a label dictionary to rename the lineages by their WHO name:
# If you don't do this, the lineage will be labeled as a really long name of all the Pango lineages like "B.1.617.2 OR AY.1 OR AY.2 ...)"
who_labels = c("Alpha", "Delta", "Omicron")
names(who_labels) = c(alpha_lineages, delta_lineages, omicron_lineages)

who_prevalence = getPrevalence(pangolin_lineage = c(alpha_lineages, delta_lineages,
                                                    omicron_lineages), 
                               location = "Guam","Northern Mariana Islands")

plotPrevalenceOverTime(who_prevalence, labelDictionary = who_labels)



#make list of all files to read in
locationName <- list("Guam","Northern Mariana Islands",
                     "Palau","Micronesia",
                     "Marshall Islands","American Samoa")

#create function to read in files correctly
multi_prevalence <- function(x){ 
  getPrevalence(pangolin_lineage = c(alpha_lineages, delta_lineages,omicron_lineages), 
                location = x)
}

#combine all prevalence data for USAPI
raw <- do.call(rbind.data.frame, lapply(locationName, multi_prevalence))

#create tiled graph for major variant proportions by USAPI
tiled_proportions <- ggplot(data=raw) +
  geom_line(aes(x=date,y=proportion,colour=lineage)) +  
  theme_classic() +
  theme(panel.background = element_blank(), 
        panel.border = element_blank(),
        legend.position="bottom",
        legend.title = element_blank(),
        plot.margin = unit(c(1,2,1,2), "cm")) +
  facet_wrap( ~ location) + 
  labs(title="SARS-CoV-2 Variants by USAPI",
       caption="Source: GISAID", 
       y="Proportion of samples tested",
       x="Date")

multi_lineages <- function(x){ 
  getAllLineagesByLocation(location = x, other_threshold = 0.03, 
                           nday_threshold = 5, ndays = 60)
}

getAllLineagesByLocation(location = x, other_threshold = 0.03, nday_threshold = 5, ndays = 60)
