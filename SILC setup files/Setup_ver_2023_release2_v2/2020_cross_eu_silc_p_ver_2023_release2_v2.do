* 2020_cross_eu_silc_p_ver_2023_release2_v2.do 
*
* STATA Command Syntax File
* Stata 17.0;
*
* Transforms the EU-SILC CSV-data (as released by Eurostat) into a Stata systemfile
* Update:
* Update of missing value labels
* Including DOI
* 
* EU-SILC Cross 2020 - release 2023-release2 / DOI: 10.2907/EUSILC2004-2022V1
*
* When publishing statistics derived from the EU-SILC UDB, please state as source:
* "EU-SILC <Type> UDB <yyyy> - version of 2023-release2"
*
* Personal data file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_c*country_stub*20P.csv
* 
* (c) GESIS 2024-07-08
*
* PLEASE NOTE
* For Differences between data as described in the guidelines
* and the anonymised user database as well as country specific anonymisation measures see:
* C-2020 DIFFERENCES BETWEEN DATA COLLECTED.doc	
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
* Pforr, Klaus, Johanna Jung and Carl Riemann (2024): 2020_cross_eu_silc_p_ver_2023_release2_v2.do, 1st update.
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

local log_file "$log/eusilc_2020_p" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2020) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2020_p_cs" ;

* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 
tempfile temp ;
save `temp', emptyok ;

foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HR HU IE /*IS*/ IT LT LU LV MT NL NO PL PT RO RS SE SI SK /*UK*/ { ;
      cd "$csv_path/`CC'/2020" ;	
	  import delimited using "UDB_c`CC'20P.csv", case(upper) asdouble clear stringcols(224 232 234 240 248 256 258 266);
	  * In some countries non-numeric characters are wrongfully included.
      * This command prevents errors in the format. ;
      destring PY092G_F, ignore("**") replace;
      destring PY102G_F, ignore("**") replace;
      destring PY103G_F, ignore("**") replace;
      destring PY112G_F, ignore("**") replace;
      destring PY122G_F, ignore("**") replace;
      destring PY132G_F, ignore("**") replace;
      destring PY133G_F, ignore("**") replace;
      destring PY143G_F, ignore("**") replace;
	  append using `temp', force ;
	save `temp', replace  ;
} ;

* Countries in data file are sorted in alphanumeric order ;
sort PB020;

