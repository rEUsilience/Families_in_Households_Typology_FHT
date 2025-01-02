* 2012_cross_eu_silc_p_ver_2023_release2_v2.do 
*
* STATA Command Syntax File
* Stata 17;
*
* Transforms the EU-SILC CSV-data (as released by Eurostat) into a Stata systemfile
* Update:
* Update of missing value labels
* Including DOI
* 
* EU-SILC Cross 2012 - release 2023-release2 / DOI: 10.2907/EUSILC2004-2022V1
*
* When publishing statistics derived from the EU-SILC UDB, please state as source:
* "EU-SILC <Type> UDB <yyyy> - version of 2023-release2"
*
* Personal data file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_l*country_stub*12P.csv
* 
* (c) GESIS 2024-07-08
* 
* PLEASE NOTE
* For Differences between data as described in the guidelines
* and the anonymised user database as well as country specific anonymisation measures see:
* L-2012 DIFFERENCES BETWEEN DATA COLLECTED.doc	
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
* Pforr, Klaus, Johanna Jung and Carl Riemann (2024): 2012_cross_eu_silc_p_ver_2023_release2_v2.do, 1st update.
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

local log_file "$log/eusilc_2012_p" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2020) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2012_p_cs" ;


* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 

tempfile temp ;
save `temp', emptyok ;

foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HR HU IE IS IT LT LU LV MT NL NO PL PT RO SE SI SK UK { ;
      cd "$csv_path/`CC'/2012" ;	
	   import delimited using "UDB_c`CC'12P.csv", case(upper) asdouble clear ;
	  tostring PB220A, replace ;
append using `temp', force ;
save `temp', replace  ;
} ;

* Countries in data file are sorted in alphanumeric order ;

sort PB020 ;

log using "`log_file'", replace text ;

replace PB220A = "" if PB220A=="." ;

