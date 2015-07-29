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

## Regression Weighted Scores

Call:
lm(formula = Avg_Median_Home_Price ~ avg_temperature + female_labor + 
    pop_growth_rate + Poverty_Rate + unemployment_rate + renter_occupied + 
    Construction + Educational_Services + Health_Care_and_Social_Assistance + 
    Information + Management_of_Companies_and_Enterprises + income, 
    data = high_level, na.action = na.omit)

Residuals:
   Min     1Q Median     3Q    Max 
-72872 -17962   5989  24749  74234 

Coefficients:
                                          Estimate Std. Error t value Pr(>|t|)    
(Intercept)                              1.413e+06  7.630e+05   1.852 0.082638 .  
avg_temperature                         -4.730e+04  1.311e+04  -3.608 0.002360 ** 
female_labor                             1.365e+06  5.516e+05   2.475 0.024901 *  
pop_growth_rate                          1.452e+05  5.915e+04   2.455 0.025895 *  
Poverty_Rate                             2.240e+04  7.821e+03   2.864 0.011243 *  
unemployment_rate                       -2.810e+04  7.395e+03  -3.800 0.001574 ** 
renter_occupied                          8.769e+05  2.601e+05   3.372 0.003882 ** 
Construction                            -1.352e+03  2.963e+02  -4.562 0.000320 ***
Educational_Services                    -8.443e+03  2.040e+03  -4.140 0.000770 ***
Health_Care_and_Social_Assistance        9.464e+02  2.934e+02   3.225 0.005287 ** 
Information                              6.710e+03  1.153e+03   5.818 2.62e-05 ***
Management_of_Companies_and_Enterprises -6.616e+03  1.597e+03  -4.142 0.000766 ***
income                                   1.018e+01  7.688e-01  13.243 4.87e-10 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 51700 on 16 degrees of freedom
  (491 observations deleted due to missingness)
Multiple R-squared:  0.9852,	Adjusted R-squared:  0.9742 
F-statistic: 89.01 on 12 and 16 DF,  p-value: 2.711e-12

attach(high_level)
subset = data.frame(avg_temperature, female_labor, pop_growth_rate, renter_occupied, Construction, Educational_Services,  Health_Care_and_Social_Assistance, Information, Management_of_Companies_and_Enterprises)

reg_weighted_raw = (-47300)*avg_temperature/max(avg_temperature, na.rm=TRUE) + (1365000)*female_labor/max(female_labor, na.rm=TRUE) + (145200)*pop_growth_rate/max(pop_growth_rate, na.rm=TRUE) + (876900)*renter_occupied/max(renter_occupied, na.rm=TRUE) + (-1352)*Construction/max(Construction, na.rm=TRUE) + (-8443)*Educational_Services/max(Educational_Services, na.rm=TRUE) + (946.4)*Health_Care_and_Social_Assistance/max(Health_Care_and_Social_Assistance, na.rm=TRUE) + (6710)*Information/max(Information, na.rm=TRUE) + (-6616)*Management_of_Companies_and_Enterprises/max(Management_of_Companies_and_Enterprises, na.rm=TRUE)

rdist = max(reg_weighted_raw, na.rm=TRUE) - min(reg_weighted_raw, na.rm=TRUE)
reg_weighted = (reg_weighted_raw - min(reg_weighted_raw, na.rm=TRUE)) / rdist * 100

