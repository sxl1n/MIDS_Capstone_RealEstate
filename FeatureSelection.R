dat = read.csv('merged.csv', header=TRUE)
head(dat)

dim(dat)

fit = lm(dat$median_home_price_2015_april~., data = dat, na.action = na.omit)
summary(fit)

attach(dat)
example = lm(median_home_price_2015_april~PM2.5+Parks+AVERAGE.of.Precipitation..1981.2010.Annual.Total..in.Inches+crime_index+earthquake_index+income+ Accommodation_and_Food_Services + Arts._Entertainment._and_Recreation, data = dat, na.action = na.omit)
summary(example)

#Variable Selection using AIC
library(MASS)
step = stepAIC(example, direction = "both")

#Subset Regression
library(leaps)
leaps = regsubsets(median_home_price_2015_april~PM2.5+Parks+AVERAGE.of.Precipitation..1981.2010.Annual.Total..in.Inches+crime_index+earthquake_index+income+ Accommodation_and_Food_Services + Arts._Entertainment._and_Recreation, data=dat, nbest=10)
summary(leaps)
plot(leaps, scale="r2")
library(car)
subsets(leaps, statistic="rsq")

#Stepwise AIC
summary(fit)
fit1 = lm(median_home_price_2015_april~Ozone + PM2.5 + Parks + Coffeeshops + Restaurants + AVERAGE.of.Temperature..1981.2010.Annual.Average..in.F + AVERAGE.of.Precipitation..1981.2010.Annual.Total..in.Inches + income, data = dat, na.action = na.omit)
summary(fit1) 
step1 = stepAIC(fit1, direction = "both") #PM2.5, Temp, Precipitation, Parks

fit2 = lm(median_home_price_2015_april~ PM2.5 + Parks + AVERAGE.of.Temperature..1981.2010.Annual.Average..in.F + AVERAGE.of.Precipitation..1981.2010.Annual.Total..in.Inches + crime_index + earthquake_index + female_labor + pop_growth_rate + renter_occupied + income, data = dat, na.action = na.omit)
summary(fit2)
step2 = stepAIC(fit2, direction = "both") #PM2.5, Parks, Precipitation, renter_occupied

fit3 = lm(median_home_price_2015_april~ PM2.5 + Parks + AVERAGE.of.Temperature..1981.2010.Annual.Average..in.F + AVERAGE.of.Precipitation..1981.2010.Annual.Total..in.Inches + renter_occupied + Accommodation_and_Food_Services + Administrative_and_Support_and_Waste_Management_and_Remediation_Services + Agriculture._Forestry._Fishing_and_Hunting + Arts._Entertainment._and_Recreation + Construction + income, data = dat, na.action = na.omit)
summary(fit3)
step3 = stepAIC(fit3, direction = "both") #PM2.5, Parks, Precipitation, renter_occupied, construction

fit4 = lm(median_home_price_2015_april~ PM2.5 + Parks + AVERAGE.of.Temperature..1981.2010.Annual.Average..in.F + AVERAGE.of.Precipitation..1981.2010.Annual.Total..in.Inches + renter_occupied + Construction + Educational_Services  + Finance_and_Insurance + Health_Care_and_Social_Assistance + Industries_not_classified + Information + income, data = dat, na.action = na.omit)
summary(fit4)
step4 = stepAIC(fit4, direction = "both") #PM2.5, Parks, Precipitation, renter_occupied, construction

fit5 = lm(median_home_price_2015_april~ PM2.5 + Parks + AVERAGE.of.Temperature..1981.2010.Annual.Average..in.F + AVERAGE.of.Precipitation..1981.2010.Annual.Total..in.Inches + renter_occupied + Construction + Finance_and_Insurance  + Information + Management_of_Companies_and_Enterprises + Manufacturing + Mining._Quarrying._and_Oil_and_Gas_Extraction+ Other_Services_.except_Public_Administration. + Professional._Scientific._and_Technical_Services + Real_Estate_and_Rental_and_Leasing + income, data = dat, na.action = na.omit)
summary(fit5)
step5 = stepAIC(fit5, direction = "both")

fit6 = lm(median_home_price_2015_april~ PM2.5 + Parks + AVERAGE.of.Temperature..1981.2010.Annual.Average..in.F + AVERAGE.of.Precipitation..1981.2010.Annual.Total..in.Inches + renter_occupied + Construction + Finance_and_Insurance  + Professional._Scientific._and_Technical_Services + Retail_Trade + Transportation_and_Warehousing + Utilities + Wholesale_Trade + income, data = dat, na.action = na.omit)
summary(fit6)
step6 = stepAIC(fit6, direction = "both")


final = lm(median_home_price_2015_april~ PM2.5 + Parks + AVERAGE.of.Temperature..1981.2010.Annual.Average..in.F + AVERAGE.of.Precipitation..1981.2010.Annual.Total..in.Inches + renter_occupied + Construction + Finance_and_Insurance  + Professional._Scientific._and_Technical_Services + income, data = dat, na.action = na.omit)
summary(final)
AIC(final) #513.72
BIC(final) #525.72
final = stepAIC(final, direction = "both") #449.29
