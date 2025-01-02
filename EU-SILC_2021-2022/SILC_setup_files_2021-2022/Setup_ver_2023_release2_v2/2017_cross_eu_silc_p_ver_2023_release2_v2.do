* 2017_cross_eu_silc_p_ver_2023_release2_v2.do
*
* STATA Command Syntax File
* Stata 17.0;
*
* Transforms the EU-SILC CSV-data (as released by Eurostat) into a Stata systemfile
* Update:
* Update of missing value labels
* Including DOI
* 
* EU-SILC Cross 2018 - release 2023-release2 / DOI: 10.2907/EUSILC2004-2022V1
*
* When publishing statistics derived from the EU-SILC UDB, please state as source:
* "EU-SILC <Type> UDB <yyyy> - version of 2023-release2"
*
* Personal data file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_l*country_stub*17H.csv
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
* Pforr, Klaus, Johanna Jung and Carl Riemann (2024): 2017_cross_eu_silc_p_ver_2023_release2_v2.do, 1st update.
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

local log_file "$log/eusilc_2017_p" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2020) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2017_p_cs" ;



* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 

tempfile temp ;
save `temp', emptyok ;
foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HR HU IE IS IT LT LU LV MT NL NO PL PT RO RS SE SI SK UK { ;
      cd "$csv_path/`CC'/2017" ;
	  import delimited using "UDB_c`CC'17P.csv", case(upper) asdouble clear ;
	  append using `temp', force ;
save `temp', replace  ;
};

* Countries in data file are sorted in alphanumeric order ;
sort PB020;

log using "`log_file'", replace text;

