library(tidyverse)
library(data.table)

#Checking what is the best way to merge 2018 and 2017
#read datasets

f1_2018 <- fread("f_5500_2018_latest.csv")
f1_2017 <- fread("f_5500_2017_latest.csv")


filt_2018 <- f1_2018[,c(2,16, 17, 18, 19,24:26,44,46, 125, 72)]
filt_2017 <- f1_2017[,c(2,16, 17, 18, 19,24:26,44, 46, 125, 72)]

setDT(filt_2018)
setDT(filt_2017)

####Checking if rows are unique: should be unique########
#unique18 <- unique(filt_2018)
#dupl2018 <- filt_2018[duplicated(filt_2018)]

#unique17 <- unique(filt_2017)

names(filt_2018)=c("Begin Date", "PlanName", "PlanTypeNumber", "PlanEffectiveDate", 
                   "CompanyName","US_City","US_State","US_ZIP", "CompanyEIN",
                   "Business_Code", "BOY_Active", "Total_Active(EOY)")

names(filt_2017)=c("Begin Date", "PlanName", "PlanTypeNumber", "PlanEffectiveDate", 
                   "CompanyName","US_City","US_State","US_ZIP", "CompanyEIN",
                   "Business_Code", "BOY_Active", "Total_Active(EOY)")


#####Checking######## 
ordered <- filt_2018[order(-filt_2018$PlanName),]
ordered$BegDateInt <- as.numeric(as.factor(ordered$FORM_PLAN_YEAR_BEGIN_DATE))
ordered$EffectDateInt <- as.numeric(as.factor(ordered$PLAN_EFF_DATE))

#f1_2018_Benefits <- f1_2018[!(f1_2018$TYPE_WELFARE_BNFT_CODE == "" & f1_2018$TYPE_PENSION_BNFT_CODE == ""),]
#f1_2018_Benefits <- unique(f1_2018_Benefits)

###########Join fil_2018 and filt_2017#################

#Remove puntuation and extra space from Company Names
filt_2018$CompanyName <- str_replace_all(filt_2018$CompanyName, "[[:punct:]]", "")
filt_2018$CompanyName <- str_squish(filt_2018$CompanyName)


##for 2017
#f1_2017_Benefits <- f1_2017[!(f1_2017$TYPE_WELFARE_BNFT_CODE == "" & f1_2017$TYPE_PENSION_BNFT_CODE == ""),]
#f1_2017_Benefits <- unique(f1_2017_Benefits)

#Remove Punctuation and extra space from Company Names 
filt_2017$CompanyName <- str_replace_all(filt_2017$CompanyName, "[[:punct:]]", "")
filt_2017$CompanyName <- str_squish(filt_2017$CompanyName)

CompEIN2018 <- filt_2018[,9]
CompEIN2018 <- unique(CompEIN2018)

CompEIN_Names2018 <- filt_2018[,c(5,9)]
CompEIN_Names2018 <- CompEIN_Names2018[order(-CompEIN_Names2018$CompanyName),]

CompNames2018 <- filt_2018[,5]
CompNames2018 <- unique(CompNames2018)

CompNames2017 <- filt_2017[,5]
CompNames2017 <- unique(CompNames2017)

CompEIN_Names2018_NoDupl <- CompEIN_Names2018 %>%
  distinct(CompEIN_Names2018$CompanyEIN, .keep_all = TRUE)
#EINUn <- CompEIN_Names2018_NoDupl[,2]
#EINUn <- setDT(as.data.frame(EINUn))
#EINUn <- EINUn[duplicated(EINUn)]

CompEIN_Names2018_NoDupl_Names <- CompEIN_Names2018_NoDupl[,1]
CompEIN_Names2018_NoDupl_Names <- setDT(as.data.frame(CompEIN_Names2018_NoDupl_Names))
#Check how many companies have the same name but different EIN: 4616
CompEIN_Names2018_NoDupl_Names <- CompEIN_Names2018_NoDupl_Names[duplicated(CompEIN_Names2018_NoDupl_Names)]

CompEIN2017 <- filt_2017[,9]
CompEIN2017 <- unique(CompEIN2017)

CompEIN_Names2017 <- filt_2017[,c(5,9)]
CompEIN_Names2017 <- unique(CompEIN_Names2017)

CompEIN_Names2017_NoDupl <- CompEIN_Names2017 %>%
  distinct(CompEIN_Names2017$CompanyEIN, .keep_all = TRUE)

CompEIN_CompNames2017_NoDupl <- CompEIN_Names2017 %>%
  distinct(CompEIN_Names2017$CompanyName, .keep_all = TRUE)

CompEIN_Names2017_NoDupl_Names <- CompEIN_Names2017_NoDupl[,1]
CompEIN_Names2017_NoDupl_Names <- setDT(as.data.frame(CompEIN_Names2017_NoDupl_Names))
#Check how many companies have the same name but different EIN: 4616
CompEIN_Names2017_NoDupl_Names <- CompEIN_Names2017_NoDupl_Names[duplicated(CompEIN_Names2017_NoDupl_Names)]


#put together the companies EINs in both 2018 and 2017 in one column 
EIN17_18 <- rbind(CompEIN2018, CompEIN2017)
#check which EINs are the same in both years and which are different 
EIN17_18Dupl <- EIN17_18[duplicated(EIN17_18)]
EIN17_18Diff <- EIN17_18[!duplicated(EIN17_18)]

#put together the companies EINs and Names in both 2018 and 2017 in one column 
EIN_Names17_18 <- rbind(CompEIN_Names2018, CompEIN_Names2017)
#check which EINs are the same in both years and which are different 
EIN_Names17_18Dupl <- EIN_Names17_18[duplicated(EIN_Names17_18)] #0.44
EIN_Names17_18Diff <- EIN_Names17_18[!duplicated(EIN_Names17_18)]

