* 2021_cross_eu_silc_r_ver_2023_release2_v2.do 
*
* STATA Command Syntax File
* Stata 17.0;
*
* Transforms the EU-SILC CSV-data (as released by Eurostat) into a Stata systemfile
* Update:
* Update of missing value labels
* Including DOI
* 
* EU-SILC Cross 2021 - release 2023_release2 / DOI: 10.2907/EUSILC2004-2022V1
*
* When publishing statistics derived from the EU-SILC UDB, please state as source:
* "EU-SILC <Type> UDB <yyyy> - version of 2023_release2"
*
* Personal register file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_c*country_stub*21R.csv
* 
* (c) GESIS 2024-07-08
*
* PLEASE NOTE
* For Differences between data as described in the guidelines
* and the anonymised user database as well as country specific anonymisation measures see:
* C-2021 DIFFERENCES BETWEEN DATA COLLECTED.doc	
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
* Pforr, Klaus, Johanna Jung and Carl Riemann (2024): 2021_cross_eu_silc_r_ver_2023_release2_v2.do, 1st update.
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

local log_file "$log/eusilc_2021_r" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2020) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2021_r_cs" ;

* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 

tempfile temp ;
save `temp', emptyok ;

foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HR HU IE /*IS*/ IT LT LU LV MT NL /*NO*/ PL PT RO RS SE SI SK /*UK*/ { ;
      cd "$csv_path/`CC'/2021" ;
	  import delimited using "UDB_c`CC'21R.csv", case(upper) asdouble clear stringcols(2 30 34);
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
label variable RB050 "Personal cross-sectional weight" ;
label variable RB050_F "Flag" ;
label variable RB051 "Regional weight" ;
label variable RB051_F "Flag" ;
label variable RB081 "Age in completed years (at the end of income reference period) (IT,MT: removed)" ;
label variable RB081_F "Flag" ;
label variable RB082 "Age in completed years at the time of the interview (IT,MT: removed)" ;
label variable RB082_F "Flag" ;
label variable RB080 "Year of birth (MT: 5 yr groups)" ;
label variable RB080_F "Flag" ;
label variable RB090 "Sex (DE, SI: in same sex HH: recoded gender)" ;
label variable RB090_F "Flag" ;
label variable RB200 "Residential status" ;
label variable RB200_F "Flag" ;
label variable RB211 "Main activity status (self-defined)" ;
label variable RB211_F "Flag" ;
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
label variable RB280 "Country of birth (grouped) (EE,IT,LV,MT,SI: EU -> OTH)" ;
label variable RB280_F "Flag" ;
label variable RB285 "Duration of stay in the country of residence in completed years" ;
label variable RB285_F "Flag" ;
label variable RB290 "Country of main citizenship (grouped) (EE,LV,MT,SI: EU -> OTH)" ;
label variable RB290_F "Flag" ;
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
label variable RB032 "Sequential number of the persons in the household (IT: not provided)";
label variable RB032_F "Flag";
label variable RG_1 "Household grid person 1 (DE,IT: not provided)" ;
label variable RG_1_F "Flag" ;
label variable RG_2 "Household grid person 2 (DE,IT: not provided)" ;
label variable RG_2_F "Flag" ;
label variable RG_3 "Household grid person 3 (DE,IT: not provided)" ;
label variable RG_3_F "Flag" ;
label variable RG_4 "Household grid person 4 (DE,IT: not provided)" ;
label variable RG_4_F "Flag" ;
label variable RG_5 "Household grid person 5 (DE,IT: not provided)" ;
label variable RG_5_F "Flag" ;
label variable RG_6 "Household grid person 6 (DE,IT: not provided)" ;
label variable RG_6_F "Flag" ;
label variable RG_7 "Household grid person 7 (DE,IT: not provided)" ;
label variable RG_7_F "Flag" ;
label variable RG_8 "Household grid person 8 (DE,IT: not provided)" ;
label variable RG_8_F "Flag" ;
label variable RG_9 "Household grid person 9 (DE,IT: not provided)" ;
label variable RG_9_F "Flag" ;
label variable RG_10 "Household grid person 10 (DE,IT: not provided)" ;
label variable RG_10_F "Flag" ;
label variable RG_11 "Household grid person 11 (DE,IT: not provided)" ;
label variable RG_11_F "Flag" ;
label variable RG_12 "Household grid person 12 (DE,IT: not provided)" ;
label variable RG_12_F "Flag" ;
label variable RG_13 "Household grid person 13 (DE,IT: not provided)" ;
label variable RG_13_F "Flag" ;
label variable RG_14 "Household grid person 14 (DE,IT: not provided)" ;
label variable RG_14_F "Flag" ;
label variable RG_15 "Household grid person 15 (DE,IT: not provided)" ;
label variable RG_15_F "Flag" ;
label variable RG_16 "Household grid person 16 (DE,IT: not provided)" ;
label variable RG_16_F "Flag" ;
label variable RG_17 "Household grid person 17 (DE,IT: not provided)" ;
label variable RG_17_F "Flag" ;
label variable RG_18 "Household grid person 18 (DE,IT: not provided)" ;
label variable RG_18_F "Flag" ;
label variable RG_19 "Household grid person 19 (DE,IT: not provided)" ;
label variable RG_19_F "Flag" ;
label variable RG_20 "Household grid person 20 (DE,IT: not provided)" ;
label variable RG_20_F "Flag" ;
label variable RG_21 "Household grid person 21 (DE,IT: not provided)" ;
label variable RG_21_F "Flag" ;
label variable RG_22 "Household grid person 22 (DE,IT: not provided)" ;
label variable RG_22_F "Flag" ;
label variable RCH010 "General health (child)" ;
label variable RCH010_F "Flag" ;
label variable RCH020 "Limitation in activities because of health problems (child)" ;
label variable RCH020_F "Flag" ;
label variable RX010 "Age at the date of the interview (MT: missing)" ;
label variable RX020 "Age at the end of the income reference period (MT: missing, FI: perturb)" ;
label variable RX030 "Household ID" ;
label variable RX040 "Work intensity" ;
label variable RX050 "Low work intensity status";
label variable RX060 "Severely materially and socially deprived household";
label variable RX070 "At risk of poverty or social exclusion";



