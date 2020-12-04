library(stringr)
library(data.table)


NAICS.Codes.List$V1 <- sub(".*NAICS","", NAICS.Codes.List$V1)

class(NAICS.Codes.List$V1)

NAICS.Codes.List$V1 <- str_trim(NAICS.Codes.List$V1) #removes the space at the beginnign of a string

NAICS.Codes.List$Description <- gsub("[[:digit:]]","", NAICS.Codes.List$V1)

NAICS.Codes.List$Code <- gsub("[aA-zZ]+","", NAICS.Codes.List$V1)

NAICS.Codes.List$Code <- str_replace_all(NAICS.Codes.List$Code, "[[:punct:]]", "")
NAICS.Codes.List$Code <- str_trim(NAICS.Codes.List$Code)
class(NAICS.Codes.List$Code)

#word(NAICS.Codes.List$V1, 2)
n <- c(0:9)
substr(NAICS.Codes.List$V1, 1, 1)
NAICS.Codes.List$V2 <- ifelse(substr(NAICS.Codes.List$V1, 1, 1) %in% n, NAICS.Codes.List$V1, "NA")

NAICS.Codes.List <- NAICS.Codes.List[!(NAICS.Codes.List$V2 == "NA"),]

NAICS.Codes.List$Code <- as.numeric(NAICS.Codes.List$Code)

NAICS.Codes.List <- NAICS.Codes.List[,c(2,3,4)]
names(NAICS.Codes.List)[3] <- "Code_Descr"
fwrite(NAICS.Codes.List, "NAICS_Code_List_Upd.csv")

#
# load data
#my.data <- c("aaa", "b11", "b21", "b101", "b111", "ccc1", "ddd1", "ccc20", "ddd13")
#
# extract numbers only
#my.data.num <- as.numeric(str_extract(my.data, "[0-9]+"))
#
# check output
#my.data.num
#[1]  NA  11  21 101 111   1   1  20  13
#
# extract characters only
#my.data.cha <- (str_extract(my.data, "[aA-zZ]+"))
# 
# check output
#my.data.cha
#[1] "aaa" "b"   "b"   "b"   "b"   "ccc" "ddd" "ccc" "ddd"

#https://stackoverflow.com/questions/9756360/split-character-data-into-numbers-and-letters