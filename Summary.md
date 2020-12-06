
**TX Franchise Data and 5500 Datasets**

<span style="text-decoration:underline">Objective:</span> to automate
the downloading process of TX Franchise Data, 5500 and 5500 SF. Filter
only companies and requested information and combine both data sets and
NAISC codes.

 

**Folder TXFranchise\_5500Data:**

Automate the downloading process and download all the files available on
the dol.gov website: (AutomateDownloading\_5500\&TX.R). If the files are
zip, unzip them in the loop. Afterwards, keep only columns that contain
useful information, replace missing number of participants in the TX
Franchise data with 0, and keep only the companies that have business
code available. Observe that the first 3 digits of the business code map
with the main NAICS code. Download dataset that contains all NAICS codes
and descriptions. Afterwards, match (join) the NAICS codes and
descriptions with the company data using strings and left join on the
first 3 numbers.

Take the number of plan participants as a rough approximation of the
number of employees in the company, and hence, its size. Compute
maximum, minimum and mean of the participants for each of the datasets.
Compute aggregate statistics of number of participants for each business
code. The tables below are computed using the TX Franchise 2018 data.

 

<table class="table" style="margin-left: auto; margin-right: auto;">

<caption>

Top 10 TX Companies with max participants

</caption>

<thead>

<tr>

<th style="text-align:left;">

</th>

<th style="text-align:left;">

CompanyName

</th>

<th style="text-align:left;">

US\_City

</th>

<th style="text-align:left;">

US\_State

</th>

<th style="text-align:left;">

Business\_Code

</th>

<th style="text-align:left;">

Number\_Of\_Participants

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

5030

</td>

<td style="text-align:left;">

AT\&T INC.

</td>

<td style="text-align:left;">

DALLAS

</td>

<td style="text-align:left;">

TX

</td>

<td style="text-align:left;">

517000

</td>

<td style="text-align:left;">

498781

</td>

</tr>

<tr>

<td style="text-align:left;">

11457

</td>

<td style="text-align:left;">

INSPERITY HOLDINGS, INC.

</td>

<td style="text-align:left;">

KINGWOOD

</td>

<td style="text-align:left;">

TX

</td>

<td style="text-align:left;">

541990

</td>

<td style="text-align:left;">

171402

</td>

</tr>

<tr>

<td style="text-align:left;">

11947

</td>

<td style="text-align:left;">

TENET HEALTHCARE CORPORATION

</td>

<td style="text-align:left;">

DALLAS

</td>

<td style="text-align:left;">

TX

</td>

<td style="text-align:left;">

622000

</td>

<td style="text-align:left;">

149059

</td>

</tr>

<tr>

<td style="text-align:left;">

10647

</td>

<td style="text-align:left;">

J.C. PENNEY CORPORATION, INC. LEGAL DEPARTMENT - MS4103

</td>

<td style="text-align:left;">

PLANO

</td>

<td style="text-align:left;">

TX

</td>

<td style="text-align:left;">

452200

</td>

<td style="text-align:left;">

113980

</td>

</tr>

<tr>

<td style="text-align:left;">

9126

</td>

<td style="text-align:left;">

AMERICAN AIRLINES, INC.

</td>

<td style="text-align:left;">

DFW AIRPORT

</td>

<td style="text-align:left;">

TX

</td>

<td style="text-align:left;">

481000

</td>

<td style="text-align:left;">

112144

</td>

</tr>

<tr>

<td style="text-align:left;">

3427

</td>

<td style="text-align:left;">

WHOLE FOODS MARKET, INC.

</td>

<td style="text-align:left;">

AUSTIN

</td>

<td style="text-align:left;">

TX

</td>

<td style="text-align:left;">

445110

</td>

<td style="text-align:left;">

102978

</td>

</tr>

</tbody>

</table>

 

<table class="table" style="margin-left: auto; margin-right: auto;">

<caption>

Max Participants in each Business Code for US

</caption>

<thead>

<tr>

<th style="text-align:left;">

Business\_Code

</th>

<th style="text-align:left;">

Mean\_Participants

</th>

<th style="text-align:left;">

Total\_Participants

</th>

<th style="text-align:left;">

Max\_Participants

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

813930

</td>

<td style="text-align:left;">

1779752

</td>

<td style="text-align:left;">

1779752

</td>

<td style="text-align:left;">

1779752

</td>

</tr>

<tr>