* Definition of category labels ;
label define RB050_F_VALUE_LABELS           
1 "Filled"
-2 "Not applicable (RB110 not equal to 1, 2, 3 or 4)"
-7 "Not applicable RB010 not equal last year"
;
label define RB051_F_VALUE_LABELS
1 "Filled"
-1 "Missing" 
;
label define RB081_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-7 "Not applicable (RB010 not equal to 2021)"
;
label define RB082_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-7 "Not applicable (RB010 not equal to 2021)"
;
label define RB080_VALUE_LABELS            
    1940 "1940 or before"
    1941 "PT: 1941 and before"
    1  "MT: 1941 or before"
    2  "MT: 1942-1946"
    3  "MT: 1947-1951"
    4  "MT: 1952-1956"
    5  "MT: 1957-1961"
    6  "MT: 1962-1966"
    7  "MT: 1967-1971"
    8  "MT: 1972-1976"
    9  "MT: 1977-1981"
    10 "MT: 1982-1986"
    11 "MT: 1987-1991"
    12 "MT: 1992-1996"
    13 "MT: 1997-2001"
    14 "MT: 2002-2006"
    15 "MT: 2007-2011"
    16 "MT: 2012-2016"
    17 "MT: 2017-2021"
;
label define RB080_F_VALUE_LABELS           
1 "Collected via survey/interview (RB010>=2021), Filled (RB010<2021)"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
;
label define RB090_VALUE_LABELS             
1 "Male"
2 "Female"
;
label define RB090_F_VALUE_LABELS           
1 "Main source is survey or interview"
2 "Main source is administrative data"
3 "Imputed"
4 "It is not possible to establish a main source"
-1 "Missing"
;
label define RB200_VALUE_LABELS             
1 "Currently living in the household"
2 "Temporarily absent"
;
label define RB200_F_VALUE_LABELS           
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
;
label define RB211_VALUE_LABELS
1 "Employed"
2 "Unemployed"
3 "Retired"
4 "Unable to work due to long-standing health problems"
5 "Student, pupil"
6 "Fulfilling domestic tasks"
7 "Compulsory military or civilian service"
8 "Other"
;
label define RB211_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
-7 "Not applicable (RB010 not equal to 2021)"
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
label define RB280_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
-7 "Not applicable (RB010 not equal to 2021)"
;
label define RB285_VALUE_LABELS
0  "0-4"
5  "5-9"
10 "10-14"
15 "15-19"
20 "20-24"
25 "25-29"
30 "30-34"
35 "35-39"
40 "40-44"
45 "45-49"
50 "50-54"
55 "55-59"
60 "60-64"
65 "65-69"
70 "70-74"
75 "75-79"
80 ">=80"
;
label define RB285_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
-2 "Not applicable (born in this country and never lived abroad for a period of at least 1 year)"
-7 "Not applicable (RB010 not equal to 2021)"
;
label define RB290_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
-7 "Not applicable (RB010 not equal to 2021)"
;
label define RL010_F_VALUE_LABELS           
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (person at pre-school because of age, at compuls school, aged 13+); (RL010>0 and RL020>0) not possible)"
;
label define RL020_F_VALUE_LABELS           
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (person not at compuls sch bec of age, at compuls school, aged 13+); (RL010>0 and RL020>0) not possible)"
;
label define RL030_F_VALUE_LABELS            
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (person not at pre-school/school, aged 12-); (RL010>0 and RL020>0) is not possible)"
;     
label define RL040_F_VALUE_LABELS            
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (person is more than twelve years old)"
;
label define RL050_VALUE_LABELS
1 "MT: 0"
2 "MT: 1-10"
3 "MT: 11-20"
4 "MT: 21+"
;
label define RL050_F_VALUE_LABELS            
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
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
-7 "Not applicable (RB010 not equal to last year of operation)"