* Note that some variables in the csv-data file might in lowercase
* To ensure that the dataset contains only variable names in uppercase ;

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
label variable PB130 "Quarter of birth (DE, IE, MT, SI, NL, UK: missing)" ;
label variable PB130_F "Flag" ;
label variable PB140 "Year of birth (MT: 5 yr groups; DE: Age group pertubation)" ;
label variable PB140_F "Flag" ;
label variable PB150 "Sex (DE, SI: in same sex HH: recoded gender)" ;
label variable PB150_F "Flag" ;
label variable PB160 "Father ID" ;
label variable PB160_F "Flag" ;
label variable PB170 "Mother ID" ;
label variable PB170_F "Flag" ;
label variable PB180 "Spouse/Partner ID" ;
label variable PB180_F "Flag" ;
label variable PB190 "Marital status (MT: 3,5=3)" ;
label variable PB190_F "Flag" ;
label variable PB200 "Consensual union" ;
label variable PB200_F "Flag" ;
label variable PB210 "Country of birth alphanumeric (DE,EE,LV,MT,SI: Recoded)" ;
label variable PB210_F "Flag" ;
label variable PB220A "Citizenship 1 alphanumeric (DE,EE,LV,MT,SI: Recoded)" ;
label variable PB220A_F "Flag" ;
label variable PD020 "Replace worn-out clothes by some new (not second-hand) ones";
label variable PD020_F "Flag";
label variable PD030 "Two pairs of properly fitting shoes (incl. a pair of all-weather shoes)";
label variable PD030_F "Flag";
label variable PD050 "Get-together with friends/family/relatives for a drink/meal at least once a mnth";
label variable PD050_F "Flag";
label variable PD060 "Regularly participate in a leisure activity";
label variable PD060_F "Flag";
label variable PD070 "Spend a small amount of money each week on yourself";
label variable PD070_F "Flag";
label variable PD080 "Internet connection for personal use at home";
label variable PD080_F "Flag";
label variable PE010 "Current education activity" ;
label variable PE010_F "Flag" ;
label variable PE020 "ISCED level currently attended (Top cod 50 & above; DE,IT,MT,SI: specific rules)" ;
label variable PE020_F "Flag" ;
label variable PE030 "Year when highest level of education was attained (DE: Age group pertubation)" ;
label variable PE030_F "Flag" ; 
label variable PE040 "Highest ISCED level attained (Top cod 500 & above; IE, IT, SI: specific rules)" ;
label variable PE040_F "Flag" ;
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
label variable PL015 "Person has ever worked" ;
label variable PL015_F "Flag" ;
label variable PL020 "Actively looking for a job" ;
label variable PL020_F "Flag" ;
label variable PL025 "Available for work" ;
label variable PL025_F "Flag" ;
label variable PL031 "Self-defined current economic status" ;
label variable PL031_F "Flag" ;
label variable PL035 "Worked at least one hour during the previous week" ;
label variable PL035_F "Flag" ;
label variable PL040 "Status in employment" ;
label variable PL040_F "Flag" ;
label variable PL051 "Occupation (ISCO-08 (COM)) (DE, MT, SI: grouped)" ;
label variable PL051_F	"Flag" ;
label variable PL060 "Number of hours usually worked per week in main job" ;
label variable PL060_F "Flag" ;
label variable PL073 "Number of months spent at full-time work as employee" ;
label variable PL073_F "Flag" ;
label variable PL074 "Number of months spent at part-time work as employee" ;
label variable PL074_F "Flag" ;
label variable PL075 "Number of months spent at full-time work as slfemplyed (including family worker)" ;
label variable PL075_F "Flag" ;
label variable PL076 "Number of months spent at part-time work as slfemplyed (including family worker)" ;
label variable PL076_F "Flag" ;
label variable PL080 "Number of months spent in unemployment" ;
label variable PL080_F "Flag" ;
label variable PL085 "Number of months spent in retirement" ;
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
label variable PL100 "Total number of hours usually worked in second, third...jobs" ;
label variable PL100_F "Flag" ;  
label variable PL111_F "Flag" ;
label variable PL111 "NACE (Rev 2)" ;
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
label variable PY010G "Employee cash or near cash income (gross, DE, SI: Top coding)" ;
label variable PY010G_F "Flag" ;
label variable PY010G_I "Imputation factor" ;
label variable PY020G "Non-cash employee income (gross)" ;  
label variable PY020G_F "Flag" ;
label variable PY020G_I "Imputation factor" ; 
label variable PY021G "Company car (in Euros, SI: Top coding)" ;
label variable PY021G_F "Flag" ;
label variable PY021G_I "Imputation factor" ;
label variable PY030G  "Employers social insurance contribution (in Euros, SI: Top coding)" ;
label variable PY030G_F "Flag" ;
label variable PY030G_I "Imputation factor" ;
label variable PY031G "Optional employer social insurance contributions (in Euros, SI: Top coding)" ;
label variable PY031G_F "Flag" ;
label variable PY031G_I "Imputation factor" ;
label variable PY035G "Contributions to individual private pension plans (gross, SI: Top coding)" ;
label variable PY035G_F "Flag" ;
label variable PY035G_I "Imputation factor" ;
label variable PY050G "Cash benefits or losses from selfemployment (gross, DE, SI: Top & bottom coding)" ;
label variable PY050G_F "Flag" ;
label variable PY050G_I "Imputation factor" ;
label variable PY080G  "Pension from individual private plans (gross, DE, SI: Top coding)" ;
label variable PY080G_F "Flag" ;
label variable PY080G_I "Imputation factor" ;
label variable PY090G  "Unemployment benefits (gross, DE, SI: Top coding)" ;
label variable PY090G_F "Flag" ;
label variable PY090G_I "Imputation factor" ;
* For PY091G-PY144G: Please see Differences Collection vs UDB for more information ;
label variable PY091G "Unemployment benefits (contributory and means-tested, DE: Adjustments)";
label variable PY091G_F "Flag";
label variable PY092G "Unemployment benefits (contributory and non means-tested, DE, SI: Adjustments)";
label variable PY092G_F "Flag";
label variable PY093G "Unemployment benefits (non-contributory and means-tested, DE: Adjustments)";
label variable PY093G_F "Flag";
label variable PY094G "Unemployment benefits (non-contributory and non means-tested, DE, SI: Adj)";
label variable PY094G_F "Flag";
label variable PY100G "Old-age benefits (gross, DE, SI: Top coding)" ;
label variable PY100G_F "Flag" ;
label variable PY100G_I "Imputation factor" ;
label variable PY101G "Old-age benefits (contributory and means-tested, DE: Adjustments)";
label variable PY101G_F "Flag";
label variable PY102G "Old-age benefits (contributory and non means-tested, DE, SI: Adjustments)";
label variable PY102G_F "Flag";
label variable PY103G "Old-age benefits (non-contributory and means-tested, DE: Adjustments)";
label variable PY103G_F "Flag";
label variable PY104G "Old-age benefits (non-contributory and non means-tested, DE, SI: Adjustments)";
label variable PY104G_F "Flag";
label variable PY110G "Survivor benefit (gross, SI: Top coding)" ;
label variable PY110G_F "Flag" ;
label variable PY110G_I "Imputation factor" ;
label variable PY111G "Survivor benefits (contributory and means-tested)";
label variable PY111G_F "Flag";
label variable PY112G "Survivor benefits (contributory and non means-tested, SI: Adjustments)";
label variable PY112G_F "Flag";
label variable PY113G "Survivor benefits (non-contributory and means-tested, SI: Adjustments)";
label variable PY113G_F "Flag";
label variable PY114G "Survivor benefits (non-contributory and non means-tested, SI: Adjustments)";
label variable PY114G_F "Flag";
label variable PY120G "Sickness benefits (gross, SI: Top coding)" ;
label variable PY120G_F "Flag" ;
label variable PY120G_I "Imputation factor" ;
label variable PY121G "Sickness benefits (contributory and means-tested)";
label variable PY121G_F "Flag";
label variable PY122G "Sickness benefits (contributory and non means-tested)";
label variable PY122G_F "Flag";
label variable PY123G "Sickness benefits (non-contributory and means-tested)";
label variable PY123G_F "Flag";
label variable PY124G "Sickness benefits (non-contributory and non means-tested)";
label variable PY124G_F "Flag";
label variable PY130G "Disability benefits (gross, SI: Top coding)" ;
label variable PY130G_F "Flag" ;   
label variable PY130G_I "Imputation factor" ;  
label variable PY131G "Disability benefits (contributory and means-tested)";
label variable PY131G_F "Flag";
label variable PY132G "Disability benefits (contributory and non means-tested, SI: Adjustments)";
label variable PY132G_F "Flag";                         
label variable PY133G "Disability benefits (non-contributory and means-tested, SI: Adjustments)";
label variable PY133G_F "Flag";
label variable PY134G "Disability benefits (non-contributory and non means-tested)";
label variable PY134G_F "Flag";
label variable PY140G "Education-related allowances (gross, SI: Top coding)" ;
label variable PY140G_F "Flag" ;
label variable PY140G_I "Imputation factor" ;
label variable PY141G "Education-related allowances (contributory and means-tested)";
label variable PY141G_F "Flag";
label variable PY142G "Education-related allowances (contributory and non means-tested)";
label variable PY142G_F "Flag";
label variable PY143G "Education-related allowances (non-contributory and means-tested)";
label variable PY143G_F "Flag";
label variable PY144G "Education-related allowances (non-contributory and non means-tested, SI: Adj)";
label variable PY144G_F "Flag";
label variable PY200G "Gross monthly earnings for employees (gross)" ;
label variable PY200G_F "Flag" ;
label variable PY200G_I "Imputation factor" ;
label variable PY010N "Employee cash or near cash income (net, DE, SI: Top coding)" ;
label variable PY010N_F "Flag" ;
label variable PY010N_I "Imputation factor" ;
label variable PY020N "Non-cash employee income (net)" ;
label variable PY020N_F "Flag" ;
label variable PY020N_I "Imputation factor" ;
label variable PY021N   "Company car (in Euros, SI: Top coding)" ;
label variable PY021N_F "Flag" ;
label variable PY021N_I "Imputation factor" ;
label variable PY035N "Contributions to individual private pension plans (net, SI: Top coding)" ;
label variable PY035N_F "Flag" ;
label variable PY035N_I "Imputation factor" ;
label variable PY050N "Cash benefits or losses from self-employment (net, DE, SI: Top & bottom coding)" ;
label variable PY050N_F "Flag" ;
label variable PY050N_I "Imputation factor" ;
label variable PY080N "Pension from individual private plans (net, DE, SI: Top & bottom coding)" ;
label variable PY080N_F "Flag" ;
label variable PY080N_I "Imputation factor" ;
label variable PY090N "Unemployment benefits (net, DE, SI: Top coding)" ;
label variable PY090N_F "Flag" ;
label variable PY090N_I "Imputation factor" ;
label variable PY100N "Old-age benefits (net, DE, SI: Top coding)" ;
label variable PY100N_F "Flag" ;  
label variable PY100N_I "Imputation factor" ;   
label variable PY110N "Survivors benefits (net, SI: Top coding)" ;
label variable PY110N_F "Flag" ;
label variable PY110N_I "Imputation factor" ;
label variable PY120N "Sickness benefits (net, SI: Top coding)" ;
label variable PY120N_F "Flag" ;
label variable PY120N_I "Imputation factor" ;
label variable PY130N "Disability benefits (net, SI: Top coding)" ;
label variable PY130N_F "Flag" ;
label variable PY130N_I "Imputation factor" ;
label variable PY140N "Education-related allowances (net, SI: Top coding)" ;
label variable PY140N_F "Flag" ;
label variable PY140N_I "Imputation factor" ;
label variable PX010 "Exchange rate" ;
label variable PX020 "Age at the end of the income reference period (DE: age group pertubation)" ;
label variable PX030 "Household ID" ;
label variable PX040 "Respondent status" ;
label variable PX050 "Activity status" ;

