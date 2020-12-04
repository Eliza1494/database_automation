library(tidyverse)
library(data.table)


f1_2018 <- fread("f_5500_2018_latest.csv")
f1_2017 <- fread("f_5500_2017_latest.csv")
f1_2016 <- fread("f_5500_2016_latest.csv")
f1_2015 <- fread("f_5500_2015_latest.csv")
f1_2014 <- fread("f_5500_2014_latest.csv")

filt_2018 <- f1_2018[,c(2,16, 17, 18, 19,24:26,44,46, 125, 72)]
filt_2017 <- f1_2017[,c(2,16, 17, 18, 19,24:26,44, 46, 125, 72)]
filt_2016 <- f1_2016[,c(2,16, 17, 18, 19,24:26,44,46, 125, 72)]
filt_2015 <- f1_2015[,c(2,16, 17, 18, 19,24:26,44,46, 125, 72)]
filt_2014 <- f1_2014[,c(2,16, 17, 18, 19,24:26,44,46, 125, 72)]

setDT(filt_2018)
setDT(filt_2017)
setDT(filt_2016)
setDT(filt_2015)
setDT(filt_2014)

names(filt_2018)=c("Begin Date", "PlanName", "PlanTypeNumber", "PlanEffectiveDate", 
                   "CompanyName","US_City","US_State","US_ZIP", "CompanyEIN",
                   "Business_Code", "BOY_Active", "Total_Active(EOY)")

names(filt_2017)=c("Begin Date", "PlanName", "PlanTypeNumber", "PlanEffectiveDate", 
                   "CompanyName","US_City","US_State","US_ZIP", "CompanyEIN",
                   "Business_Code", "BOY_Active", "Total_Active(EOY)")

names(filt_2016)=c("Begin Date", "PlanName", "PlanTypeNumber", "PlanEffectiveDate", 
                   "CompanyName","US_City","US_State","US_ZIP", "CompanyEIN",
                   "Business_Code", "BOY_Active", "Total_Active(EOY)")

names(filt_2015)=c("Begin Date", "PlanName", "PlanTypeNumber", "PlanEffectiveDate", 
                   "CompanyName","US_City","US_State","US_ZIP", "CompanyEIN",
                   "Business_Code", "BOY_Active", "Total_Active(EOY)")

names(filt_2014)=c("Begin Date", "PlanName", "PlanTypeNumber", "PlanEffectiveDate", 
                   "CompanyName","US_City","US_State","US_ZIP", "CompanyEIN",
                   "Business_Code", "BOY_Active", "Total_Active(EOY)")

#remove puntuation and extra space from company names 
filt_2018$CompanyName <- str_replace_all(filt_2018$CompanyName, "[[:punct:]]", "")
filt_2018$CompanyName <- str_squish(filt_2018$CompanyName)

filt_2017$CompanyName <- str_replace_all(filt_2017$CompanyName, "[[:punct:]]", "")
filt_2017$CompanyName <- str_squish(filt_2017$CompanyName)

filt_2016$CompanyName <- str_replace_all(filt_2016$CompanyName, "[[:punct:]]", "")
filt_2016$CompanyName <- str_squish(filt_2016$CompanyName)

filt_2015$CompanyName <- str_replace_all(filt_2015$CompanyName, "[[:punct:]]", "")
filt_2015$CompanyName <- str_squish(filt_2015$CompanyName)

filt_2014$CompanyName <- str_replace_all(filt_2014$CompanyName, "[[:punct:]]", "")
filt_2014$CompanyName <- str_squish(filt_2014$CompanyName)

#Create ID2 to join all the tables by combining EIN and plan type number so to differentiate betweeen both company and plan type
filt_2018$ID2 <- paste0(filt_2018$CompanyEIN, filt_2018$PlanTypeNumber, sep = "")
filt_2017$ID2 <- paste0(filt_2017$CompanyEIN, filt_2017$PlanTypeNumber, sep = "") 
filt_2016$ID2 <- paste0(filt_2016$CompanyEIN, filt_2016$PlanTypeNumber, sep = "") 
filt_2015$ID2 <- paste0(filt_2015$CompanyEIN, filt_2015$PlanTypeNumber, sep = "") 
filt_2014$ID2 <- paste0(filt_2014$CompanyEIN, filt_2014$PlanTypeNumber, sep = "") 