log using "`log_file'", replace text;

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
label variable PB140 "Year of birth (MT: 5 yr groups)" ;
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
label variable PB210 "Country of birth alphanumeric (DE, EE, LV, MT, SI: Recoded)" ;
label variable PB210_F "Flag" ;
label variable PB220A "Citizenship 1 alphanumeric (DE, EE, LV, MT, SI: Recoded)" ;
label variable PB220A_F "Flag" ;
label variable PD020 "Replace worn-out clothes by some new (not second-hand) ones";
label variable PD020_F "Flag";
label variable PD030 "Two pairs of properly fitting shoes (incl. a pair of all-weather shoes)";
label variable PD030_F "Flag";
label variable PD050 "Get-together with friends/family (relatives) for a drink/meal at least once/mnth";
label variable PD050_F "Flag";
label variable PD060 "Regularly participate in a leisure activity";
label variable PD060_F "Flag";
label variable PD070 "Spend a small amount of money each week on yourself";
label variable PD070_F "Flag";
label variable PD080 "Internet connection for personal use at home";
label variable PD080_F "Flag";
label variable PE010 "Current education activity" ;
label variable PE010_F "Flag" ;
label variable PE020 "ISCED level currently attended (T cod 50 & ab; DE, IT, MT, SI: specific rules)" ;
label variable PE020_F "Flag" ;
label variable PE030 "Year when highest level of education was attained" ;
label variable PE030_F "Flag" ; 
label variable PE040 "Highest ISCED level attained (Top cod 500 & above; IE, IT, SI: specific rules)" ;
label variable PE040_F "Flag" ; 
label variable PH010 "General health" ;
label variable PH010_F "Flag" ;
label variable PH020 "Suffer from a chronic (long-standing) illness or condition" ;
label variable PH020_F "Flag" ;
label variable PH030 " Limitation in activities because of health problems" ;
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
label variable PL051 "Occupation (ISCO-08(COM) (DE, MT, SI: grouped)" ;
label variable PL051_F	"Flag" ;
label variable PL060 "Number of hours usually worked per week in main job (MT: Top & bottom coding)" ;
label variable PL060_F "Flag" ;
label variable PL073 "Number of months spent at full-time work as employee (MT: Top & bottom coding)" ;
label variable PL073_F "Flag" ;
label variable PL074 "Number of months spent at part-time work as employee (MT: Top & bottom coding)" ;
label variable PL074_F "Flag" ;
label variable PL075 "No months spent at full-time wrk as slfmplyd (inc family worker) (MT: T & b cod)" ;
label variable PL075_F "Flag" ;
label variable PL076 "No months spent at part-time wrk as slfmplyd (inc family worker) (MT: T & b cod)" ;
label variable PL076_F "Flag" ;
label variable PL080 "Number of months spent in unemployment (MT: Top & bottom coding)" ;
label variable PL080_F "Flag" ;
label variable PL085 "Number of months spent in retirement (MT: Top & bottom coding)" ;
label variable PL085_F "Flag" ;
label variable PL086 "Number of months spent as disabled or/and unfit to work (MT: Top & bottom cod)" ;
label variable PL086_F "Flag" ;
label variable PL087 "Number of months spent studying (MT: Top & bottom coding)" ;
label variable PL087_F "Flag" ;
label variable PL088 "Number of months spent in compulsory military service (MT: Top & bottom coding)" ;
label variable PL088_F "Flag" ;
label variable PL089 "Number of months spent fulfilling domestic tsks & care rspnsblts (MT: T & b cod)" ;
label variable PL089_F "Flag" ;
label variable PL090 "Number of months spent in other inactivity (MT: Top & bottom coding)" ;
label variable PL090_F "Flag" ;
label variable PL100 "Total number of hours usually worked in second, third...jobs (MT: T & b cod)" ;
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
label variable PL190 "When began regular first job (IE: top & bottom coding)" ;
label variable PL190_F "Flag" ;
label variable PL200 "Number of years spent in paid work (IE: top coding)" ;
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
label variable PY010G "Employee cash or near cash income (gross, DE, SI: Top coding; MT: T & b cod)" ;
label variable PY010G_F "Flag" ;
label variable PY010G_I "Imputation factor" ;
label variable PY020G "Non-cash employee income (gross, SI: Top Coding; MT: Top & bottom coding)" ;  
label variable PY020G_F "Flag" ;
label variable PY020G_I "Imputation factor" ; 
label variable PY021G "Company car (in Euros, SI: Top Coding; MT: Top & bottom coding)" ;
label variable PY021G_F "Flag" ;
label variable PY021G_I "Imputation factor" ;
label variable PY030G  "Employers social insurance contribution (in Euros, SI: T coding; MT: T & b cod)" ;
label variable PY030G_F "Flag" ;
label variable PY030G_I "Imputation factor" ;
label variable PY031G "Optional employer social insurance contributions (in Euros, SI: Top coding)" ;
label variable PY031G_F "Flag" ;
label variable PY031G_I "Imputation factor" ;
label variable PY035G "Contributions to individual private pension plans (gr, SI: T cod; MT: T & b cod)" ;
label variable PY035G_F "Flag" ;
label variable PY035G_I "Imputation factor" ;
label variable PY050G "Cash benefits or losses from self-employment (gr,SI:T cod;MT:T & b cod;DE:b cod)" ;
label variable PY050G_F "Flag" ;
label variable PY050G_I "Imputation factor" ;
label variable PY080G  "Pension from individual private plans (gross, DE, SI: T cod; MT: T & b cod)" ;
label variable PY080G_F "Flag" ;
label variable PY080G_I "Imputation factor" ;
label variable PY090G  "Unemployment benefits (gross, DE, SI: Top coding; MT: Top & bottom coding)" ;
label variable PY090G_F "Flag" ;
label variable PY090G_I "Imputation factor" ;
* For PY091G-PY144G: Please see Differences Collection vs UDB for more information ;
label variable PY091G "Unemployment benefits (contributory and means-tested, MT: T & b cod)";
label variable PY091G_F "Flag";
label variable PY092G "Unemployment benefits (contributory and means-tested, MT: T & b cod)";
label variable PY092G_F "Flag";
label variable PY093G "Unemployment benefits (contributory and means-tested, MT: T & b cod)";
label variable PY093G_F "Flag";
label variable PY094G "Unemployment benefits (non-contributory and non means-tested, SI: Adj)";
label variable PY094G_F "Flag";
label variable PY100G "Old-age benefits (gross, DE, SI: Top coding; MT: Top & bottom coding)" ;
label variable PY100G_F "Flag" ;
label variable PY100G_I "Imputation factor" ;
label variable PY101G "Old-age benefits (contributory and means-tested)";
label variable PY101G_F "Flag";
label variable PY102G "Old-age benefits (contributory and non means-tested, SI: Adj; MT: T & b cod)";
label variable PY102G_F "Flag";
label variable PY103G "Old-age benefits (non-contributory and means-tested, MT: T & b cod)";
label variable PY103G_F "Flag";
label variable PY104G "Old-age benefits (n.-contributory & n. means-tested, DE, SI: Adj; MT: T & b cod)";
label variable PY104G_F "Flag";
label variable PY110G "Survivor benefit (gross, SI: Top Coding; MT: Top & bottom coding)" ;
label variable PY110G_F "Flag" ;
label variable PY110G_I "Imputation factor" ;
label variable PY111G "Survivor benefits (contributory and means-tested)";
label variable PY111G_F "Flag";
label variable PY112G "Survivor benefits (contributory and non means-tested, SI: Adj; MT: T & b cod)";
label variable PY112G_F "Flag";
label variable PY113G "Survivor benefits (non-contributory and means-tested, SI: Adjustments)";
label variable PY113G_F "Flag";
label variable PY114G "Survivor benefits (non-contributory and non means-tested, SI: Adjustments)";
label variable PY114G_F "Flag";
label variable PY120G "Sickness benefits (gross, SI: Top Coding; MT: Top & bottom coding)" ;
label variable PY120G_F "Flag" ;
label variable PY120G_I "Imputation factor" ;
label variable PY121G "Sickness benefits (contributory and means-tested)";
label variable PY121G_F "Flag";
label variable PY122G "Sickness benefits (contributory and non means-tested; MT: T & b cod; MT: Adj)";
label variable PY122G_F "Flag";
label variable PY123G "Sickness benefits (non-contributory and means-tested; MT: Top & bottom coding)";
label variable PY123G_F "Flag";
label variable PY124G "Sickness benefits (non-contributory and non means-tested)";
label variable PY124G_F "Flag";
label variable PY130G "Disability benefits (gross, SI: Top Coding; MT: Top & bottom coding)" ;
label variable PY130G_F "Flag" ;   
label variable PY130G_I "Imputation factor" ; 
label variable PY131G "Disability benefits (contributory and means-tested)";
label variable PY131G_F "Flag";
label variable PY132G "Disability benefits (contributory and non means-tested, SI: Adj; MT: T & b cod)";
label variable PY132G_F "Flag";                         
label variable PY133G "Disability benefits (non-contributory and means-tested, SI: Adj; MT: T & b cod)";
label variable PY133G_F "Flag";
label variable PY134G "Disability benefits (non-contributory and non means-tested; MT: T & b cod)";
label variable PY134G_F "Flag";
label variable PY140G "Education-related allowances (gross, SI: Top Coding; MT: Top & bottom coding)" ;
label variable PY140G_F "Flag" ;
label variable PY140G_I "Imputation factor" ;
label variable PY141G "Education-related allowances (contributory and means-tested)";
label variable PY141G_F "Flag";
label variable PY142G "Education-related allowances (contributory and non means-tested)";
label variable PY142G_F "Flag";
label variable PY143G "Education-related allowances (non-contributory and means-tested)";
label variable PY143G_F "Flag";
label variable PY144G "Education-related allow. (non-cntrbtry & n. means-tstd, SI: Adj; MT: T & b cod)";
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
label variable PY050N "Cash benefits or losses from self-employment (net, SI: Top cod; DE: b cod)" ;
label variable PY050N_F "Flag" ;
label variable PY050N_I "Imputation factor" ;
label variable PY080N "Pension from individual private plans (net, DE, SI: Top coding)" ;
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
label variable PX010 "Change rate" ;
label variable PX020 "Age at the end of the income reference period (MT: Adjusted)" ;
label variable PX030 "Household ID" ;
label variable PX040 "Selected respondent status" ;
label variable PX050 "Activity status" ;

