* 2016_cross_eu_silc_r_ver_2023_release2_v2.do 
*
* STATA Command Syntax File
* Stata 17;
*
* Transforms the EU-SILC CSV-data (as released by Eurostat) into a Stata systemfile
* Update:
* Update of missing value labels
* Including DOI
* 
* EU-SILC Cross 2016 - release 2023-release2 / DOI: 10.2907/EUSILC2004-2022V1
*
* When publishing statistics derived from the EU-SILC UDB, please state as source:
* "EU-SILC <Type> UDB <yyyy> - version of 2023-release2"
*
* Personal register file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_l*country_stub*16R.csv
* 
* (c) GESIS 2024-07-08
* 
* PLEASE NOTE
* For Differences between data as described in the guidelines
* and the anonymised user database as well as country specific anonymisation measures see:
* L-2016 DIFFERENCES BETWEEN DATA COLLECTED.doc	
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
* Pforr, Klaus, Johanna Jung and Carl Riemann (2024): 2016_cross_eu_silc_r_ver_2023_release2_v2.do, 1st update.
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

local log_file "$log/eusilc_2016_r" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2020) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2016_r_cs" ;


* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 

tempfile temp ;
save `temp', emptyok ;

foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HR HU IE IS IT LT LU LV MT NL NO PL PT RO RS SE SI SK UK { ;
      cd "$csv_path/`CC'/2016" ;
	  import delimited using "UDB_c`CC'16R.csv", case(upper) asdouble clear ;
	  append using `temp', force ;
save `temp', replace  ;
} ;

* Countries in data file are sorted in alphanumeric order ;
sort RB020 ;

log using "`log_file'", replace text ;

* Delete erroneously included variable;
drop RB080_BC ;

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
label variable RB090 "Sex (DE: in same sex HH: recoded gender)" ;
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
label variable RX020 "Age at the end of the income reference period (DE: age group pertubatn, MT: mis)" ;
label variable RX030 "Household ID" ;
label variable RX040 "Work intensity" ;
label variable RX050 "Low work intensity status";
label variable RX060 "Severely materially deprived household";
label variable RX070 "At risk of poverty or social exclusion";

*Ad-hoc module on costs ;
label variable RC010 "Payment for the cost of formal childcare services";
label variable RC010_F "Flag" ;
label variable RC020 "Proportion of the cost of formal childcare services paid";
label variable RC020_F "Flag" ;
label variable RC030 "Who pays/contributes to the cost of formal childcare services";
label variable RC030_F "Flag" ;
label variable RC070 "Payment for tuition fees";
label variable RC070_F "Flag" ;
label variable RC080 "Part of the tuition fees paid";
label variable RC080_F "Flag" ;
label variable RC090 "Who pays/ contributes to the tuition fees";
label variable RC090_F "Flag" ;

* Definition of category labels ;

label define RB031_VALUE_LABELS
2016 "2016 - 2012"  
2011 "2011 - 2007"   
2006 "2006 - 2002"  
2001 "2001 - 1997"   
1996 "1996 - 1992"  
1991 "1991 - 1987"  
1986 "1986 - 1982"   
1981 "1981 - 1977"   
1976 "1976 - 1972"   
1971 "1971 - 1967"   
1966 "1966 - 1962"  
1961 "1961 - 1957"   
1956 "1956 - 1952"   
1951 "1951 - 1947"   
1946 "1946 - 1942"   
1941 "1941 - 1937"   
1936 "<=1936" 
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
1935 "1935 or before"
1936 "PT: 1936 and before"
1940 "MT: 1936-1940"
1942 "DE: 1942 and before"
1945 "MT: 1941-1945"
1950 "MT: 1946-1950"
1955 "MT: 1951-1955"
1960 "MT: 1956-1960"
1965 "MT: 1961-1965"
1970 "MT: 1966-1970"
1975 "MT: 1971-1975"
1980 "MT: 1976-1980"
1985 "MT: 1981-1985"
1990 "MT: 1986-1990"
1995 "MT: 1991-1995"
2000 "MT: 1996-2000"
2005 "MT: 2001-2005"
2010 "MT: 2006-2010"
2016 "MT: 2011-2016"
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
-2 "Not available (RB245 not = 1,2 or 3)"
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
80 "80 and over"
;
label define RX020_VALUE_LABELS             
73 "DE: 73 and over"
80 "80 and over"
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

