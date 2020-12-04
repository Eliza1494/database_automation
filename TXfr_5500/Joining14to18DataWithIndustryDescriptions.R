library(tidyverse)
library(data.table)

Merged14to18SF_Comp18and17 <- fread("Merged14to18SF_Comp18and17.csv")

TX5500_SF_Industr_Updated <- fread("TX5500_SF_Industr_UniqueCompTotBC_Updated.csv")

BC_Industry <- TX5500_SF_Industr_Updated[,c(6,8,9,10:12)]

#How many descriptions are missing 
sum(BC_Industry$Description == "")
sum(is.na(BC_Industry$Business_Code))

BC_Industry <- unique(BC_Industry)

#how many business codes are missing from the SF dataset
NoBC <- Merged14to18SF_Comp18and17[which(is.na(Merged14to18SF_Comp18and17$Business_Code)),]

#left join to get industry descriptions 
names(Merged14to18SF_Comp18and17)
names(BC_Industry)

class(BC_Industry$Business_Code)
class(Merged14to18SF_Comp18and17$Business_Code)

Merged14to18SF_Comp18and17NoNa <- Merged14to18SF_Comp18and17[!(is.na(Merged14to18SF_Comp18and17$Business_Code)),]
nrow(Merged14to18SF_Comp18and17) - nrow(Merged14to18SF_Comp18and17NoNa)

Merged14to18SF_Comp18and17_Industry <- left_join(Merged14to18SF_Comp18and17NoNa, BC_Industry, by = "Business_Code")

664199 + 239
Merged14to18SF_Comp18and17_Industry <- rbind(Merged14to18SF_Comp18and17_Industry, NoBC, fill = TRUE)

fwrite(Merged14to18SF_Comp18and17_Industry, "Merged14to18SF_Comp18and17_Industry.csv")