* Ad-hoc module for physical health ;
label variable PH080 "Number of visits to a dentist or orthodontist" ;
label variable PH080_F "Flag" ;
label variable PH090 "Number of consultations of a general practitioner or family doctor" ;
label variable PH090_F "Flag" ;
label variable PH100 "Number of consultations of a medical or surgical specialist" ;
label variable PH100_F "Flag" ;
label variable PH110 "Body mass index (BMI) (16: bottom coding/ 40: top coding)" ;
label variable PH110_F "Flag" ;
label variable PH120 "Type of physical activity when working" ;
label variable PH120_F "Flag" ;
label variable PH130 "Time spent on physical activities (excluding working) in a typical week" ;
label variable PH130_F "Flag" ;
label variable PH140 "Frequency of eating fruit" ;
label variable PH140_F "Flag" ;
label variable PH150 "Frequency of eating vegetables or salad" ;
label variable PH150_F "Flag" ;


* Definition of category labels ;

label define PB040_F_VALUE_LABELS             
1 "Filled"
;
label define PB060_F_VALUE_LABELS             
 1 "Filled"
-2 "Not applicable (country does not use the selected respondent model)"
-3 "Not selected respondent"
;
label define PB100_VALUE_LABELS               
1 "January, February, March"
2 "April, May, June"
3 "July, August, September"
4 "October, November, December"
;
label define PB100_F_VALUE_LABELS             
 1 "Filled"
-1 "Missing"
;
label define PB110_F_VALUE_LABELS              
 1 "Filled"
-1 "Missing"
;
label define PB120_F_VALUE_LABELS              
 1 "Filled"
-1 "Missing"
-2 "Not applicable (information only extracted from registers)"
;
label define PB130_VALUE_LABELS                
1 "January, February, March"
2 "April, May, June"
3 "July, August, September"
4 "October, November, December"
;
label define PB130_F_VALUE_LABELS              
 1 "Filled"
