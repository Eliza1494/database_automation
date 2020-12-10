library(RSelenium)
#library(rJava)
library(tidyverse)
library(data.table)
library(foreach)
library(pineium)
library(glue)
library(devtools)
library(pushoverr)
library(chromote)
#devtools::install_github("rstudio/chromote")


rd <- rsDriver(browser="chrome",chromever = "87.0.4280.88", port=4598L)

#--disable-background-networking 
#--disable-background-timer-throttling --disable-breakpad --disable-client-side-phishing-detection --disable-default-apps
#--disable-dev-shm-usage --disable-extensions --safebrowsing-disable-auto-update

remDr <- rd$client
remDr$navigate("https://www.duckduckgo.com")


code <- "561"
State <- "North Carolina"


#click on reference USA from the research tools

remDr$navigate("https://library.cityoflewisville.com/digital-library/research-tools")
webElem <- remDr$findElement(using = 'xpath', '//*[@id="widget_4_3285_3377"]/table/tbody/tr[11]/td[1]/a/img')
rs(1,2)
webElem$clickElement()
rs(1,2)

#switch windows
myswitch <- function (remDr, windowId) 
{
  qpath <- sprintf("%s/session/%s/window", remDr$serverURL, 
                   remDr$sessionInfo[["id"]])
  remDr$queryRD(qpath, "POST", qdata = list(handle = windowId))
}
windows_handles <- remDr$getWindowHandles()
myswitch(remDr, windows_handles[[2]])
rs(2,3)

#click the agree button
webElem <- remDr$findElement(using = 'xpath', '//*[@id="chkAgree"]')
rs(1,2)
webElem$clickElement()
rs(2,3)

#click continue
webElem <- remDr$findElement(using = 'xpath', '//*[@id="TACForm"]/fieldset/div/ul/li[2]/div/a[2]/span/span')
rs(1,2)
webElem$clickElement()
rs(1,2)


sample <- sample(100000:999999, 1)
sample

webElem <- remDr$findElement(using = 'xpath', '//*[@id="matchcode"]')
webElem$clickElement()
rs(2,5)
webElem$sendKeysToElement(list(paste(sample)))
rs(2,5)
webElem <- remDr$findElement(using = 'xpath', '//*[@id="logOn"]/form/fieldset/div[3]/a/span/span')
webElem$clickElement()
rs(5,10)

#remove advertising
webElem <- remDr$findElement(using = 'xpath', '//*[@id="closeRebrandingModal"]')
webElem$clickElement()
webElem$clickElement()
rs(5,10)

#click on the search button 
webElem <- remDr$findElement(using = 'xpath', '/html/body/div[1]/div/div/div[1]/div[3]/div/div[3]/div/div/ul/li[1]/ul/li[1]/a')
webElem$clickElement()
rs(5,10)

#click on advanced search button 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="searchOptions"]/ul/li[2]/a')
webElem$clickElement()
rs(2,5)

#click on the NAISC/SIC check box 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="cs-YellowPageHeadingOrSic"]')
webElem$clickElement()
rs(2,5)

#click on search primary NAICS Only 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="naicsPrimaryOptionId"]')
webElem$clickElement()
rs(2,5)


#clear result
webElem <- remDr$findElement(using = 'xpath', '//*[@id="phYellowPageHeadingOrSic"]/div/div[2]/div/fieldset/div[10]/a')
rs(1,2)
webElem$clickElement()
rs(1,2)
#Input Code
webElem <- remDr$findElement(using = 'xpath', '//*[@id="naicsLookupKeyword"]')
rs(1,2)
webElem$clickElement()
rs(2,5)
webElem$sendKeysToElement(list(code, "\uE007"))
rs(2,5)

#Select all the elements in the result
#click the view 2-6 button 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="NaicsViewButtonLabel"]')
rs(2,5)
webElem$clickElement()
rs(20,23) #it take a lot of time to load so it needs more time 