* Definition of variable labels ;
label variable PB010 "Year of the survey" ;
label variable PB020 "Country alphanumeric" ;
label variable PB030 "Personal ID" ;
label variable PB040 "Personal cross-sectional weight" ;
label variable PB040_F "Flag" ;
label variable PB060 "Personal cross-sectional weight for selected respondent" ;
label variable PB060_F "Flag" ;
label variable PB100 "Quarter of the personal interview" ;
label variable PB100_F "Flag" ;
label variable PB110 "Year of the personal interview" ;
label variable PB110_F "Flag" ;
label variable PB120 "Minutes to complete the personal questionnaire" ;
label variable PB120_F "Flag" ;
label variable PB130 "Quarter of birth" ;
label variable PB130_F "Flag" ;
label variable PB140 "Year of birth" ;
label variable PB140_F "Flag" ;
label variable PB150 "Sex" ;
label variable PB150_F "Flag" ;
label variable PB160 "Father ID" ;
label variable PB160_F "Flag" ;
label variable PB170 "Mother ID" ;
label variable PB170_F "Flag" ;
label variable PB180 "Spouse/partner ID" ;
label variable PB180_F "Flag" ;
label variable PB190 "Marital status (MT: lbl 3,5 = 3)" ;
label variable PB190_F "Flag" ;
label variable PB200 "Consensual union" ;
label variable PB200_F "Flag" ;
label variable PB210 "Country of birth alphanumeric" ;
label variable PB210_F "Flag" ;
label variable PB220A "Citizenship 1 alphanumeric" ;
label variable PB220A_F "Flag" ;
label variable PE010 "Current education activity" ;
label variable PE010_F "Flag" ;
label variable PE020 "ISCED level currently attended (MT: lbl 0,1,2 = 2)" ;
label variable PE020_F "Flag" ;
label variable PE030 "Year when highest level of education was attained" ; // No bottom code for PT
label variable PE030_F "Flag" ; 
label variable PE040 "Highest ISCED level attained" ;
label variable PE040_F "Flag" ;
label variable PL031 "Self-defined current economic status" ;
label variable PL031_F "Flag" ;
label variable PL035 "Worked at least 1 hour during the previous week" ;
label variable PL035_F "Flag" ;
label variable PL015 "Person has ever worked" ;
label variable PL015_F "Flag" ;
label variable PL020 "Actively looking for a job" ;
label variable PL020_F "Flag" ;
label variable PL025 "Available for work" ;
label variable PL025_F "Flag" ;
label variable PL040 "Status in employment" ;
label variable PL040_F "Flag" ;
label variable PL060 "Number of hours usually worked per week in main job" ;
label variable PL060_F "Flag" ;
label variable PL073 "Number of months spent at full-time work as employee" ;
label variable PL073_F "Flag" ;
label variable PL074 "Number of months spent at part-time work as employee" ;
label variable PL074_F "Flag" ;
label variable PL075 "Number of months spent at full-time work as selfemployed (incl family worker)" ;
label variable PL075_F "Flag" ;
label variable PL076 "Number of months spent at part-time work as selfemployed (incl family worker)" ;
label variable PL076_F "Flag" ;
label variable PL080 "Number of months spent in unemployment" ;
label variable PL080_F "Flag" ;
label variable PL085 "Number of months spent in retirement or early retirement" ;
label variable PL085_F "Flag" ;
label variable PL086 "Number of months spent as disabled or/and unfit to work" ;
label variable PL086_F "Flag" ;
label variable PL087 "Number of months spent studying" ;
label variable PL087_F "Flag" ;
label variable PL088 "Number of months spent in compulsory military service" ;
label variable PL088_F "Flag" ;
label variable PL089 "Number of months spent fulfilling domestic tasks and care responsibilities" ;
label variable PL089_F "Flag" ;
label variable PL090 "Number of months spent in other inactivity" ;
label variable PL090_F "Flag" ;
label variable PL100 "Total number of hours usually worked in second, third... jobs" ;
label variable PL100_F "Flag" ;  
label variable PL111_F "Flag" ;
label variable PL120 "Reason for working less than 30 hours" ;
label variable PL120_F "Flag" ; 
label variable PL130 "Number of persons working at the local unit (MT: grouped)" ; 
label variable PL130_F "Flag" ;
label variable PL140 "Type of contract" ;
label variable PL140_F "Flag" ;
label variable PL150 "Managerial position" ;
label variable PL150_F "Flag" ;
label variable PL160 "Change of job since last year" ;
label variable PL160_F "Flag" ;
label variable PL170 "Reason for change" ;
label variable PL170_F "Flag" ;
label variable PL180 "Most recent change in the individuals activity status" ;
label variable PL180_F "Flag" ;
label variable PL190 "When began regular first job" ;
label variable PL190_F "Flag" ;
label variable PL200 "Number of years spent in paid work" ;
label variable PL200_F "Flag" ;
label variable PL211A "Main activity on January";
label variable PL211A_F "Flag" ;
label variable PL211B  "Main activity on February"; 
label variable PL211B_F "Flag" ;
label variable PL211C "Main activity on March";
label variable PL211C_F "Flag" ;
label variable PL211D  "Main activity on April";
label variable PL211D_F "Flag" ;
label variable PL211E  "Main activity on May";
label variable PL211E_F "Flag" ;
label variable PL211F "Main activity on June";
label variable PL211F_F "Flag" ;
label variable PL211G  "Main activity on July";
label variable PL211G_F "Flag" ;
label variable PL211H "Main activity on August";
label variable PL211H_F "Flag" ;
label variable PL211I "Main activity on September";
label variable PL211I_F "Flag" ;
label variable PL211J  "Main activity on October";
label variable PL211J_F "Flag" ;
label variable PL211K  "Main activity on November";
label variable PL211K_F "Flag" ;
label variable PL211L "Main activity on December";
label variable PL211L_F "Flag" ;
label variable PH010 "General health" ;
label variable PH010_F "Flag" ;
label variable PH020 "Suffer from a chronic (long-standing) illness or condition" ;
label variable PH020_F "Flag" ;
label variable PH030 "Limitation in activities because of health problems" ;
label variable PH030_F "Flag" ;
label variable PH040 "Unmet need for medical examination or treatment" ;
label variable PH040_F "Flag" ;
label variable PH050 "Main reason for unmet need for medical examination or treatment" ;
label variable PH050_F "Flag" ;
label variable PH060 "Unmet need for dental examination or treatment" ;
label variable PH060_F "Flag" ;
label variable PH070 "Main reason for unmet need for dental examination or treatment" ;
label variable PH070_F "Flag" ;
label variable PY010N "Employee cash or near cash income (net)" ;
label variable PY010N_F "Flag" ;
label variable PY010N_I "Imputation factor" ;
label variable PY020N "Non-Cash employee income (net)" ;
label variable PY020N_F "Flag" ;
label variable PY020N_I "Imputation factor" ;
label variable PY021N   "Company car (in euros)" ;
label variable PY021N_F "Flag" ;
label variable PY035N "Contributions to individual private pension plans (net)" ;
label variable PY035N_F "Flag" ;
label variable PY035N_I "Imputation factor" ;
label variable PY050N "Cash benefits or losses from self-employment (net)" ;
label variable PY050N_F "Flag" ;
label variable PY050N_I "Imputation factor" ;
label variable PY080N "Pension from individual private plans (net)" ;
label variable PY080N_F "Flag" ;
label variable PY080N_I "Imputation factor" ;
label variable PY090N "Unemployment benefits (net)" ;
label variable PY090N_F "Flag" ;
label variable PY090N_I "Imputation factor" ;
label variable PY100N "Old-age benefits (net)" ;
label variable PY100N_F "Flag" ;
label variable PY100N_I "Imputation factor" ;
label variable PY110N "Survivors benefits (net)" ;
label variable PY110N_F "Flag" ;
label variable PY110N_I "Imputation factor" ;
label variable PY120N "Sickness benefits (net)" ;
label variable PY120N_F "Flag" ;
label variable PY120N_I "Imputation factor" ;
label variable PY130N "Disability benefits (net)" ;
label variable PY130N_F "Flag" ;
label variable PY130N_I "Imputation factor" ;
label variable PY140N "Education-related allowances" ;
label variable PY140N_F "Flag" ;
label variable PY140N_I "Imputation factor" ;
label variable PY010G "Employee cash or near cash income (gross)" ;
label variable PY010G_F "Flag" ;
label variable PY010G_I "Imputation factor" ;
label variable PY020G "Non-Cash employee income (gross)" ;  
label variable PY020G_F "Flag" ;
label variable PY020G_I "Imputation factor" ; 
label variable PY021G "Company car (in euros)" ;
label variable PY021G_F "Flag" ;
label variable PY030G  "Employer's social insurance contribution (in euros)" ;
label variable PY030G_F "Flag" ;
label variable PY035G "Contributions to individual private pension plans (gross)" ;
label variable PY035G_F "Flag" ;
label variable PY035G_I "Imputation factor" ;
label variable PY050G "Cash benefits or losses from self-employment (gross)" ;
label variable PY050G_F "Flag" ;
label variable PY050G_I "Imputation factor" ;
label variable PY080G  "Pension from individual private plans (gross)" ;
label variable PY080G_F "Flag" ;
label variable PY080G_I "Imputation factor" ;
label variable PY090G  "Unemployment benefits (gross)" ;
label variable PY090G_F "Flag" ;
label variable PY090G_I "Imputation factor" ;
label variable PY100G "Old-age benefits (gross)" ;
label variable PY100G_F "Flag" ;
label variable PY100G_I "Imputation factor" ;
label variable PY110G "Survivor benefit" ;
label variable PY110G_F "Flag" ;
label variable PY110G_I "Imputation factor" ;
label variable PY120G "Sickness benefits (gross)" ;
label variable PY120G_F "Flag" ;
label variable PY120G_I "Imputation factor" ;
label variable PY130G "Disability benefits (gross)" ;
label variable PY130G_F "Flag" ;
label variable PY130G_I "Imputation factor" ;
label variable PY140G "Education-related allowances (gross)" ;
label variable PY140G_F "Flag" ;
label variable PY140G_I "Imputation factor" ;
label variable PY200G "Gross monthly earnings for employees (gross)" ;
label variable PY200G_F "Flag" ;
label variable PY200G_I "Imputation factor" ;
label variable PX030 "Household ID" ;
label variable PX040 "Selected respondent status" ;
label variable PY021N_I "Imputation factor" ;
label variable PY021G_I "Imputation factor" ;
label variable PY030G_I "Imputation factor" ;
label variable PX020 "Age at the end of the income reference period" ;
label variable PX050 "Activity status" ;
label variable PX010 "Exchange rate" ;
label variable PY031G "Optional employer's social insurance contributions (in euros)" ;
label variable PY031G_F "Flag" ;
label variable PY031G_I "Imputation factor" ;
label variable PL111 "NACE Rev.2" ;
label variable PL051 "Occupation (ISCO-08 (COM) (MT: grouped; PT: lbl 11,12,13 = 14))" ;
label variable PL051_F"Flag" ;
label variable PC170 "Change of the dwelling" ;
label variable PC170_F "Flag" ;
label variable PC180 "Main reason for the change of the dwelling" ;
label variable PC180_F "Flag" ;