*Ad-hoc module on costs ;

label define RC010_VALUE_LABELS
1 "Yes"
2 "No"
;
label define RC010_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-4 "No formal childcare for this child (RL030<1 AND RL040<1) OR not current household member (RB110 not in (1,2,3,4))"
-5 "Not applicable (person is more than 12 years old)"
-7 "Not applicable RB010 ≠ 2016"
;
label define RC020_VALUE_LABELS
1 "Full price (full cost)"
2 "Reduced price (subsidised by government, employer, private person, etc.)"
9 "Do not know"
;
label define RC020_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "Not applicable (RC010 = 2)"
-4 "No formal childcare for this child (RL030<1 AND RL040<1) OR not current household member (RB110 not in (1,2,3,4))"
-5 "Not applicable (person is more than 12 years old)"
-7 "Not applicable RB010 ≠ 2016"
;
label define RC030_VALUE_LABELS
1 "Government or local authorities"
2 "Employer"
3 "Other institutions (e.g. church, non-profit organisations)"
4 "Private persons who are not household members"
5 "Other"
9 "Do not know"
;
label define RC030_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "Not applicable (RC020 = 1 OR RC020=9)"
-4 "No formal childcare for this child (RL030<1 AND RL040<1) OR not current household member (RB110 not in (1,2,3,4))"
-5 "Not applicable (person is more than 12 years old)"
-7 "Not applicable RB010 is unequal 2016"
;
label define RC070_VALUE_LABELS
1 "Yes"
2 "No"
;
label define RC070_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-4 "Person does not follow formal education OR not current household member (RB110 not in (1,2,3,4))"
-5 "value not defined in data documentation"
-7 "Not applicable RB010 is unequal 2016"
;
label define RC080_VALUE_LABELS
1 "Full price (full cost)"
2 "Reduced price (subsidised by government, employer, private person, etc.)"
9 "Do not know"
;
label define RC080_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "Not applicable (RC070=2)"
-4 "Person does not follow formal education OR not current household member (RB110 not in (1,2,3,4))"
-5 "value not defined in data documentation"
-7 "Not applicable RB010 is unequal 2016"
;
label define RC090_VALUE_LABELS
1 "Government or local authorities"
2 "Employer"
3 "Other institutions (e.g. church, non-profit organisations)"
4 "Private persons who are not household members"
5 "Other"
9 "Do not know"
;
label define RC090_F_VALUE_LABELS
 1 "Filled"
 -1 "Missing"
 -2 "Not applicable (RC080=1 OR RC080=9) OR not current household member (RB110 not in (1,2,3,4))"
 -4 "Person does not follow formal education"
 -5 "value not defined in data documentation"
 -7 "Not applicable RB010 is unequal 2016"
;
* Attachment of category labels to variable ;

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

*Ad-hoc module on costs ;
label values RC010 RC010_VALUE_LABELS ;
label values RC010_F RC010_F_VALUE_LABELS ;
label values RC020 RC020_VALUE_LABELS ;
label values RC020_F RC020_F_VALUE_LABELS ;
label values RC030 RC030_VALUE_LABELS ;
label values RC030_F RC030_F_VALUE_LABELS ;
label values RC070 RC070_VALUE_LABELS ;
label values RC070_F RC070_F_VALUE_LABELS ;
label values RC080 RC080_VALUE_LABELS ;
label values RC080_F RC080_F_VALUE_LABELS ;
label values RC090 RC090_VALUE_LABELS ;
label values RC090_F RC090_F_VALUE_LABELS ;

label data "Personal register file 2016" ;

compress ;
save "`stata_file'", replace ;

log close ;
set more on
#delimit cr



