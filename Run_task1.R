library(data.table)
library(stringr)
library(dplyr)
library(tidyr)
library(fhidata)
library(fhi)
library(fhiplot)
library(tidyverse)

# You will need to change your working directory
setwd("~/Desktop/xx_03_submission")

fileSources = file.path("code_task1", list.files("code_task1", pattern = "*.[rR]$"))
sapply(fileSources, source, .GlobalEnv)

data <- readRDS("data_raw/individual_level_data.RDS")

municip <- fhidata::norway_locations_b2020
municip_code <- as.list(municip$municip_code)

fhidata <- fhidata::norway_locations_b2020
county_code <- as.list(fhidata$county_code)


###################
# Create new dataframes for each municip
for (i in municip_code){
  kommune <- data %>% filter(data$location_code == i)
  
  aggKommune <-aggregate(.~date+location_code, kommune, sum)
  
  full_dates <- seq(min(aggKommune$date), max(aggKommune$date), 
                    by = "1 day")
  full_dates <- data.frame(date = full_dates)
  
  my_complete_data <- merge(full_dates, aggKommune, by = "date", 
                            all.x = TRUE)
  
  my_complete_data[is.na(my_complete_data)] = 0
  
  my_complete_data$location_code <- as.character(my_complete_data$location_code)
  
  my_complete_data$location_code[my_complete_data$location_code == "0"] <- i
  
  saveRDS(my_complete_data, file = file.path("kommuneAgg", paste(i,".RDS",sep="")))
}

###############
# legge sammen #
###############
result = data[FALSE,]

for (i in municip_code){
  file <- readRDS(paste("~/Desktop/xx_03_submission/kommuneAgg/",paste(i,".RDS",sep=""),sep=""))
  result <- rbind(result,file)
}

##################################################################################

result$date <- format.Date(result$date, "%G/%V/%d") #changes dates to ISO format


######################
#Create Norway data#
#####################
result$location_code <- NULL
norway <- aggregate(x = result$value,
                    FUN = sum,
                    by = list(Group.date = result$date))


data$value <- gsub("person","", data$value)
data$value <- as.numeric(data$value)

aggData <-aggregate(.~date+location_code, data, sum)














