* 2019_cross_eu_silc_r_ver_2023_release2_v2.do 
*
* STATA Command Syntax File
* Stata 17.0;
*
* Transforms the EU-SILC CSV-data (as released by Eurostat) into a Stata systemfile
* Update:
* Update of missing value labels
* Including DOI
* 
* EU-SILC Cross 2019 - release 2023-release2 / DOI: 10.2907/EUSILC2004-2022V1
*
* When publishing statistics derived from the EU-SILC UDB, please state as source:
* "EU-SILC <Type> UDB <yyyy> - version of 2023-release2"
*
* Personal register file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_c*country_stub*19R.csv
* 
* (c) GESIS 2024-07-08
*
* PLEASE NOTE
* For Differences between data as described in the guidelines
* and the anonymised user database as well as country specific anonymisation measures see:
* C-2019 DIFFERENCES BETWEEN DATA COLLECTED.doc	
* 
* This Stata-File is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
* 
* You should have received a copy of the GNU Affero General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
*
* Pforr, Klaus, Johanna Jung and Carl Riemann (2024): 2019_cross_eu_silc_r_ver_2023_release2_v2.do, 1st update.
* Stata-Syntax for transforming EU-SILC csv data into a Stata-Systemfile.
*
* https://www.gesis.org/gml/european-microdata/eu-silc/
*
* Contact: klaus.pforr@gesis.org


/* Initialization commands */

clear 
capture log close
set more off
set linesize 250
set varabbrev off
#delimit ;


* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;
* CONFIGURATION SECTION - Start ;

* The following command should contain the complete path and
* name of the Stata log file.
* Change LOG_FILENAME to your filename ; 

local log_file "$log/eusilc_2019_r" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2020) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2019_r_cs" ;

* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 

tempfile temp ;
save `temp', emptyok ;

foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HR HU IE /*IS*/ IT LT LU LV MT NL NO PL PT RO RS SE SI SK /*UK*/ { ;
      cd "$csv_path/`CC'/2019" ;
	  import delimited using "UDB_c`CC'19R.csv", case(upper) asdouble clear ;
	  append using `temp', force ;
save `temp', replace  ;
} ;

* Countries in data file are sorted in alphanumeric order ;
sort RB020 ;

log using "`log_file'", replace text ;

* Definition of variable labels ;
label variable RB010 "Year of the survey" ;
label variable RB020 "Country alphanumeric" ;
label variable RB030 "Personal ID" ;
label variable RB031 "Year of immigration - grouped in 5 year classes (DE, IS, MT, SI: missing)" ;
label variable RB031_F "Flag" ;
label variable RB050 "Personal cross-sectional weight" ;
label variable RB050_F "Flag" ;
label variable RB070 "Quarter of birth (DE, IE, MT, NL, SI, UK: missing)" ;
label variable RB070_F "Flag" ;
label variable RB080 "Year of birth (DE: Age group pertubation and bottom coding; MT: 5 yr groups)" ;
label variable RB080_F "Flag" ;
label variable RB090 "Sex (DE, SI: in same sex HH: recoded gender)" ;
label variable RB090_F "Flag" ;
label variable RB200 "Residential status" ;
label variable RB200_F "Flag" ;
label variable RB210 "Basic activity status" ;
label variable RB210_F "Flag" ;
label variable RB220 "Father ID" ;
label variable RB220_F "Flag" ;
label variable RB230 "Mother ID" ;
label variable RB230_F "Flag" ;
label variable RB240 "Spouse/Partner ID" ;
label variable RB240_F "Flag" ;
label variable RB245 "Respondent status" ;
label variable RB245_F "Flag" ;
label variable RB250 "Data status" ;
label variable RB250_F "Flag" ;
label variable RB260 "Type of interview" ;
label variable RB260_F "Flag" ;
label variable RB270 "Personal ID of proxy" ;
label variable RB270_F "Flag" ;
label variable RL010 "Education at pre-school: hours of education during an usual week" ;
label variable RL010_F "Flag" ;
label variable RL020 "Education at compulsory school: hours of education during an usual week" ;
label variable RL020_F "Flag" ;
label variable RL030 "Childcare at centre-based services: hours of child care during an usual week" ;
label variable RL030_F "Flag" ;
label variable RL040 "Childcare at day-care centre: hours of child care during an usual week" ;
label variable RL040_F "Flag" ;
label variable RL050 "Chldc. by prof. child-minder: h of chi. care drng us. week (MT: mis. if RL050>0)" ;
label variable RL050_F "Flag" ;
label variable RL060 "Childc. by grand-parents/o. hhld members/relatives etc: h during an usual week" ;
label variable RL060_F "Flag" ;
label variable RL070 "Children cross-sectional weight for child care" ;
label variable RL070_F "Flag" ;
label variable RX010 "Age at the date of the interview (DE: age group pertubation, MT: missing)" ;
label variable RX020 "Age at the end of the income reference period (DE: age group pert., MT: mis.)" ;
label variable RX030 "Household ID" ;
label variable RX040 "Work intensity" ;
label variable RX050 "Low work intensity status";
label variable RX060 "Severely materially deprived household";
label variable RX070 "At risk of poverty or social exclusion";

