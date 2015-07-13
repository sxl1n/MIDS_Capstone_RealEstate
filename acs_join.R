setwd("C:\\Users\\jheckman\\OneDrive\\Documents\\School\\W210 Capstone\\Project\\acs_2013_5yr_est")

filenames <- list.files(path=getwd())
filenames <- filenames[grepl("*_ann.csv$", filenames)]

datalist = lapply(filenames, function(x) { read.csv(file=x, header=T, skip=1) })
mergeddata = Reduce(function(x,y) { merge(x, y, by = "Id2", all=T) }, datalist)

#-- Filter to bay area zip codes
bayzips <- read.csv("zip_code_database_bay_area.csv")
bay_merged <- merge(bayzips[c("zip")], mergeddata, by.x = "zip", by.y = "Id2", all.x = T)

#-- Remove all total margin of error columns
is_total_margin <- grepl("Margin.of.Error", names(bay_merged))
bay_merged_no_moe <- bay_merged[!is_total_margin]

write.csv(bay_merged_no_moe, file = "..\\Data\\bay_acs_2013_5yr_est_joined.csv")
