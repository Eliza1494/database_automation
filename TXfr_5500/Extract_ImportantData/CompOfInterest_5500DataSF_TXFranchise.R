library(tidyverse)
library(data.table)
library(stringr)
library(RecordLinkage) #for strings dist computations

f1SF_2018 <- fread("f_5500_sf_2018_latest.csv")

filtSF_2018 <- f1SF_2018[,c(2,14, 15, 16, 17, 21:23, 30, 32, 51, 145, 146)]

setDT(filtSF_2018)

names(filtSF_2018)=c("Begin Date", "PlanName", "PlanTypeNumber", "PlanEffectiveDate", 
                     "CompanyName","US_City","US_State","US_ZIP", "CompanyEIN",
                     "Business_Code","Total_Participants_BOY","BOY_Active", "Total_Active(EOY)")

filtSF_2018 <- filtSF_2018[!(is.na(filtSF_2018$BOY_Active) & is.na(filtSF_2018$`Total_Active(EOY)`)),]


#####Add industry descriptions
TX5500_SF_Industr_Updated <- fread("TX5500_SF_Industr_UniqueCompTotBC_Updated.csv")

BC_Industry <- TX5500_SF_Industr_Updated[,c(6,8,9,10:12)]
BC_Industry <- unique(BC_Industry)

#244 companes with no business codes
filtSF_2018NoBC <- filtSF_2018[which(is.na(filtSF_2018$Business_Code)),]

filtSF_2018_Industry <- left_join(filtSF_2018, BC_Industry, by = "Business_Code")

####Choose companies only in particular industries by using business codes 

#List whose BC start with 238: (Specialty Trade Contractors)
stc <- unique(filtSF_2018_Industry[grepl("^238", filtSF_2018_Industry$Business_Code),10])

#list of BC that start with 31, 32, or 33 (Manufacturing)
m <- unique(filtSF_2018_Industry[grepl("^31|^32|^33", filtSF_2018_Industry$Business_Code),10])

#list of BC that start with 42 (Wholesale Trade)
wt <- unique(filtSF_2018_Industry[grepl("^42", filtSF_2018_Industry$Business_Code),10])

#list of BC that start with 51 (Information)
i <- unique(filtSF_2018_Industry[grepl("^51", filtSF_2018_Industry$Business_Code),10])

#list of BC that start with 48 (Transportation)
tr <- unique(filtSF_2018_Industry[grepl("^48", filtSF_2018_Industry$Business_Code),10])

#list of BC that start with 5413 (Architecture/engineer services)
arch <- unique(filtSF_2018_Industry[grepl("^5413", filtSF_2018_Industry$Business_Code),10])

#list of BC that start with 56 (Administrative/Support)
adm <- unique(filtSF_2018_Industry[grepl("^56", filtSF_2018_Industry$Business_Code),10])

#list of BC Health and Food/drinking places 
h <- c("621510", "621610", "722300")

#list of BC that start with "811" (Repair and Maintenance)
rp <- unique(filtSF_2018_Industry[grepl("^811", filtSF_2018_Industry$Business_Code),10])

#list of companies that are in the specific industries
CompaniesOfInt <- filtSF_2018_Industry[(filtSF_2018_Industry$Business_Code %in% 
                                         c(stc, m, wt, i, tr, arch, adm, h, rp)) | is.na(filtSF_2018_Industry$Business_Code), ]


#list of companies that have more than 10 active participants as of end of year 
CompaniesOfInt <- CompaniesOfInt[CompaniesOfInt$`Total_Active(EOY)` > 10,]

#Choose only in the following states: TX, OK, TN, NC, SC, AL, GA
CompaniesOfInt <- CompaniesOfInt[CompaniesOfInt$US_State %in% c("TX", "OK", "TN", "NC", "SC", "AL", "GA"),]

#TX <- CompaniesOfInt[CompaniesOfInt$US_State == "TX", ]
#OK <- CompaniesOfInt[CompaniesOfInt$US_State == "OK", ]

#CompaniesOfInt_TXOK <- CompaniesOfInt[CompaniesOfInt$US_State %in% c("TX", "OK"), ]

#15031 observations
fwrite(CompaniesOfInt, "CompaniesOfInt_5500Dataset_SF.csv")

################Texas Franchise holders Data Set 

TexasFranchise <- fread("Active_Franchise_Tax_Permit_Holders.csv")
setDT(TexasFranchise)