* ad-hoc module ;
label variable PL230 "Public/private employment sector" ;
label variable PL230_F "Flag" ;
label variable PL250 "Months with any work" ;
label variable PL250_F "Flag" ;
label variable PL280 "Registration of unemployment" ;
label variable PL280_F "Flag" ;

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
1939 "1939 or before"
1940 "PT: 1940 and before"
1	 "MT: 1940 or before"
1945 "DE: 1945 & before"
2	"MT: 1941-1945"
3	"MT: 1946-1950"
4	"MT: 1951-1955"
5	"MT: 1956-1960"
6	"MT: 1961-1965"
7	"MT: 1966-1970"
8	"MT: 1971-1975"
9 	"MT: 1976-1980"
10	"MT: 1981-1985"
11	"MT: 1986-1990"
12	"MT: 1991-1995"
13	"MT: 1996-2000"
14	"MT: 2001-2005"
15	"MT: 2006-2010"
16	"MT: 2011-2015"
17	"MT: 2016-2020"
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
0 "Pre-primary education; Early childhood education (PB010>2013)"
1 "Primary education"
2 "Lower secondary education"
3 "(Upper) Secondary education"
4 "Post-secondary non-tertiary education"
5 "1st stage & 2nd stage of tertiary education"
6 "Second stage of tertiary education (leading to an advanced research qualification)"
10 "Primary education (PB010>2013)"
20 "Lower secondary education (PB010>2013; SI: 0,10,20=20)"
30 "Upper secondary education (not further specified) (PB010>2013; IT: 30,34,35=30)"
34 "General education (Only for people 16-34, PB010>2013)"
35 "Vocational education (Only for people 16-34, PB010>2013)"
40 "Post-secondary non tertiary education (not further specified) (PB010>2013; IT: 40,44,45=40)"
44 "General education (Only for people 16-34, PB010>2013)"
45 "Vocational education (Only for people 16-34, PB010>2013)"
50 "Short cycle tertiary (PB010>2013)"
60 "Bachelor or equivalent (PB010>2013)"
70 "Master or equivalent (PB010>2013)"
80 "Doctorate or equivalent (PB010>2013)"
;
label define PE020_F_VALUE_LABELS             
 1 "Filled"
