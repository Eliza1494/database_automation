library(utils)
library(data.table) #for fread 
library(stringr) #filesstrings requires package stringr
library(filesstrings) #for moving a file


#use getwd() to see working directory 
#set working directory to Documents: Session -> Set Working Directory -> Choose Directory

###########Download 5500 Datasets#############
#set the URL from where to download the file 
URL <- "http://askebsa.dol.gov/FOIA%20Files/2019/Latest/F_5500_2019_Latest.zip"

#try for 1 dataset 
#set the destionaion where to save the file
dest <- "C:/Users/Eliza/Documents/F_5500_2019_Latest.zip"
download.file(URL, dest)
unzip("F_5500_2019_Latest.zip", "f_5500_2019_latest.csv") #unzip the file
d1 <- fread("f_5500_2019_latest.csv") #read the file 

#Download all files from 2009 to 2019; 1999 to 2008 have a slightly different name
n = 2009:2019 #have all numbers from 2009 to 2019 by 1 year apart 
year = as.vector(n) #make a vector of all these numbers that can be used in the loop

#use paste0 to concatinate different parts of the website together with the year 
#from the vector which is the only one that differs in the download website for each year
#download.file(URL of the file to be downloaded, destination)
#unzip(the name of the zipped file, the filename that you need to be unzipped from the zipped folder)

Loop1 = for (y in year) {
#For 5500 files
URL1 = paste0("http://askebsa.dol.gov/FOIA%20Files/", y ,"/Latest/F_5500_",
             y , "_Latest.zip", sep = "")
dest1 = paste0("C:/Users/Eliza/Documents/F_5500_", y , "_Latest.zip", sep = "")
name1 = paste0("F_5500_", y, "_Latest.zip", sep = "")
filename1 = paste0("f_5500_", y, "_latest.csv", sep = "")
download.file(URL1, dest1)
unzip(name1, filename1)

#For 5500_SF Files
URL_SF = paste0("http://askebsa.dol.gov/FOIA%20Files/", y ,"/Latest/F_5500_SF_",
                y , "_Latest.zip", sep = "")
dest_SF = paste0("C:/Users/Eliza/Documents/F_5500_SF_", y , "_Latest.zip", sep = "")
name_SF = paste0("F_5500_SF_", y, "_Latest.zip", sep = "")
filename_SF = paste0("f_5500_sf_", y, "_latest.csv", sep = "")
download.file(URL_SF, dest_SF)
unzip(name_SF, filename_SF)
}

#From 1999 to 2008 there is no "Latest" in the file name; website text hints
#everything else the same and can be coped from above; "_Latest" needs to be deleted from each link
#download.file the same
#the zipped folder contains multiple other folders so in unzip(name of the zipped folder, filename to be unzipped in the zipped folder)
#using list = TRUE to see the folders it contains, get the path to unzip the oracle folder
#from the oracle folder, move the csv file to the directory you want using file.move 

unzip("F_5500_1999.zip", list = TRUE)

n2 = 1999:2008
year2 = as.vector(n2)

Loop2 = for (y in year2) {
  URL = paste0("http://askebsa.dol.gov/FOIA%20Files/", y ,"/F_5500_",
               y , ".zip", sep = "")
  dest = paste0("C:/Users/Eliza/Documents/F_5500_", y , ".zip", sep = "")
  name = paste0("F_5500_", y, ".zip", sep = "")
  filename = paste0("oracle/Directories/Foia/f_5500_",
                    y, ".csv", sep = "") #change that and include file.move
  filemove = paste0("C:/Users/Eliza/Documents/oracle/Directories/Foia/f_5500_",
                    y, ".csv")
  directory = "C:/Users/Eliza/Documents"
  download.file(URL, dest)
  unzip(name, filename)
  file.move(filemove, directory)
}


##################Download Texas.gov Dataset#############################
#https://data.texas.gov/resource/jrea-zgmq.json
#https://data.texas.gov/api/views/jrea-zgmq/rows.csv?accessType=DOWNLOAD
destT <- "C:/Users/Eliza/Documents/FRTaxesTexasD.csv"
download.file("https://data.texas.gov/api/views/jrea-zgmq/rows.csv?accessType=DOWNLOAD", destT)

library(httr) #for the GET function 
library(jsonlite)

r <- GET("https://data.texas.gov/resource/jrea-zgmq.csv")
r
content(r)
DataFrame <- data.frame(content(r))
write.csv(DataFrame, "FrTaxesTexas.csv")
