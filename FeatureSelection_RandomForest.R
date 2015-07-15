setwd("C:\\Users\\jheckman\\OneDrive\\Documents\\School\\W210 Capstone\\Project\\Data")

dat = read.csv('merged_data.csv')
summary(dat)

#-- rename income variable
names(dat)[names(dat)=="Total..Estimate..INCOME.IN.THE.PAST.12.MONTHS..IN.2012.INFLATION.ADJUSTED.DOLLARS....With.earnings...Mean.earnings..dollars..x"] <- "income"

#-- unemployment rate var is factor, change to numeric
dat$unemployment_rate <- as.numeric(levels(dat$Total..Estimate..EMPLOYMENT.STATUS...Unemployment.rate))[dat$Total..Estimate..EMPLOYMENT.STATUS...Unemployment.rate]
dat <-  subset(dat, select = -c(zip,Total..Estimate..EMPLOYMENT.STATUS...Unemployment.rate))

####---- Random Forest
library(randomForest)
train_size <- floor(0.75 * nrow(dat))
train_i <- sample(seq_len(nrow(dat)), size = train_size)

train <- dat[train_i,]
test <- dat_complete[-train_i,]

colnames(dat)

#-- Removed columns: income, unemployment_rate
cols <- c('median_home_price_2015_april',
          'PM2.5',
          'Coffeeshops',
          'AVERAGE.of.Temperature..1981.2010.Annual.Average..in.F',
          'crime_index',
          'female_labor',
          'renter_occupied',
          'Accommodation_and_Food_Services',
          'Agriculture._Forestry._Fishing_and_Hunting',
          'Construction',
          'Finance_and_Insurance',
          'Industries_not_classified',
          'Management_of_Companies_and_Enterprises',
          'Mining._Quarrying._and_Oil_and_Gas_Extraction',
          'Professional._Scientific._and_Technical_Services',
          'Retail_Trade',
          'Transportation_and_Warehousing',
          'Wholesale_Trade',
          'Ozone',
          'Parks',
          'Restaurants',
          'AVERAGE.of.Precipitation..1981.2010.Annual.Total..in.Inches',
          'earthquake_index',
          'pop_growth_rate',
          'Administrative_and_Support_and_Waste_Management_and_Remediation_Services',
          'Arts._Entertainment._and_Recreation',
          'Educational_Services',
          'Health_Care_and_Social_Assistance',
          'Information',
          'Manufacturing',
          'Other_Services_.except_Public_Administration.',
          'Real_Estate_and_Rental_and_Leasing',
          'Total_for_all_sectors',
          'Utilities')

rf <- randomForest(median_home_price_2015_april ~ ., data = train[,cols], na.action = na.omit, ntree=1500, mtry=20, keep.forest = F, importance = T)
feature_importance <- data.frame(importance(rf))
feature_importance$names <- rownames(feature_importance)
feature_importance <- feature_importance[order(-feature_importance$X.IncMSE),]
