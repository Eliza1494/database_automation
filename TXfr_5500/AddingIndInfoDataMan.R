library(tidyverse)
library(data.table)

#read datasets

#f1_2018_Benefits=f1_2018_Benefits %>% replace_na(list(Number_Of_Participants=0))%>% 
#  group_by(CompanyName,Business_Code)%>%
#  filter(Number_Of_Participants==max(Number_Of_Participants))%>%
#  slice(head(1))

#Crete 2 data frames with only company names from each 2018 and 2017  
f1 <- fread("f_5500_sf_2017_latest.csv")
f2 <- fread("f_5500_sf_2018_latest.csv")


#force set as data.table
setDT(f1)

setDT(f2)



#filter to just significant columns using column numbers
filt <- f1[,c(1,2,19,24:26,46, 125, 72)]
#filt2 <- f2[,c(2,19,22:26,46,71:72)] #add 17
filt2 <- f2[,c(1, 2,17,21:23,32, 145,146)] #add 17
names(filt)
names(filt2)

filt <- data.frame(filt,stringsAsFactors = F)
filt2 <- data.frame(filt2,stringsAsFactors = F)

names(filt)=c("ID" , "Begin Date","CompanyName","US_City","US_State","US_ZIP",
              "Business_Code", "BOY_Active", "EOY_Active")
names(filt2)=names(filt)



#delete duplicated rows
#unique1=unique(filt)
#unique2=unique(filt2)


#####Created#######
filt <- filt %>% 
  replace_na(list(Number_Of_Participants=0))

filtNA <- filt[is.na(filt$Business_Code),]

filtNoNa <- filt[!is.na(filt$Business_Code),]
#Check nrow(filt) - nrow(filtNoNa) = nrow(filtNA) only Business Code has NA values

BusinessCodesCSV1 <- fread("BusinessCodesCSV1.csv")
TX5500Industries_UniqueComp <- left_join(filtNoNa, BusinessCodesCSV1, by = "Business_Code")

fwrite(TX5500Industries_UniqueComp, "TX5500Industries_UniqueComp.csv") #to be used to create the final file

fread("TX5500Industries_UniqueComp.csv")

#Contains both the original and amended; bc amended has blank where not changed, so it contains only 400 codes
TX5500Industries_UniqueComp$Business_Code_Amended <- ifelse(
  is.na(TX5500Industries_UniqueComp$Business_Code_Amended), 
  TX5500Industries_UniqueComp$Business_Code_Original, 
  TX5500Industries_UniqueComp$Business_Code_Amended
)

fwrite(TX5500Industries_UniqueComp, "TX5500Industries_UniqueCompUpdated.csv")

TX5500Industries_UniqueComp$CompanyName <- as.character(TX5500Industries_UniqueComp$CompanyName)

TotalBC <- TX5500Industries_UniqueCompUpdated[,c(6,7,9,10,11,12)]
TotalBC <- TotalBC[!duplicated(TotalBC[,1]),] # have only unique original business codes
names(TotalBC)[names(TotalBC) == "Business_Code_Original"] <- "Business_Code"
#change the name to join afterwards 
fwrite(TotalBC, "TotalBCIndustrDescr.csv") #including the amended one to be used together with NAICS

#Compare if  the new created BC give the same results as the one created manually 
#Compare TX5500Industries_UniqueCompUpdated with the new created data from TotalBC
TX5500Industries_UniqueCompNEW <- left_join(filtNoNa, TotalBC, by = "Business_Code")
nrow(TX5500Industries_UniqueCompUpdated)

TX5500Industries_UniqueCompUpdated$CompanyName <- as.character(TX5500Industries_UniqueCompUpdated$CompanyName)

TX5500Industries_UniqueCompNEW$CompanyName

#compare if they are equal: Equal
names(TX5500Industries_UniqueCompUpdated)[names(TX5500Industries_UniqueCompUpdated) == "Business_Code_Original"] <- "Business_Code"
NotEqual2 <- anti_join(TX5500Industries_UniqueCompNEW, TX5500Industries_UniqueCompUpdated, by = "Business_Code")

#NAICS
M <- TX5500Industries_UniqueComp[which(TX5500Industries_UniqueComp$Descrition == ""),]

M <- M[!(M$Business_Code == 0),]

NAICS_Code_List_Upd <- fread("NAICS_Code_List_Upd.csv")
class(NAICS_Code_List_Upd$Description)
class(NAICS_Code_List_Upd$Code_Descr)
substr(NAICS_Code_List_Upd$Code_Descr, 7,7)

NAICS_Code_List_Upd$Code_Descr <- gsub(substr(NAICS_Code_List_Upd$Code_Descr, 7,7), "", NAICS_Code_List_Upd$Code_Descr)

NAICS_Code_List_Upd$Description <- gsub("Â", "",NAICS_Code_List_Upd$Description)

NAICS_Code_List_Upd$Description <- str_trim(NAICS_Code_List_Upd$Description)
NAICS_Code_List_Upd$Code <- as.integer(NAICS_Code_List_Upd$Code)
names(NAICS_Code_List_Upd)[2] <- "Business_Code"
fwrite(NAICS_Code_List_Upd, "NAICS_Code_List_Upd.csv")