* Definition of category labels ;
label define PB040_F_VALUE_LABELS             
1 "Filled"
;
label define PB060_F_VALUE_LABELS             
 1 "Filled"
-2 "Not applicable (country does not use the selected respondent model)"
-3 "Non-selected respondent"
-7 "Not applicable: PB010 not equal last year"
;
label define PB100_VALUE_LABELS               
1 "January, February, March"
2 "April, May, June"
3 "July, August, September"
4 "October, November, December"
;
label define PB100_F_VALUE_LABELS             
 1 "filled"
-1 "missing"
;
label define PB110_F_VALUE_LABELS              
 1 "filled"
-1 "missing"
;
label define PB120_F_VALUE_LABELS              
 1 "filled"
-1 "missing"
-2 "na (information only extracted from registers)"
;
label define PB130_VALUE_LABELS                
1 "January, February, March"
2 "April, May, June"
3 "July, August, September"
4 "October, November, December"
;
label define PB130_F_VALUE_LABELS              
 1 "filled"
-1 "missing"
;
label define PB140_VALUE_LABELS             
1931 "1931 or before"
1932 "PT: 1932 and before"
1936 "MT: 1932-1936"
1941 "MT: 1937-1941"
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
;
label define PB140_F_VALUE_LABELS             
 1 "filled"
-1 "missing"
;
label define PB150_VALUE_LABELS                
1 "male"
2 "female"
;
label define PB150_F_VALUE_LABELS              
 1 "filled"
-1 "missing"
;
label define PB160_F_VALUE_LABELS              
 1 "filled"
-1 "missing"
-2 "na (father is not a household member)"
;
label define PB170_F_VALUE_LABELS             
 1 "filled"
-1 "missing"
-2 "na (mother is not a household member)"
;
label define PB180_F_VALUE_LABELS              
 1 "filled"
-1 "missing"
-2 "not applicable (person has no spouse/partner or spouse/partner is not a household member)"
;
label define PB190_VALUE_LABELS                
1 "never married"
2 "married" 
3 "separated"
4 "widowed"
5 "divorced"
;
label define PB190_F_VALUE_LABELS              
 1 "filled"
-1 "missing"
;
label define PB200_VALUE_LABELS                
1 "yes, on a legal basis"
2 "yes, without a legal basis"
3 "no"
;
label define PB200_F_VALUE_LABELS              
 1 "filled"
-1 "missing"
;
label define PB210_F_VALUE_LABELS             
 1 "filled"
-1 "missing"
;
label define PB220A_F_VALUE_LABELS            
 1 "filled"
-1 "missing"
;
label define PE010_VALUE_LABELS               
1 "in education"
2 "not in education"
;
label define PE010_F_VALUE_LABELS            
 1 "filled"
-1 "missing"
;
label define PE020_VALUE_LABELS               
0 "pre-primary education"
1 "primary education"
2 "lower secondary education"
3 "(upper) secondary education"
4 "post-secondary non-tertiary education"
5 "1st stage & 2nd stage of tertiary education"
;
label define PE020_F_VALUE_LABELS             
 1 "filled"
-1 "missing"
-2  "na (PE010 not=1)"
;
label define PE030_F_VALUE_LABELS            
 1 "filled"
-1 "missing"
-2 "n.a. (the person has never been in education)"
;
label define PE040_VALUE_LABELS              
0 "pre-primary education"
1 "primary education"
2 "lower secondary education"
3 "(upper) secondary education"
4 "post-secondary non-tertiary education"
5 "1st & 2nd stage of tertiary education"
;
label define PE040_F_VALUE_LABELS           
1 "filled"
-1 "missing"
-2 "n.a. (the person has never been in education)"
;
label define PL031_VALUE_LABELS 
1 "Employee working full-time"
2 "Employee working part-time"
3 "Self-employed working full-time (including family worker)"
4 "Self-employed working part-time (including family worker)"
5 "Unemployed"
6 "Pupil, student, further training, unpaid work experience"
7 "In retirement or in early retirement or has given up business"
8 "Permanently disabled or/and unfit to work"
9 "In compulsory military community or service"
10 "Fulfilling domestic tasks and care responsibilities"
11 "Other inactive person" 
;
label define PL031_F_VALUE_LABELS
1 "filled"
-1 "missing"
-5 "missing value of PL031 because PL030 is still used"
;
label define PL035_VALUE_LABELS              
1 "yes"
2 "no"
;
label define PL035_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "na (person is not employee or MS has other source to calculate the gender pay gap)"
-3 "not selected respondent"
;       
label define PL015_VALUE_LABELS              
1 "yes"
2 "no"
;
label define PL015_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "na (PL031=1,2, 3 or 4)"
;
label define PL020_VALUE_LABELS              
1 "Yes"
2 "No"
;
label define PL020_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "na (PL031=1,2,3 or 4)"
;
label define PL025_VALUE_LABELS              
1 "Yes"
2 "No"
;
label define PL025_F_VALUE_LABELS            
1 "filled"
-1 "missing"
-2 "na (PL020=2)"
;
label define PL040_VALUE_LABELS                
1 "Self-employed with employees"
2 "Self-employed without employees"
3 "Employee"
4 "Family worker"
;
label define PL040_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "not applicable (PL015 not = 1) cross-sectional not applicable (person never worked) longitudinal" 
;