-1 "Missing"
;
label define PB140_VALUE_LABELS             
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
;
label define PB140_F_VALUE_LABELS             
 1 "Filled"
-1 "Missing"
;
label define PB150_VALUE_LABELS                
1 "Male"
2 "Female"
;
label define PB150_F_VALUE_LABELS              
 1 "Filled"
-1 "Missing"
;
label define PB160_F_VALUE_LABELS              
 1 "Filled"
-1 "Missing"
-2 "Not applicable (father is not a household member)"
;
label define PB170_F_VALUE_LABELS             
 1 "Filled"
-1 "Missing"
-2 "Not applicable (mother is not a household member)"
;
label define PB180_F_VALUE_LABELS              
 1 "Filled"
-1 "Missing"
-2 "Not applicable (person has no spouse/partner or spouse/partner is not a household member)"
;
label define PB190_VALUE_LABELS                
1 "Never married"
2 "Married" 
3 "Separated,MT:3,5=3"
4 "Widowed"
5 "Divorced"
;
label define PB190_F_VALUE_LABELS              
 1 "Filled"
-1 "Missing"
;
label define PB200_VALUE_LABELS                
1 "Yes, on a legal basis"
2 "Yes, without a legal basis"
3 "No"
;
label define PB200_F_VALUE_LABELS              
 1 "Filled"
-1 "Missing"
;
label define PB210_F_VALUE_LABELS             
 1 "Filled"
-1 "Missing"
;
label define PB220A_F_VALUE_LABELS            
 1 "Filled"
-1 "Missing"
;
label define PD020_VALUE_LABELS 
1 "Yes"
2 "No - cannot afford it"
3 "No - other reason"
;
label define PD020_F_VALUE_LABELS 
 1 "Filled"
-1 "Missing"
-3 "Not selected respondent"
;
label define PE010_VALUE_LABELS               
1 "In education"
2 "Not in education"
;
label define PE010_F_VALUE_LABELS            
 1 "Filled"
-1 "Missing"
;
label define PE020_VALUE_LABELS               
0 "Pre-primary education/Early childhood education (PB010>2013)"
1 "Primary education"
2 "Lower secondary education"
3 "(Upper) Secondary education"
4 "Post-secondary non-tertiary education"
5 "1st stage & 2nd stage of tertiary education"
6 "Second stage of tertiary education (leading to an advanced research qualification)"
10 "Primary education (PB010>2013)"
20 "Lower secondary education (PB010>2013)"
30 "Upper secondary education (not further specified)(PB010>2013)"
34 "General education (Only for people 16-34, PB010>2013)"
35 "Vocational education (Only for people 16-34, PB010>2013)"
40 "Post-secondary non tertiary education (not further specified) (PB010>2013)"
44 "General education (Only for people 16-34, PB010>2013)"
45 "Vocational education (Only for people 16-34, PB010>2013)"
50 "Short cycle tertiary (PB010>2013)"
60 "Bachelor or equivalent (PB010>2013)"
70 "Master or equivalent (PB010>2013)2"
80 "Doctorate or equivalent(PB010>2013)"
;
label define PE020_F_VALUE_LABELS             
 1 "Filled"
-1 "Missing"
-2 "Not applicable (PE010 not=1)"
;
label define PE030_VALUE_LABELS 
1946 "1946 SI: bottom coding"
;
label define PE030_F_VALUE_LABELS            
 1 "Filled"
-1 "Missing"
-2 "Not applicable (the person has never been in education)"
;
label define PE040_VALUE_LABELS              
0 "Pre-primary education; Less than primary education (PB010>2013)"
1 "Primary education"
2 "Lower secondary education"
3 "(upper) secondary education"
4 "Post-secondary non-tertiary education"
5 "1st & 2nd stage of tertiary education "
6 "second stage of tertiary education (leading to an advanced research qualification)"
100 "Primary education (PB010>2013)"
200 "Lower secondary education(PB010>2013) SI: Bottom coding: grouping 000, 100, 200 into 200)"
300 "Upper secondary education (not further specified) (PB010>2013)"
34 "General education  (Only for people 16-34; PB010>2013)"
340 "Without distinction of direct access to tertiary education (Only for people 16-34 PB010>2013)"
342 "Partial level completion and without direct access to tertiary education   (Only for people 16-34 PB010>2013)"
343 "Level completion, without direct access to tertiary education   (Only for people 16-34  PB010>2013)"
344 "Level completion, with direct access to tertiary education   (Only for people 16-34  PB010>2013)"
35 "Vocational education   (Only for people 16-34  PB010>2013)"
350 "Without distinction of direct access to tertiary education   (Only for people 16-34  PB010>2013)"
352 "Partial level completion and without direct access to tertiary education   (Only for people 16-34  PB010>2013)"
353 "Level completion, without direct access to tertiary education   (Only for people 16-34  PB010>2013)"
354 "Level completion, with direct access to tertiary  education   (Only for people 16-34  PB010>2013)"
400 "Post-secondary non-tertiary education (not further specified) (PB010>2013)"
440 "General education   (Only for people 16-34  PB010>2013)"
450 "Vocational education (PB010>2013)"
500 "Short cycle tertiary (PB010>2013)(Top coding: 500 & above)"
600 "Bachelor or equivalent (PB010>2013)"
700 "Master or equivalent (PB010>2013)"
800 "Doctorate or equivalent (PB010>2013)"
;
label define PE040_F_VALUE_LABELS           
 1 "Filled"
