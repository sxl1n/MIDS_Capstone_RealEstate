data = read.csv('2013census.csv', header=TRUE)
attach(data)

##All Data
correlations = rep(NA, 11120)

for (i in 7:11120){
	if(is.numeric(data[[i]])==TRUE){
		correlations[i-6] = cor(data[6], data[i])
		}
}

write.table(correlations, "2013census_correlations.csv", sep=",")

##Bay Area Only
correlations_ba = rep(NA, 11120)

for (i in 7:11120){
	if(is.numeric(data[[i]])==TRUE){
		correlations_ba[i-6] = cor(data[6][data[2]=='Yes'], data[i][data[2]=='Yes'])
		}
}

write.table(correlations_ba, "2013census_correlations_bayarea.csv", sep=",")
