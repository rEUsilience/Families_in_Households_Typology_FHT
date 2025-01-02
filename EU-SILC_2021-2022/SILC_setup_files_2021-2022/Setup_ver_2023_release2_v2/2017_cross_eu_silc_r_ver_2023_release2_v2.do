* 2017_cross_eu_silc_r_ver_2023_release2_v2.do 
*
* STATA Command Syntax File
* Stata 17.0;
*
* Transforms the EU-SILC CSV-data (as released by Eurostat) into a Stata systemfile
* Update:
* Update of missing value labels
* Including DOI
* 
* EU-SILC Cross 2017 - release 2023-release2 / DOI: 10.2907/EUSILC2004-2022V1
*
* When publishing statistics derived from the EU-SILC UDB, please state as source:
* "EU-SILC <Type> UDB <yyyy> - version of 2023-release2"
*
* Personal register file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_l*country_stub*17R.csv
* 
* (c) GESIS 2024-07-08
* 
* PLEASE NOTE
* For Differences between data as described in the guidelines
* and the anonymised user database as well as country specific anonymisation measures see:
* L-2017 DIFFERENCES BETWEEN DATA COLLECTED.doc	
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
* Pforr, Klaus, Johanna Jung and Carl Riemann (2024): 2017_cross_eu_silc_r_ver_2023_release2_v2.do, 1st update.
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

local log_file "$log/eusilc_2017_r" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2020) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2017_r_cs" ;


* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 

tempfile temp ;
save `temp', emptyok ;

foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HR HU IE IS IT LT LU LV MT NL NO PL PT RO RS SE SI SK UK { ;
      cd "$csv_path/`CC'/2017" ;
	  import delimited using "UDB_c`CC'17R.csv", case(upper) asdouble clear ;
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
label variable RB080 "Year of birth (DE: Age group pertubation; MT: 5 yr groups)" ;
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
label variable RL050 "Child care by a professional child-miner: No. h of child care during usual week" ;
label variable RL050_F "Flag" ;
label variable RL060 "Child care by grnd-prnts; oth. hhld mmbrs; rltvs etc: No. of h/usual week" ;
label variable RL060_F "Flag" ;
label variable RL070 "Children cross-sectional weight for child care" ;
label variable RL070_F "Flag" ;
label variable RX010 "Age at the date of the interview (DE: age group pertubation, MT: missing)" ;
label variable RX020 "Age at the end of the income reference period (DE: age grp pertubation, MT: mis)" ;
label variable RX030 "Household ID" ;
label variable RX040 "Work intensity" ;
label variable RX050 "Low work intensity status";
label variable RX060 "Severely materially deprived household";
label variable RX070 "At risk of poverty or social exclusion";

* Ad-hoc module on health ;
label variable RC010T "General health (child)";
label variable RC010T_F "Flag";
label variable RC020T "Limitation in activities because of health problems (child)";
label variable RC020T_F "Flag";
label variable RC030T "Module child 0-15 personal weight (optional)";
label variable RC030T_F "Flag";


* Definition of category labels ;

label define RB031_VALUE_LABELS
2017 "2017 - 2013"  
2012 "2012 - 2008"   
2007 "2007 - 2003"  
2002 "2002 - 1998"   
1997 "1997 - 1993"  
1992 "1992 - 1988"  
1987 "1987 - 1983"   
1982 "1982 - 1978"   
1977 "1977 - 1973"   
1972 "1972 - 1968"   
1967 "1967 - 1963"  
1962 "1962 - 1958"   
1957 "1957 - 1953"   
1952 "1952 - 1948"   
1947 "1947 - 1943"   
1942 "1942 - 1938"   
1937 "<=1937" 
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
1936 "1936 or before"
1937 "PT: 1937 and before"
1941 "MT: 1937-1941"
1943 "DE: 1943 & before"
1946 "MT: 1942-1946"
1951 "MT: 1947-1951"
1956 "MT: 1952-1956"
1961 "MT: 1957-1961"
1966 "MT: 1962-1966"
1971 "MT: 1967-1971"
1976 "MT: 1972-1976"
1981 "MT: 1977-1981"
1986 "MT: 1982-1986"
1991 "MT: 1987-1991"
1996 "MT: 1992-1996"
2001 "MT: 1997-2001"
2006 "MT: 2002-2006"
2011 "MT: 2007-2011"
2017 "MT: 2012-2017"
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
5 "Computer assisted web interviewing-CAWI"
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
-2 "Not applicable (persons aged more than 12 years old at the date of interview)"
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

* Ad-hoc module on health ;

label define RC010T_VALUE_LABELS
1 "Very good"
2 "Good"
3 "Fair"
4 "Bad"
5 "Very bad"
;
label define RC010T_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "Not applicable: RB110 not equal to 1, 2, 3 or 4 (person is not a current household member)"
-5 "Not applicable (person is not 0 - 15 years old)"
-7 "Not applicable (RB010 not equal 2017)"
;
label define RC020T_VALUE_LABELS
1 "Severely limited"
2 "Limited but not severely"
3 "Not limited at all"
;
label define RC020T_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "Not applicable: RB110 not equal to 1, 2, 3 or 4 (person is not a current household member)"
-5 "Not applicable (person is not aged 0 - 15 years)"
-7 "Not applicable (RB010 not equal 2017)"
;
label define RC030T_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "Not applicable (RB110 not equal to 1, 2, 3 or 4) or not aged 0-15 at the time of interview"
-5 "Not applicable (person is not aged 0 - 15 years)"
-7 "Not applicable RB010 not equal last year"
;


* Attachment of category labels to variable ;

label values RB031 RB031_VALUE_LABELS ;
label values RB031_F RB031_F_VALUE_LABELS ;
label values RB050_F RB050_F_VALUE_LABELS ;
label values RX060 RX060_VALUE_LABELS ;
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
label values RX070 RX070_VALUE_LABELS ;

* Ad-hoc module on health ;
label values RC010T RC010T_VALUE_LABELS ;
label values RC010T_F RC010T_F_VALUE_LABELS ;
label values RC020T RC020T_VALUE_LABELS ;
label values RC020T_F RC020T_F_VALUE_LABELS ;
label values RC030T_F RC030T_F_VALUE_LABELS ;

label data "Personal register file 2017" ;

compress ;
save "`stata_file'", replace ;

log close ;
set more on
#delimit cr