#click at that row that has the needed initials of the code.
#####It only works if it is the first coupel of initial digits not the full code
codeN <- as.numeric(code)
codeN <- nchar(codeN)
codeL <- codeN - 1
xp <- glue('//*[@id="naicsKeyword"]/ul/li[{codeL}]')
webElem <- remDr$findElement(using = 'xpath', xp )
rs(2,5)
webElem$clickElement()
rs(2,5)


#Input State
#check on the box City/State 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="cs-CityState"]')
rs(1,2)
webElem$clickElement()
rs(20,23) #it takes a lot of time to load so it needs more time the state option to show up 

#input the state into the box
webElem <- remDr$findElement(using = 'xpath', '//*[@id="filterCityState"]')
rs(1,2)
webElem$clickElement()
rs(1,2)
webElem$sendKeysToElement(list(State, "\uE007"))
rs(2,5)
#click on go 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="SearchCityState"]/span/span')
rs(1,2)
webElem$clickElement()
rs(1,2)

#click on the first option avaiable. Make sure the state is spelled out; no abreviation
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableCityState"]/ul/li/div[1]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#check on number of employees 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="cs-EmployeeSize"]')
rs(1,2)
webElem$clickElement()
rs(20,23) #needs more time to load and show up results 

#click on the number of employees needed
#5-9
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[2]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#10-19
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[3]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#20-49
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[4]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#50-99
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[5]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#100-249
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[6]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#250-499
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[7]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#500-999
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[8]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#check only Privately Owned Companies 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="cs-HoldingStatus"]')
rs(1,2)
webElem$clickElement()
rs(15,18)

#check on only Privately Owned companies 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="Private"]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#view results GREEN button                                                                              
webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[1]/div[3]/div/a[1]')
webElem$clickElement()
rs(4,5)








#save search criterias
#webElem <- remDr$findElement(using = 'xpath', '//*[@id="searchResults"]/div[1]/div/ul/li[9]/a')
#webElem$clickElement()
#rs(4,5)

webElem1 <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[1]/ul[1]/li[1]/span')

#598
tp <- as.integer(gh(opt="text",xpath='//*[@id="searchResults"]/div[1]/div/div[1]/div[1]/span[2]'))
m <- seq(1,tp, by = 10)
n <- seq(1,tp, by = 10)
n <- as.character(n)
ed <- length(n) #the position of the last number in the sequence
m[ed] #the last number
pl <- (ed - 1)

#do first for the first 4 times 
foreach (i = 1:4) %do% {
  #find where to input pages 
  webElem <-
    remDr$findElement(using = 'xpath',
                      '//*[@id="searchResults"]/div[1]/div/div[1]/div[2]/div[2]')
  rs(5, 8)
  webElem$clickElement()
  
  #input page you want 
  webElem <-
    remDr$findElement(using = 'xpath',
                      '//*[@id="searchResults"]/div[1]/div/div[1]/div[2]/input')
  rs(1, 2)
  webElem$sendKeysToElement(list(n[i], "\uE007"))
  rs(5, 8)
  
  
  
  #select all of the companies on the page by check the vlue box 10 times 
  checkBox <- function(webElem4) {
    webElem4 <-
      remDr$findElement(using = 'xpath', '//*[@id="checkboxCol"]')
    rs(2, 5)
    webElem4$clickElement()
    rs(5, 10)
    
    webElem4 <-  
      remDr$findElement(using = 'xpath', '//*[@id="searchResults"]/div[1]/div/div[1]/div[2]/div[3]')
    rs(2, 5)
    webElem4$clickElement()
    rs(5, 10)
  }
  
  #select 10 pages in a row by clicking next button
  
  foreach(i = 1:10) %do% {
    checkBox(webElem[i])
  }
  
  rs(5,10)
  
  #go to download
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="searchResults"]/div[1]/div/ul/li[6]/a')
  webElem$clickElement()
  rs(2,5)
  
  #find and click the detailed
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="detailDetail"]')
  rs(5,10)
  webElem$clickElement()
  rs(2,5)
  
  #download
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="downloadForm"]/div[3]/a[1]/span/span')
  rs(5,10)
  webElem$clickElement()
  rs(1,2)
  
  #Click the back button
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[1]/ul/li[1]/a')
  rs(1,2)
  webElem$clickElement()
  rs(5,10)
  
  #click the revise search button and wait for like 15 seconds  
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[1]/ul[2]/li[1]/a')
  rs(1,2)
  webElem$clickElement()
  rs(15,20)
  
  #click again view results 
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[2]/div[3]/div/a[1]')
  rs(1,2)
  webElem$clickElement()
  rs(15,20)
}