label define PL060_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "n.a. (PL031 not = 1, 2, 3 or 4)"
-6 "Hours varying(even an average over 4 weeks is not possible)"
;
label define PL073_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-5 "missing value because the definition of this variable is not used"
;
label define PL074_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-5 "missing value because the definition of this variable is not used"
;
label define PL075_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-5 "missing value because the definition of this variable is not used"
;
label define PL076_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-5 "missing value because the definition of this variable is not used"
;
label define PL080_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-5 "missing value because the definition of this variable is not used"
;
label define PL085_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-5 "missing value because the definition of this variable is not used"
;
label define PL086_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-5 "missing value because the definition of this variable is not used"
;
label define PL087_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-5 "missing value because the definition of this variable is not used"
;
label define PL088_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-5 "missing value because the definition of this variable is not used"
;
label define PL089_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-5 "missing value because the definition of this variable is not used"
;
label define PL090_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-5 "missing value because the definition of this variable is not used"
;
label define PL100_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "n.a. (person does not have a 2nd job or PL031 not = 1, 2, 3 or 4)"
;

label define PL111_F_VALUE_LABELS
1 "filled"
-1 "missing"
-2 "not applicable (PL031 not = 1, 2, 3 or 4)"
-3 "not selected respondent"
-5 "missing value of PL111 because PL110 is still used"
;

label define PL120_VALUE_LABELS                
1 "Undergoing education or training"
2 "Personal illness or disability"
3 "Want to work more hours but cannot find a job(s) or work(s) of more hours"
4 "Do not want to work more hours"
5 "Number of all hours in all job(s) are considered as full-time job"
6 "Housework, looking after children or other persons"  
7 "Other reasons"
;
label define PL120_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na (Not (PL031 = 1, 2 , 3 or 4, and PL060 + PL100 < 30))" 
-3 "not selected respondent"
;

label define PL130_VALUE_LABELS
1  "MT: 1-5"
2  "MT: 6-10"
3  "MT: 11-12"
4  "MT: 13"
5  "MT: 14" 
6  "MT: 15"              
11 "between 11 and 19 persons"
12 "between 20 and 49 persons"
13 "50 persons or more"
14 "do not know but less than 11 persons"
15 "do not know but more than 10 persons"
;
label define PL130_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na (PL031 not = 1, 2, 3 or 4)" 
-3 "not selected respondent"
;
label define PL140_VALUE_LABELS                
1 "Permanent job: work contract of unlimited duration" 
2 "temporary job: work contract of limited duration"
;
label define PL140_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "n.a."
-3 "not selected respondent"
-4 "n.a.:person is employee (PL040 not=3) but has not any contract"   
;

label define PL150_VALUE_LABELS                
1 "supervisory"
2 "non-supervisory"
;
label define PL150_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "n.a.(PL040 not = 3)" 
-3 "not selected respondent"
;
label define PL160_VALUE_LABELS                
1 "yes"
2 "no"
; 
label define PL160_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na (PL031 not = 1, 2, 3 or 4)" 
-3 "not selected respondent"
;
label define PL170_VALUE_LABELS                
1 "To take up or seek better job"
2 "End of temporary contract"
3 "Obliged to stop by employer (business closure, redundancy, early retirement, dismissal etc.)"
4 "Sale or closure of own/family business"
5 "Child care and care for other dependant"
6 "Partners job required us to move to another area or marriage"
7 "Other reasons"
;
label define PL170_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na" 
-3 "not selected respondent"
;

