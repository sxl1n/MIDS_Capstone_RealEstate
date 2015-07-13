setwd("C:\\Users\\jheckman\\OneDrive\\Documents\\School\\W210 Capstone\\Project\\Data")

#-- Read in original csv data
bayzips <- read.csv("zip_code_database_bay_area.csv")
ca_homeprices <- read.csv("Zip_MedianSoldPrice_AllHomes_CA.csv")

#-- Sharon's data
sharon <- read.csv("sharon_combined.csv")

#-- Thiyagu's data
crime_index <- read.csv("crime_index.csv")
earthquake_index <- read.csv("earthquake_index.csv")
female_in_labor_force <- read.csv("female_in_labor_force.csv")
pop_growth_rate <- read.csv("pop_growth_rate.csv")
renter_occupied_housing_units <- read.csv("renter_occupied_housing_units.csv")

#-- Judd's data
acs2013_5yr <- read.csv("bay_acs_2013_5yr_est_joined.csv")
zbp2013 <- read.csv("desc_est_zbp13detail.csv")

#-- NOTE: All merges are left join on the master bay area zip list to ensure no zip code with data is excluded

#-- Filter homeprices to just bay area zips
bay_homeprices <- merge(bayzips, ca_homeprices, by.x = "zip", by.y = "RegionName", all.x = T)

#-- Looks like April 2015 has data for the most zip codes: 204
sum(!is.na(bay_homeprices$X2015.04))

#-- Merge in Sharon's data
merged <- merge(bay_homeprices[c("zip", "X2015.04")], subset(sharon, select = -c(Median.House.Price..May.2015.)), by.x = "zip", by.y = "zip", all.x = T)
names(merged)[names(merged)=="X2015.04"] <- "median_home_price_2015_april"

#-- Merge in Thiyagu's data
merged <- merge(merged, crime_index, by = "zip", all.x = T)
merged <- merge(merged, earthquake_index, by = "zip", all.x = T)
merged <- merge(merged, female_in_labor_force, by = "zip", all.x = T)
merged <- merge(merged, pop_growth_rate, by = "zip", all.x = T)
merged <- merge(merged, renter_occupied_housing_units, by = "zip", all.x = T)

#-- Merge in Judd's data
merged <- merge(merged, acs2013_5yr[c("zip", "Total..Estimate..INCOME.IN.THE.PAST.12.MONTHS..IN.2012.INFLATION.ADJUSTED.DOLLARS....With.earnings...Mean.earnings..dollars..x", "Total..Estimate..EMPLOYMENT.STATUS...Unemployment.rate")], by = "zip", all.x = T)
merged <- merge(merged, zbp2013, by = "zip", all.x = T)

write.csv(merged, file = "merged_data.csv", row.names = F)