################################################################
################################################################


revpn()

i_st <- seq(5,pl, by = 3)
j <- length(i_st)
u <- seq(5,pl, by = 3)
sl <- length(u)

if (sl > 1) {

foreach(st = i_st) %do%{
  
  system("kill -9 $(lsof -t -i:4559 -sTCP:LISTEN)")
  rd <- rsDriver(browser="chrome",chromever = "83.0.4103.39", port=4559L)

  remDr <- rd$client
  remDr$navigate("https://www.duckduckgo.com")
  
  

remDr$navigate("https://library.cityoflewisville.com/digital-library/research-tools")
webElem <- remDr$findElement(using = 'xpath', '//*[@id="widget_4_3285_3377"]/table/tbody/tr[11]/td[1]/a/img')
rs(1,2)
webElem$clickElement()
rs(1,2)

#switch windows
myswitch <- function (remDr, windowId) 
{
  qpath <- sprintf("%s/session/%s/window", remDr$serverURL, 
                   remDr$sessionInfo[["id"]])
  remDr$queryRD(qpath, "POST", qdata = list(handle = windowId))
}
windows_handles <- remDr$getWindowHandles()
myswitch(remDr, windows_handles[[2]])
rs(2,3)

#click the agree button
webElem <- remDr$findElement(using = 'xpath', '//*[@id="chkAgree"]')
rs(1,2)
webElem$clickElement()
rs(2,3)

#click continue
webElem <- remDr$findElement(using = 'xpath', '//*[@id="TACForm"]/fieldset/div/ul/li[2]/div/a[2]/span/span')
rs(1,2)
webElem$clickElement()
rs(1,2)


sample <- sample(100000:999999, 1)
sample

webElem <- remDr$findElement(using = 'xpath', '//*[@id="matchcode"]')
webElem$clickElement()
rs(2,5)
webElem$sendKeysToElement(list(paste(sample)))
rs(2,5)
webElem <- remDr$findElement(using = 'xpath', '//*[@id="logOn"]/form/fieldset/div[3]/a/span/span')
webElem$clickElement()
rs(2,5)

#click on the search button 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/ul/li[1]/ul/li[1]/a')
webElem$clickElement()
rs(2,5)

#click on advanced search button 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="searchOptions"]/ul/li[2]/a')
webElem$clickElement()
rs(2,5)

#click on the NAISC/SIC check box 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="cs-YellowPageHeadingOrSic"]')
webElem$clickElement()
rs(2,5)

#click on search primary NAICS Only 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="naicsPrimaryOptionId"]')
webElem$clickElement()
rs(2,5)

#clear result
webElem <- remDr$findElement(using = 'xpath', '//*[@id="phYellowPageHeadingOrSic"]/div/div[2]/div/fieldset/div[10]/a')
rs(1,2)
webElem$clickElement()
rs(1,2)
#Input Code
webElem <- remDr$findElement(using = 'xpath', '//*[@id="naicsLookupKeyword"]')
rs(1,2)
webElem$clickElement()
rs(2,5)
webElem$sendKeysToElement(list(code, "\uE007"))
rs(2,5)

#Select all the elements in the result
#click the view 2-6 button 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="NaicsViewButtonLabel"]')
rs(2,5)
webElem$clickElement()
rs(20,23) #it take a lot of time to load so it needs more time 

#click at that row that has the needed initials of the code.
#####It only works if it is the first coupel of initial digits not the full code
codeN <- as.numeric(code)
codeN <- nchar(codeN)
codeL <- codeN - 1
xp <- glue('//*[@id="naicsKeyword"]/ul/li[{codeL}]')
webElem <- remDr$findElement(using = 'xpath', xp )
rs(2,5)
webElem$clickElement()
rs(2,5)


#Input State

#check on the box City/State 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="cs-CityState"]')
rs(1,2)
webElem$clickElement()
rs(20,23) #it takes a lot of time to load so it needs more time the state option to show up 

#input the state into the box
webElem <- remDr$findElement(using = 'xpath', '//*[@id="filterCityState"]')
rs(1,2)
webElem$clickElement()
rs(1,2)
webElem$sendKeysToElement(list(State, "\uE007"))
rs(2,5)
#click on go 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="SearchCityState"]/span/span')
rs(1,2)
webElem$clickElement()
rs(1,2)

#click on the first option avaiable. Make sure the state is spelled out; no abreviation
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableCityState"]/ul/li/div[1]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#check on number of employees 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="cs-EmployeeSize"]')
rs(1,2)
webElem$clickElement()
rs(20,23) #needs more time to load and show up results 

#click on the number of employees needed
#5-9
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[2]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#10-19
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[3]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#20-49
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[4]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#50-99
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[5]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#100-249
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[6]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#250-499
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[7]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#500-999
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[8]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#check only Privately Owned Companies 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="cs-HoldingStatus"]')
rs(1,2)
webElem$clickElement()
rs(15,18)

#check on only Privately Owned companies 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="Private"]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#view results GREEN button                                                                              
webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[2]/div[3]/div/a[1]')
webElem$clickElement()
rs(4,5)

webElem1 <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[1]/ul[1]/li[1]/span')

#598

#do for the rest 

for (f in 1:sl) {
  for (i in st:(u[f+1] - 1)) {
  #find where to input pages 
  webElem <-
    remDr$findElement(using = 'xpath',
                      '//*[@id="searchResults"]/div[1]/div/div[1]/div[2]/div[2]')
  rs(5, 8)
  webElem$clickElement()
  
  #input page you want 
  webElem <-
    remDr$findElement(using = 'xpath',
                      '//*[@id="searchResults"]/div[1]/div/div[1]/div[2]/input')
  rs(1, 2)
  webElem$sendKeysToElement(list(n[i], "\uE007"))
  rs(5, 8)
  
  
  
  #select all of the companies on the page by check the vlue box 10 times 
  checkBox <- function(webElem4) {
    webElem4 <-
      remDr$findElement(using = 'xpath', '//*[@id="checkboxCol"]')
    rs(2, 5)
    webElem4$clickElement()
    rs(5, 10)
    
    webElem4 <-  
      remDr$findElement(using = 'xpath', '//*[@id="searchResults"]/div[1]/div/div[1]/div[2]/div[3]')
    rs(2, 5)
    webElem4$clickElement()
    rs(5, 10)
  }
  
  #select 10 pages in a row by clicking next button
  
  foreach(i = 1:10) %do% {
    checkBox(webElem[i])
  }
  
  rs(5,10)
  
  #go to download
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="searchResults"]/div[1]/div/ul/li[6]/a')
  webElem$clickElement()
  rs(2,5)
  
  #find and click the detailed
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="detailDetail"]')
  rs(5,10)
  webElem$clickElement()
  rs(2,5)
  
  #download
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="downloadForm"]/div[3]/a[1]/span/span')
  rs(5,10)
  webElem$clickElement()
  rs(1,2)
  
  #Click the back button
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[1]/ul/li[1]/a')
  rs(1,2)
  webElem$clickElement()
  rs(5,10)
  
  #click the revise search button and wait for like 15 seconds  
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[1]/ul[2]/li[1]/a')
  rs(1,2)
  webElem$clickElement()
  rs(15,20)
  
  #click again view results 
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[2]/div[3]/div/a[1]')
  rs(1,2)
  webElem$clickElement()
  rs(15,20)

}
}
}
}