#just the active: A
#remove non-profit organizations: "CN": TEXAS NON-PROFIT CORPORATION ;
TexasFranchise1 <- TexasFranchise[((TexasFranchise$`Taxpayer Organizational Type` == "C")),] #2,006,397

INC <- TexasFranchise[which(grepl("INC", TexasFranchise$`Taxpayer Name`)),]

#"CL",
#"CP", "CT", 
#"HS", "IS", 
#"J", "L", "M",
#"O", "P", "PB", 
#"PI", "PL", "PV", 
#"PX", "PZ", "S", 
#"ST", "UF"

v <- TexasFranchise %>%
  arrange(TexasFranchise$`SOS Status Code`)

vcount <- TexasFranchise %>%
  count(TexasFranchise$`Taxpayer Organizational Type`)

INCcount <- INC %>%
  count(INC$`Taxpayer Organizational Type`)


pl <- TexasFranchise[which(TexasFranchise$`Taxpayer Organizational Type` == "PL"), ]

scA <- TexasFranchise[which(TexasFranchise$`SOS Status Code` == "A"), ]

#1,896,628 active business code and for profit companies 
bcA <- TexasFranchise[TexasFranchise$`Right to Transact Business Code` == "A",] 

bv <- TXFr %>% 
  arrange(TXFr$`NAICS Code`)


#####find which companies in 5500 are in the texas franchise#####
names(TexasFranchise)[2] <- "CompanyName"

TexasFranchise$CompName_Join <- str_replace_all(TexasFranchise$CompanyName, "[[:punct:]]", "")
TexasFranchise$CompName_Join <- str_squish(TexasFranchise$CompName_Join)

CompaniesOfInt$CompName_Join <- str_replace_all(CompaniesOfInt$CompanyName, "[[:punct:]]", "")
CompaniesOfInt$CompName_Join <- str_squish(CompaniesOfInt$CompName_Join)

#there are 5115 observations in both data sets and 4914 unique company names that are in both 5500 and Texas franchise and 3773 total 
TXFranch_5500Data <- inner_join(TexasFranchise, CompaniesOfInt, by = "CompName_Join") #5309

TXFranch_5500Data <- unique(TXFranch_5500Data) #5309: there are company names with multiple plans in the 5500 so there are duplicate company names; but there are no duplicate names in the texas franchise

fwrite(TXFranch_5500Data, "Comp_TXFranch_5500Data_SF.csv")

#find the unique companies that are both in 5500 dataset and TXFranchise dataset 
CompNames_unique <- unique(as.data.frame(TXFranch_5500Data[,19]))#5083 companies in 5500 are in the Texas franchise

CompNames <- as.data.frame(TXFranch_5500Data[,19])
CompNames_dupl <- as.data.frame(CompNames[duplicated(CompNames),]) 


#fin the companies that are only in the TXFranchise data base but not in the 5500 dataset
NoMatch <- anti_join(TexasFranchise, CompaniesOfInt, by = "CompName_Join") 
nrow(NoMatch) + nrow(TXFranch_5500Data)



########Find companies that have similar Business Codes as the ones in 5500########

TexasFranchise$`NAICS Code` <- as.integer(TexasFranchise$`NAICS Code`)
NoMatch$`NAICS Code` <- as.integer(NoMatch$`NAICS Code`)

#List whose BC start with 238: (Specialty Trade Contractors)
stcN <- unique(TexasFranchise[grepl("^238", TexasFranchise$`NAICS Code`), 18])
stcN <- stcN$`NAICS Code`

#list of BC that start with 31, 32, or 33 (Manufacturing)
mN <- unique(TexasFranchise[grepl("^31|^32|^33", TexasFranchise$`NAICS Code`), 18])
mN <- mN$`NAICS Code`

#list of BC that start with 42 (Wholesale Trade)
wtN <- unique(TexasFranchise[grepl("^42", TexasFranchise$`NAICS Code`), 18])
wtN <- wtN$`NAICS Code`

#list of BC that start with 51 (Information)
iN <- unique(TexasFranchise[grepl("^51", TexasFranchise$`NAICS Code`), 18])
iN <- iN$`NAICS Code`

#list of BC that start with 48 (Transportation)
trN <- unique(TexasFranchise[grepl("^48", TexasFranchise$`NAICS Code`), 18])
trN <- trN$`NAICS Code`

#list of BC that start with 5413 (Architecture/engineer services)
archN <- unique(TexasFranchise[grepl("^5413", TexasFranchise$`NAICS Code`), 18])
archN <- archN$`NAICS Code`

