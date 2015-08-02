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

## Using plain coefficients
reg_weighted_raw = (-47300)*avg_temperature/max(avg_temperature, na.rm=TRUE) + (1365000)*female_labor/max(female_labor, na.rm=TRUE) + (145200)*pop_growth_rate/max(pop_growth_rate, na.rm=TRUE) + (876900)*renter_occupied/max(renter_occupied, na.rm=TRUE) + (-1352)*Construction/max(Construction, na.rm=TRUE) + (-8443)*Educational_Services/max(Educational_Services, na.rm=TRUE) + (946.4)*Health_Care_and_Social_Assistance/max(Health_Care_and_Social_Assistance, na.rm=TRUE) + (6710)*Information/max(Information, na.rm=TRUE) + (-6616)*Management_of_Companies_and_Enterprises/max(Management_of_Companies_and_Enterprises, na.rm=TRUE)

## Using T-values
reg_weighted_raw = (-3.608)*avg_temperature/max(avg_temperature, na.rm=TRUE) + (2.475)*female_labor/max(female_labor, na.rm=TRUE) + (2.455)*pop_growth_rate/max(pop_growth_rate, na.rm=TRUE) + (3.372)*renter_occupied/max(renter_occupied, na.rm=TRUE) + (-4.562)*Construction/max(Construction, na.rm=TRUE) + (-4.14)*Educational_Services/max(Educational_Services, na.rm=TRUE) + (3.225)*Health_Care_and_Social_Assistance/max(Health_Care_and_Social_Assistance, na.rm=TRUE) + (5.818)*Information/max(Information, na.rm=TRUE) + (-4.142)*Management_of_Companies_and_Enterprises/max(Management_of_Companies_and_Enterprises, na.rm=TRUE)

rdist = max(reg_weighted_raw, na.rm=TRUE) - min(reg_weighted_raw, na.rm=TRUE)
reg_weighted = (reg_weighted_raw - min(reg_weighted_raw, na.rm=TRUE)) / rdist * 100

scores = cbind(zip[complete_records==TRUE], as.integer(reg_weighted[complete_records==TRUE]))
scores

        [,1]       [,2]
  [1,] 94010  52.077622
  [2,] 94018  70.356039
  [3,] 94019  54.906536
  [4,] 94020  66.380438
  [5,] 94021  57.415892
  [6,] 94022  33.080812
  [7,] 94027  37.137656
  [8,] 94030  52.654520
  [9,] 94037  65.065164
 [10,] 94038  71.112448
 [11,] 94041  97.956891
 [12,] 94043  99.659594
 [13,] 94044  33.584712
 [14,] 94061  62.410628
 [15,] 94063  42.406752
 [16,] 94066  24.412610
 [17,] 94070   1.162323
 [18,] 94074  29.216250
 [19,] 94085  74.911594
 [20,] 94086  75.585428
 [21,] 94102  71.515573
 [22,] 94103  91.550667
 [23,] 94107  98.719929
 [24,] 94114  91.618068
 [25,] 94116  42.486603
 [26,] 94117  84.870671
 [27,] 94122  41.737090
 [28,] 94124  13.058586
 [29,] 94127  80.510389
 [30,] 94128  80.147008
 [31,] 94132  90.530783
 [32,] 94158  85.985162
 [33,] 94301  71.403765
 [34,] 94304  82.220650
 [35,] 94305  82.293911
 [36,] 94306  78.392740
 [37,] 94401  88.387899
 [38,] 94501  41.664361
 [39,] 94502  69.478950
 [40,] 94505  50.697300
 [41,] 94506  47.695873
 [42,] 94508  77.308367
 [43,] 94509  53.982830
 [44,] 94513  25.839220
 [45,] 94514  60.805664
 [46,] 94515  60.307263
 [47,] 94517  48.979296
 [48,] 94518  39.040156
 [49,] 94519  72.768129
 [50,] 94520  21.122564
 [51,] 94523  23.878078
 [52,] 94526  19.807053
 [53,] 94527  73.874525
 [54,] 94528  49.635059
 [55,] 94531  56.233781
 [56,] 94536  54.490005
 [57,] 94538  37.840641
 [58,] 94541  61.060580
 [59,] 94544  45.204053
 [60,] 94545  10.920509
 [61,] 94548  60.047388
 [62,] 94550  11.229365
 [63,] 94551   6.357904
 [64,] 94555  59.948251
 [65,] 94558  17.461913
 [66,] 94559  36.325221
 [67,] 94560  28.097976
 [68,] 94561  39.068345
 [69,] 94562 100.000000
 [70,] 94566  23.693465
 [71,] 94567  22.778778
 [72,] 94569  84.838541
 [73,] 94573  87.427472
 [74,] 94574  56.009866
 [75,] 94576  75.624925
 [76,] 94577  25.377635
 [77,] 94579  69.690190
 [78,] 94580  61.155999
 [79,] 94581  73.034342
 [80,] 94587  53.804833
 [81,] 94588  20.114792
 [82,] 94599  60.836024
 [83,] 94603  76.289616
 [84,] 94607  45.590401
 [85,] 94612  46.462367
 [86,] 94614  85.083879
 [87,] 94617  83.358653
 [88,] 94621  49.342641
 [89,] 94662  88.747649
 [90,] 94703  72.077224
 [91,] 94704  69.818005
 [92,] 94708  74.799320
 [93,] 94709  64.181362
 [94,] 94720  82.643739
 [95,] 94804  52.322218
 [96,] 94805  72.214618
 [97,] 94901   3.608377
 [98,] 94922  88.348384
 [99,] 94923  52.029220