-1 "Missing"
-2 "Not applicable (the person has never been in education)"
;
label define PH010_VALUE_LABELS                
1 "Very good"
2 "Good"
3 "Fair"
4 "Bad"
5 "Very bad"
;
label define PH010_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-3 "Not selected respondent"
;
label define PH020_VALUE_LABELS                
1 "Yes"
2 "No"
;
label define PH020_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-3 "Not selected respondent"
;
label define PH030_VALUE_LABELS               
1 "Yes, strongly limited"
2 "Yes, limited"
3 "No, not limited"
;
label define PH030_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-3 "Not selected respondent"
;
label define PH040_VALUE_LABELS                
1 "Yes there was at least one occasion when the person really needed examination or treatment but did not"               
2 "No, there was no occasion when the person really needed examination or treatment but did not"
;
label define PH040_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable: the person did not really need any medical examination or treatment"
-3 "Not selected respondent"
;
label define PH050_VALUE_LABELS                
1 "Could not afford to (too expensive)"
2 "Waiting list"
3 "Could not take time because of work, care for children or for others"
4 "Too far to travel/no means of transportation"
5 "Fear of doctor/hospital/examination/treatment"
6 "Wanted to wait and see if problem got better on its own"
7 "Did not know any good doctor or specialist"
8 "Other reasons"
;
label define PH050_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable (PH040 not=1)"
-3 "Not selected respondent"
;
label define PH060_VALUE_LABELS                
1 "Yes there was at least one occasion when the person really needed dental examination or treatment but did not"               
2 "No, there was no occasion when the person really needed dental examination or treatment but did not"
;
label define PH060_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable: the person did not really need any dental examination or treatment"
-3 "Not selected respondent"
;
label define PH070_VALUE_LABELS               
1 "Could not afford to (too expensive)"
2 "Waiting list"
3 "Could not take time because of work, care for children or for others"
4 "Too far to travel/no means of transportation"
5 "Fear of doctor(dentist)/hospital/examination/treatment"
6 "Wanted to wait and see if problem got better on its own"
7 "Did not know any dentist"
8 "Other reasons"
;
label define PH070_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable (PH060 not =1)"
-3 "Not selected respondent"
;
label define PL015_VALUE_LABELS              
1 "Yes"
2 "No"
;
label define PL015_F_VALUE_LABELS            
1  "Filled"
-1 "Missing"
-2 "Not applicable (PL031=1,2, 3 or 4)"
;
label define PL020_VALUE_LABELS              
1 "Yes"
2 "No"
;
label define PL020_F_VALUE_LABELS            
1 "Filled"
-1 "Missing"
-2 "Not applicable (PL031=1,2,3 or 4)"
;
label define PL025_VALUE_LABELS              
1 "Yes"
2 "No"
;
label define PL025_F_VALUE_LABELS            
1  "Filled"
-1 "Missing"
-2 "Not applicable (PL020=2)"
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
 1 "Filled"