#list of BC that start with 561 (Administrative/Support)
admN <- unique(TexasFranchise[grepl("^561", TexasFranchise$`NAICS Code`), 18])
admN <- admN$`NAICS Code`

#list of BC Health and Food/drinking places 
hN <- unique(TexasFranchise[grepl("^6215|^6216|^7223", TexasFranchise$`NAICS Code`), 18])
hN <- hN$`NAICS Code`

#list of BC that start with "811" (Repair and Maintenance)
rpN <- unique(TexasFranchise[grepl("^811", TexasFranchise$`NAICS Code`), 18])
rpN <- rpN$`NAICS Code`

sum(is.na(NoMatch$`NAICS Code`)) #there are 1426085 companies with NA in Business Code 

#find these companies that are not in 5500 but have similar BC: 117,972 
Comp_TXfrNotin5500_SimilarBC <- NoMatch[NoMatch$`NAICS Code` %in% 
                                        c(stcN, mN, wtN, iN, trN, archN, admN, hN, rpN) , ]

#| is.na(NoMatch$`NAICS Code`)
fwrite(Comp_TXfrNotin5500_SimilarBC,"Comp_TXfrNotin5500SF_SimilarBC.csv")


################Create files for each of the BCs#############3

setwd("C:/Users/Eliza/Desktop/CaruthCap/FinalDatasetsToBeUsed/TXFranchise_5500Data")

CompaniesOfInt_5500Dataset_SF <- fread("CompaniesOfInt_5500Dataset_SF.csv")
CompaniesOfInt_5500Dataset_SF$Business.Code.Description <- str_squish(CompaniesOfInt_5500Dataset_SF$Business.Code.Description)

m2 <- unique(CompaniesOfInt_5500Dataset_SF$Business_Code)

#BC is the original Business Codes to be used to filter out based on business codes 
#BC <- unique(Merged14to18SF_2018Companies_Industry$Business_Code)

setwd("C:/Users/Eliza/Desktop/CaruthCap/FinalDatasetsToBeUsed/TXFranchise_5500Data/CompOfInt_SF_BConly")

for (bc in m2) {
  bc_descr = filter(CompaniesOfInt_5500Dataset_SF, 
                    Business_Code == bc)
  fwrite(bc_descr, paste0("BC_", bc, ".csv", sep = ""))
}

setwd("~/")

names(Comp_TXfrNotin5500SF_SimilarBC)[18] <- "Business_Code_NAICS"
names(NAICS_Code_List_Upd)[2] <- "Business_Code_NAICS"

NAICS_Code_List_Upd <- fread("NAICS_Code_List_Upd.csv")

Comp_TXfrNotin5500SF_SimilarBC <- left_join(Comp_TXfrNotin5500SF_SimilarBC, NAICS_Code_List_Upd, by = "Business_Code_NAICS")




Comp_TXfrNotin5500SF_SimilarBC$Industry <- ifelse(grepl("^238", Comp_TXfrNotin5500SF_SimilarBC$Business_Code_NAICS) == "TRUE", "Specialty Trade Contractors",
                                                  ifelse(grepl("^31|^32|^33", Comp_TXfrNotin5500SF_SimilarBC$Business_Code_NAICS) == "TRUE", "Manufacturing", 
                                                         ifelse(grepl("^42", Comp_TXfrNotin5500SF_SimilarBC$Business_Code_NAICS) == "TRUE", "Wholesale Trade", 
                                                                ifelse(grepl("^51", Comp_TXfrNotin5500SF_SimilarBC$Business_Code_NAICS) == "TRUE", "Information",
                                                                       ifelse(grepl("^48", Comp_TXfrNotin5500SF_SimilarBC$Business_Code_NAICS) == "TRUE", "Transportation",
                                                                              ifelse(grepl("^5413", Comp_TXfrNotin5500SF_SimilarBC$Business_Code_NAICS) == "TRUE", "Architecture_Engineering Services",
                                                                                     ifelse(grepl("^561", Comp_TXfrNotin5500SF_SimilarBC$Business_Code_NAICS) == "TRUE", "Administrative Support",
                                                                                            ifelse(grepl("^6215|^6216", Comp_TXfrNotin5500SF_SimilarBC$Business_Code_NAICS) == "TRUE", "Health_Medical Laboratories",
                                                                                                   ifelse(grepl("^7223", Comp_TXfrNotin5500SF_SimilarBC$Business_Code_NAICS) == "TRUE", "Specialty Food services",
                                                                                                          ifelse(grepl("^811", Comp_TXfrNotin5500SF_SimilarBC$Business_Code_NAICS) == "TRUE", "Repair_Maintenance Services", "NA_Unclassified"))))))))))