label define PL180_VALUE_LABELS                
1 "employed - unemployed"
2 "employed - retired"
3 "employed - other inactive"
4 "unemployed - employed"
5 "unemployed - retired"
6 "unemployed - other inactive"
7 "retired - employed"
8 "retired - unemployed" 
9 "retired - other inactive"
10 "other inactive - employed"
11 "other inactive - unemployed"
12 "other inactive - retired"
;
label define PL180_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na (no change since last year)"
-3 "not selected respondent"
;
label define PL190_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "n.a. (person never worked( PL031 not = 1, 2, 3 or 4 AND PL015 not= 1))"
-3 "not selected respondent" 
;
label define PL200_F_VALUE_LABELS              
1 "filled"
-1 "missing"
-2 "na (person never worked (PL031 not = 1, 2, 3 or 4 AND PL015 not= 1))"
-3 "not selected respondent"  
;
label define PL211A_VALUE_LABELS
1 "Employee working full-time"
2 "Employee working part-time"
3 "Self-employed working full-time (including family worker)"
4 "Self-employed working part-time (including family worker)"
5 "Unemployed"
6 "Pupil, student, further training, unpaid work experience"
7 "In retirement or in early retirement or has given up business"
8 "Permanently disabled or/and unfit to work"
9 "In compulsory military community or service"
10 "Fulfilling domestic tasks and care responsibilities"
11 "Other inactive person"
;
label define PL211A_F_VALUE_LABELS
1 "filled"
-1 "missing"
-3 "not selected respondent"
-5 "missing value of PL211 because PL210 is still used"
;
label define PH010_VALUE_LABELS                
1 "very good"
2 "good"
3 "fair"
4 "bad"
5 "very bad"
;
label define PH010_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-3 "not selected respondent"
;
label define PH020_VALUE_LABELS                
1 "yes"
2 "no"
8 "do not know (Germany only)"
;
label define PH020_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-3 "not selected respondent"
;
label define PH030_VALUE_LABELS               
1 "yes, strongly limited"
2 "yes, limited"
3 "no, not limited"
8 "do not know (Germany only)"
;
label define PH030_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-3 "not selected respondent"
;
label define PH040_VALUE_LABELS                
1 "yes there was at least one occasion when the person really needed examination or treatment but did not"               
2 "no, there was no occasion when the person really needed examination or treatment but did not"
8 "do not know (Germany only)"
;
label define PH040_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-3 "not selected respondent"
;
label define PH050_VALUE_LABELS                
1 "Could not afford to (too expensive)"
2 "Waiting list"
3 "Could not take time because of work, care for children or for others"
4 "Too far to travel/no means of transportation"
5 "Fear of doctor/hospital/examination/treatment"
6 "Wanted to wait and see if problem got better on its own"
7 "did not know any good doctor or specialist"
8 "other reasons"
;
label define PH050_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-2 "na (PH040 not=1)"
-3 "not selected respondent"
;
label define PH060_VALUE_LABELS                
1 "yes there was at least one occasion when the person really needed dental examination or treatment but did not"               
2 "no, there was no occasion when the person really needed dental examination or treatment but did not"
8 "do not know (Germany only)"
;
label define PH060_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-3 "not selected respondent"
;
label define PH070_VALUE_LABELS               
1 "Could not afford to (too expensive)"
2 "Waiting list"
3 "Could not take time because of work, care for children or for others"
4 "Too far to travel/no means of transportation"
5 "Fear of doctor(dentist)/hospital/examination/treatment"
6 "Wanted to wait and see if problem got better on its own"
7 "did not know any dentist"
8 "other reasons"
;
label define PH070_F_VALUE_LABELS              
1 "Filled"
-1 "missing"
-2 "na (PH060 not =1)"
-3 "not selected respondent"
;
label define PY010N_F_VALUE_LABELS             
0  "no income"
11  "collec. & recorded net of tax on income at source & social contrib."
13  "collec. & recorded net of tax net of tax on social contrib."           
22  "collec. & recorded net of tax on income at source" 
31  "collected net of tax on social contrib./recorded net of tax on income & social contrib."
33  "collected & recorded net of tax on social contrib."
41  "collected gross/recorded net of tax on income & social contrib."
42  "collected gross/recorded net of tax on income at source"
43  "collected gross/recorded net of tax on social contrib."
51  "collected unknown/recorded net of tax on income & social contrib."
53  "collected unknown/recorded net of tax on social contrib."
55  "Type of collection & recording: unknown"
61 "collected mix (parts of the component collected according to different ways)-Deductive imputation"
-1  "missing"
-5 "not filled: variable of gross series is filled"
;
label define PY020N_F_VALUE_LABELS             
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected gross/recorded net of tax on income & social contrib."
42 "collected gross/recorded net of tax on income at source"
51 "collected unknown/recorded net of tax on income & social contrib."
53 "collected unknown/recorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
61 "mix/deductive imputation"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY021N_VALUE_LABELS               
0 "no income"
;
label define PY021N_F_VALUE_LABELS            
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected gross/recorded net of tax on income & social contrib."
42 "collected gross/recorded net of tax on income at source"
51 "collected unknown/recorded net of tax on income & social contrib."
53  "collected unknown/recorded net of tax on social contrib."
55  "Type of collection & recording: unknown"
61 "mix/deductive imputation"
-1  "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY035N_F_VALUE_LABELS             
0  "no contribution"
1 "variable is filled"
-1  "missing"
-5 "not filled: variable of the gross series is filled"
;
label define PY050N_VALUE_LABELS              
0 "no income"
;
label define PY050N_F_VALUE_LABELS             
0  "no income"
11  "collec. & recorded net of tax on income at source & social contrib."
22  "collec. & recorded net of tax on income at source" 
31  "collected net of tax on social contrib./recorded net of tax on income & social contrib."
32  "collected net of tax on social contrib./recorded net of tax on income at source."
33  "collected & recorded net of tax on social contrib."
41  "collected gross/recorded net of tax on income & social contrib."
42  "collected gross/recorded net of tax on income at source"
43  "collected gross/recorded net of tax on social contrib."
51  "collected unknown/recorded net of tax on income & social contrib."
52  "collected unknown/recorded net of tax on income"
53  "collected unknown/recorded net of tax on social contrib."
55  "Type of collection & recording: unknown"
61 "collected mix (parts of the component collected according to different ways)-Deductive imputation"
-1  "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY080N_F_VALUE_LABELS             
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31  "collected net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected gross/recorded net of tax on income & social contrib."
42 "collected gross/recorded net of tax on income at source"
51 "collected unknown/recorded net of tax on income & social contrib."
52 "collected unknown/recorded net of tax on income"
53 "collected unknown/recorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
61 "mix/deductive imputation"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY090N_F_VALUE_LABELS             
0  "no income"
11  "collec. & recorded net of tax on income at source & social contrib."
22  "collec. & recorded net of tax on income at source" 
31  "collected net of tax on social contrib./recorded net of tax on income & social contrib."
33  "collected & recorded net of tax on social contrib."
41  "collected gross/recorded net of tax on income & social contrib."
42  "collected gross/recorded net of tax on income at source"
43  "collected gross/recorded net of tax on social contrib."
51  "collected unknown/recorded net of tax on income & social contrib."
52  "collected unknown/recorded net of tax on income"
53  "collected unknown/recorded net of tax on social contrib."
55  "Type of collection & recording: unknown"
61 "collected mix (parts of the component collected according to different ways)-Deductive imputation"
-1  "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY100N_F_VALUE_LABELS             
0  "no income"
11  "collec. & recorded net of tax on income at source & social contrib."
22  "collec. & recorded net of tax on income at source" 
31  "collected net of tax on social contrib./recorded net of tax on income & social contrib."
33  "collected & recorded net of tax on social contrib."
41  "collected gross/recorded net of tax on income & social contrib."
42  "collected gross/recorded net of tax on income at source"
51  "collected unknown/recorded net of tax on income & social contrib."
52  "collected unknown/recorded net of tax on income"
53  "collected unknown/recorded net of tax on social contrib."
55  "Type of collection & recording: unknown"
61 "collected mix (parts of the component collected according to different ways)-Deductive imputation"
-1  "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY110N_F_VALUE_LABELS             
0  "no income"
11  "collec. & recorded net of tax on income at source & social contrib."
22  "collec. & recorded net of tax on income at source" 
31  "collected net of tax on social contrib./recorded net of tax on income & social contrib."
33  "collected & recorded net of tax on social contrib."
41  "collected gross/recorded net of tax on income & social contrib."
42  "collected gross/recorded net of tax on income at source"
51  "collected unknown/recorded net of tax on income & social contrib."
52  "collected unknown/recorded net of tax on income"
53  "collected unknown/recorded net of tax on social contrib."
55  "Type of collection & recording: unknown"
61 "collected mix (parts of the component collected according to different ways)-Deductive imputation"
-1  "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY120N_F_VALUE_LABELS            
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected gross/recorded net of tax on income & social contrib."
42 "collected gross/recorded net of tax on income at source"
51 "collected unknown/recorded net of tax on income & social contrib."
52 "collected unknown/recorded net of tax on income"
53 "collected unknown/recorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
61 "mix/deductive imputation"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY130N_F_VALUE_LABELS            
0  "no income"
           11  "collec. & recorded net of tax on income at source & social contrib."
           22  "collec. & recorded net of tax on income at source" 
           31  "collected net of tax on social contrib./recorded net of tax on income & social contrib."
           33  "collected & recorded net of tax on social contrib."
           41  "collected gross/recorded net of tax on income & social contrib."
           42  "collected gross/recorded net of tax on income at source"
           51  "collected unknown/recorded net of tax on income & social contrib."
           52  "collected unknown/recorded net of tax on income"
           53  "collected unknown/recorded net of tax on social contrib."
           55  "Type of collection & recording: unknown"
           61 "collected mix (parts of the component collected according to different ways)-Deductive imputation"
           -1  "missing"
           -4 "amount included in another component"
           -5 "not filled: variable of gross series is filled"
