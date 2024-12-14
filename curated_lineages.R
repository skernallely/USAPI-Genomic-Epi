###
# GISAID Pull
#
# guam/,palau/pw,/micronesia,/marshall islands,/american samoa,/northern mariana
#

###

library(outbreakinfo)

curated <- getCuratedLineages()

View(curated[!is.na(curated$who_name),])
