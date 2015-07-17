setwd("C:\\Users\\jheckman\\OneDrive\\Documents\\School\\W210 Capstone\\Project\\Data")

#-- Read in original csv data
bayzips <- read.csv("zip_code_database_bay_area.csv")
bay_avg_homeprices <- read.csv("sf_bay_area_avg_median_home_price.csv")
names(bay_avg_homeprices)[names(bay_avg_homeprices)=="X.ZIP"] <- "zip"

#-- Sharon's data
sharon <- read.csv("sharon_combined.csv")
names(sharon)[names(sharon)=="AVERAGE.of.Temperature..1981.2010.Annual.Average..in.F"] <- "avg_temperature"
names(sharon)[names(sharon)=="AVERAGE.of.Precipitation..1981.2010.Annual.Total..in.Inches"] <- "avg_precipitation"

#-- Thiyagu's data
crime_index <- read.csv("crime_index.csv")
earthquake_index <- read.csv("earthquake_index.csv")
female_in_labor_force <- read.csv("female_in_labor_force.csv")
pop_growth_rate <- read.csv("pop_growth_rate.csv")
renter_occupied_housing_units <- read.csv("renter_occupied_housing_units.csv")
bay_poverty <- read.csv("sf_bay_area_poverty_rate.csv")
bay_poverty <- bay_poverty[1:2]

#-- Judd's data
acs2013_5yr <- read.csv("bay_acs_2013_5yr_est_joined.csv")
names(acs2013_5yr)[names(acs2013_5yr)=="Total..Estimate..INCOME.IN.THE.PAST.12.MONTHS..IN.2012.INFLATION.ADJUSTED.DOLLARS....With.earnings...Mean.earnings..dollars..x"] <- "income"
acs2013_5yr$unemployment_rate <- as.numeric(levels(acs2013_5yr$Total..Estimate..EMPLOYMENT.STATUS...Unemployment.rate))[acs2013_5yr$Total..Estimate..EMPLOYMENT.STATUS...Unemployment.rate]
acs2013_5yr <- subset(acs2013_5yr, select = -c(Total..Estimate..EMPLOYMENT.STATUS...Unemployment.rate))

zbp2013 <- read.csv("desc_est_zbp13detail.csv")

#-- NOTE: All merges are left join on the master bay area zip list to ensure no zip code with data is excluded

#-- Merge avg median home prices
merged <- merge(bayzips[c("zip")], bay_avg_homeprices, by = "zip", all.x = T)

#-- Merge in Sharon's data
merged <- merge(merged, subset(sharon, select = -c(Median.House.Price..May.2015.)), by.x = "zip", by.y = "zip", all.x = T)

#-- Merge in Thiyagu's data
merged <- merge(merged, crime_index, by = "zip", all.x = T)
merged <- merge(merged, earthquake_index, by = "zip", all.x = T)
merged <- merge(merged, female_in_labor_force, by = "zip", all.x = T)
merged <- merge(merged, pop_growth_rate, by = "zip", all.x = T)
merged <- merge(merged, renter_occupied_housing_units, by = "zip", all.x = T)
merged <- merge(merged, bay_poverty, by.x = "zip", by.y = "X.ZIP", all.x = T)

#-- Merge in Judd's data
merged <- merge(merged, acs2013_5yr[c("zip", "income", "unemployment_rate")], by = "zip", all.x = T)
merged <- merge(merged, zbp2013, by = "zip", all.x = T)

write.csv(merged, file = "merged_data.csv", row.names = F)