-1 "Missing"
-2 "Not applicable (PE010 not=1)"
;
label define PE030_VALUE_LABELS 
1947 "IE, PT: bottom coding"
1948 "SI: bottom coding"
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
3 "(Upper) secondary education"
4 "Post-secondary non-tertiary education"
5 "First stage of tertiary education (not leading to an advanced research qualification)"
6 "Second stage of tertiary education (leading to an advanced research qualification)"
100 "Primary education (PB010>2013)"
200 "Lower secondary education(PB010>2013, SI: Bottom coding: grouping 000, 100, 200 into 200)"
300 "Upper secondary education (not further specified) (PB010>2013)"
34 "General education  (Only for people 16-34; PB010>2013)"
340 "Without distinction of direct access to tertiary education (Only for people 16-34, PB010>2013)"
342 "Partial level completion and without direct access to tertiary education   (Only for people 16-34, PB010>2013)"
343 "Level completion, without direct access to tertiary education   (Only for people 16-34, PB010>2013)"
344 "Level completion, with direct access to tertiary education   (Only for people 16-34, PB010>2013)"
35 "Vocational education   (Only for people 16-34, PB010>2013)"
350 "Without distinction of direct access to tertiary education   (Only for people 16-34, PB010>2013)"
352 "Partial level completion and without direct access to tertiary education   (Only for people 16-34, PB010>2013)"
353 "Level completion, without direct access to tertiary education   (Only for people 16-34, PB010>2013)"
354 "Level completion, with direct access to tertiary  education   (Only for people 16-34, PB010>2013)"
400 "Post-secondary non-tertiary education (not further specified) (PB010>2013)"
440 "General education   (Only for people 16-34, PB010>2013)"
450 "Vocational education (PB010>2013)"
500 "Short cycle tertiary (PB010>2013)(All except PL: Top coding: 500 & above)"
600 "Bachelor or equivalent (PB010>2013) (Only PL)"
700 "Master or equivalent (PB010>2013) (Only PL)"
800 "Doctorate or equivalent (PB010>2013) (Only PL)"
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
-2 "Not applicable (PL031 = 1, 2, 3 or 4 or older than the standard retirement age)"
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
0 "SI: Armed Forces"
1 "Commissioned armed forces officers. MT, SI:11-14 Legislators,senior officials & managers"
2 "Non-commissioned armed forces officers. MT, SI:21-26 Professionals"
3 "Armed forces occupations, other ranks. MT, SI:31-35 Technicians & associate professionals"
4 "MT, SI: 41-44 Clerks"
5 "MT, SI: 51-54 Service workers and shop and market sales workers"
6 "MT, SI: 61-63 Skilled agricultural and fishery workers"
7 "MT, SI: 71-75 Craft and related trades workers"
8 "MT, SI: 81-83 Plant and machine operators and assemblers"
9 "MT, SI: 91-96 Elementary occupations"
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
label define PL075_VALUE_LABELS              
10  "MT: 10 to 12"
;
label define PL073_F_VALUE_LABELS              
1  "Filled"
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
-2 "Not applicable (PL031 not = 1, 2, 3 or 4)"
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
-2 "Not applicable (Not (PL031 = 1, 2 , 3 or 4, and PL060 + PL100< 30))"
-3 "Not selected respondent"
-8 "PL: missing"
;
label define PL130_VALUE_LABELS
1  "MT: 1-5"
2  "MT: 6-10"
3  "MT: 11-19"
4  "MT: 20-49"
5  "MT: 50 and more" 
6  "MT: Do not know but less than 11 persons"   
7  "MT: Do not know but more than 10 persons"            
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
-8 "PL: missing"
;
label define PL140_VALUE_LABELS                
1 "Permanent job: work contract of unlimited duration" 
2 "Temporary job: work contract of limited duration"
;
label define PL140_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable (PL040 not=3)"
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
-8 "PL: missing"
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
-8 "PL: missing"
;            
label define PL180_VALUE_LABELS                
1 "Employed - unemployed (MT, IE:1-3=1)"
2 "Employed - retired (MT, IE:4-6=2)"
3 "Employed - other inactive (MT, IE:7-9=3)"
4 "Unemployed - employed (MT, IE:10-12=4)"
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
-8 "PL: missing"
;
label define PL190_VALUE_LABELS              
13 "IE: 13 and before"
30 "IE: 30 and later"
;
label define PL190_F_VALUE_LABELS              
1  "Filled"
-1 "Missing"
-2 "Not applicable (person never worked i.e. (PL031 not equal to 1, 2, 3 or 4 AND PL015 not equal to 1))"
-3 "Not selected respondent" 
-8 "PL: missing"
;
label define PL200_VALUE_LABELS              
55 "IE: 55 and later" 
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
-8 "PL: missing (values set to 0)"
-9 "value not defined in data documentation"
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
5 "FR: not defined in data documentation"
;
label define PY031G_VALUE_LABELS               
0 "No contribution"
;
label define PY035G_F_VALUE_LABELS            
0 "No contribution"
1 "Filled"
-1 "Missing"
-5 "Not filled: variable of net series is filled" 
6 "FR: value not defined in data documentation"
;  
label define PY091G_F_VALUE_LABELS
2 "Filled with mixed components"
1 "Filled with only contributory and means-tested components"
0 "No income"
-1 "Missing"
-2 "Not available This scheme doesn't exist at national level"
-5 "FR: missing"
-7 "Not available (PB010 < 2014)"
;
label define PY010N_F_VALUE_LABELS             
0  "No income"
11 "Collected & recorded net of tax on income at source & social contributions"
12 "Collected net of tax on income source and social contributions & record net of tax on income at source"   
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
62 "Mix/Statistical imputation"
63 "Collected: Mix & recorded: Net of tax on social contributions"
-1 "Missing"
-4 "Missing (amount included in another income component)"
-5 "Not filled: variable of gross series is filled"
-9 "value not defined in data documentation"
;
label define PY021N_VALUE_LABELS               
0 "No income"
;
label define PY035N_F_VALUE_LABELS             
0  "No contribution"
1  "Filled"
-1 "Missing"
-5 "Not filled: variable of the gross series is filled"
6 "FR: value not defined in data documentation"
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
66 "DE: 66 and over"
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
8 "Other inactive (when time of unemployed, retirement & inactivity is > 0.5 of total time calendar)"
;