;
label define PY140N_F_VALUE_LABELS             
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collected net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collected & recorded net of tax on social contrib."
41 "collected gross/recorded net of tax on income & social contrib."
42 "collected gross/recorded net of tax on income at source"
51 "collected unknown/recorded net of tax on income & social contrib."
52 "collected unknown/recorded net of tax on income"
53 "collected unknown/recorded net of tax on social contrib."
55 "Type of collection & recording: unknown"
61 "mix/deductive imputation"
-1 "missing"
-4 "amount included in another component"
-5 "not filled: variable of gross series is filled"
;
label define PY010G_F_VALUE_LABELS             
0  "no income"
1 "net of tax on income at source and social contribution"
2 "net of tax on income at source"
3 "net of tax on social contribution"
4 "gross"
5 "unknown"
6 "mix (parts of the component collected according to different ways)"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define PY020G_F_VALUE_LABELS             
0  "no income"
1 "net of tax on income at source and social contribution"
2 "net of tax on income at source"
3 "net of tax on social contribution"
4 "gross"
5 "unknown"
6 "mix (parts of the component collected according to different ways)"
-1 "missing"
-4 "amount included in another component"
-5 "not filled:variable of net series is filled"
;
label define PY021G_VALUE_LABELS               
0 "no income"
;
label define PY021G_F_VALUE_LABELS            
-5 "not filled: variable of net series is filled"
-4 "amount included in another component"
-1 "missing"
0 "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
6 "mix (parts of the component collected according to different ways)"
;
label define PY030G_VALUE_LABELS               
0 "no contribution"
;
label define PY030G_F_VALUE_LABELS            
-5 "not filled: variable of net series is filled"
-1 "missing"
0 "no income"
1 "income (variable is filled)"
;
label define PY031G_VALUE_LABELS               
0 "no contribution"
;
label define PY031G_F_VALUE_LABELS 
0 "no income"
1 "income (variable is filled)"
-1 "missing"
-5 "not filled: variable of net (..G)   gross (..N) series is filled"
;

label define PY035G_F_VALUE_LABELS            
0 "no contribution"
1 "variable is filled"
-1 "missing"
-5 "not filled: variable of net series is filled" 
;  
label define PY050G_F_VALUE_LABELS             
0 "no income"
            1 "collected net of tax on income at source and social contribution+nc"
            2 "collected net of tax on income at source+nc"
            3 "collected net of tax on social contributions+nc"
            4 "collected gross"
            5 "unknown"
            6  "collected mix (parts of the component collected according to different ways)"
           -1 "missing"
           -5 "not filled:variable of net series is filled"
;
label define PY080G_F_VALUE_LABELS             
0 "no income"
            1 "collected net of tax on income at source and social contribution+nc"
            2 "collected net of tax on income at source+nc"
            3 "collected net of tax on social contributions+nc"
            4 "collected gross"
            5 "unknown"
            6  "collected mix (parts of the component collected according to different ways)"
           -1 "missing"
           -5 "not filled:variable of net series is filled"
;
label define PY090G_F_VALUE_LABELS             
0  "no income"
            1 "collected net of tax on income at source and social contribution+nc"
            2 "collected net of tax on income at source+nc"
            3 "collected net of tax on social contributions+nc"
            4 "collected gross"
            5 "unknown"
            6  "collected mix (parts of the component collected according to different ways)"
           -1 "missing"
           -5 "not filled:variable of net series is filled"
;
label define PY100G_F_VALUE_LABELS             
0  "no income"
            1 "collected net of tax on income at source and social contribution+nc"
            2 "collected net of tax on income at source+nc"
            3 "collected net of tax on social contributions+nc"
            4 "collected gross"
            5 "unknown"
            6  "collected mix (parts of the component collected according to different ways)"
           -1 "missing"
           -4 "amount included in another component"
           -5 "not filled:variable of net series is filled"
;
label define PY110G_F_VALUE_LABELS             
0 "no income"
            1 "collected net of tax on income at source and social contribution+nc"
            2 "collected net of tax on income at source+nc"
            3 "collected net of tax on social contributions+nc"
            4 "collected gross"
            5 "unknown"
            6  "collected mix (parts of the component collected according to different ways)"
           -1 "missing"
           -4 "amount included in another component"
           -5 "not filled:variable of net series is filled"
;
label define PY120G_F_VALUE_LABELS             
0 "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
6 "mix (parts of the component collected according to different ways)"
-1 "missing"
-4 "amount included in another component"
-5 "not filled:variable of net series is filled"
;
label define PY130G_F_VALUE_LABELS             
0  "no income"
            1 "collected net of tax on income at source and social contribution+nc"
            2 "collected net of tax on income at source+nc"
            3 "collected net of tax on social contributions+nc"
            4 "collected gross"
            5 "unknown"
            6  "collected mix (parts of the component collected according to different ways)"
           -1 "missing"
           -4 "amount included in another component"
           -5 "not filled:variable of net series is filled"