-1 "Missing"
;
label define PL035_VALUE_LABELS              
1 "Yes"
2 "No"
;
label define PL035_F_VALUE_LABELS            
1 "Filled"
-1 "Missing"
-2 "Not applicable (person is not employee or MS has other source to calculate the gender pay gap)"
-3 "not selected respondent"
;       
label define PL040_VALUE_LABELS                
1 "Self-employed with employees"
2 "Self-employed without employees"
3 "Employee"
4 "Family worker"
;
label define PL040_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable (PL015 not equal to 1 and PL031 not equal to 1,2,3 or 4)" 
;
label define PL051_VALUE_LABELS
0 "DE: 01-03; SI: Armed Forces"
1 "Commissioned armed forces officers (DE, MT, SI: 11-14 Legislators,senior officials & managers)"
2 "Non-commissioned armed forces officers (DE, MT, SI: 21-26 Professionals)"
3 "Armed forces occupations, other ranks (DE, MT, SI:31-35 Technicians & associate professionals)"
4 "DE, MT, SI: 41-44 Clerks"
5 "DE, MT, SI: 51-54 Service workers and shop and market sales workers"
6 "DE, MT, SI: 61-63 Skilled agricultural and fishery workers"
7 "DE, MT, SI: 71-75 Craft and related trades workers"
8 "DE, MT, SI: 81-83 Plant and machine operators and assemblers"
9 "DE, MT, SI: 91-96 Elementary occupations"
10 "MT:01 Armed forces"
11 "Chief executives, senior officials and legislators"
12 "Administrative and commercial managers"
13 "Production and specialised services managers"
14 "Hospitality, retail and other services managers, PT:11,12 and 13 into 14"
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
label define PL051_F_VALUE_LABELS   
1  "Filled"
-1 "Missing"
-2 "Not applicable (PL015 not = 1)"
;
label define PL060_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable (PL031 not = 1, 2, 3 or 4)"
-6 "Hours varying(even an average over 4 weeks is not possible)"
;
label define PL073_F_VALUE_LABELS              
1 "Filled"
-1 "Missing"
-5 "Missing value because the definition of this variable is not used"
;
label define PL100_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable (person does not have a 2nd job or PL031 not = 1, 2, 3 or 4)"
;
label define PL111_F_VALUE_LABELS
1  "Filled"
-1 "Missing"
-2 "Not applicable (PL031 not = 1,2,3 or 4)"
-3 "Not selected respondent"
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
1  "Filled"
-1 "Missing"
-2 "Not applicable (PL031 = 1,2,3 or 4, and PL060 + PL100 < 30)" 
-3 "Not selected respondent"
;
label define PL130_VALUE_LABELS
1  "1; MT: 1-5"
2  "2; MT: 6-10"
3  "3; MT: 11-12"
4  "4; MT: 13"
5  "5; MT: 14" 
6  "6; MT: 15"               
11 "Between 11 and 19 persons"
12 "Between 20 and 49 persons"
13 "50 persons or more"
14 "Do not know but less than 11 persons"
15 "Do not know but more than 10 persons"
;
label define PL130_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable(PL031 not = 1, 2, 3 or 4)" 
-3 "Not selected respondent"
;
label define PL140_VALUE_LABELS                
1 "Permanent job: work contract of unlimited duration" 
2 "Temporary job: work contract of limited duration"
;
label define PL140_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable (Pl040 not=3)"
-3 "Not selected respondent"
-4 "Not applicable (person is employee (PL040 not=3) but has not any contract)"   
;
label define PL150_VALUE_LABELS                
1 "Supervisory"
2 "Non-supervisory"
;
label define PL150_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable (PL040 not=3)"
-3 "Not selected respondent"
;
label define PL160_VALUE_LABELS                
1 "Yes"
2 "No"
; 
label define PL160_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable (PL031 not = 1, 2, 3 or 4)" 
-3 "Not selected respondent"
;
label define PL170_VALUE_LABELS                
1 "To take up or seek better job"
2 "End of temporary contract"
3 "Obliged to stop by employer (business closure, redundancy, early retirement, dismissal etc."
4 "Sale or closure of own/family business"
5 "Child care and care for other dependant"
6 "Partners job required us to move to another area or marriage"
7 "Other reasons"
;
label define PL170_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable (PL160 not equal to 1)" 
-3 "Not selected respondent"
;            
label define PL180_VALUE_LABELS                
1 "Employed - unemployed; MT:1-3=1"
2 "Employed - retired; MT:4-6=2"
3 "Employed - other inactive; MT:7-9=3"
4 "Unemployed - employed; MT:10-12=4"
5 "Unemployed - retired"
6 "Unemployed - other inactive"
7 "Retired - employed"
8 "Retired - unemployed" 
9 "Retired - other inactive"
10 "Other inactive - employed"
11 "Other inactive - unemployed"
12 "Other inactive - retired"
;
label define PL180_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable (no change since last year)"
-3 "Not selected respondent"
;
label define PL190_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable  (person never worked( PL031 not = 1, 2, 3 or 4 AND PL015 not= 1))"
-3 "Not selected respondent" 
;
label define PL200_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable (person never worked (PL031 not = 1, 2, 3 or 4 AND PL015 not= 1))"
-3 "Not selected respondent"  
;
label define PL211A_VALUE_LABELS
1 "Employee working full-time"
2 "Employee working part-time"
3 "Self-employed working full-time (including family worker)"
4 "Self-employed working part-time (including family worker)"
5 "Unemployed"
6 "Pupil, student, further training, unpaid work experience"
7 "In retirement or in early retirement or has given up business"
8 "Permanently disabled or;and unfit to work"
9 "In compulsory military community or service"
10 "Fulfilling domestic tasks and care responsibilities"
11 "Other inactive person"
;
label define PL211A_F_VALUE_LABELS
1  "Filled"
-1 "Missing"
-3 "Not selected respondent"
;
label define PY010G_F_VALUE_LABELS             
0 "No income"
1 "Collected net of tax on income at source and social contribution"
2 "Collected net of tax on income at source"
3 "Collected net of tax on social contribution"
4 "Gross"
5 "Unknown"
6 "Mix (parts of the component collected according to different ways)"
-1 "Missing"
-2 "Not applicable (PL040 not equal to 3 or MS has other source to calculate the gender pay gap"
-4 "Missing (amount included in another income component)"
-5 "Not filled: variable of the net series is filled"
;
label define PY021G_VALUE_LABELS               
0 "No income"
;
label define PY030G_VALUE_LABELS               
0 "No contribution"
;
label define PY030G_F_VALUE_LABELS            
-5 "Not filled: variable of the net series is filled"
-1 "Missing"
0 "No income"
1 "Filled"
;
label define PY031G_VALUE_LABELS               
0 "No contribution"
;
label define PY035G_F_VALUE_LABELS            
0 "No contribution"
1 "Filled"
-1 "Missing"
-5 "Not filled: variable of net series is filled" 
;  
label define PY091G_F_VALUE_LABELS
2 "Filled with mixed components"
1 "Filled with only contributory and means-tested components"
0 "No income"
-1 "Missing"
-2 "Not available This scheme doesn't exist at national level"
-7 "Not available (PB010 < 2014)"
;
label define PY010N_F_VALUE_LABELS             
0  "No income"
11 "Collected & recorded net of tax on income at source & social contributions"
13 "Collected net of tax on income source and social contributions & record net of tax on social contributions"   
22 "Collected & recorded net of tax on income at source" 
23 "Collected net of tax on income source & recorded net of tax on social contributions"
31 "Collected net of tax on social contributions & recorded net of tax on income & social contributions"
33 "Collected & recorded net of tax on social contributions"
41 "Collected gross/recorded net of tax on income & social contributions"
42 "Collected gross/recorded net of tax on income at source"
43 "Collected gross/recorded net of tax on social contributions"
51 "Collected unknown/recorded net of tax on income & social contributions"
53 "Collected unknown/recorded net of tax on social contributions"
55 "Type of collection & recording: Unknown"
56 "Type of collection & recording: Mix (parts of the component collected according to different methods)"
61 "Mix/deductive imputation"
63 "Collected: Mix & recorded: Net of tax on social contributions"
-1 "Missing"
-4 "Missing (amount included in another income component)"
-5 "Not filled: variable of gross series is filled"
;
label define PY021N_VALUE_LABELS               
0 "No income"
;
label define PY035N_F_VALUE_LABELS             
0  "No contribution"
1  "Filled"
-1 "Missing"
-5 "Not filled: variable of the gross series is filled"
;
label define PY050N_VALUE_LABELS              
0 "No income"
;
label define PX020_VALUE_LABELS               
15 "MT: 15-19"
20 "MT: 20-24"
25 "MT: 25-29"
30 "MT: 30-34"
35 "MT: 35-39"
40 "MT: 40-44"
45 "MT: 45-49"
50 "MT: 50-54"
55 "MT: 55-59"
60 "MT: 60-64"
65 "MT: 65-69"
70 "MT: 70-74"
73 "DE: 73 and over"
76 "MT: 76 and over"
80 "80 and over"
;
label define PX040_VALUE_LABELS                
1 "Current household member aged >=16 (All hhld members aged >=16 are interviewed)"
2 "Selected respondent(Only selected hhld member aged >= 16 is interviewed)"
3 "Not selected respondent (Only selected hhld member aged >= 16 is interviewed)"
4 "Not eligible person (Hhld members aged < 16 at the time of interview)"
;
label define PX050_VALUE_LABELS                
2 "Employees (SAL)" 
3 "Employed persons except employees (NSAL)" 
4 "Other employed (when time of SAL and NSAL is > 0.5 of total time calendar)" 
5 "Unemployed" 
6 "Retired" 
7 "Inactive"  
8 "Other inactive (when time of unemployed, retirement & inactivity is > 0.5 total time calendar)"
;