Names17_18 <- rbind(CompNames2018, CompNames2017)
Names17_18Dupl <- Names17_18[duplicated(Names17_18)]
Names17_18Diff <- Names17_18[!duplicated(Names17_18)] #0.43

#Create a unique Identifier for each of the company names 
#Names17_18$CompID <- cumsum(!duplicated(Names17_18$CompanyName))

#Use company EIN, Plan TYpe Number, Effective Date to join the tables 
#Create "ID" from effective date variable 
filt_2018$EffectDateNum <- as.numeric(as.factor(filt_2018$PlanEffectiveDate))
filt_2017$EffectDateNum <- as.numeric(as.factor(filt_2017$PlanEffectiveDate))

#Create a unique ID for each row
filt_2018$ID <- filt_2018$CompanyEIN + filt_2018$PlanTypeNumber + filt_2018$EffectDateNum
filt_2017$ID <- filt_2017$CompanyEIN + filt_2017$PlanTypeNumber + filt_2017$EffectDateNum

filt_2018$ID2 <- filt_2018$CompanyEIN + filt_2018$PlanTypeNumber
filt_2017$ID2 <- filt_2017$CompanyEIN + filt_2017$PlanTypeNumber

filt_2018_Check <- filt_2018
filt_2017_Check <- filt_2017

filt_2018_Check$ID2 <- paste0(filt_2018$CompanyEIN, filt_2018$PlanTypeNumber, sep = "")
filt_2017_Check$ID2 <- paste0(filt_2017$CompanyEIN, filt_2017$PlanTypeNumber, sep = "")

Joint18_17_3_Check <- merge(filt_2018_Check, filt_2017_Check, by = "ID2", all = TRUE)

#check for duplicates
ID_2018 <- filt_2018[,14]
ID_2017 <- filt_2017[,14]

ID_2018 <- ID_2018[duplicated(ID_2018)]
ID_2017 <- ID_2017[duplicated(ID_2017)]

ID2_2018 <- filt_2018[,15]
ID2_2017 <- filt_2017[,15]

ID2_2018 <- ID2_2018[duplicated(ID2_2018)]
ID2_2017 <- ID2_2017[duplicated(ID2_2017)]

#Joint18_17 <- full_join(f1_2018_Benefits_IDs, f1_2017_Benefits_IDs, by = "CompID")
names(filt_2018)
names(filt_2017)

Joint18_17_1 <- merge(filt_2018, filt_2017, by = "ID", all = TRUE)
Joint18_17_3 <- merge(filt_2018, filt_2017, by = "ID2", all = TRUE)
#Joint18_17_4 <- merge(filt_2018, filt_2017, by = "CompanyEIN", all = TRUE)
Joint18_17_2 <- merge(filt_2018, filt_2017, by = c("CompanyEIN", "PlanTypeNumber"), all = TRUE)

Joint18_17_3Un <- unique(Joint18_17_3)
Joint18_17_3SpColumns <- Joint18_17_3[,!c(16:19, 21:25, 28,29)]
Joint18_17_3SpColumns_NoNA <- na.omit(Joint18_17_3SpColumns)

Joint18_17_2Un <- unique(Joint18_17_2)
Joint18_17_2SpColumns <- Joint18_17_2[,!c(16:18, 20:23, 26:28)]
Joint18_17_2SpColumns <- na.omit(Joint18_17_2SpColumns)

Joint18_17_2CNames <- Joint18_17_2SpColumns[,6]
Joint18_17_3CNames <- Joint18_17_3SpColumns[,6]



Joint18_17_2CNames <- unique(Joint18_17_2CNames)
Joint18_17_3CNames <- unique(Joint18_17_3CNames)

ID <- c(1:5)
Comp <- c("a", "b", "c", "d", "e")
m.data <- data.frame(ID, Comp)

ID <- c(1,7,8,9,2)
Comp1 <- c("gb", "t","b", "y", "a")
n.data <- data.frame(ID, Comp1)

merge.data <- merge(m.data, n.data, by = "ID", all = TRUE)
#NaBoth18_17 <- Joint18_17[is.na(Joint18_17$EOY_Active.x) & is.na(Joint18_17$EOY_Active.y), ]

###################Check SF
filtSF_2018_Check <- filtSF_2018
filtSF_2017_Check <- filtSF_2017
filtSF_2018_Check$EffDateInt <- as.numeric(as.factor(filtSF_2018_Check$PlanEffectiveDate))
filtSF_2017_Check$EffDateInt <- as.numeric(as.factor(filtSF_2017_Check$PlanEffectiveDate))

filtSF_2018_Check$ID3 <- paste0(filtSF_2018_Check$CompanyEIN, filtSF_2018_Check$PlanTypeNumber, sep = "") 
filtSF_2017_Check$ID3 <- paste0(filtSF_2017_Check$CompanyEIN, filtSF_2017_Check$PlanTypeNumber, sep = "")

#best with ID2

Merge17SF_18_Check <- merge(filtSF_2018_Check, filtSF_2017_Check, by = "ID3", all = TRUE)

Merge17SF_18NoNa_Check <- na.omit(Merge17SF_18_Check)

#filtSF_2018$ID2 <- filtSF_2018$CompanyEIN + filtSF_2018$PlanTypeNumber
#filtSF_2017$ID2 <- filtSF_2017$CompanyEIN + filtSF_2017$PlanTypeNumber

#Merge17SF_18 <- merge(filtSF_2018, filtSF_2017_M, by = "ID2", all = TRUE)
#Merge17SF_18NoNa <- na.omit(Merge17SF_18)