library(MASS)
low_level = read.csv('merged_data.csv', header=TRUE)
high_level = read.csv('merged_data_high_level_categories.csv', header=TRUE)


reg = lm(Avg_Median_Home_Price ~ avg_temperature + female_labor + pop_growth_rate + Poverty_Rate + unemployment_rate + renter_occupied + Construction + Educational_Services  +  Health_Care_and_Social_Assistance + Information + Management_of_Companies_and_Enterprises + income, data = high_level, na.action = na.omit)
summary(reg)

rf = lm(Avg_Median_Home_Price ~ income+ unemployment_rate+ Transportation_and_Warehousing+ Parks+ Educational_Services+ renter_occupied+ Accommodation_and_Food_Services+ Industries_not_classified+ Real_Estate_and_Rental_and_Leasing+ Utilities + Poverty_Rate, data = high_level, na.action = na.omit)
summary(rf)

## Variable Selection for RF + Regression on low
fit = lm(Avg_Median_Home_Price ~ income + unemployment_rate + Poverty_Rate + Specialized_Freight_.except_Used_Goods._Trucking._Local + Exam_Preparation_and_Tutoring + Beauty_Salons + Fine_Arts_Schools + Window_Treatment_Stores + Kidney_Dialysis_Centers + Child_Day_Care_Services + Passenger_Car_Rental + Convention_and_Trade_Show_Organizers + All_Other_Plastics_Product_Manufacturing + General_Freight_Trucking._Local + Parks + Temporary_Help_Services + Newspaper_Publishers + Pet_and_Pet_Supplies_Stores + Other_Social_Advocacy_Organizations + Toy_and_Hobby_Goods_and_Supplies_Merchant_Wholesalers + Paint_and_Wallpaper_Stores + Residential_Remodelers + renter_occupied + Graphic_Design_Services + Nature_Parks_and_Other_Similar_Institutions + Discount_Department_Stores + Offices_of_Dentists + Painting_and_Wall_Covering_Contractors + Residential_Property_Managers + Drycleaning_and_Laundry_Services_.except_Coin.Operated. + Other_Accounting_Services, data = low_level, na.action = na.omit)
fit_step = stepAIC(fit, direction = 'both')

rf_reg = lm(Avg_Median_Home_Price ~ income + unemployment_rate + Exam_Preparation_and_Tutoring + Beauty_Salons + Passenger_Car_Rental + Convention_and_Trade_Show_Organizers + All_Other_Plastics_Product_Manufacturing + Parks + Temporary_Help_Services + Newspaper_Publishers + Toy_and_Hobby_Goods_and_Supplies_Merchant_Wholesalers + Paint_and_Wallpaper_Stores + renter_occupied + Graphic_Design_Services + Nature_Parks_and_Other_Similar_Institutions + Discount_Department_Stores + Offices_of_Dentists, data = low_level, na.action = na.omit)


AIC(reg) #722.535
AIC(rf) #1561.684
AIC(rf_reg) #1553.804

BIC(reg) #741.6771
BIC(rf) #1588.47
BIC(rf_reg) #1592.952