;
label define PY140G_F_VALUE_LABELS            
0 "no income"
1 "collected net of tax on income at source and social contribution+nc"
2 "collected net of tax on income at source+nc"
3 "collected net of tax on social contributions+nc"
4 "collected gross"
5 "unknown"
6 "mix (parts of the component collected according to different ways)"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define PY200G_F_VALUE_LABELS             
0 "no income"
1 "net of tax on income at source and social contribution"
2 "net of tax on income at source"
3 "net of tax on social contribution"
4 "gross"
5 "unknown"
6 "mix (parts of the component collected according to different ways)"
61 "mix (parts of the component collected according to different ways)-Deductive imputation"
-1 "missing"
-2 "not applicable"
-4 "amount included in another component"
-5 "not filled:variable of net series is filled" 
;
label define PX020_VALUE_LABELS               
80 "80 and over"
;
label define PX040_VALUE_LABELS                
1 "current household member aged >=16 (All hhld members aged >=16 are interviewed)"
2 "selected respondent(Only selected hhld member aged >= 16 is interviewed)"
3 "not selected respondent (Only selected hhld member aged >= 16 is interviewed)"
4 "not eligible person (Hhld members aged < 16 at the time of interview)"
;
label define PX050_VALUE_LABELS                
2 "employees (SAL)" 
3 "employed persons except employees (NSAL)" 
4 "other employed (when time of SAL and NSAL is > 0.5 of total time calendar)" 
5 "unemployed" 
6 "retired" 
7 "inactive"  
8 "other inactive (when time of unemployed, retirement & inactivity is > 0.5 of total time calendar)"
;
label define PL051_F_VALUE_LABELS   
1 "filled"
-1 "missing"
-2 "not applicable (PL015 not = 1) cross sectional not applicable (person never worked) longitudinal"
;
label define PL051_VALUE_LABELS
1 "Commissioned armed forces officers. MT:11-14 Legislators,senior officials & managers"
2 "Non-commissioned armed forces officers. MT:21-26 Professionals"
3 "Armed forces occupations, other ranks. MT:31-35 Technicians & associate professionals"
4 "MT: 41-44 Clerks"
5 "MT: 51-54 Service workers and shop and market sales workers"
6 "MT: 61-63 Skilled agricultural and fishery workers"
7 "MT: 71-75 Craft and related trades workers"
8 "MT: 81-83 Plant and machine operators and assemblers"
9 "MT: 91-96 Elementary occupations"
10 "MT:01 Armed forces"
11 "Chief executives, senior officials and legislators"
12 "Administrative and commercial managers"
13 "Production and specialised services managers"
14 "Hospitality, retail and other services managers"
21 "Science and engineering professionals"
22 "Health professionals"
23 "Teaching professionals"
24 "Business and administration professionals"
25 "Information and communications technology professionals"
26 "Legal, social and cultural professionals"
31 "Science and engineering associate professionals"
32 "Health associate professionals"
33 "Business and administration associate professionals"
34 "Legal, social, cultural and related associate professionals"
35 "Information and communications technicians"
41 "General and keyboard clerks"
42 "Customer services clerks"
43 "Numerical and material recording clerks"
44 "Other clerical support workers"
51 "Personal service workers"
52 "Sales workers"
53 "Personal care workers"
54 "Protective services workers"
61 "Market-oriented skilled agricultural workers"
62 "Market-oriented skilled forestry, fishery and hunting workers"
63 "Subsistence farmers, fishers, hunters and gatherers"
71 "Building and related trades workers, excluding electricians"
72 "Metal, machinery and related trades workers"
73 "Handicraft and printing workers"
74 "Electrical and electronic trades workers"
75 "Food processing, wood working, garment and other craft and related trades workers"
81 "Stationary plant and machine operators"
82 "Assemblers"
83 "Drivers and mobile plant operators"
91 "Cleaners and helpers"
92 "Agricultural, forestry and fishery labourers"
93 "Labourers in mining, construction, manufacturing and transport"
94 "Food preparation assistants"
95 "Street and related sales and service workers"
96 "Refuse workers and other elementary workers" 
;
label define PC170_VALUE_LABELS
1 "Yes"
2 "No"
;
label define PC170_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-3 "Not selected respondent"
;
label define PC180_VALUE_LABELS
1 "Family-related reasons"
2 "Employment-related reasons"
3 "Education-related reasons"
4 "Eviction"
5 "Landlord did not prolong the contract"
6 "Desire to change tenure status"
7 "Dwelling-related reasons"
8 "Neighbourhood-related reasons"
9 "Financial reasons"
10 "Other reasons"
;
label define PC180_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "Not applicable (PC170 = 2)"
-3 "Not selected respondent"
;

* Attachement of category labels to variables ;