;
label define RB032_F_VALUE_LABELS            
1 "Filled"
-1 "Missing"
-2 "Not applicable (single person household)"
-7 "Not applicable (RB010 not equal to 2021)"
;
label define RG_VALUE_LABELS
10 "Partner (low level)"
11 "Husband/wife/civil partner (high level)"
12 "Partner/cohabitee(high level)"
20 "Son/daughter (low level)"
21 "Natural/Adopted son/daughter (high level)"
22 "Step-son/step-daughter (high level)"
30 "Son-in-law/daughter-in-law (low; high level)"
40 "Grandchild (low; high level)"
50 "Parent(low level)"
51 "Natural/adoptive parent (high level)"
52 "Step-parent (high level)"
60 "Parent in law(low; high level)"
70 "Grandparent (low; high level)"
80 "Brother/Sister (low level)"
81 "Natural brother/sister (high level)"
82 "Step-brother/Sister (high level)"
90 "Other relative (low; high level)"
95 "Other non-relative (low; high level)"
-1 "Not stated (low; high level)"
;
label define RG_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
-2 "Not applicable (one person household)"
-4 "Not applicable (Number of household members less than maximum of RB032 in country level)"
-5 "Not applicable (information is already provided in the symmetrical part of grid and can be derived from there)"
-7 "Not applicable (RB010 not equal to 2021)"
;
label define RCH010_VALUE_LABELS
1 "Very good"
2 "Good"
3 "Fair (neither good nor bad)"
4 "Bad"
5 "Very bad"
;
label define RCH010_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-4 "Not applicable (person is more than 15 years old)"
-7 "Not applicable (year not equal 2017 or not equal 2021)"
;
label define RCH020_VALUE_LABELS
1 "Severely limited"
2 "Limited but not severely"
3 "Not limited at all"
;
label define RCH020_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-4 "Not applicable (person is more than 15 years old)"
-7 "Not applicable (year not equal 2017 or not equal 2021)"
;
label define RX010_VALUE_LABELS             
-1 "Missing"
80 "80 or over"
;
label define RX020_VALUE_LABELS             
-1 "Missing"
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


