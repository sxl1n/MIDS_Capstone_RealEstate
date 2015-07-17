setwd("C:\\Users\\jheckman\\OneDrive\\Documents\\School\\W210 Capstone\\Project\\Data")

library(reshape)

#-- Read in original csv data
bayzips <- read.csv("zip_code_database_bay_area.csv")
naics_descriptions <- read.csv("NAICS2012.csv")

#-- read, convert, and save all files
filenames <- list.files(path=getwd())
filenames <- filenames[grepl("^zbp[0-9]*detail.csv$", filenames)]

for (filename in filenames) {
  zbp <- read.csv(filename)
  
  #-- merge data to combine datasets filtered to zip codes in the bay area with NAICS descriptions instead of codes
  bay_zbp <- merge(bayzips[c("zip")], zbp, by = "zip")
  
  #--- just include detailed levels, not top level classifications
  bay_zbp_detail <- bay_zbp[grep("[^-]$", bay_zbp$naics),]
  
  bay_zbp_descriptions <- merge(bay_zbp_detail, naics_descriptions, by.x = "naics", by.y = "NAICS")
  
  #-- pivot to have one row per zip code with wide format for all naics counts on the total estimate column
  bay_zbp_est <- cast(bay_zbp_descriptions, zip ~ DESCRIPTION, value = "est")
  bay_zbp_est[is.na(bay_zbp_est)] <- 0
  
  write.csv(bay_zbp_est, file = paste("desc_est", filename, sep = "_"), row.names = F)
}