fwrite(Comp_TXfrNotin5500SF_SimilarBC, "Comp_TXfrNotin5500SF_SimilarBC.csv")


Comp_TXfrNotin5500SF_SimilarBC <- fread("Comp_TXfrNotin5500SF_SimilarBC.csv")

Comp_TXfrNotin5500SF_SimilarBC$NAICS_Descr <- paste0(Comp_TXfrNotin5500SF_SimilarBC$Business_Code_NAICS,  " ",
                                                     Comp_TXfrNotin5500SF_SimilarBC$Industry)

BC <- unique(Comp_TXfrNotin5500SF_SimilarBC$NAICS_Descr)

setwd("C:/Users/Eliza/Desktop/CaruthCap/FinalDatasetsToBeUsed/TXFranchise_5500Data/Comp_TXFranch_NotIn5500SF_BCs")
for (bc in BC) {
  bc_descr = filter(Comp_TXfrNotin5500SF_SimilarBC, 
                    NAICS_Descr == bc)
  fwrite(bc_descr, paste0("BC_", bc, ".csv", sep = ""))
}


###########################Remove 5500 from TexasFr not in 5500SF#########################
Comp_TXfrNotin5500SF_SimilarBC <- fread("Comp_TXfrNotin5500SF_SimilarBC.csv")
CompaniesOfInt_5500Dataset <- fread("CompaniesOfInt_5500Dataset.csv")

#names(CompaniesOfInt_5500Dataset)[5] <- "CompanyName"

CompaniesOfInt_5500Dataset$CompName_Join <- str_replace_all(CompaniesOfInt_5500Dataset$CompanyName, "[[:punct:]]", "")
CompaniesOfInt_5500Dataset$CompName_Join <- str_squish(CompaniesOfInt_5500Dataset$CompName_Join)

Comp_TXfrNotin5500SF_SimilarBC$CompName_Join <- str_replace_all(Comp_TXfrNotin5500SF_SimilarBC$CompanyName, "[[:punct:]]", "")
Comp_TXfrNotin5500SF_SimilarBC$CompName_Join <- str_squish(Comp_TXfrNotin5500SF_SimilarBC$CompName_Join)

NoMatch <- anti_join(Comp_TXfrNotin5500SF_SimilarBC, CompaniesOfInt_5500Dataset, by = "CompName_Join") 

setwd("C:/Users/Eliza/Desktop/CaruthCap/FinalDatasetsToBeUsed/TXFranchise_5500Data")
fwrite(NoMatch, "TXfr_NotinBoth5500_SimilarBC.csv")



###############Compute the distance between nonmatching names 
NoMatchNames <- NoMatch$CompName_Join

CompaniesOfInt_Names <- unique(as.data.frame(CompaniesOfInt$CompName_Join))
names(CompaniesOfInt_Names)[1] <- "CompName_Join"
CompaniesOfInt_Names$CompName_Join <- as.character(CompaniesOfInt_Names$CompName_Join)

TXFranch_5500DataNames <- unique(as.data.frame(TXFranch_5500Data$CompName_Join))
names(TXFranch_5500DataNames)[1] <- "CompName_Join"

CompaniesOfInt_Names <- anti_join(CompaniesOfInt_Names, TXFranch_5500DataNames, by = "CompName_Join")


#CompaniesOfInt_Names <- CompaniesOfInt_Names$CompName_Join
#CompaniesOfInt_Names <- as.character(CompaniesOfInt_Names)

CN <- c("STONE RESTORATION OF AMERICA INC", "STRIPEITUP LLC")
NMN <- c("SANLLO ONLINE LLC", "FOUR SEASONS PRODUCE INC", "3HM TRUCKING LLC")

CN <- CompaniesOfInt_Names$CompName_Join
NMN <- NoMatch$CompName_Join

Comp_Check <- as.data.table(CompaniesOfInt_Names[1:2,])
CompaniesOfInt_Names$MaxDist <- map(CN, ~ max(levenshteinSim(CN, NMN)))

levenshteinSim(CompaniesOfInt_Names$CompName_Join, NoMatchNames)