system("kill -9 $(lsof -t -i:4561 -sTCP:LISTEN)")
rd <- rsDriver(browser="chrome",chromever = "83.0.4103.39", port=4561L)

remDr <- rd$client
remDr$navigate("https://www.duckduckgo.com")

#click on reference USA from the research tools

remDr$navigate("https://library.cityoflewisville.com/digital-library/research-tools")
webElem <- remDr$findElement(using = 'xpath', '//*[@id="widget_4_3285_3377"]/table/tbody/tr[11]/td[1]/a/img')
rs(1,2)
webElem$clickElement()
rs(1,2)

#switch windows
myswitch <- function (remDr, windowId) 
{
  qpath <- sprintf("%s/session/%s/window", remDr$serverURL, 
                   remDr$sessionInfo[["id"]])
  remDr$queryRD(qpath, "POST", qdata = list(handle = windowId))
}
windows_handles <- remDr$getWindowHandles()
myswitch(remDr, windows_handles[[2]])
rs(2,3)

#click the agree button
webElem <- remDr$findElement(using = 'xpath', '//*[@id="chkAgree"]')
rs(1,2)
webElem$clickElement()
rs(2,3)

#click continue
webElem <- remDr$findElement(using = 'xpath', '//*[@id="TACForm"]/fieldset/div/ul/li[2]/div/a[2]/span/span')
rs(1,2)
webElem$clickElement()
rs(1,2)