* Ad-hoc module for physical health ;

label define PH080_VALUE_LABELS               
1 "None"
2 "1-2 times"
3 "3-5 times"
4 "6-9 times"
5 "10 times or more"
;
label define PH080_F_VALUE_LABELS              
1 "Filled"
-1 "Missing"
-3 "Non-selected respondent"
-7 "Not applicable (PB010 not equal 2017)"
;
label define PH090_VALUE_LABELS               
1 "None"
2 "1-2 times"
3 "3-5 times"
4 "6-9 times"
5 "10 times or more"
;
label define PH090_F_VALUE_LABELS              
1 "Filled"
-1 "Missing"
-3 "Non-selected respondent"
-7 "Not applicable (PB010 not equal 2017)"
;
label define PH100_VALUE_LABELS 
1 "None"
2 "1-2 times"
3 "3-5 times"
4 "6-9 times"
5 "10 times or more"
;
label define PH100_F_VALUE_LABELS 
1 "Filled"
-1 "Missing"
-3 "Non-selected respondent"
-7 "Not applicable (PB010 not equal 2017)"
;
label define PH110_F_VALUE_LABELS 
1  "Filled"
-1 "Missing"
-3 "Non-selected respondent"
-7 "Not applicable (PB010 not equal 2017)"
;
label define PH120_VALUE_LABELS 
1 "Mostly sitting"
2 "Mostly standing"
3 "Mostly walking or tasks of moderate physical effort"
4 "Mostly heavy labour or physically demanding work"
;
label define PH120_F_VALUE_LABELS 
1  "Filled"
-1 "Missing"
-2 "Not applicable (not performing any working tasks)"
-3 "Non-selected respondent"
-7 "Not applicable (PB010 not equal 2017)"
;
label define PH130_F_VALUE_LABELS 
1  "Filled"
-1 "Missing"
-3 "Non-selected respondent"
-7 "Not applicable (PB010 not equal 2017)"
;
label define PH140_VALUE_LABELS 
1 "Twice or more a day"
2 "Once a day"
3 "4 to 6 times a week"
4 "1 to 3 times a week"
5 "Less than once a week"
6 "Never"
;
label define PH140_F_VALUE_LABELS 
 1 "Filled"