* ad-hoc module: Households grid (only available for BE, EE, EL, ES, FI, NL, PT);
label variable RB032 "Sequential number of the persons in the household (OPTIONAL)";
label variable RB032_F "Flag";

forvalues i = 1(1)20 { ;
label variable RG_`i' "Person `i' (OPTIONAL)";
label variable RG_`i'_F "Flag";
} ;



* Definition of category labels ;
label define RB031_VALUE_LABELS
2019 "2015 - 2019"  
2014 "2010 - 2014"   
2009 "2005 - 2009"  
2004 "2000 - 2004"   
1999 "1995 - 1999"  
1994 "1990 - 1994"  
1989 "1985 - 1989"   
1984 "1980 - 1984"   
1979 "1975 - 1979"   
1974 "1970 - 1974"   
1969 "1965 - 1969"  
1964 "1960 - 1964"   
1959 "1955 - 1959"   
1954 "1950 - 1954"   
1949 "1945 - 1949"   
1944 "1940 - 1944"   
1939 "<=1939" 
;
label define RB031_F_VALUE_LABELS  
1 "Filled"
-1 "Missing"
-2 "Not applicable (no immigration for the person)"
;
label define RB050_F_VALUE_LABELS           
1 "Filled"
-2 "Not applicable (RB110 not equal to 1, 2, 3 or 4)"
-7 "Not applicable RB010 not equal last year"
;
label define RB070_VALUE_LABELS             
1 "January, February, March"
2 "April, May, June"
3 "July, August, September"
4 "October, November, December"
;
label define RB070_F_VALUE_LABELS           
1 "Filled"
-1 "Missing"
;
label define RB080_VALUE_LABELS            
1938 "1938 or before"
1939 "PT: 1939 and before"
1943 "MT: 1939-1943"
1945 "DE: 1945 & before"
1948 "MT: 1944-1948"
1953 "MT: 1949-1953"
1958 "MT: 1954-1958"
1963 "MT: 1959-1963"
1968 "MT: 1964-1968"
1973 "MT: 1969-1973"
1978 "MT: 1974-1978"
1983 "MT: 1979-1983"
1988 "MT: 1984-1988"
1993 "MT: 1989-1993"
1998 "MT: 1994-1998"
2003 "MT: 1999-2003"
2008 "MT: 2004-2008"
2013 "MT: 2009-2013"
2019 "MT: 2014-2019"
;
label define RB080_F_VALUE_LABELS           
1 "Filled"
-1 "Missing" 
;
label define RB090_VALUE_LABELS             
1 "Male"
2 "Female"
;
label define RB090_F_VALUE_LABELS           
1 "Filled"
-1 "Missing"
;
label define RB200_VALUE_LABELS             
1 "Currently living in the household"
2 "Temporarily absent"
;
label define RB200_F_VALUE_LABELS           
1 "Filled"      
-1 "Missing"
-2 "Not applicable (RB110 not = 1, 2, 3 or 4)"
;
label define RB210_VALUE_LABELS             
1 "At work"
2 "Unemployed"
3 "In retirement or early retirement"
4 "Other inactive person"
;
label define RB210_F_VALUE_LABELS           
1 "Filled"      
-1 "Missing"
-2 "Not applicable (RB110 not = 1, 2, 3 or 4)"
;
label define RB220_F_VALUE_LABELS           
1 "Filled"      
-1 "Missing" 
-2 "Not applicable (father is not a household member) or (RB110 not = 1, 2, 3 or 4)"
;
label define RB230_F_VALUE_LABELS           
1 "Filled"      
-1 "Missing" 
-2 "Not applicable (mother is not a household member) or (RB110 not = 1, 2, 3 or 4)"
;
label define RB240_F_VALUE_LABELS            
1 "Filled"      
-1 "Missing" 
-2 "Not applicable (spouse/partner is not a household member) or (RB110 not = 1,2, 3 or 4)"
; 
label define RB245_VALUE_LABELS              
1 "Current household member aged 16 and over (all hm aged 16+ interviewed)"
2 "Selected respondent (only selected hm aged 16+ interviewed)"
3 "Not selected respondent(only selected hm aged 16+ interviewed)"
4 "Not eligible person(Hm aged less than 16)"
;
label define RB245_F_VALUE_LABELS            
1 "Filled"
-2 "Not applicable (RB110 not = 1, 2, 3 or 4)"
;
label define RB250_VALUE_LABELS             
11 "Information only completed from interview (information or interview completed)"
12 "Information only completed from registers(information or interview completed)"
13 "Information completed from both: interview and registers(information or interview completed)"
14 "Information completed from full-record imputation (information or interview completed)"
21 "Individual unable to respond and no proxy possible(Interview not completed though contact made)"
22 "Failed to return self-completed questionnaire (Interview not completed though contact made)"
23 "Refusal to cooperate(Interview not completed though contact made)"
31 "Individual not contacted because temporarily away and no proxy possible"
32 "Individual not contacted  for other reasons"
33 "Information not completed: reason unknown"
;
label define RB250_F_VALUE_LABELS            
1 "Filled"
-2 "Not applicable (RB245 not = 1,2 or 3)"
;
label define RB260_VALUE_LABELS              
1 "Face to face interview-PAPI"
2 "Face to face interview-CAPI"
3 "CATI, telephone interview"
4 "Self-administered by respondent"
5 "Proxy interview (RB010<2014); Computer assisted web interviewing-CAWI (RB010>2013)"
6 "Face to face interview-PAPI with proxy"
7 "Face to face interview-CAPI with proxy"
8 "CATI, telephone interview with proxy"
9 "Self-administered by respondent with proxy"
10 "Computer assisted web interviewing-CAWI with proxy"
;
label define RB260_F_VALUE_LABELS           
1 "Filled"
-1 "Missing"
-2 "Not applicable (RB250 not=11 or 13)" 
;
label define RB270_F_VALUE_LABELS            
1 "Filled"
-1 "Missing"
-2 "Not applicable (RB260 not=5)"
;
label define RL010_F_VALUE_LABELS            
1 "Filled"
-1 "Missing"
-2 "Not applicable (person not admitted to pre-school because of her age)"
;
label define RL020_F_VALUE_LABELS           
1 "Filled"
-1 "Missing"
-2 "Not applicable (person is not admitted to compulsory school)"
;
label define RL030_F_VALUE_LABELS            
1 "Filled"
-1 "Missing"
-2 "Not applicable (person is neither at pre-school nor at school or is more than twelve years old" 
;     
label define RL040_F_VALUE_LABELS            
1 "Filled"
-1 "Missing"
-2 "Not applicable (person is more than twelve years old)"
;
label define RL050_F_VALUE_LABELS            
1 "Filled"
-1 "Missing"
-2 "Not applicable (person is more than twelve years old)"
;
label define RL060_F_VALUE_LABELS           
1 "Filled"
-1 "Missing"
-2 "Not applicable (person is more than twelve years old)"
;
label define RL070_F_VALUE_LABELS            
1 "Filled"
-2 "Not applicable (persons age more than 12 years old at the date of interview)"
;
label define RX010_VALUE_LABELS             
74 "DE: 74 and over"
80 "80 or over"
;
label define RX020_VALUE_LABELS             
73 "DE: 73 and over"
80 "80 or over"
;
label define RX050_VALUE_LABELS
0 "No low work intensity"
1 "Low work intensity"
2 "Not applicable"
;
label define RX060_VALUE_LABELS
0 "Not severely deprived"
1 "Severely deprived"
;
label define RX070_VALUE_LABELS
000 "Not ARP/not severely materially deprived/no low work intensity"
001 "Not ARP/not severely materially deprived/low work intensity"
010 "Not ARP/severely materially deprived/no low work intensity"
011 "Not ARP/severely materially deprived/low work intensity"
100 "ARP/not severely materially deprived/no low work intensity"
101 "ARP/not severely materially deprived/low work intensity"
110 "ARP/severely materially deprived/no low work intensity"
111 "ARP/severely materially deprived/low work intensity"
;

* Ad-hoc module: Household grid ;

label define RB032_F_VALUE_LABELS 
1 "Filled"
-1 "Missing"
-2 "Not applicable (single person household)"
-7 "Not applicable (RB032 not 2019)"
-8 "Not applicable (variable not collected)"
;
label define RG_Z_VALUE_LABELS
10 "Partner (Low level)"
11 "Husband/wife/civil partner (High level)"
12 "Partner/cohabitee(High level)"
20 "Son/daughter (low level)"
21 "Natural/Adopted son/daughter (high level)"
22 "Step-son/step-daughter (high level)"
30 "Son-in-law/daughter-in-law (low, high level)"
40 "Grandchild (low, high level)"
50 "Parent(low level)"
51 "Natural/adoptive parent (high level)"
52 "Step-parent (high level)"
60 "Parent in law (low, high level)"
70 "Grandparent (low, high level)"
80 "Brother/Sister (low level)"
81 "Natural brother/sister (high level)"
82 "Step-brother/Sister (high level)"
90 "Other relative (low, high level)"
95 "Other non-relative (low, high level)"
-1 "Not stated (low, high level)"
;
label define RG_Z_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "Not applicable (one person household or respondent)"
-4 "Not applicable for the variable RG_Z where Z is higher than the number of household members in this household"
-5 "Not applicable for the variable RG_Z where information is already provided in the symmetrical part of grid" 
-7 "Not applicable (RB010 not 2019)"
-8 "Not applicable (variable not collected)"
;

* Attachement of category labels to variable ;

label values RB031 RB031_VALUE_LABELS ;
label values RB031_F RB031_F_VALUE_LABELS ;
label values RB050_F RB050_F_VALUE_LABELS ;
label values RB070 RB070_VALUE_LABELS ;
label values RB070_F RB070_F_VALUE_LABELS ;
label values RB080 RB080_VALUE_LABELS ;
label values RB080_F RB080_F_VALUE_LABELS ;
label values RB090 RB090_VALUE_LABELS ;
label values RB090_F RB090_F_VALUE_LABELS ;
label values RB200 RB200_VALUE_LABELS ;
label values RB200_F RB200_F_VALUE_LABELS ;
label values RB210 RB210_VALUE_LABELS ;
label values RB210_F RB210_F_VALUE_LABELS ;
label values RB220_F RB220_F_VALUE_LABELS ;
label values RB230_F RB230_F_VALUE_LABELS ;
label values RB240_F RB240_F_VALUE_LABELS ;
label values RB245 RB245_VALUE_LABELS ;
label values RB245_F RB245_F_VALUE_LABELS ;
label values RB250 RB250_VALUE_LABELS ;
label values RB250_F RB250_F_VALUE_LABELS ;
label values RB260 RB260_VALUE_LABELS ;
label values RB260_F RB260_F_VALUE_LABELS ;
label values RB270_F RB270_F_VALUE_LABELS ;
label values RL010_F RL010_F_VALUE_LABELS ;
label values RL020_F RL020_F_VALUE_LABELS ;
label values RL030_F RL030_F_VALUE_LABELS ;
label values RL040_F RL040_F_VALUE_LABELS ;
label values RL050_F RL050_F_VALUE_LABELS ;
label values RL060_F RL060_F_VALUE_LABELS ;
label values RL070_F RL070_F_VALUE_LABELS ;
label values RX010 RX010_VALUE_LABELS ;
label values RX020 RX020_VALUE_LABELS ;
label values RX050 RX050_VALUE_LABELS ;
label values RX060 RX060_VALUE_LABELS ;
label values RX070 RX070_VALUE_LABELS ;
label values RB032_F RB032_F_VALUE_LABELS ;
label values RG_1 RG_2 RG_3 RG_3 RG_4 RG_5 RG_6 RG_7 RG_8 RG_9 RG_10 ///
             RG_11 RG_12 RG_13 RG_14 RG_15 RG_16 RG_17 RG_18 RG_19 RG_20 RG_Z_VALUE_LABELS ;
label values RG_1_F RG_2_F RG_3_F RG_4_F RG_5_F RG_6_F RG_7_F RG_8_F RG_9_F RG_10_F ///
             RG_11_F RG_12_F RG_13_F RG_14_F RG_15_F RG_16_F RG_17_F RG_18_F RG_19_F RG_20_F RG_Z_F_VALUE_LABELS ;


label data "Personal register file 2018" ;

compress ;
save "`stata_file'", replace ;

log close ;
set more on
#delimit cr