sample <- sample(100000:999999, 1)
sample

webElem <- remDr$findElement(using = 'xpath', '//*[@id="matchcode"]')
webElem$clickElement()
rs(2,5)
webElem$sendKeysToElement(list(paste(sample)))
rs(2,5)
webElem <- remDr$findElement(using = 'xpath', '//*[@id="logOn"]/form/fieldset/div[3]/a/span/span')
webElem$clickElement()
rs(2,5)

#click on the search button 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/ul/li[1]/ul/li[1]/a')
webElem$clickElement()
rs(2,5)

#click on advanced search button 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="searchOptions"]/ul/li[2]/a')
webElem$clickElement()
rs(2,5)

#click on the NAISC/SIC check box 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="cs-YellowPageHeadingOrSic"]')
webElem$clickElement()
rs(2,5)

#click on search primary NAICS Only 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="naicsPrimaryOptionId"]')
webElem$clickElement()
rs(2,5)

#clear result
webElem <- remDr$findElement(using = 'xpath', '//*[@id="phYellowPageHeadingOrSic"]/div/div[2]/div/fieldset/div[10]/a')
rs(1,2)
webElem$clickElement()
rs(1,2)
#Input Code
webElem <- remDr$findElement(using = 'xpath', '//*[@id="naicsLookupKeyword"]')
rs(1,2)
webElem$clickElement()
rs(2,5)
webElem$sendKeysToElement(list(code, "\uE007"))
rs(2,5)

#Select all the elements in the result
#click the view 2-6 button 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="NaicsViewButtonLabel"]')
rs(2,5)
webElem$clickElement()
rs(20,23) #it take a lot of time to load so it needs more time 

#click at that row that has the needed initials of the code.
#####It only works if it is the first coupel of initial digits not the full code
codeN <- as.numeric(code)
codeN <- nchar(codeN)
codeL <- codeN - 1
xp <- glue('//*[@id="naicsKeyword"]/ul/li[{codeL}]')
webElem <- remDr$findElement(using = 'xpath', xp )
rs(2,5)
webElem$clickElement()
rs(2,5)


#Input State
#check on the box City/State 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="cs-CityState"]')
rs(1,2)
webElem$clickElement()
rs(20,23) #it takes a lot of time to load so it needs more time the state option to show up 

#input the state into the box
webElem <- remDr$findElement(using = 'xpath', '//*[@id="filterCityState"]')
rs(1,2)
webElem$clickElement()
rs(1,2)
webElem$sendKeysToElement(list(State, "\uE007"))
rs(2,5)
#click on go 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="SearchCityState"]/span/span')
rs(1,2)
webElem$clickElement()
rs(1,2)

#click on the first option avaiable. Make sure the state is spelled out; no abreviation
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableCityState"]/ul/li/div[1]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#check on number of employees 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="cs-EmployeeSize"]')
rs(1,2)
webElem$clickElement()
rs(20,23) #needs more time to load and show up results 

