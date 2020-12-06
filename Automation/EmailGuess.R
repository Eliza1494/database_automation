library(data.table)
library(tidyverse)
library(stringr)

setwd("C:/Users/Eliza/Desktop/CaruthCap/ReferenceUSA/NC.SC")

#create a function 
emailGuess <- function(csv, EmailGuessCSV) {
  
csv <- csv

csv <- fread(csv)

csv <- csv[!(csv$Website == ""),]

csv2 <- csv[!(csv$`Executive First Name` == "" &
                                                      csv$`Executive First Name 1` == "" &
                                                      csv$`Executive First Name 2` == "" &
                                                      csv$`Executive First Name 3` == "" &
                                                      csv$`Executive First Name 4` == ""),]

# first_initial last: jdoe@friedmanllp.com
#first last	 janedoe@friedmanllp.com	

######Guess for first executive email
fi <- tolower(substr(csv2$`Executive First Name`, 1,1))
l <- tolower(csv2$`Executive Last Name`)
f <- tolower(csv2$`Executive First Name`)
web <- csv2$Website

csv2$GuessEm1 <- paste0(fi, l, "@", web)

csv2$GuessEm2 <- paste0(f, l, "@", web, sep = "")
csv2$GuessEm2 <- gsub(" ", "", csv2$GuessEm2)

#guess for next executive email 
fi_1 <- tolower(substr(csv2$`Executive First Name 1`, 1,1))
l_1 <- tolower(csv2$`Executive Last Name 1`)
f_1 <- tolower(csv2$`Executive First Name 1`)

csv2$GuessEm1_1 <- paste0(fi_1, l_1, "@", web)

csv2$GuessEm2_1 <- paste0(f_1, l_1, "@", web, sep = "")
csv2$GuessEm2_1 <- gsub(" ", "", csv2$GuessEm2_1)

#make blank if they are the same as prrevious email 
csv2$GuessEm1_1 <- ifelse(csv2$GuessEm1 == csv2$GuessEm1_1, csv2$GuessEm1_1 == "", 
       csv2$GuessEm1_1)

csv2$GuessEm1_1 <- gsub("FALSE", "", csv2$GuessEm1_1)

csv2$GuessEm2_1 <- ifelse(csv2$GuessEm2 == csv2$GuessEm2_1, csv2$GuessEm2_1 == "", 
       csv2$GuessEm2_1)

csv2$GuessEm2_1 <- gsub("FALSE", "", csv2$GuessEm2_1)

#Guess Second executive email 
fi_2 <- tolower(substr(csv2$`Executive First Name 2`, 1,1))
l_2 <- tolower(csv2$`Executive Last Name 2`)
f_2 <- tolower(csv2$`Executive First Name 2`)

csv2$GuessEm1_2 <- paste0(fi_2, l_2, "@", web)

csv2$GuessEm2_2 <- paste0(f_2, l_2, "@", web, sep = "")
csv2$GuessEm2_2 <- gsub(" ", "", csv2$GuessEm2_2)

#leave blank if second executive names are missing 
csv2$GuessEm1_2 <- ifelse(csv2$`Executive First Name 2` == "", csv2$GuessEm1_2 == "", csv2$GuessEm1_2)
csv2$GuessEm2_2 <- ifelse(csv2$`Executive First Name 2` == "", csv2$GuessEm2_2 == "", csv2$GuessEm2_2)

csv2$GuessEm1_2 <- gsub("FALSE", "", csv2$GuessEm1_2)
csv2$GuessEm2_2 <- gsub("FALSE", "", csv2$GuessEm2_2)


#guess for the third executive emails
fi_3 <- tolower(substr(csv2$`Executive First Name 3`, 1,1))
l_3 <- tolower(csv2$`Executive Last Name 3`)
f_3 <- tolower(csv2$`Executive First Name 3`)

csv2$GuessEm1_3 <- paste0(fi_3, l_3, "@", web)

csv2$GuessEm2_3 <- paste0(f_3, l_3, "@", web, sep = "")
csv2$GuessEm2_3 <- gsub(" ", "", csv2$GuessEm2_3)

#leave blank if second executive names are missing 
csv2$GuessEm1_3 <- ifelse(csv2$`Executive First Name 3` == "", csv2$GuessEm1_3 == "", csv2$GuessEm1_3)
csv2$GuessEm2_3 <- ifelse(csv2$`Executive First Name 3` == "", csv2$GuessEm2_3 == "", csv2$GuessEm2_3)

csv2$GuessEm1_3 <- gsub("FALSE", "", csv2$GuessEm1_3)
csv2$GuessEm2_3 <- gsub("FALSE", "", csv2$GuessEm2_3)




fi_4 <- tolower(substr(csv2$`Executive First Name 4`, 1,1))
l_4 <- tolower(csv2$`Executive Last Name 4`)
f_4 <- tolower(csv2$`Executive First Name 4`)

csv2$GuessEm1_4 <- paste0(fi_4, l_4, "@", web)

csv2$GuessEm2_4 <- paste0(f_4, l_4, "@", web, sep = "")
csv2$GuessEm2_4 <- gsub(" ", "", csv2$GuessEm2_4)

#leave blank if second executive names are missing 
csv2$GuessEm1_4 <- ifelse(csv2$`Executive First Name 4` == "", csv2$GuessEm1_4 == "", csv2$GuessEm1_4)
csv2$GuessEm2_4 <- ifelse(csv2$`Executive First Name 4` == "", csv2$GuessEm2_4 == "", csv2$GuessEm2_4)

csv2$GuessEm1_4 <- gsub("FALSE", "", csv2$GuessEm1_4)
csv2$GuessEm2_4 <- gsub("FALSE", "", csv2$GuessEm2_4)

EmailGuessCSV <- EmailGuessCSV

fwrite(csv2, EmailGuessCSV)

}

