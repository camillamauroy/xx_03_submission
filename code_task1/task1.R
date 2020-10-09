library(stringr)
library(dplyr)
library(tidyr)
library(fhidata)
library(fhi)
library(fhiplot)

setwd("~/Desktop/xx_03_submission")
data <- readRDS("~/Desktop/xx_03_submission/data_raw/individual_level_data.RDS")

municip <- fhidata::norway_locations_b2020
municip_code <- as.list(municip$municip_code)

smData <- as.data.frame(data[1:100,])
newData <- merge(municip_code, smData, join = "left", fill = 0)
smData$value <- gsub("person","", smData$value)
smData$value <- as.numeric(smData$value)

agg <-aggregate(.~date+location_code, smData, sum)

start <- as.Date("2010-01-01",format="%y-%m-%d")
end   <- as.Date("2010-01-02",format="%y-%m-%d")

theDate <- start
i = 0

while (theDate <= end)
{
  for (i in municip_code)
    if(i != smData$location_code)
      new <- data.frame(theDate, i, 0)
      rbind (smData, new )
    theDate <- theDate + 1                    
}

#####################

data$value <- gsub("person","", data$value)
data$value <- as.numeric(data$value)

agg <-aggregate(.~date+location_code, data, sum)




####################
# FOR SMALLER DATA #
####################
# smallerData <- as.data.frame(data[1:5,])
# smallerData$value <- gsub("person","", smallerData$value)
# smallerData$value <- as.numeric(smallerData$value)
# 
# 
# aggregate(.~date+location_code, smallerData, sum)

# list <- strsplit(smallerData$value, ' ')









