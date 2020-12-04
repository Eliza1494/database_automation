
##as of january 20, 2020
#item 1...update webium as of jan 20, 2020
.rs.restartR()
#remove.packages("webbium")
library(remotes)
remotes::install_github("nealbotn/webbium", auth_token="142af89d28375b61c1d8a4a3b588f86e00e1729f")
install_github("nbarsch/pineium") #not able to install
library(pineium) #not able to install 
library("webbium") #not able to install 
library("foreach")
rpack()

#Item 2: In Google drive, best methods to run RScripts both in Rstudio/terminal in background: https://docs.google.com/document/d/1Ai4zWsAd6t0q-u9FmUvo0HGJr6Fcm34bu8Md-aQjHqg/edit?usp=sharing

#3  setting up system for consistent loading      .libPaths("/home/neal/rpack")

#item 4... downlad, unzip and start to process raw 5500 data, or other files

library(data.table)

#note creating data table, downloading, and unzipping in one line..for linux/mac
#dt <- fread("curl http:etc | funzip")

#alternative is download.file
#download.file("http://askebsa.dol.gov/FOIA%20Files/2018/Latest/F_5500_2018_Latest.zip?_ga=2.238250440.950943228.1579572691-826666608.1579572691", dest="dataset.zip", mode="wb") 
#unzip ("dataset.zip", exdir = "./")


#unzip files as sent in email

#note must library zip to use unzip function
library("zip")
unzip(zipfile="F_5500_2018_Latest.zip")
unzip(zipfile="F_5500_SF_2018_Latest.zip")


getwd()
#"/Users/davidwebb/Desktop/R project"


#read datasets
f1 <- fread("f_5500_2018_latest.csv")
f2 <- fread("f_5500_sf_2018_latest.csv")

#explore the dataset
names(f1)
head(f1)
tail(f1)

#force set as data.table
setDT(f1)
f1
setDT(f2)
f2


#filter to just significant columns using column numbers
filt <- f1[,c(2,19,24:26,46,71)]
#filt2 <- f2[,c(2,19,22:26,46,71:72)] #add 17
filt2 <- f2[,c(2,17,21:23,32,51)] #add 17
names(filt)
names(filt2)

filt <- data.frame(filt,stringsAsFactors = F)
filt2 <- data.frame(filt2,stringsAsFactors = F)

names(filt)=c("Begin Date","CompanyName","US_City","US_State","US_ZIP",
              "Business_Code", "Number_Of_Participants")
names(filt2)=names(filt)



#delete duplicated rows
filt=unique(filt)
filt2=unique(filt2)

library(tidyverse)
library(data.table)
#####Created#######
filt <- filt %>% 
  replace_na(list(Number_Of_Participants=0))
filtNoNa <- filt[!is.na(filt$Business_Code),]
#Check nrow(filt) - nrow(filtNoNa) = nrow(filtNA) only Business Code has NA values
TotalBCIndustrDescr <- fread("TotalBCIndustrDescr.csv")
#have a final file to be used for that 
TX5500Industries_UniqueComp <- left_join(filtNoNa, TotalBCIndustrDescr, by = "Business_Code")
#fwrite(TX5500Industries_UniqueComp, "TX5500Industries_UniqueComp.csv") to be used to create the final file

filt2 <- filt2 %>% 
  replace_na(list(Number_Of_Participants=0))
filt2NA <- filt2[is.na(filt2$Business_Code),]
filt2NoNa <- filt2[!is.na(filt2$Business_Code),]
nrow(filt2) - nrow(filt2NoNa)
nrow(filt2NA)
#not accounted for missing Business Codes because they have been written as NAICS. Already done file to be used
#"TotalBCIndustrDescr.csv" includes missing codes as well 
TX5500_SF_Industries_UniqueComp <- left_join(filt2NoNa, BusinessCodesCSV1, by = "Business_Code")
fwrite(TX5500_SF_Industries_UniqueComp, "TX5500_SF_Industries_UniqueComp.csv")
#########################

#keep only one row per company name,select the maximun for each group
#if we have the maximun in more than one row, we keep the first(head), 
library(tidyr)