#make Id2 as numeric 
filt_2018$ID2 <- as.numeric(filt_2018$ID2)
filt_2017$ID2 <- as.numeric(filt_2017$ID2)
filt_2016$ID2 <- as.numeric(filt_2016$ID2)
filt_2015$ID2 <- as.numeric(filt_2015$ID2)
filt_2014$ID2 <- as.numeric(filt_2014$ID2)

filt_2017_M <- filt_2017[,c(2,5, 11,12,13)]
filt_2016_M <- filt_2016[,c(2,5, 11,12, 13)]
filt_2015_M <- filt_2015[,c(2,5, 11,12, 13)]
filt_2014_M <- filt_2014[,c(2,5, 11,12, 13)]

names(filt_2017_M)
names(filt_2017_M)[c(1:4)] <- c("PlName_2017", "CompName_2017", 
                                "BOY_Act_2017", "TotAct(EOY)_2017")
names(filt_2016_M)[c(1:4)] <- c("PlName_2016", "CompName_2016", 
                                "BOY_Act_2016", "TotAct(EOY)_2016")
names(filt_2015_M)[c(1:4)] <- c("PlName_2015", "CompName_2015", 
                                "BOY_Act_2015", "TotAct(EOY)_2015")
names(filt_2014_M)[c(1:4)] <- c("PlName_2014", "CompName_2014", 
                                "BOY_Act_2014", "TotAct(EOY)_2014")

Merge17_18 <- merge(filt_2018, filt_2017_M, by = "ID2", all = TRUE)
Merge17_18NoNa <- na.omit(Merge17_18) #companies plans that can be found in both years

Merge16_15 <- merge(filt_2016_M, filt_2015_M, by = "ID2", all = TRUE)
Merge16_15NoNa <- na.omit(Merge16_15)

Merge15to18 <- merge(Merge17_18, Merge16_15, by = "ID2", all = TRUE)
Merge15to18_NoNa <- na.omit(Merge15to18)

Merged14to18 <- merge(Merge15to18, filt_2014_M, by = "ID2", all = TRUE)
Merged14to18_NoNa <- na.omit(Merged14to18)

#remove rows that have NA participants in all years like 10000001
Merged14to18 <- Merged14to18[!(is.na(BOY_Active) & is.na(Merged14to18$`Total_Active(EOY)`) &
                               is.na(BOY_Act_2017) & is.na(Merged14to18$`TotAct(EOY)_2017`) &
                              is.na(BOY_Act_2016) & is.na(Merged14to18$`TotAct(EOY)_2016`) & 
                                is.na(BOY_Act_2015) & is.na(Merged14to18$`TotAct(EOY)_2015`) &
                                is.na(BOY_Act_2014) & is.na(Merged14to18$`TotAct(EOY)_2014`)),]

names(Merged14to18)[c(2,3,4, 12,13)] <- c("BeginDate_2018", "PlanName_2018",
                                             "PlanTypeNumb_2018", "BOY_Act_2018", 
                                           "TotAct(EOY)_2018")

#Reorder the position of the columns
names(Merged14to18) #29 original variables; keep 29 just reorder the position 
Merged14to18 <- Merged14to18[,c(1:13, 16,17,20,21,24,25,28,29, 14,15, 18,19,22,23,26,27)]

#Delete Companies that do not appear in 2018 and 2017 
Merged14to18_Comp18and17 <- Merged14to18[!(is.na(`BOY_Act_2018`) & is.na(Merged14to18$`TotAct(EOY)_2018`) &
                                 is.na(BOY_Act_2017) & is.na(Merged14to18$`TotAct(EOY)_2017`)),]

fwrite(Merged14to18_Comp18and17, "Merged14to18_Comp18and17.csv")

#Check how the dataset created with different IDs differ 



#######################SF Data#################

f1SF_2018 <- fread("f_5500_sf_2018_latest.csv")
f1SF_2017 <- fread("f_5500_sf_2017_latest.csv")
f1SF_2016 <- fread("f_5500_sf_2016_latest.csv")
f1SF_2015 <- fread("f_5500_sf_2015_latest.csv")
f1SF_2014 <- fread("f_5500_sf_2014_latest.csv")

filtSF_2018 <- f1SF_2018[,c(2,14, 15, 16, 17, 21:23, 30, 32, 145, 146)]
filtSF_2017 <- f1SF_2017[,c(2,14, 15, 16, 17, 21:23, 30, 32, 145, 146)]
filtSF_2016 <- f1SF_2016[,c(2,14, 15, 16, 17, 21:23, 30, 32, 145, 146)]
filtSF_2015 <- f1SF_2015[,c(2,14, 15, 16, 17, 21:23, 30, 32, 145, 146)]
filtSF_2014 <- f1SF_2014[,c(2,14, 15, 16, 17, 21:23, 30, 32, 145, 146)]