-1 "Missing"
-3 "Non-selected respondent"
-7 "Not applicable (PB010 not equal 2017)"
;
label define PH150_VALUE_LABELS 
1 "Twice or more a day"
2 "Once a day"
3 "4 to 6 times a week"
4 "1 to 3 times a week"
5 "Less than once a week"
6 "Never"
;
label define PH150_F_VALUE_LABELS 
1  "Filled"
-1 "Missing"
-3 "Non-selected respondent"
-7 "Not applicable (PB010 not equal 2017)"
;

* Attachment of category labels to variables ;

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
label values PD020 PD030 PD050 PD060 PD070 PD080 PD020_VALUE_LABELS ;
label values PD020_F PD030_F PD050_F PD060_F PD070_F PD080_F PD020_F_VALUE_LABELS ;
label values PE010 PE010_VALUE_LABELS ;
label values PE010_F PE010_F_VALUE_LABELS ;
label values PE020 PE020_VALUE_LABELS ;
label values PE020_F PE020_F_VALUE_LABELS ;
label values PE030 PE030_VALUE_LABELS ;
label values PE030_F PE030_F_VALUE_LABELS ;
label values PE040 PE040_VALUE_LABELS ;
label values PE040_F PE040_F_VALUE_LABELS ;
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
label values PL015 PL015_VALUE_LABELS ;
label values PL015_F PL015_F_VALUE_LABELS ;
label values PL020 PL020_VALUE_LABELS ;
label values PL020_F PL020_F_VALUE_LABELS ;
label values PL025 PL025_VALUE_LABELS ;
label values PL025_F PL025_F_VALUE_LABELS ;
label values PL031 PL031_VALUE_LABELS ;
label values PL031_F PL031_F_VALUE_LABELS ;
label values PL035 PL035_VALUE_LABELS ;
label values PL035_F PL035_F_VALUE_LABELS ;
label values PL040 PL040_VALUE_LABELS ;
label values PL040_F PL040_F_VALUE_LABELS ;
label values PL051_F PL051_F_VALUE_LABELS ;
label values PL051 PL051_VALUE_LABELS ;
label values PL060_F PL060_F_VALUE_LABELS ;
label values PL073_F PL074_F PL075_F PL076_F PL080_F PL085_F ///
			 PL086_F PL087_F PL088_F PL089_F PL090_F PL073_F_VALUE_LABELS ;
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
label values PL211A PL211B PL211C PL211D PL211E PL211F PL211G PL211H ///
             PL211I PL211J PL211K PL211L PL211A_VALUE_LABELS ; 
label values PL211A_F PL211B_F PL211C_F PL211D_F PL211E_F PL211F_F PL211G_F ///
             PL211H_F PL211I_F PL211J_F PL211K_F PL211L_F PL211A_F_VALUE_LABELS ;
label values PY010G_F PY020G_F PY021G_F PY050G_F PY080G_F PY090G_F ///
             PY100G_F PY110G_F PY120G_F PY130G_F PY140G_F PY200G_F PY010G_F_VALUE_LABELS ;
label values PY021G PY021G_VALUE_LABELS ;
label values PY030G PY030G_VALUE_LABELS ;
label values PY030G_F PY031G_F PY030G_F_VALUE_LABELS ;
label values PY031G PY031G_VALUE_LABELS ;
label values PY035G_F PY035G_F_VALUE_LABELS ;
label values PY091G_F PY101G_F PY111G_F PY121G_F PY131G_F PY141G_F ///
             PY092G_F PY102G_F PY112G_F PY122G_F PY132G_F PY142G_F ///
			 PY093G_F PY103G_F PY113G_F PY123G_F PY133G_F PY143G_F ///
			 PY094G_F PY104G_F PY114G_F PY124G_F PY134G_F PY144G_F PY091G_F_VALUE_LABELS ; 
label values PY010N_F PY020N_F PY021N_F PY050N_F PY080N_F PY090N_F ///
             PY100N_F PY110N_F PY120N_F PY130N_F PY140N_F PY010N_F_VALUE_LABELS ;
label values PY021N PY021N_VALUE_LABELS ;
label values PY035N_F PY035N_F_VALUE_LABELS ;
label values PY050N PY050N_VALUE_LABELS ;
label values PX020 PX020_VALUE_LABELS ;
label values PX040 PX040_VALUE_LABELS ;
label values PX050 PX050_VALUE_LABELS ;

* Ad-hoc module for physical health ;
label values PH080 PH080_VALUE_LABELS ;
label values PH080_F PH080_F_VALUE_LABELS ;
label values PH090 PH090_VALUE_LABELS ;
label values PH090_F PH090_F_VALUE_LABELS ;
label values PH100 PH100_VALUE_LABELS ;
label values PH100_F PH100_F_VALUE_LABELS ;
label values PH110_F PH110_F_VALUE_LABELS ;
label values PH120 PH120_VALUE_LABELS ;
label values PH120_F PH120_F_VALUE_LABELS ;
label values PH130_F PH130_F_VALUE_LABELS ;
label values PH140 PH140_VALUE_LABELS ;
label values PH140_F PH140_F_VALUE_LABELS ;
label values PH150 PH150_VALUE_LABELS ;
label values PH150_F PH150_F_VALUE_LABELS ;

label data "Personal data file 2017" ;

compress ;
save "`stata_file'", replace ;

log close ;
set more on
#delimit cr



