setwd("C:\\Users\\jheckman\\OneDrive\\Documents\\School\\W210 Capstone\\Project\\Data")

dat = read.csv('merged_data.csv')

####---- Random Forest
library(randomForest)
train_size <- floor(0.75 * nrow(dat))
train_i <- sample(seq_len(nrow(dat)), size = train_size)

train <- dat[train_i,]
test <- dat[-train_i,]

train <- dat

rf <- randomForest(Avg_Median_Home_Price ~ ., data = train, na.action = na.omit, ntree=2000, mtry=700, keep.forest = F, importance = T)
feature_importance <- data.frame(importance(rf))
feature_importance$names <- rownames(feature_importance)
feature_importance <- feature_importance[order(-feature_importance$X.IncMSE),]

write.csv(feature_importance, file = "rfr_feature_importances.csv", row.names = F)
#--------------------------------------------------------------------------------------

#-- ad hoc analysis below
result <- vector("list",1)
for (col in cols) {
  result[col] <- cor(dat$income, dat[,col], use="complete.obs")
}
result


hist(dat$PM2.5)
hist(dat$Utilities)
hist(dat$AVERAGE.of.Temperature..1981.2010.Annual.Average..in.F)
hist(dat$Parks)
hist(dat$Coffeeshops)
hist(dat$Restaurants)
stem(dat$Restaurants)
stem(dat$Parks)
plot(dat$Parks, dat$median_home_price_2015_april) #-- parks --> What's with the 40's?
plot(dat$income, dat$median_home_price_2015_april) #-- income / price is linear
plot(dat$Coffeeshops, dat$median_home_price_2015_april)
plot(dat$Restaurants, dat$median_home_price_2015_april)
plot(dat$Accommodation_and_Food_Services, dat$median_home_price_2015_april)
plot(dat$pop_growth_rate, dat$median_home_price_2015_april)
plot(dat$AVERAGE.of.Temperature..1981.2010.Annual.Average..in.F, dat$median_home_price_2015_april)

dat[dat$Parks == 40,]
summary(dat$Parks)

# Scatterplot Matrices from the glus Package 
library(gclus)
dat.r <- abs(cor(dat)) # get correlations
dta.col <- dmat.color(dat.r) # get colors
# reorder variables so those with highest correlation
# are closest to the diagonal
dat.o <- order.single(dat.r) 
cpairs(dat, dat.o, panel.colors=dat.col, gap=.5,
       main="Variables Ordered and Colored by Correlation" )