csv <- paste0("Admin.sup_56_NC.SC_em", ".csv", sep = "")
EmailGuessCSV <- paste0("Admin.sup_56_NC.SC_em", "Guess.csv", sep = "")

emailGuess(csv, EmailGuessCSV)

#list all the files in the folder 
list.files(pattern = "*.csv")

csv <- paste0("Arch.Eng_5413_NC.SC_em", ".csv", sep = "")
EmailGuessCSV <- paste0("Arch.Eng_5413_NC.SC_em", "Guess.csv", sep = "")
emailGuess(csv, EmailGuessCSV)

csv <- paste0("HealthLab_6215.6216_NC.SC_em", ".csv", sep = "")
EmailGuessCSV <- paste0("HealthLab_6215.6216_NC.SC_em", "Guess.csv", sep = "")
emailGuess(csv, EmailGuessCSV)

csv <- paste0("Inform51_NC.SC_em", ".csv", sep = "")
EmailGuessCSV <- paste0("Inform51_NC.SC_em", "Guess.csv", sep = "")
emailGuess(csv, EmailGuessCSV)

csv <- paste0("Manufct_31.32.33_NC.SC_em", ".csv", sep = "")
EmailGuessCSV <- paste0("Manufct_31.32.33_NC.SC_em", "Guess.csv", sep = "")
emailGuess(csv, EmailGuessCSV)

csv <- paste0("Rep.Maint_811_NC.SC_em", ".csv", sep = "")
EmailGuessCSV <- paste0("Rep.Maint_811_NC.SC_em", "Guess.csv", sep = "")
emailGuess(csv, EmailGuessCSV)

csv <- paste0("SpecFoodServ_7223_NC.SC_em", ".csv", sep = "")
EmailGuessCSV <- paste0("SpecFoodServ_7223_NC.SC_em", "Guess.csv", sep = "")
emailGuess(csv, EmailGuessCSV)

csv <- paste0("SpTrContr_238_NC.SC_em", ".csv", sep = "")
EmailGuessCSV <- paste0("SpTrContr_238_NC.SC_em", "Guess.csv", sep = "")
emailGuess(csv, EmailGuessCSV)

csv <- paste0("Transp_48_NC.SC_em", ".csv", sep = "")
EmailGuessCSV <- paste0("Transp_48_NC.SC_em", "Guess.csv", sep = "")
emailGuess(csv, EmailGuessCSV)

csv <- paste0("WhSaleTr_42_NC.SC_em", ".csv", sep = "")
EmailGuessCSV <- paste0("WhSaleTr_42_NC.SC_em", "Guess.csv", sep = "")
emailGuess(csv, EmailGuessCSV)

