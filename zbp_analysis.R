setwd("C:\\Users\\jheckman\\OneDrive\\Documents\\School\\W210 Capstone\\Project\\Data")

#-- Read in original csv data
bayzips <- read.csv("zip_code_database_bay_area.csv")
zbp2013 <- read.csv("zbp13detail.csv")

summary(bayzips)
summary(ca_homeprices)

#-- merge data to combine datasets filtered to zip codes in the bay area
bay_homeprices <- merge(bayzips, ca_homeprices, by.x = "zip", by.y = "RegionName")
bay_irs <- merge(bayzips, ca_irs, by.x = "zip", by.y = "zipcode")
bay_homeprices_irs <- merge(bay_homeprices, bay_irs, by = "zip")