#created
filterGroup2 = filt %>% replace_na(list(Number_Of_Participants=0))%>% 
  group_by(CompanyName,Business_Code)
#

#created
filtMNoSlice=filt %>% replace_na(list(Number_Of_Participants=0))%>% 
  group_by(CompanyName,Business_Code)%>%
  filter(Number_Of_Participants==max(Number_Of_Participants))
#

filtM=filt %>% replace_na(list(Number_Of_Participants=0))%>% 
  group_by(CompanyName,Business_Code)%>%
  filter(Number_Of_Participants==max(Number_Of_Participants))%>%
  slice(head(1))

############created###########

Mean = mean(filtM$Number_Of_Participants) #872
Max = max(filtM$Number_Of_Participants)
min(filtM$Number_Of_Participants)
sd(filtM$Number_Of_Participants)
summary(filtM$Number_Of_Participants)

filtMtop50 <- filtM[order(-filtM$Number_Of_Participants),]
filtMtop50 <- filtMtop50[1:50, ]
filtMLess50 <- filtM[filtM$Number_Of_Participants < 50,]
filtMbw10_50 <- filtM[between(filtM$Number_Of_Participants, 10,50),]
filtMbw872_210572 <- filtM[between(filtM$Number_Of_Participants, 872, 210572),]


dir.create("csvbw872and210572_5500")

BusinessCodes1=unique(filtMbw872_210572$Business_Code)

for (bc in BusinessCodes1) {
  filterBC = filtMbw872_210572 %>% 
    filter( Business_Code==bc)
  fwrite(filterBC, paste0("csvbw872and210572_5500/be_",bc,".csv"))
}

#Number of Participants by Business Code
filtMEmplbyBusinessCode <- filtM[,colnames(filtM) %in% c("Business_Code", "Number_Of_Participants")]
filtMEmplbyBusinessCode1 <- aggregate(filtMEmplbyBusinessCode$Number_Of_Participants, by=list(Business_Code = filtMEmplbyBusinessCode$Business_Code), FUN = sum)
filtMEmplbyBusinessCode1 <- filtMEmplbyBusinessCode1[order(-filtMEmplbyBusinessCode1$x),]

NAValues <- filtM[is.na(filtM$Business_Code),]#there is NA in Business Code in the original 
NoNAValues <- filtM[!is.na(filtM$Business_Code),] #check nrow(NoNAValues) = nrow(filtM) to make sure no other variable has NA
filtM <- na.omit(filtM)
names(BusinessCodesCSV1)[names(BusinessCodesCSV1) == "BC"] <- "Business_Code"
BusinessCodesCSV1$Business_Code <- as.integer(BusinessCodesCSV1$Business_Code)

filtMerged <- left_join(filtM, BusinessCodesCSV1, by = "Business_Code")

fwrite(filtMerged, "FiltCompBCMaxPart.csv")
FiltCompBCMaxPart <- fread("FiltCompBCMaxPart.csv")

NPartIndustry <- aggregate(FiltCompBCMaxPart$Number_Of_Participants, by = list(Industry = FiltCompBCMaxPart$Industry), FUN = sum)
###################################

filt2M=filt2 %>% replace_na(list(Number_Of_Participants=0))%>% 
  group_by(CompanyName,Business_Code)%>%
  filter(Number_Of_Participants==max(Number_Of_Participants))%>%
  slice(head(1))

#note could have saved certain rows and columns, 
#not just columns as above
#note force data table into dataframe as above
#to play around, remember to remove or rm the object u created

library(foreach)
#must libary to do looping in parallel

if(!dir.exists("csvlib_5500")){dir.create("csvlib_5500")}

bc_list=unique(filt2M$Business_Code)

for (i in bc_list) {
  ntempdt = filt2M %>% filter( Business_Code==i)
  fwrite(ntempdt, paste0("csvlib_5500/be_",i,".csv"))
}

bc_list=unique(filtM$Business_Code)
for (i in bc_list) {
  tempdt = filtM %>% filter( Business_Code==i)
  fwrite(tempdt, paste0("csvlib_5500/bd_",i,".csv"))
}