<td style="text-align:left;">

452300

</td>

<td style="text-align:left;">

1655031

</td>

<td style="text-align:left;">

1655031

</td>

<td style="text-align:left;">

1655031

</td>

</tr>

<tr>

<td style="text-align:left;">

442110

</td>

<td style="text-align:left;">

1042967

</td>

<td style="text-align:left;">

1042967

</td>

<td style="text-align:left;">

1042967

</td>

</tr>

<tr>

<td style="text-align:left;">

524290

</td>

<td style="text-align:left;">

778122

</td>

<td style="text-align:left;">

778122

</td>

<td style="text-align:left;">

778122

</td>

</tr>

<tr>

<td style="text-align:left;">

452200

</td>

<td style="text-align:left;">

715473

</td>

<td style="text-align:left;">

715473

</td>

<td style="text-align:left;">

715473

</td>

</tr>

<tr>

<td style="text-align:left;">

484120

</td>

<td style="text-align:left;">

585467

</td>

<td style="text-align:left;">

585467

</td>

<td style="text-align:left;">

585467

</td>

</tr>

<tr>

<td style="text-align:left;">

238210

</td>

<td style="text-align:left;">

577831

</td>

<td style="text-align:left;">

577831

</td>

<td style="text-align:left;">

577831

</td>

</tr>

<tr>

<td style="text-align:left;">

517000

</td>

<td style="text-align:left;">

498781

</td>

<td style="text-align:left;">

498781

</td>

<td style="text-align:left;">

498781

</td>

</tr>

<tr>

<td style="text-align:left;">

541110

</td>

<td style="text-align:left;">

492106

</td>

<td style="text-align:left;">

492106

</td>

<td style="text-align:left;">

492106

</td>

</tr>

<tr>

<td style="text-align:left;">

484200

</td>

<td style="text-align:left;">

461685

</td>

<td style="text-align:left;">

461685

</td>

<td style="text-align:left;">

461685

</td>

</tr>

</tbody>

</table>

 

Join the data tables from Texas Franchise 2017 and 2018 to see which
companies are in both datasets. Create a unique ID by removing all
punctuation from the company name and concatenating the company name
with EIN column. Since some companies have common EIN, I cannot use it
as a unique identifier. (MergingDataTables5500\_17and18.R)

To come to the final data tables that should be used, please look at
CompOfInterest\_5500DataSF\_TXFranchise.R and
CompOfInt\_5500Data\_TXFranchise.R.

Start with the 5500 data table: only the informative columns are kept
and if active participants at both BOY and EOY are missing these
companies are removed from the table. Only companies that have EOY
participants higher than 10 are kept. In addition, companies that have
not provided business codes are removed as well. Used grepl to extract
the first 2/3 digits of the Business Code in order to group to filter
only these companies that are in the industries of interest.

Afterwards, clean again the TX Franchise table by using the same
procedure to keep only the business codes and states of interest.

For both TX FRanchise and 5500, remove the punctuation and additional
space from the companies name and join the tables on company
name.Observe which companies are in TX Franchise but not in 5500 using
anti join.

 

**Folders in the drive and explanations:**

 

1.  <span style="text-decoration:underline">CompOf\_Int\_SF\_FilteredByBC:
    companies of the 5500 SF dataset filtered by:</span>
    
      - Companies that are in the following business codes: BC start
        with 238: (Specialty Trade Contractors); BC that start with 31,
        32, or 33 (Manufacturing); BC that start with 42 (Wholesale
        Trade); BC that start with 51 (Information); BC that start with
        48 (Transportation); BC that start with 5413
        (Architecture/engineer services); BC that start with 56
        (Administrative/Support); BC Health and Food/drinking places; BC
        that start with “811” (Repair and Maintenance);
      - Companies that have more than 10 active participants as of end
        of year
      - Companies that are in TX, OK, TN, NC, SC, AL, GA
      - CompOfInterest\_5500DataSF\_TXFranchise.R: 1 to 76

 

2.  <span style="text-decoration:underline">InBoth\_TXFranch\_5500SF\_ByBCs:</span>
    companies that are in both 5500 SF dataset and TX franchise: (5115
    observations that are in both 5500 and Texas franchise and 4914
    unique company names)
    
      - Same conditions as above
      - Only active companies
      - No nonprofit companies
      - CompOfInterest\_5500DataSF\_TXFranchise.R script: 80 to 111

 

