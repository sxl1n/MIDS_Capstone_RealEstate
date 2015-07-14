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