setDT(filtSF_2018)
setDT(filtSF_2017)
setDT(filtSF_2016)
setDT(filtSF_2015)
setDT(filtSF_2014)

names(filtSF_2018)=c("Begin Date", "PlanName", "PlanTypeNumber", "PlanEffectiveDate", 
                   "CompanyName","US_City","US_State","US_ZIP", "CompanyEIN",
                   "Business_Code", "BOY_Active", "Total_Active(EOY)")

names(filtSF_2017)=c("Begin Date", "PlanName", "PlanTypeNumber", "PlanEffectiveDate", 
                   "CompanyName","US_City","US_State","US_ZIP", "CompanyEIN",
                   "Business_Code", "BOY_Active", "Total_Active(EOY)")

names(filtSF_2016)=c("Begin Date", "PlanName", "PlanTypeNumber", "PlanEffectiveDate", 
                   "CompanyName","US_City","US_State","US_ZIP", "CompanyEIN",
                   "Business_Code", "BOY_Active", "Total_Active(EOY)")

names(filtSF_2015)=c("Begin Date", "PlanName", "PlanTypeNumber", "PlanEffectiveDate", 
                   "CompanyName","US_City","US_State","US_ZIP", "CompanyEIN",
                   "Business_Code", "BOY_Active", "Total_Active(EOY)")

names(filtSF_2014)=c("Begin Date", "PlanName", "PlanTypeNumber", "PlanEffectiveDate", 
                   "CompanyName","US_City","US_State","US_ZIP", "CompanyEIN",
                   "Business_Code", "BOY_Active", "Total_Active(EOY)")

filtSF_2018 <- filtSF_2018[!(is.na(filtSF_2018$BOY_Active) & is.na(filtSF_2018$`Total_Active(EOY)`)),]
filtSF_2017 <- filtSF_2017[!(is.na(BOY_Active) & is.na(`Total_Active(EOY)`)),]
filtSF_2016 <- filtSF_2016[!(is.na(BOY_Active) & is.na(`Total_Active(EOY)`)),]
filtSF_2015 <- filtSF_2015[!(is.na(BOY_Active) & is.na(`Total_Active(EOY)`)),]
filtSF_2014 <- filtSF_2014[!(is.na(BOY_Active) & is.na(`Total_Active(EOY)`)),]

filtSF_2018$CompanyName <- str_replace_all(filtSF_2018$CompanyName, "[[:punct:]]", "")
filtSF_2018$CompanyName <- str_squish(filtSF_2018$CompanyName)

filtSF_2017$CompanyName <- str_replace_all(filtSF_2017$CompanyName, "[[:punct:]]", "")
filtSF_2017$CompanyName <- str_squish(filtSF_2017$CompanyName)

filtSF_2016$CompanyName <- str_replace_all(filtSF_2016$CompanyName, "[[:punct:]]", "")
filtSF_2016$CompanyName <- str_squish(filtSF_2016$CompanyName)

filtSF_2015$CompanyName <- str_replace_all(filtSF_2015$CompanyName, "[[:punct:]]", "")
filtSF_2015$CompanyName <- str_squish(filtSF_2015$CompanyName)

filtSF_2014$CompanyName <- str_replace_all(filtSF_2014$CompanyName, "[[:punct:]]", "")
filtSF_2014$CompanyName <- str_squish(filtSF_2014$CompanyName)

#Create ID2 to join all the tables 

filtSF_2018$ID2 <- paste0(filtSF_2018$CompanyEIN, filtSF_2018$PlanTypeNumber, sep = "") 
filtSF_2017$ID2 <- paste0(filtSF_2017$CompanyEIN, filtSF_2017$PlanTypeNumber, sep = "")
filtSF_2016$ID2 <- paste0(filtSF_2016$CompanyEIN, filtSF_2016$PlanTypeNumber, sep = "") 
filtSF_2015$ID2 <- paste0(filtSF_2015$CompanyEIN, filtSF_2015$PlanTypeNumber, sep = "") 
filtSF_2014$ID2 <- paste0(filtSF_2014$CompanyEIN, filtSF_2014$PlanTypeNumber, sep = "") 