3.  <span style="text-decoration:underline">Comp\_TXFranch\_NotIn5500SF\_BCs:</span>
    companies that are in the TX franchise data but not in the 5500 SF
    data:
    
      - CompOfInterest\_5500DataSF\_TXFranchise.R: 115 and 116
      - Keep only these companies from the dataset that have no matches
        with the 5500 but have the same specific business codes as in
        the 5500 SF data; (in the R script 112 to 165);
        CompOfInterest\_5500DataSF\_TXFranchise.R: 115 and 116

 

CompOfInterest\_5500DataSF\_TXFranchise.R script: from 172 to 227 are
the lines to create file for each of the business codes to be used for
the DoRock.

Same process for the 5500 dataset and the TX franchise.
CompOfInt\_5500Data\_TXFranchise.R. It is mainly the same codes and
process as CompOfInterest\_5500DataSF\_TXFranchise.R but names of the
data tables are changed and any other differences between 5500 and 5500
SF are accounted for.

 

**ReferenceUSA**

RScript: RefUSA\_L (1).R

Extract data for companies in the states of interest and in the
following NAICS industries:

  - Specialty Trade Contractors (“238”)
  - Manufacturing (“31”, “32”, “33”)
  - Wholesale Trade (“42”)
  - Information (“51”)
  - Transportation (“48”)
  - Architecture/Engineering (“5413”)
  - Administration and Support (“561”)
  - Healthcare/Laboratories (“6215”, “6216”)
  - Food/Drinking Places (“7223”)
  - Repair/Maintenance (“811”)
  - Downloaded info for OK, TN, AL, GA about companies in the same NAICS
    codes.
  - Merge all the data extracted and create tables for each of the
    business codes, and remove the unnecessary columns
  - Filter out companies that have website from companies that do not
    \*Predict emails based on the most used email formats for the
    companies that have websites and then verify using email verifier

 

1.  <span style="text-decoration:underline">Specified options in the
    code:</span>
    
      - NAICS primary codes
      - States
      - Number of Employees: 5-9; 10-19; 20-49; 50-99; 100-249; 250-499;
        500-999
      - Only Privately Owned Companies

 

2.  <span style="text-decoration:underline">code ← “811” and i\_st ← 1:
    </span> the NAICS code specified and the number of page to start
    downloading. Loop explained:
    
      - tp is the last page
      - n takes the total number of pages and makes a sequence by 10 (if
        tp=89 then n will be “1” “11” “21” “31” “41” “51” “61” “71”
        “81”)
      - because the total number of pages may not be a multiple of 10,
        it needs to be accounted for the last number of n because 81+10
        is not 89 so the loop goes only till 71: (71+10) and there is
        another line of codes that accounts only for the last couple of
        pages which are always less than or equal to 10.
      - ed is the position of the last number of the sequence so ed=9
        and n\[ed\] = 81
      - pl is the position before last so in this case pl is 8 and the
        loop will go for 8 times so the loop goes i = i\_st:(pl)
      - for each i, it clicks the checkbox and the arrow to go forward
        so 10 times. checkbox is the function to do that and it does it
        for each i so for 1st page it will click the checkbox than the
        arrow until it hits 11 so total of 10 times to get 250
        companies; then it will go to download, detailed and will
        download it;
      - in the R script 115 to 199

 

3.  <span style="text-decoration:underline">Extracting information from
    the last page: </span>
    
      - It takes the length of n: ed which is the last position (n\[ed\]
        = 81) and it subtracts the total pages (89) from n\[ed\] = 81 so
        in this case that will be 8 times to check the box and click the
        arrow for next; so using the checkbox function 8 times instead
        of 10 as in the loop.

 

4.  <span style="text-decoration:underline">Predict Emails for companies
    missing email information but contain website info: </span>
    
      - EmailGuess.R
      - Follow the formats: first\_initial last: <jdoe@friedmanllp.com>
        and first last names <janedoe@friedmanllp.com>  
      - Observe the executives are ranked based on importance,
        therefore, keep only the first and last names of the first 5
        executives
      - Extract only the first initial of the first name and concatenate
        with the last name, adding “@” and the website at the end, make
        the email all lowercase
      - Concatenate the first and last names of the executives, together
        with “@” and the website, make the email lowercase
      - Do the last 2 steps for each of the five executives and for each
        company in the data table
      - Use the email verifier provider to verify emails