* Ad-hoc module on intergenerational transmission of disadvantage ;
label define PT020_VALUE_LABELS                
1 "SI: 1 or less"
6 "SI: 6 or more"
7 "DE: 7 or more"
;
label define PT020_F_VALUE_LABELS                
1 "Filled"
-1 "Missing"
-2 "N/A (PT220=2 - lived in a collective household or institution)"
-3 "Not `selected respondent'"
-6 "Not in age range (25-59)"
-7 "Not applicable (PB010 not 2020)"
;
label define PT030_VALUE_LABELS                
6 "SI: 6 or more"
7 "DE: 7 or more"
;
label define PT040_VALUE_LABELS                
4 "SI: 4 or more"
7 "DE: 7 or more"
;
label define PT060_F_VALUE_LABELS                
1 "Filled"
-1 "Missing"
-2 "N/A (PT220=2 - lived in a collective household or institution)"
-3 "Not selected respondent"
-5 "N/A (PT240=3 or 4 - Father not present and no contact or deceased)"
-6 "Not in age range (25-59)"
-7 "Not applicable (PB010 not 2020)"
;
label define PT090_F_VALUE_LABELS                
1 "Filled"
-1 "Missing"
-2 "N/A (PT220=2 - lived in a collective household or institution)"
-3 "Not selected respondent"
-5 "N/A (PT240=3 or 4 - Mother not present and no contact or deceased)"
-6 "Not in age range (25-59)"
;
label define PT110_VALUE_LABELS                
1 "Low level (less than primary, primary education or lower secondary education)"
2 "Medium level (upper secondary education and post-secondary non-tertiary education)"
3 "High level (short-cycle tertiary education, bachelor's or equivalent level, master's or equivalent level, doctoral or equivalent level)"
-1 "Don't know"
;
label define PT110_F_VALUE_LABELS                
1 "Filled"
-1 "Missing"
-2 "N/A (PT220=2 - lived in a collective household or institution)"
-3 "Not selected respondent"
-5 "N/A (PT240=3 or 4 - Father not present and no contact or deceased)"
-6 "Not in age range (25-59)"
;
label define PT120_F_VALUE_LABELS                
1 "Filled"
-1 "Missing"
-2 "N/A (PT220=2 - lived in a collective household or institution)"
-3 "Not selected respondent"
-5 "N/A (PT240=3 or 4 - Mother not present and no contact or deceased)"
-6 "Not in age range (25-59)"
;
label define PT130_VALUE_LABELS                
1 "Employee working full-time"
2 "Employee working part-time"
3 "Self- employed or helping family business"
4 "Unemployed/Looking for job"
5 "In retirement"
6 "Permanently disabled and/or unfit to work"
7 "Fulfilling domestic tasks and care responsibilities"
8 "Other inactive"
-1 "Don't know"
;
label define PT130_F_VALUE_LABELS                
1 "Filled"
-1 "Missing"
-2 "N/A (PT220=2 - lived in a collective household or institution)"
-3 "Not selected respondent"
-5 "N/A (PT240=3 or 4 - Father not present and no contact or deceased)"
-6 "Not in age range (25-59)"
-7 "Not applicable (PB010 not 2020)"
;
label define PT140_VALUE_LABELS                
1 "Yes"
2 "No"
-1 "Don't know"
;
label define PT140_F_VALUE_LABELS                
1 "Filled"
-1 "Missing"
-2 "N/A (PT220=2 - lived in a collective household or institution)"
-3 "Not selected respondent"
-4 "N/A father not working (not employed PT130 ne 1 and 2)"
-5 "N/A (PT240=3 or 4 - Father not present and no contact or deceased)"
-6 "Not in age range (25-59)"
-7 "Not applicable (PB010 not 2020)"
;
label define PT150_VALUE_LABELS                
1 "Managers"
2 "Professionals"
3 "Technicians and Associate Professionals"
4 "Clerical Support Workers"
5 "Services and Sales Workers"
6 "Skilled Agricultural, Forestry and Fishery Workers"
7 "Craft and Related Trades Workers"
8 "Plant and Machine Operators and Assemblers"
9 "Elementary Occupations"
0 "Armed Forces Occupations"
-1 "Don't know"
;
label define PT150_F_VALUE_LABELS                
1 "Filled"
-1 "Missing"
-2 "N/A (PT220=2 - lived in a collective household or institution)"
-3 "Not selected respondent"
-4 "N/A father not working (PT130 ne 1 and 2)"
-5 "N/A (PT240=3 or 4 - Father not present and no contact or deceased)"
-6 "Not in age range (25-59)"
-7 "Not applicable (PB010 not 2020)"
;
label define PT160_VALUE_LABELS                
1 "Employee working full-time"
2 "Employee working part-time"
3 "Self- employed or helping family business"
4 "Unemployed/Looking for job"
5 "In retirement"
6 "Permanently disabled and/or unfit to work"
7 "Fulfilling domestic tasks and care responsibilities"
8 "Other inactive"
-1 "Don't know"
;
label define PT160_F_VALUE_LABELS                
1 "Filled"
-1 "Missing"
-2 "N/A (PT220=2 - lived in a collective household or institution)"
-3 "Not selected respondent"
-5 "N/A (PT240=3 or 4 - Mother not present and no contact or deceased)"
-6 "Not in age range (25-59)"
-7 "Not applicable (PB010 not 2020)"
;
label define PT170_VALUE_LABELS                
1 "Yes"
2 "No"
-1 "Don't know"
;
label define PT170_F_VALUE_LABELS                
1 "Filled"
-1 "Missing"
-2 "N/A (PT220=2 - lived in a collective household or institution)"
-3 "Not selected respondent"
-4 "N/A Mother not working (not employed PT130 ne 1and 2)"
-5 "N/A (PT240=3 or 4 - Mother not present and no contact or deceased)"
-6 "Not in age range (25-59)"
-7 "Not applicable (PB010 not 2020)"
;
label define PT180_F_VALUE_LABELS                
1 "Filled"
-1 "Missing"
-2 "N/A (PT220=2 - lived in a collective household or institution)"
-3 "Not selected respondent"
-4 "N/A Mother not working (PT130 ne 1and 2)"
-5 "N/A (PT240=3 or 4 - Mother not present and no contact or deceased)"
-6 "Not in age range (25-59)"
-7 "Not applicable (PB010 not 2020)"
;
label define PT190_VALUE_LABELS                
1 "Very bad"
2 "Bad"
3 "Moderately bad"
4 "Moderately good"
5 "Good"
6 "Very good"
-1 "Don't know"
;
label define PT210_VALUE_LABELS                
1 "Owned"
2 "Rented"
3 "Accommodation was provided free"
-1 "Don't know"
;
label define PT220_VALUE_LABELS                
1 "Private household"
2 "Lived in a collective household or institution"
;
label define PT230_VALUE_LABELS                
1 "Yes"
2 "No, she did not live in the same household but I had contact"
3 "No, she did not live in the same household and I had no contact"
4 "No, deceased"
;
label define PT240_VALUE_LABELS                
1 "Yes"
2 "No, he did not live in the same household but I had contact"
3 "No, he did not live in the same household and I had no contact"
4 "No, deceased"
;
label define PT250_VALUE_LABELS                
1 "City (more than 100 000 inhabitants)"
2 "Town or suburb (10 000 to 100 000 inhabitants)"
3 "Rural area, small town or village (less than 10 000 inhabitants)"
;
label define PT260_VALUE_LABELS                
1 "Yes"
2 "No - due to financial reasons"
3 "No - other reason"
;
label define PL230_VALUE_LABELS
1 "Public"
2 "Private"
3 "Mixed"
;
label define PL230_F_VALUE_LABLES
1 "Filled"
-1 "Missing"
-2 "N/A (PL031 is not 1, 2)"
-3 "Non-selected respondent"
-7 "N/A (PB010 is not 2020)"
;
label define PL250_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-3 "Non-selected respondent"
-7 "N/A (PB010 is not 2020)"
-8 "IT: missing"
;
label define PL280_VALUE_LABLES
1 "Unemployed and registered for the whole period"
2 "Unemployed and registered for part of the period"
3 "Unemployed and not registered at all"
;
label define PL280_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "N/A (PL211 is not 5)"
-3 "Non-selected respondent"
-7 "N/A (PB010 is not 2020)"
-8 "IT: missing"
;
label define NO_INCOME
0 "No income"
;
label define NO_CONTRIBUTION
0 "No contribution"
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
label values PL075 PL080 PL085 PL086 PL087 PL075_VALUE_LABELS ;
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
label values PL190 PL190_VALUE_LABELS ;
label values PL190_F PL190_F_VALUE_LABELS ;
label values PL200 PL200_VALUE_LABELS ;
label values PL200_F PL200_F_VALUE_LABELS ;
label values PL211A PL211B PL211C PL211D PL211E PL211F PL211G PL211H PL211I ///
             PL211J PL211K PL211L PL211A_VALUE_LABELS ; 
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

* Ad-hoc Module ;
label values PY010N PY020N PY080N PY090N PY100N PY110N PY120N PY130N PY140N ///
			 PY010G PY020G PY050G PY080G PY090G PY100G PY110G PY120G PY130G ///
			 PY140G PY200G PY091G PY092G PY093G PY094G PY101G PY102G PY103G ///
			 PY104G PY111G PY112G PY113G PY114G PY121G PY122G PY123G PY124G ///
			 PY131G PY132G PY133G PY134G PY141G PY142G PY143G PY144G NO_INCOME ;
label values PY030G PY031G PY035G PY035N NO_CONTRIBUTION ;
label values PL230 PL230_VALUE_LABELS ;
label values PL230_F PL230_F_VALUE_LABLES ;
label values PL250_F PL250_F_VALUE_LABELS ;
label values PL280 PL280_VALUE_LABLES ;
label values PL280_F PL280_F_VALUE_LABELS ;

label data "Personal data file 2020" ;

compress ;
save "`stata_file'", replace ;

log close ;
set more on
#delimit cr



