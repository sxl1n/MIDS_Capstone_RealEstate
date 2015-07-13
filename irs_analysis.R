setwd("C:\\Users\\jheckman\\OneDrive\\Documents\\School\\W210 Capstone\\Project\\Data")

#-- Read in original csv data
bayzips <- read.csv("zip_code_database_bay_area.csv")
ca_homeprices <- read.csv("Zip_MedianSoldPrice_AllHomes_CA.csv")
ca_irs <- read.csv("12zpallagi_ca.csv")

summary(bayzips)
summary(ca_homeprices)

#-- merge data to combine datasets filtered to zip codes in the bay area
bay_homeprices <- merge(bayzips, ca_homeprices, by.x = "zip", by.y = "RegionName")
bay_irs <- merge(bayzips, ca_irs, by.x = "zip", by.y = "zipcode")
bay_homeprices_irs <- merge(bay_homeprices, bay_irs, by = "zip")

write.csv(bay_irs, file = "bay_12zpallagi.csv")

#-- Correlation on percentage of returns with self employed retirement plan
bay_homeprices_irs$ser_plan_pct <- bay_homeprices_irs$N03300 / bay_homeprices_irs$N1
cor(bay_homeprices_irs$ser_plan_pct, bay_homeprices_irs$X2014.05, use="complete.obs")

#-- Correlation on percentage of returns with taxable social security benefits
bay_homeprices_irs$tax_ssben_pct <- bay_homeprices_irs$N02500 / bay_homeprices_irs$N1
cor(bay_homeprices_irs$tax_ssben_pct, bay_homeprices_irs$X2014.05, use="complete.obs")

#-- Correlation on percentage of returns with unemployment compensation
bay_homeprices_irs$unemp_comp_pct <- bay_homeprices_irs$N02300 / bay_homeprices_irs$N1
cor(bay_homeprices_irs$unemp_comp_pct, bay_homeprices_irs$X2014.05, use="complete.obs")

#-- Find zip codes where homeprices are above average, but number of self-employed retirement plans are below average
bay_homeprice_median <- median(bay_homeprices_irs$X2014.05, na.rm=T)
bay_ser_plan_mean <- mean(bay_homeprices_irs$ser_plan_pct, na.rm=T)

above_median_price <- unique(bay_homeprices_irs$zip[bay_homeprices_irs$X2014.05 > bay_homeprice_median])
below_mean_ser_pct <- unique(bay_homeprices_irs$zip[bay_homeprices_irs$ser_plan_pct < bay_ser_plan_mean])

bay_homeprices_irs$zip[bay_homeprices_irs$X2014.05 > bay_homeprice_median && bay_homeprices_irs$ser_plan_pct < bay_ser_plan_mean]

above_below <- merge(above_median_price, below_mean_ser_pct)