#choose only specific columns for all years except 2018
filtSF_2017_M <- filtSF_2017[,c(2,5,10,11,12,13)]
filtSF_2016_M <- filtSF_2016[,c(2,5,11,12,13)]
filtSF_2015_M <- filtSF_2015[,c(2,5,11,12,13)]
filtSF_2014_M <- filtSF_2014[,c(2,5,11,12,13)]

names(filtSF_2017_M)
names(filtSF_2017_M)[c(1:5)] <- c("PlName_2017", "CompName_2017", "BusinessCode2017",
                                "BOY_Act_2017", "TotAct(EOY)_2017")
names(filtSF_2016_M)[c(1:4)] <- c("PlName_2016", "CompName_2016", 
                                "BOY_Act_2016", "TotAct(EOY)_2016")
names(filtSF_2015_M)[c(1:4)] <- c("PlName_2015", "CompName_2015", 
                                "BOY_Act_2015", "TotAct(EOY)_2015")
names(filtSF_2014_M)[c(1:4)] <- c("PlName_2014", "CompName_2014", 
                                "BOY_Act_2014", "TotAct(EOY)_2014")

Merge17SF_18 <- merge(filtSF_2018, filtSF_2017_M, by = "ID2", all = TRUE)
Merge17SF_18NoNa <- na.omit(Merge17SF_18)

Merge16SF_15 <- merge(filtSF_2016_M, filtSF_2015_M, by = "ID2", all = TRUE)
Merge16SF_15NoNa <- na.omit(Merge16SF_15)

Merge15to18SF <- merge(Merge17SF_18, Merge16SF_15, by = "ID2", all = TRUE)
Merge15to18SF_NoNa <- na.omit(Merge15to18SF)

Merged14to18SF <- merge(Merge15to18SF, filtSF_2014_M, by = "ID2", all = TRUE)
Merged14to18SF_NoNa <- na.omit(Merged14to18SF)

#remove rows that have NA all years like 10000001
Merged14to18SF <- Merged14to18SF[!(is.na(BOY_Active) & is.na(Merged14to18SF$`Total_Active(EOY)`) &
                                 is.na(BOY_Act_2017) & is.na(Merged14to18SF$`TotAct(EOY)_2017`) &
                                 is.na(BOY_Act_2016) & is.na(Merged14to18SF$`TotAct(EOY)_2016`) & 
                                 is.na(BOY_Act_2015) & is.na(Merged14to18SF$`TotAct(EOY)_2015`) &
                                 is.na(BOY_Act_2014) & is.na(Merged14to18SF$`TotAct(EOY)_2014`)),]

names(Merged14to18SF)[c(2,3,4, 12,13)] <- c("BeginDate_2018", "PlanName_2018",
                                          "PlanTypeNumb_2018", "BOY_Act_2018", 
                                          "TotAct(EOY)_2018")

#Reorder the position of the columns
names(Merged14to18SF) #29 original variables; keep 29 just reorder the position 
Merged14to18SF <- Merged14to18SF[,c(1:13, 17, 18, 21,22,25,26,29,30,14:16,19,20,23,24,27,28)]

#Delete Companies that do not appear in 2018 and 2017 

Merged14to18SF_Comp18and17 <- Merged14to18SF[!(is.na(`BOY_Act_2018`) & is.na(Merged14to18SF$`TotAct(EOY)_2018`) &
                                             is.na(BOY_Act_2017) & is.na(Merged14to18SF$`TotAct(EOY)_2017`)),]

#find which businesses are missing business codes: the ones that are in 2017 but not in 2018 because the business code column is from 2018
NoBC <- Merged14to18SF_Comp18and17[which(is.na(Merged14to18SF_Comp18and17$Business_Code)),]

#239 Companies are missing Business codes from both 2017 and 2018
NoBC_2017 <- NoBC[which(is.na(NoBC$BusinessCode2017)),]

Merged14to18SF_Comp18and17$Business_Code <- ifelse(is.na(Merged14to18SF_Comp18and17$Business_Code), 
                                                        Merged14to18SF_Comp18and17$BusinessCode2017, 
                                                        Merged14to18SF_Comp18and17$Business_Code)

sum(is.na(Merged14to18SF_Comp18and17$Business_Code)) #239 missing business codes

#ifelse(test,yes,no)

fwrite(Merged14to18SF_Comp18and17, "Merged14to18SF_Comp18and17.csv")