[100,] 94929  31.501498
[101,] 94931  64.400290
[102,] 94939  75.095154
[103,] 94951  69.982940
[104,] 94954  28.742856
[105,] 94957  50.165887
[106,] 94960  40.957057
[107,] 95001  67.877986
[108,] 95005  67.150168
[109,] 95007  72.370778
[110,] 95008   8.384825
[111,] 95010  75.781227
[112,] 95018  68.835228
[113,] 95019  75.815664
[114,] 95020  47.319104
[115,] 95021  72.352606
[116,] 95023  47.599371
[117,] 95024  74.713863
[118,] 95030  61.214522
[119,] 95032  87.123160
[120,] 95033  53.197640
[121,] 95037  17.045106
[122,] 95038  67.207732
[123,] 95041  81.227538
[124,] 95045  83.424446
[125,] 95046  51.686146
[126,] 95050  49.281530
[127,] 95052  79.695864
[128,] 95053  79.277517
[129,] 95062  53.981288
[130,] 95063  80.331623
[131,] 95065  78.361376
[132,] 95066  53.030843
[133,] 95073  50.727698
[134,] 95075  70.437135
[135,] 95077  84.342128
[136,] 95110  56.498478
[137,] 95112   0.000000
[138,] 95121  86.422553
[139,] 95124  63.516252
[140,] 95135  76.474185
[141,] 95138  75.982789
[142,] 95148  71.755246
[143,] 95154  75.574051
[144,] 95206  69.980033
[145,] 95207  80.461277
[146,] 95213  74.212603
[147,] 95215  60.643024
[148,] 95231  65.570617
[149,] 95240  45.442912
[150,] 95241  70.815141
[151,] 95242  60.093586
[152,] 95253  78.157026
[153,] 95258  66.762099
[154,] 95267  73.822825
[155,] 95269  73.630667
[156,] 95297  73.630667
[157,] 95304  53.330074
[158,] 95336  60.155876
[159,] 95376  56.414509
[160,] 95378  69.262740
[161,] 95401  54.985629
[162,] 95402  75.840398
[163,] 95403   6.122875
[164,] 95404  44.055110
[165,] 95405  93.666316
[166,] 95406  77.010088
[167,] 95419  26.771270
[168,] 95421  66.411877
[169,] 95430  27.956494
[170,] 95431  64.273313
[171,] 95433  81.282778
[172,] 95436  69.775185
[173,] 95439  80.882403
[174,] 95441  61.356185
[175,] 95444  80.765625
[176,] 95448  53.895420
[177,] 95450  72.984955
[178,] 95465  57.788589
[179,] 95471  29.701904
[180,] 95472  27.374065
[181,] 95473  83.027047
[182,] 95486  29.701904
[183,] 95487  25.285184
[184,] 95492  31.477228