label values PB040_F PB040_F_VALUE_LABELS ;
label values PB060_F PB060_F_VALUE_LABELS ;
label values PB100 PB100_VALUE_LABELS ;
label values PB100_F PB100_F_VALUE_LABELS ;
label values PB110_F PB110_F_VALUE_LABELS ;
label values PB120_F PB120_F_VALUE_LABELS ;
label values PB130 PB130_VALUE_LABELS ;
label values PB130_F PB130_F_VALUE_LABELS ; 
label values PB140 PB140_VALUE_LABELS ;
label values PB140_F PB140_F_VALUE_LABELS ;
label values PB150 PB150_VALUE_LABELS ;
label values PB150_F PB150_F_VALUE_LABELS ;
label values PB160_F PB160_F_VALUE_LABELS ;
label values PB170_F PB170_F_VALUE_LABELS ;
label values PB180_F PB180_F_VALUE_LABELS ;
label values PB190 PB190_VALUE_LABELS ;
label values PB190_F PB190_F_VALUE_LABELS ;
label values PB200 PB200_VALUE_LABELS ;
label values PB200_F PB200_F_VALUE_LABELS ;
label values PB210_F PB210_F_VALUE_LABELS ;
label values PB220A_F PB220A_F_VALUE_LABELS ;
label values PE010 PE010_VALUE_LABELS ;
label values PE010_F PE010_F_VALUE_LABELS ;
label values PE020 PE020_VALUE_LABELS ;
label values PE020_F PE020_F_VALUE_LABELS ;
label values PE030_F PE030_F_VALUE_LABELS ;
label values PE040 PE040_VALUE_LABELS ;
label values PE040_F PE040_F_VALUE_LABELS ;
label values PL031 PL031_VALUE_LABELS ;
label values PL031_F PL031_F_VALUE_LABELS ;
label values PL035 PL035_VALUE_LABELS ;
label values PL035_F PL035_F_VALUE_LABELS ;
label values PL015 PL015_VALUE_LABELS ;
label values PL015_F PL015_F_VALUE_LABELS ;
label values PL020 PL020_VALUE_LABELS ;
label values PL020_F PL020_F_VALUE_LABELS ;
label values PL025 PL025_VALUE_LABELS ;
label values PL025_F PL025_F_VALUE_LABELS ;
label values PL040 PL040_VALUE_LABELS ;
label values PL040_F PL040_F_VALUE_LABELS ;
label values PL060_F PL060_F_VALUE_LABELS ;
label values PL073_F PL073_F_VALUE_LABELS ;
label values PL074_F PL074_F_VALUE_LABELS ;
label values PL075_F PL075_F_VALUE_LABELS ;
label values PL076_F PL076_F_VALUE_LABELS ;
label values PL080_F PL080_F_VALUE_LABELS ;
label values PL085_F PL085_F_VALUE_LABELS ;
label values PL086_F PL086_F_VALUE_LABELS ;
label values PL087_F PL087_F_VALUE_LABELS ;
label values PL088_F PL088_F_VALUE_LABELS ;
label values PL089_F PL089_F_VALUE_LABELS ;
label values PL090_F PL090_F_VALUE_LABELS ;
label values PL100_F PL100_F_VALUE_LABELS ;
label values PL111_F PL111_F_VALUE_LABELS ;
label values PL120 PL120_VALUE_LABELS ;
label values PL120_F PL120_F_VALUE_LABELS ;
label values PL130 PL130_VALUE_LABELS ;
label values PL130_F PL130_F_VALUE_LABELS ;
label values PL140 PL140_VALUE_LABELS ;
label values PL140_F PL140_F_VALUE_LABELS ;
label values PL150 PL150_VALUE_LABELS ;
label values PL150_F PL150_F_VALUE_LABELS ;
label values PL160 PL160_VALUE_LABELS ;
label values PL160_F PL160_F_VALUE_LABELS ;
label values PL170 PL170_VALUE_LABELS ;
label values PL170_F PL170_F_VALUE_LABELS ;
label values PL180 PL180_VALUE_LABELS ;
label values PL180_F PL180_F_VALUE_LABELS ;
label values PL190_F PL190_F_VALUE_LABELS ;
label values PL200_F PL200_F_VALUE_LABELS ;
label values PL211A PL211B PL211C PL211D PL211E PL211F PL211G PL211H PL211I PL211J PL211K PL211L PL211A_VALUE_LABELS ; 
label values PL211A_F PL211B_F PL211C_F PL211D_F PL211E_F PL211F_F PL211G_F 
             PL211H_F PL211I_F PL211J_F PL211K_F PL211L_F PL211A_F_VALUE_LABELS ;
label values PH010 PH010_VALUE_LABELS ;
label values PH010_F PH010_F_VALUE_LABELS ;
label values PH020 PH020_VALUE_LABELS ;
label values PH020_F  PH020_F_VALUE_LABELS ;
label values PH030 PH030_VALUE_LABELS ;
label values PH030_F PH030_F_VALUE_LABELS ;
label values PH040 PH040_VALUE_LABELS ;
label values PH040_F PH040_F_VALUE_LABELS ;
label values PH050 PH050_VALUE_LABELS ;
label values PH050_F PH050_F_VALUE_LABELS ;
label values PH060 PH060_VALUE_LABELS ;
label values PH060_F PH060_F_VALUE_LABELS ;
label values PH070 PH070_VALUE_LABELS ;
label values PH070_F PH070_F_VALUE_LABELS ;
label values PY010N_F PY010N_F_VALUE_LABELS ;
label values PY020N_F PY020N_F_VALUE_LABELS ;
label values PY021N PY021N_VALUE_LABELS ;
label values PY021N_F PY021N_F_VALUE_LABELS ;
label values PY035N_F PY035N_F_VALUE_LABELS ;
label values PY050N PY050N_VALUE_LABELS ;
label values PY050N_F PY050N_F_VALUE_LABELS ;
label values PY080N_F PY080N_F_VALUE_LABELS ;
label values PY090N_F PY090N_F_VALUE_LABELS ;
label values PY100N_F PY100N_F_VALUE_LABELS ; 
label values PY110N_F PY110N_F_VALUE_LABELS ;
label values PY120N_F PY120N_F_VALUE_LABELS ;
label values PY130N_F  PY130N_F_VALUE_LABELS ;
label values PY140N_F PY140N_F_VALUE_LABELS ;
label values PY010G_F PY010G_F_VALUE_LABELS ;
label values PY020G_F PY020G_F_VALUE_LABELS ;
label values PY021G PY021G_VALUE_LABELS ;
label values PY021G_F PY021G_F_VALUE_LABELS ;
label values PY030G PY030G_VALUE_LABELS ;
label values PY030G_F PY030G_F_VALUE_LABELS ;
label values PY031G PY031G_VALUE_LABELS ;
label values PY031G_F PY031G_F_VALUE_LABELS ;
label values PY035G_F PY035G_F_VALUE_LABELS ;
label values PY050G_F PY050G_F_VALUE_LABELS ;
label values PY080G_F PY080G_F_VALUE_LABELS ;
label values PY090G_F PY090G_F_VALUE_LABELS ;
label values PY100G_F PY100G_F_VALUE_LABELS ;
label values PY110G_F PY110G_F_VALUE_LABELS ;
label values PY120G_F PY120G_F_VALUE_LABELS ;
label values PY130G_F PY130G_F_VALUE_LABELS ;                             
label values PY140G_F PY140G_F_VALUE_LABELS ;
label values PY200G_F PY200G_F_VALUE_LABELS ;
label values PX020 PX020_VALUE_LABELS ;
label values PX040 PX040_VALUE_LABELS ;
label values PX050 PX050_VALUE_LABELS ;
label values PL051 PL051_VALUE_LABELS ;
label values PL051_F PL051_F_VALUE_LABELS ;
label values PC170 PC170_VALUE_LABELS ;
label values PC170_F PC170_F_VALUE_LABELS ;
label values PC180 PC180_VALUE_LABELS ;
label values PC180_F PC180_F_VALUE_LABELS ;

label data "Personal data file 2012" ;

compress ;
save "`stata_file'", replace ;

log close ;
set more on
#delimit cr