class(M$Business_Code)

MNAICS <- left_join(M, NAICS_Code_List_Upd, by = "Business_Code") #No missed NAICS codes

##############SF Data#############################

TotalBCIndustrDescr <- fread("TotalBCIndustrDescr.csv")

filt2 <- filt2 %>% 
  replace_na(list(Number_Of_Participants=0))
filt2NoNa <- filt2[!is.na(filt2$Business_Code),]

TX5500_SF_Industr_UniqueCompTotBC <- left_join(filt2NoNa, TotalBCIndustrDescr, by = "Business_Code")

nrow(filt2NoNa)
fwrite(TX5500_SF_Industr_UniqueCompTotBC, "TX5500_SF_Industr_UniqueCompTotBC.csv")

#Check which industry is blank 
TX5500_SF_Industr_UniqueCompTotBC <- fread("TX5500_SF_Industr_UniqueCompTotBC.csv")

#TX5500_SF_IndustrBlank <- TX5500_SF_Industr_UniqueCompTotBC[which(is.na(TX5500_SF_Industr_UniqueCompTotBC$Descrition)),]
TX5500_SF_IndustrBlank <- TX5500_SF_Industr_UniqueCompTotBC[which(TX5500_SF_Industr_UniqueCompTotBC$Descrition == "" & TX5500_SF_Industr_UniqueCompTotBC$Business_Code != 0),]

TX5500_SF_IndustrBlank <- TX5500_SF_IndustrBlank[, 1:7] #155 observ, 7 variables

NAICS_SF_Joined <- left_join(TX5500_SF_IndustrBlank, NAICS_Code_List_Upd, by = "Business_Code")

fwrite(NAICS_SF_Joined, "NAICS_SF_MissingBC.csv")

#exclude the 155 that have NA to join them (rbind) later when amended
TX5500_SF_Industr_NoMissingBC <- TX5500_SF_Industr_UniqueCompTotBC[-which(TX5500_SF_Industr_UniqueCompTotBC$Descrition == "" & TX5500_SF_Industr_UniqueCompTotBC$Business_Code != 0),]

NAICS_SF_MissingBC_Upd <- fread("NAICS_SF_MissingBC_Upd.csv")
names(NAICS_SF_MissingBC_Upd)
names(NAICS_SF_MissingBC_Upd)[9] <- "Business.Code.Description"
names(NAICS_SF_MissingBC_Upd)[12] <- "SubIndustry"
lapply(NAICS_SF_MissingBC_Upd, class)

names(TX5500_SF_Industr_NoMissingBC)
names(TX5500_SF_Industr_NoMissingBC)[10] <- "Description"
lapply(TX5500_SF_Industr_NoMissingBC, class)

TX5500_SF_Industr_UniqueCompTotBC1 <- rbind(TX5500_SF_Industr_NoMissingBC,
                                            NAICS_SF_MissingBC_Upd, fill=TRUE)

TX5500_SF_Industr_UniqueCompTotBC1[TX5500_SF_Industr_UniqueCompTotBC1$Description == "",][,2]

fwrite(TX5500_SF_Industr_UniqueCompTotBC1, "TX5500_SF_Industr_UniqueCompTotBC_Updated.csv")

which(grepl("theater", TX5500_SF_Industr_UniqueCompTotBC$CompanyName, ignore.case = TRUE))
filter(TX5500_SF_Industr_UniqueCompTotBC, grepl("theater", TX5500_SF_Industr_UniqueCompTotBC$CompanyName, ignore.case = TRUE))[2]
#search for company names that begin with "the"; use ^ infront
filter(TX5500_SF_Industr_UniqueCompTotBC, grepl("^the ", TX5500_SF_Industr_UniqueCompTotBC$CompanyName, ignore.case = TRUE))[2]
#to search for ending word use $at the end of the word
m <- filter(TXData, grepl("theater$", TXData$CompanyName, ignore.case = TRUE))[2]

TX5500_SF_Industr_UniqueCompTotBC_Updated <- fread("TX5500_SF_Industr_UniqueCompTotBC_Updated.csv")
TXData <- TX5500_SF_Industr_UniqueCompTotBC_Updated
#Replace with blank if last word is theater
TXData$CompanyName <- str_replace_all(TXData$CompanyName, "THEATER$", "")
#replace with blank if first word is amercan ignoring cases 
TXData$CompanyName <- str_replace_all(TXData$CompanyName, regex("^american", ignore_case = TRUE), "")

Both <- f1_2018[f1_2018$TYPE_WELFARE_BNFT_CODE == "" & f1_2018$TYPE_PENSION_BNFT_CODE == "",]
BothWith <- f1_2018[!(f1_2018$TYPE_WELFARE_BNFT_CODE == "") & !(f1_2018$TYPE_PENSION_BNFT_CODE == ""),]

f_5500_sf_2018_latest <- fread("f_5500_sf_2018_latest.csv")

fire <- filter(f1_2018, grepl("firetrol", f1_2018$SPONSOR_DFE_NAME, ignore.case = TRUE))

grep(".fire", f_5500_sf_2018_latest$SF_SPONSOR_NAME)