* Attachement of category labels to variable ;

label values RB050_F RB050_F_VALUE_LABELS ;
label values RB051_F RB051_F_VALUE_LABELS ;
label values RB081_F RB081_F_VALUE_LABELS ;
label values RB082_F RB082_F_VALUE_LABELS ;
label values RB080 RB081 RB082 RB080_VALUE_LABELS ;
label values RB080_F RB080_F_VALUE_LABELS ;
label values RB090 RB090_VALUE_LABELS ;
label values RB090_F RB090_F_VALUE_LABELS ;
label values RB200 RB200_VALUE_LABELS ;
label values RB200_F RB200_F_VALUE_LABELS ;
label values RB211 RB211_VALUE_LABELS ;
label values RB211_F RB211_F_VALUE_LABELS ;
label values RB220_F RB220_F_VALUE_LABELS ;
label values RB230_F RB230_F_VALUE_LABELS ;
label values RB240_F RB240_F_VALUE_LABELS ;
label values RB245 RB245_VALUE_LABELS ;
label values RB245_F RB245_F_VALUE_LABELS ;
label values RB250 RB250_VALUE_LABELS ;
label values RB250_F RB250_F_VALUE_LABELS ;
label values RB280_F RB280_F_VALUE_LABELS ;
label values RB285 RB285_VALUE_LABELS ;
label values RB285_F RB285_F_VALUE_LABELS ;
label values RB290_F RB290_F_VALUE_LABELS ;
label values RL010_F RL010_F_VALUE_LABELS ;
label values RL020_F RL020_F_VALUE_LABELS ;
label values RL030_F RL030_F_VALUE_LABELS ;
label values RL040_F RL040_F_VALUE_LABELS ;
label values RL050 RL050_VALUE_LABELS ;
label values RL050_F RL050_F_VALUE_LABELS ;
label values RL060_F RL060_F_VALUE_LABELS ;
label values RL070_F RL070_F_VALUE_LABELS ;
label values RB032_F RB032_F_VALUE_LABELS ;
label values RG_1 RG_2 RG_3 RG_4 RG_5 RG_6 RG_7 RG_8 RG_9 RG_10 RG_11 RG_12 RG_13 RG_14 RG_15 RG_16 RG_17 RG_18 RG_19 RG_20 RG_21 RG_22 RG_VALUE_LABELS;
label values RG_1_F RG_2_F RG_3_F RG_4_F RG_5_F RG_6_F RG_7_F RG_8_F RG_9_F RG_10_F RG_11_F RG_12_F RG_13_F RG_14_F RG_15_F RG_16_F RG_17_F RG_18_F RG_19_F RG_20_F RG_21_F RG_22_F RG_F_VALUE_LABELS;
label values RCH010   RCH010_VALUE_LABELS ;
label values RCH010_F RCH010_F_VALUE_LABELS ;
label values RCH020   RCH020_VALUE_LABELS ;
label values RCH020_F RCH020_F_VALUE_LABELS ;
label values RX010 RX010_VALUE_LABELS ;
label values RX020 RX020_VALUE_LABELS ;
label values RX050 RX050_VALUE_LABELS ;
label values RX060 RX060_VALUE_LABELS ;
label values RX070 RX070_VALUE_LABELS ;


label data "Personal register file 2021" ;

compress ;
save "`stata_file'", replace ;

log close ;
set more on
#delimit cr



