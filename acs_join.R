setwd("C:\\Users\\jheckman\\OneDrive\\Documents\\School\\W210 Capstone\\Project\\acs_2013_5yr_est")

filenames <- list.files(path=getwd())
filenames <- filenames[grepl("*_ann.csv$", filenames)]

datalist = lapply(filenames, function(x) { read.csv(file=x, header=T, skip=1) })
mergeddata = Reduce(function(x,y) { merge(x, y, by = "Id2", all=T) }, datalist)

write.csv(mergeddata, file = "acs_2013_5yr_est_joined.csv")