#click on the number of employees needed
#5-9
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[2]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#10-19
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[3]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#20-49
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[4]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#50-99
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[5]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#100-249
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[6]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#250-499
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[7]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#500-999
webElem <- remDr$findElement(using = 'xpath', '//*[@id="availableEmployeeSize"]/ul/li[8]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#check only Privately Owned Companies 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="cs-HoldingStatus"]')
rs(1,2)
webElem$clickElement()
rs(15,18)

#check on only Privately Owned companies 
webElem <- remDr$findElement(using = 'xpath', '//*[@id="Private"]')
rs(1,2)
webElem$clickElement()
rs(1,2)

#view results GREEN button                                                                              
webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[2]/div[3]/div/a[1]')
webElem$clickElement()
rs(4,5)

#save search criterias
#webElem <- remDr$findElement(using = 'xpath', '//*[@id="searchResults"]/div[1]/div/ul/li[9]/a')
#webElem$clickElement()
#rs(4,5)

webElem1 <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[1]/ul[1]/li[1]/span')


### Just for the last couple of pages ###
ls1 <- n[u[sl]] # the last number in the sequence
ls <- n[u[sl]]
ls <- as.numeric(ls)
h <- abs(tp - ls)
mn <- (1:h) + ls - 1
m1 <- seq(mn[1],tp, by = 10)
n1 <- seq(mn[1],tp, by = 10)
n1 <- as.character(n1)
ed1 <- length(n1) #the position of the last number in the sequence
m[ed1] #the last number

foreach (i = 1:ed1) %do% {
  #find where to input pages 
  webElem <-
    remDr$findElement(using = 'xpath',
                      '//*[@id="searchResults"]/div[1]/div/div[1]/div[2]/div[2]')
  rs(5, 8)
  webElem$clickElement()
  
  #input page you want 
  webElem <-
    remDr$findElement(using = 'xpath',
                      '//*[@id="searchResults"]/div[1]/div/div[1]/div[2]/input')
  rs(1, 2)
  webElem$sendKeysToElement(list(n1[i], "\uE007"))
  rs(5, 8)
  
  
  
  #select all of the companies on the page by check the vlue box 10 times 
  
    checkBox <- function(webElem4) {
    webElem4 <-
      remDr$findElement(using = 'xpath', '//*[@id="checkboxCol"]')
    rs(2, 5)
    webElem4$clickElement()
    rs(5, 10)
    
    webElem4 <-  
      remDr$findElement(using = 'xpath', '//*[@id="searchResults"]/div[1]/div/div[1]/div[2]/div[3]')
    rs(2, 5)
    webElem4$clickElement()
    rs(5, 10)
  }
  
  #select 10 pages in a row by clicking next button
    if (i < ed1) { 
  foreach(i = 1:10) %do% {
    checkBox(webElem[i])
  } 
    }  else {
      kj = abs(tp - m1[ed1])
      b = kj+1
      foreach(i = 1:(b)) %do% {
        checkBox(webElem[i])
      } 
    }
  rs(5,10)
  
  #go to download
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="searchResults"]/div[1]/div/ul/li[6]/a')
  webElem$clickElement()
  rs(2,5)
  
  #find and click the detailed
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="detailDetail"]')
  rs(5,10)
  webElem$clickElement()
  rs(2,5)
  
  #download
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="downloadForm"]/div[3]/a[1]/span/span')
  rs(5,10)
  webElem$clickElement()
  rs(1,2)
  
  #Click the back button
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[1]/ul/li[1]/a')
  rs(1,2)
  webElem$clickElement()
  rs(5,10)
  
  #click the revise search button and wait for like 15 seconds  
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[1]/ul[2]/li[1]/a')
  rs(1,2)
  webElem$clickElement()
  rs(15,20)
  
  #click again view results 
  webElem <- remDr$findElement(using = 'xpath', '//*[@id="dbSelector"]/div/div[2]/div[2]/div[3]/div/a[1]')
  rs(1,2)
  webElem$clickElement()
  rs(15,20)
}