scores = cbind(zip[complete_records==TRUE], as.integer(reg_weighted[complete_records==TRUE]))
scores

        [,1] [,2]
  [1,] 94010   68
  [2,] 94018   63
  [3,] 94019   59
  [4,] 94020   60
  [5,] 94021   40
  [6,] 94022   43
  [7,] 94027   30
  [8,] 94030   58
  [9,] 94037   61
 [10,] 94038   60
 [11,] 94041   75
 [12,] 94043   75
 [13,] 94044   63
 [14,] 94061   69
 [15,] 94063   69
 [16,] 94066   67
 [17,] 94070   61
 [18,] 94074    0
 [19,] 94085   69
 [20,] 94086   69
 [21,] 94102   74
 [22,] 94103   74
 [23,] 94107   74
 [24,] 94114   75
 [25,] 94116   75
 [26,] 94117   75
 [27,] 94122   74
 [28,] 94124   74
 [29,] 94127   75
 [30,] 94128   75
 [31,] 94132   75
 [32,] 94158   74
 [33,] 94301   60
 [34,] 94304   60
 [35,] 94305   68
 [36,] 94306   60
 [37,] 94401   68
 [38,] 94501   70
 [39,] 94502   71
 [40,] 94505   56
 [41,] 94506   48
 [42,] 94508   73
 [43,] 94509   58
 [44,] 94513   55
 [45,] 94514   56
 [46,] 94515   52
 [47,] 94517   50
 [48,] 94518   63
 [49,] 94519   63
 [50,] 94520   63
 [51,] 94523   62
 [52,] 94526   48
 [53,] 94527   64
 [54,] 94528   40
 [55,] 94531   58
 [56,] 94536   60
 [57,] 94538   59
 [58,] 94541   66
 [59,] 94544   66
 [60,] 94545   66
 [61,] 94548   47
 [62,] 94550   60
 [63,] 94551   60
 [64,] 94555   60
 [65,] 94558   64
 [66,] 94559   64
 [67,] 94560   60
 [68,] 94561   56
 [69,] 94562  100
 [70,] 94566   59
 [71,] 94567    0
 [72,] 94569   73
 [73,] 94573   78
 [74,] 94574   60
 [75,] 94576   68
 [76,] 94577   66
 [77,] 94579   66
 [78,] 94580   59
 [79,] 94581   64
 [80,] 94587   58
 [81,] 94588   58
 [82,] 94599   42
 [83,] 94603   70
 [84,] 94607   69
 [85,] 94612   69
 [86,] 94614   70
 [87,] 94617   70
 [88,] 94621   70
 [89,] 94662   77
 [90,] 94703   67
 [91,] 94704   67
 [92,] 94708   67
 [93,] 94709   67
 [94,] 94720   67
 [95,] 94804   66
 [96,] 94805   66
 [97,] 94901   68
 [98,] 94922   76
 [99,] 94923   37
[100,] 94929    1
[101,] 94931   70
[102,] 94939   68
[103,] 94951   73
[104,] 94954   62
[105,] 94957   37
[106,] 94960   62
[107,] 95001   55
[108,] 95005   61
[109,] 95007   67
[110,] 95008   71
[111,] 95010   69
[112,] 95018   61
[113,] 95019   64
[114,] 95020   63
[115,] 95021   63
[116,] 95023   64
[117,] 95024   64
[118,] 95030   55
[119,] 95032   55
[120,] 95033   55
[121,] 95037   60
[122,] 95038   60
[123,] 95041   75
[124,] 95045   68
[125,] 95046   56
[126,] 95050   69
[127,] 95052   69
[128,] 95053   69
[129,] 95062   67
[130,] 95063   67
[131,] 95065   67
[132,] 95066   57
[133,] 95073   59
[134,] 95075   55
[135,] 95077   69
[136,] 95110   64
[137,] 95112   64
[138,] 95121   64
[139,] 95124   64
[140,] 95135   64
[141,] 95138   64
[142,] 95148   64
[143,] 95154   64
[144,] 95206   62
[145,] 95207   62
[146,] 95213   62
[147,] 95215   62
[148,] 95231   54
[149,] 95240   59
[150,] 95241   59
[151,] 95242   59
[152,] 95253   71
[153,] 95258   61
[154,] 95267   62
[155,] 95269   62
[156,] 95297   62
[157,] 95304   62
[158,] 95336   65
[159,] 95376   62
[160,] 95378   62
[161,] 95401   65
[162,] 95402   65
[163,] 95403   65
[164,] 95404   65
[165,] 95405   65
[166,] 95406   65
[167,] 95419    0
[168,] 95421   59
[169,] 95430    0
[170,] 95431   43
[171,] 95433   67
[172,] 95436   64
[173,] 95439   76
[174,] 95441   52
[175,] 95444   74
[176,] 95448   62
[177,] 95450   60
[178,] 95465   45
[179,] 95471    0
[180,] 95472   70
[181,] 95473   70
[182,] 95486    0
[183,] 95487    0
[184,] 95492   59
