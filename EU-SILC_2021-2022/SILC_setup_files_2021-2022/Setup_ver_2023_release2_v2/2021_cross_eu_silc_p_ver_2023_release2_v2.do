* 2021_cross_eu_silc_p_ver_2023_release2_v2.do 
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
* Personal data file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_c*country_stub*21P.csv
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
* Pforr, Klaus, Johanna Jung and Carl Riemann (2024): 2021_cross_eu_silc_p_ver_2023_release2_v2.do, 1st update.
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

local log_file "$log/eusilc_2021_p" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2020) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2021_p_cs" ;

* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 
tempfile temp ;
save `temp', emptyok ;

foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HR HU IE /*IS*/ IT LT LU LV MT NL /*NO*/ PL PT RO RS SE SI SK /*UK*/ { ;
      cd "$csv_path/`CC'/2021" ;	
	  import delimited using "UDB_c`CC'21P.csv", case(upper) asdouble clear stringcols(2 32 34 80 82);
	  * In some countries non-numeric characters are wrongfully included.
      * This command prevents errors in the format. ;
	  append using `temp', force ;
	save `temp', replace  ;
} ;

* Recode alphanumeric vars to numeric vars ;
quietly ds;
local order `r(varlist)';
encode PL111A, gen(temp1);
encode PL111B, gen(temp2);
drop PL111A PL111B;
rename temp1 PL111A;
rename temp2 PL111B;
order `order';

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
label variable PB205 "Partners living in the same household" ;
label variable PB205_F "Flag" ;
label variable PB270 "Interviewing mode used (person)" ;
label variable PB270_F "Flag" ;
label variable PB230 "Country of birth of father (grouped,SI: EU -> OTH)" ;
label variable PB230_F "Flag" ;
label variable PB240 "Country of birth of mother (grouped,SI: EU -> OTH)" ;
label variable PB240_F "Flag" ;
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
label variable PW010 "Overall life satisfaction";
label variable PW010_F "Flag";
label variable PW191 "Trust in others";
label variable PW191_F "Flag";
label variable PE010 "Participation in formal education and training (student or apprentice)" ;
label variable PE010_F "Flag" ;
label variable PE021 "Level of current/most recent formal education or training activity" ;
label variable PE021_F "Flag" ;
label variable PE041 "Educational attainment level (ISCED)" ;
label variable PE041_F "Flag" ;
label variable PL032 "Self-defined current economic status" ;
label variable PL032_F "Flag" ;
label variable PL016 "Existence of previous employment experience" ;
label variable PL016_F "Flag" ;
label variable PL040A "Status in employment (main job)" ;
label variable PL040A_F "Flag" ;
label variable PL040B "Status in employment (last job)" ;
label variable PL040B_F "Flag" ;
label variable PL051A "Occupation in main job (ISCO-08 COM)" ;
label variable PL051A_F "Flag" ;
label variable PL051B "Occupation (last job) (ISCO-08 COM)" ;
label variable PL051B_F "Flag" ;
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
label variable PH051 "Unmet need for medical examination/treatment due to Covid-19 crisis (Optional)" ;
label variable PH051_F "Flag" ;
label variable PH060 "Unmet need for dental examination or treatment" ;
label variable PH060_F "Flag" ;
label variable PH070 "Main reason for unmet need for dental examination or treatment" ;
label variable PH070_F "Flag" ;
label variable PH071 "Unmet need for dental examination/treatment due to Covid-19 crisis (Optional)" ;
label variable PH071_F "Flag" ;
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
label variable PL111A "Economic activity of the local unit for the main job" ;
label variable PL111A_F "Flag" ;
label variable PL111B "Economic activity of the local unit (last job)" ;
label variable PL111B_F "Flag" ;
label variable PL141 "Permanency of main job" ;
label variable PL141_F "Flag" ;
label variable PL145 "Full or part-time main job (self-defined)" ;
label variable PL145_F "Flag" ;
label variable PL150 "Supervisory responsibility in the main job" ;
label variable PL150_F "Flag" ;
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
label variable PL220 "Working from home during pandemic (Optional)" ;
label variable PL220_F "Flag" ;
label variable PL271 "Duration of the most recent unemployment spell" ;
label variable PL271_F "Flag" ;
label variable PY010G "Employee cash or near cash inc. (gross, DE,FR,IE,MT,SI: modified)" ;
label variable PY010G_F "Flag" ;
label variable PY010G_IF "Imputation factor" ;
label variable PY020G "Non-cash employee inc. (gross, SI: Top Coding; MT: Top & bottom coding)" ;  
label variable PY020G_F "Flag" ;
label variable PY020G_IF "Imputation factor" ; 
label variable PY021G "Company car (in Euros, SI: Top Coding; MT: Top & bottom coding)" ;
label variable PY021G_F "Flag" ;
label variable PY021G_IF "Imputation factor" ;
label variable PY030G  "Employers social insurance contribution (in Euros, SI: T coding; MT: T & b cod)" ;
label variable PY030G_F "Flag" ;
label variable PY030G_IF "Imputation factor" ;
label variable PY035G "Contributions to individual private pension plans (gr, SI: T cod; MT: T & b cod)" ;
label variable PY035G_F "Flag" ;
label variable PY035G_IF "Imputation factor" ;
label variable PY050G "Cash benefits or losses from self-employment (gross, DE,FR,IE,MT,SI: modified)" ;
label variable PY050G_F "Flag" ;
label variable PY050G_IF "Imputation factor" ;
label variable PY080G  "Pension from individual private plans (gross, DE,FR,IE,MT,SI: modified)" ;
label variable PY080G_F "Flag" ;
label variable PY080G_IF "Imputation factor" ;
label variable PY090G  "Unemployment benefits (gross, DE,FR,IE,SI,MT: modified)" ;
label variable PY090G_F "Flag" ;
label variable PY090G_IF "Imputation factor" ;
* For PY091G-PY144G: Please see Differences Collection vs UDB for more information ;
label variable PY091G "Unemploy benefits (contrib & means-tested, DE: Adj; MT: T&b cod, FR,IE: rounded)";
label variable PY091G_F "Flag";
label variable PY091G_IF "Imputation factor" ;
label variable PY092G "Unempl benef (contrib & non-means-tested, DE: Adj; MT: T & b cod, FR,IE: round)";
label variable PY092G_F "Flag";
label variable PY092G_IF "Imputation factor" ;
label variable PY093G "Unempl benef (non-contrib & means-tested, DE: Adj; MT: T & b cod, FR,IE: round)";
label variable PY093G_F "Flag";
label variable PY093G_IF "Imputation factor" ;
label variable PY094G "Unempl benef (non-contr & non-means-tested, DE: Adj; MT: T&b cod, FR,IE: round)";
label variable PY094G_F "Flag";
label variable PY094G_IF "Imputation factor" ;
label variable PY100G "Old-age benefits (gross, DE, SI: Top cod; MT: Top & bottom cod, FR,IE: rounded)" ;
label variable PY100G_F "Flag" ;
label variable PY100G_IF "Imputation factor" ;
label variable PY101G "Old-age benefits (contributory and means-tested, DE: Adj, FR,IE: rounded)";
label variable PY101G_F "Flag";
label variable PY101G_IF "Imputation factor" ;
label variable PY102G "Old-age benef (contrib & n-means-tested, DE,SI: Adj; MT: T&b cod, FR,IE: round)";
label variable PY102G_F "Flag";
label variable PY102G_IF "Imputation factor" ;
label variable PY103G "Old-age benef (non-contrib & means-tested, DE: Adj; MT: T&b cod, FR,IE: rounded)";
label variable PY103G_F "Flag";
label variable PY103G_IF "Imputation factor" ;
label variable PY104G "Old-age benef (n-contrib & n-means-test, DE,SI: Adj; MT: T&b cod, FR,IE: round)";
label variable PY104G_F "Flag";
label variable PY104G_IF "Imputation factor" ;
label variable PY110G "Survivor benefit (gross, SI: Top Cod; MT: Top & bottom cod, FR,IE: rounded)" ;
label variable PY110G_F "Flag" ;
label variable PY110G_IF "Imputation factor" ;
label variable PY111G "Survivor benefits (contributory and means-tested, FR,IE: rounded)";
label variable PY111G_F "Flag";
label variable PY111G_IF "Imputation factor" ;
label variable PY112G "Surviv benef (contrib & non-means-tested, SI: Adj; MT: T & b cod, FR,IE: round)";
label variable PY112G_F "Flag";
label variable PY112G_IF "Imputation factor" ;
label variable PY113G "Surviv benef (non-contrib & means-tested, SI: Adj, FR,IE: rounded)";
label variable PY113G_F "Flag";
label variable PY113G_IF "Imputation factor" ;
label variable PY114G "Surviv benef (non-contrib & non-means-tested, SI: Adj, FR,IE: rounded)";
label variable PY114G_F "Flag";
label variable PY114G_IF "Imputation factor" ;
label variable PY120G "Sickness benefits (gross, SI: Top Coding; MT: Top & bottom coding)" ;
label variable PY120G_F "Flag" ;
label variable PY120G_IF "Imputation factor" ;
label variable PY121G "Sickness benefits (contributory and means-tested)";
label variable PY121G_F "Flag";
label variable PY121G_IF "Imputation factor" ;
label variable PY122G "Sickness benefits (contributory and non means-tested; MT: T & b cod; MT: Adj)";
label variable PY122G_F "Flag";
label variable PY122G_IF "Imputation factor" ;
label variable PY123G "Sickness benefits (non-contributory and means-tested; MT: Top & bottom coding)";
label variable PY123G_F "Flag";
label variable PY123G_IF "Imputation factor" ;
label variable PY124G "Sickness benefits (non-contributory and non means-tested)";
label variable PY124G_F "Flag";
label variable PY124G_IF "Imputation factor" ;
label variable PY130G "Disability benefits (gross, SI: Top Cod; MT: Top & bottom cod, FR,IE: rounded)" ;
label variable PY130G_F "Flag" ;   
label variable PY130G_IF "Imputation factor" ; 
label variable PY131G "Disability benefits (contributory and means-tested, FR,IE: rounded)";
label variable PY131G_F "Flag";
label variable PY131G_IF "Imputation factor" ;
label variable PY132G "Disabil benef (contrib & non-means-tested, SI: Adj; MT: T & b cod, FR,IE: round)";
label variable PY132G_F "Flag";       
label variable PY132G_IF "Imputation factor" ;                  
label variable PY133G "Disabil benef (non-contrib & means-tested, SI: Adj; MT: T & b cod, FR,IE: round)";
label variable PY133G_F "Flag";
label variable PY133G_IF "Imputation factor" ;
label variable PY134G "Disabil benef (non-contrib & non-means-tested; MT: T & b cod, FR,IE: round)";
label variable PY134G_F "Flag";
label variable PY134G_IF "Imputation factor" ;
label variable PY140G "Education-related allowances (gross, SI: Top Coding; MT: Top & bottom coding)" ;
label variable PY140G_F "Flag" ;
label variable PY140G_IF "Imputation factor" ;
label variable PY141G "Education-related allowances (contributory and means-tested)";
label variable PY141G_F "Flag";
label variable PY141G_IF "Imputation factor" ;
label variable PY142G "Education-related allowances (contributory and non means-tested)";
label variable PY142G_F "Flag";
label variable PY142G_IF "Imputation factor" ;
label variable PY143G "Education-related allowances (non-contributory and means-tested)";
label variable PY143G_F "Flag";
label variable PY143G_IF "Imputation factor" ;
label variable PY144G "Education-related allow. (non-cntrbtry & n. means-tstd, SI: Adj; MT: T & b cod)";
label variable PY144G_F "Flag";
label variable PY144G_IF "Imputation factor" ;
label variable PY010N "Employee cash or near cash inc. (net, DE, SI: Top coding, FR,IE: rounded)" ;
label variable PY010N_F "Flag" ;
label variable PY010N_IF "Imputation factor" ;
label variable PY020N "Non-cash employee inc. (net)" ;
label variable PY020N_F "Flag" ;
label variable PY020N_IF "Imputation factor" ;
label variable PY021N   "Company car (in Euros, SI: Top coding)" ;
label variable PY021N_F "Flag" ;
label variable PY021N_IF "Imputation factor" ;
label variable PY035N "Contributions to individual private pension plans (net, SI: Top coding)" ;
label variable PY035N_F "Flag" ;
label variable PY035N_IF "Imputation factor" ;
label variable PY050N "Cash benefits or losses from self-employment (net, DE,FR,IE,SI: modified)" ;
label variable PY050N_F "Flag" ;
label variable PY050N_IF "Imputation factor" ;
label variable PY080N "Pension from individual private plans (net, DE, SI: Top coding, FR,IE: rounded)" ;
label variable PY080N_F "Flag" ;
label variable PY080N_IF "Imputation factor" ;
label variable PY090N "Unemployment benefits (net, DE, SI: Top coding, FR,IE: rounded)" ;
label variable PY090N_F "Flag" ;
label variable PY090N_IF "Imputation factor" ;
label variable PY100N "Old-age benefits (net, DE, SI: Top coding, FR,IE: rounded)" ;
label variable PY100N_F "Flag" ;  
label variable PY100N_IF "Imputation factor" ;   
label variable PY110N "Survivors benefits (net, SI: Top coding, FR,IE: rounded)" ;
label variable PY110N_F "Flag" ;
label variable PY110N_IF "Imputation factor" ;
label variable PY120N "Sickness benefits (net, SI: Top coding)" ;
label variable PY120N_F "Flag" ;
label variable PY120N_IF "Imputation factor" ;
label variable PY130N "Disability benefits (net, SI: Top coding, FR,IE: rounded)" ;
label variable PY130N_F "Flag" ;
label variable PY130N_IF "Imputation factor" ;
label variable PY140N "Education-related allowances (net, SI: Top coding)" ;
label variable PY140N_F "Flag" ;
label variable PY140N_IF "Imputation factor" ;
label variable PX010 "Change rate" ;
label variable PX020 "Age at the end of the inc. reference period (MT: Adjusted)" ;
label variable PX030 "Household ID" ;
label variable PX040 "Selected respondent status" ;
label variable PX050 "Activity status" ;

label variable PMH010 "Mental health affected by the Covid-19 crisis (Optional)" ;
label variable PMH010_F "Flag" ;

* ad-hoc module ;

* Definition of category labels ;
label define PB040_F_VALUE_LABELS             
1 "Filled"
-7 "Not applicable (PB010 not equal to last year of operation)"
;
label define PB060_F_VALUE_LABELS             
 1 "Filled"
-2 "Not applicable (country does not use the selected respondent model)"
-3 "Not selected respondent"
-7 "Not applicable (PB010 not equal to last year of operation)"
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
-3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
;
label define PB110_F_VALUE_LABELS              
 1 "Filled"
-1 "Missing"
-3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
;
label define PB120_F_VALUE_LABELS              
 1 "Filled"
-1 "Missing"
-2 "Not applicable (information only extracted from registers)"
-3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
;
label define PB140_VALUE_LABELS             
1940 "1940 or before"
1941 "PT: 1941 and before"
1	 "MT: 1941 or before"
2	"MT: 1942-1946"
3	"MT: 1947-1951"
4	"MT: 1952-1956"
5	"MT: 1957-1961"
6	"MT: 1962-1966"
7	"MT: 1967-1971"
8	"MT: 1972-1976"
9 	"MT: 1977-1981"
10	"MT: 1982-1986"
11	"MT: 1987-1991"
12	"MT: 1992-1996"
13	"MT: 1997-2001"
14	"MT: 2002-2006"
15	"MT: 2007-2011"
16	"MT: 2012-2016"
17	"MT: 2017-2021"
;
label define PB140_F_VALUE_LABELS             
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
;
label define PB150_VALUE_LABELS                
1 "Male"
2 "Female"
;
label define PB150_F_VALUE_LABELS              
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
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
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
;
label define PB200_VALUE_LABELS                
1 "Yes, on a legal basis"
2 "Yes, without a legal basis"
3 "No"
;
label define PB200_F_VALUE_LABELS              
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
;
label define PB205_VALUE_LABELS
1 "Person living with a legal or de facto partner"
2 "Person not living with a legal or de facto partner"
;
label define PB205_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PB270_VALUE_LABELS
1 "Paper assisted personal interview (PAPI)"
2 "Computer assisted personal interview (CAPI)"
3 "Computer assisted telephone interview (CATI)"
4 "Computer assisted web-interview (CAWI)"
5 "Other"
;
label define PB270_F_VALUE_LABELS
1  "Filled"
-1 "Missing"
-3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PB230_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PB240_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
-7 "Not applicable (PB010 not equal to 2021)"
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
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PW010_VALUE_LABELS
0 "Not at all satisfied"
10 "Completely satisfied"
;
label define PW010_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
;
label define PW191_VALUE_LABELS
0 "Do not trust at all"
10 "Trust completely"
;
label define PW191_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PE010_VALUE_LABELS               
1 "Yes"
2 "No"
;
label define PE010_F_VALUE_LABELS            
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
;
label define PE021_VALUE_LABELS
0 "Early childhood education (PB010>=2014), Pre-primary education (PB010<2014)"
1 "Primary education"
2 "Lower secondary education"
3 "(upper) secondary education"
4 "Post-secondary non tertiary education"
5 "First stage of tertiary education (not leading directly to an advanced research qualification)"
6 "Second stage of tertiary education (leading to an advanced research qualification)"
10 "ISCED 1 Primary education (PB010>=2021), Primary education (2014<=PB010<=2020)"
20 "ISCED 2 Lower secondary education, (MT,SI 00-20)"
30 "ISCED 3 Upper secondary education (age 35+) (IT,MT grouped 30-39->30)"
34 "ISCED 3 Upper secondary education - general/ only for persons aged 16-34"
35 "ISCED 3 Upper secondary education - vocational/ only for persons aged 16-34"
39 "ISCED 3 Upper secondary education - orientation unknown/ only for persons aged 16-34 (PB010>=2021)"
40 "ISCED 4 Post-secondary non-tertiary education (age 35+) (IT,MT grouped 40-49->40)"
44 "ISCED 4 Post-secondary non-tertiary education - general/ only for persons aged 16-34"
45 "ISCED 4 Post-secondary non-tertiary education - vocational/ only for persons aged 16-34"
49 "ISCED 4 Post-secondary non-tertiary education - orientation unknown/ only for persons aged 16-34 (PB010>=2021)"
50 "ISCED 5-8 (top-coding)" 
;
label define PE021_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (PE010 not equal to 1)"
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PE041_VALUE_LABELS
0 "No formal educ or below ISCED 1 (PB010>=2021), <= prim educ (2014<=PB010<=2020), pre-primary education (PB010<=2013)"
1 "primary education (PB010<=2013)"
2 "lower secondary education (PB010<=2013)"
3 "(upper) secondary education (PB010<=2013)"
4 "post-secondary non tertiary education (PB010<=2013)"
5 "first stage of tertiary education (not leading directly to an advanced research qualification) (PB010<=2013)"
6 "second stage of tertiary education (leading to an advanced research qualification) (PB010<=2013)"
34  "Upper secondary education, General education, Only for people 16-34 (2014<=PB010<=2020)"
35 "Upper secondary education, Vocational education, Only for people 16-34 (2014<=PB010<=2020)"
100 "ISCED 1 Primary education"
200 "ISCED 2 Lower secondary education (PB010>=2021, SI: 0,100,200->200)" 
300 "Upper secondary education (not further specified) (IE 340-345->300, IT 300-399->300)"
340 "ISCED 3 Upper secondary education- general/ only for persons (age 35+) (MT 340-349->340)"
342 "ISCED 3 Upper secondary education (general) - partial level completion, w/o direct access to tertiary educ (age 16-34)"
343 "ISCED 3 Upper secondary education (general) - partial level completion, w/o direct access to tertiary educ (age 16-34)"
344 "ISCED 3 Upper secondary education (general) - level completion, w/ direct access to tertiary educ (age 16-34)"
349 "ISCED 3 Upper secondary education (general) - w/o possible distinction of access to tertiary educ (age 16-34)"
350 "ISCED 3 Upper secondary education- vocational (age 35+) (MT: 350-359->350)"
352 "ISCED 3 Upper secondary education (vocational) - partial lvl compl, w/o direct access to tertiary educ (age 16-34)"
353 "ISCED 3 Upper secondary education (vocational) - level completion, w/o direct access to tertiary educ (age 16-34)"
354 "ISCED 3 Upper secondary education (vocational) - level completion, w/ direct access to tertiary educ (age 16-34)"
359 "ISCED 3 Upper secondary education (vocational) - w/o possible distinction of access to tertiary educ (age 16-34)"
390 "ISCED 3 Upper secondary education- orientation unknown (age 35+) (MT: 390-399->390)"
392 "ISCED 3 Upper secondary education (orient unknown) - partial lvl compl, w/o direct access to tertiary educ (age 16-34)"
393 "ISCED 3 Upper secondary education (orient unknown) - level completion, w/o direct access to tertiary educ (age 16-34)"
394 "ISCED 3 Upper secondary education (orient unknown) - level compl, w/ direct access to tertiary educ (age 16-34)"
399 "ISCED 3 Upper secondary education (orient unknown) - w/o possible distinction tertiary educ access (age 16-34)"
400 "Post-secondary non tertiary education (not further specified) (IE 440-450->400, IT 400-490->400)"
440 "ISCED 4 Post-secondary non-tertiary education - general (age 16-34)"
450 "ISCED 4 Post-secondary non-tertiary education - vocational (age 16-34)"
490 "ISCED 4 Post-secondary non-tertiary education - orientation unknown"
500 "ISCED 5-8 (top coding)"
;
label define PE041_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PL032_VALUE_LABELS
1 "Employed (PB010>=2021), Employee working full-time (PB010<=2020)"
2 "Unemployed (PB010>=2021), Employee working part-time (PB010<=2020)"
3 "Retired (PB010>=2021), Self-employed working full-time (including family worker) (PB010<=2020)"
4 "Unable to work due to long-standing hlth probs (PB010>=2021), Self-empl in part-time (incl family worker) (PB010<=2020)" 
5 "Student, pupil (PB010>=2021), Unemployed (PB010<=2020)"
6 "Fulfilling domestic tasks (PB010>=2021), Pupil, student, further training, unpaid work experience (PB010<=2020)"
7 "Compulsory military or civilian service (PB010>=2021), In (early) retirement or given up business (PB010<=2020)"
8 "Other (PB010>=2021), Permanently disabled or/and unfit to work (PB010<=2020)"
9 "In compulsory military or community service (PB010<=2020)"
10 "Fulfilling domestic tasks and care responsibilities (PB010<=2020)"
11 "Other inactive person (PB010<=2020)"
;
label define PL032_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PL016_VALUE_LABELS
1 "Person has never been in employment"
2 "Person has employment experience limited to occasional work"
3 "Person has employment experience other than occasional work"
;
label define PL016_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (PL032 equal to 1)"
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PL040A_VALUE_LABELS
1 "Self-employed with employees"
2 "Self-employed without employees"
3 "Employee"
4 "Family worker (unpaid)"
;
label define PL040A_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
-2 "Not applicable (PL032 not equal to 1)"
;
label define PL040B_VALUE_LABELS
1 "Self-employed with employees"
2 "Self-employed without employees"
3 "Employee"
4 "Family worker (unpaid)"
;
label define PL040B_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a main source"
-1 "Missing"
-2 "Not applicable (PL032 not equal to 1)"
;
label define PL051A_VALUE_LABELS
0 "MT, SI: Armed Forces"
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
label define PL051A_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (PL032 not equal to 1)"
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PL051B_VALUE_LABELS
0 "MT, SI: Armed Forces"
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
label define PL051B_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (PL032 not equal to 1)"
-7 "Not applicable (PB010 not equal to 2021)"
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
1 "Severely limited (PB010>=2021), Yes, strongly limited (PB010<2021)"
2 "Limited but not severely (PB010>=2021), Yes, limited (PB010<2021)"
3 "Not limited at all (PB010>=2021), No, not limited (PB010<2021)"
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
label define PH051_VALUE_LABELS
  1 "Yes"
  2 "No"
;
label define PH051_F_VALUE_LABELS
   1 "Filled"
  -1 "Missing"
  -2 "Not applicable (the person did not really  need any medical examination/treatment (PH040 not equal to 1))"
  -3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
  -7 "Not applicable (HB010 not equal to 2021)"
  -8 "Not applicable (variable not collected)"
;
label define PH071_VALUE_LABELS
  1 "Yes"
  2 "No"
;
label define PH071_F_VALUE_LABELS
   1 "Filled"
  -1 "Missing"
  -2 "Not applicable (the person did not really  need any medical examination/treatment (PH060 not equal to 1))"
  -3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
  -7 "Not applicable (HB010 not equal to 2021)"
  -8 "Not applicable (variable not collected)"
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
label define PL060_F_VALUE_LABELS              
1  "Collected via survey/interview"
2  "Collected from administrative data"
3  "Imputed"
4  "Not possible to establish a main source"
-1 "Missing"
-2 "Not applicable (PL032 not equal to 1)"
-6 "Hours varying (when an average of over four weeks is not possible)"
;
label define PL075_VALUE_LABELS              
10  "MT: 10 to 12"
;
label define PL073_F_VALUE_LABELS              
1  "Collected via survey/interview"
2  "Collected from administrative data"
3  "Imputed"
4  "Not possible to establish a main source"
-1 "Missing"
-5 "Missing value because the definition of this variable is not used"
;
label define PL100_F_VALUE_LABELS              
1  "Collected via survey/interview"
2  "Collected from administrative data"
3  "Imputed"
4  "Not possible to establish a main source"
-1 "Missing"
-2 "Not applicable (PL032 not equal to 1)"
-4 "Not applicable (Not second, third...job)"
-6 "Hours varying (when an average of over four weeks is not possible)"
;
label def PL111A_VALUE_LABELS
1 "a Agriculture, forestry and fishing"
2 "b-e Mining and quarrying, Manufacturing, Electricity, gas, steam and air conditioning supply, Water supply"
3 "f Construction"
4 "g Wholesale retail"
5 "h Transportation and storage"
6 "i Accommodation and food service activities"
7 "j Information and communication"
8 "k Financial and insurance activities"
9 "l-n Real estate activities, Professional, scientific and technical activities, Administrative and support service act..."
10 "o Public administration and defence, compulsory social security"
11 "p Education"
12 "q Human health and social work activities"
13 "r-u Arts, entertainment and recreation; Other service activities activities of households as employers; Undifferenti..."
;
label define PL111A_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
 -1 "Missing"
-2 "Not applicable (PL032 not equal to 1)"
-3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PL111B_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
 -1 "Missing"
-2 "Not applicable (PL032 not equal to 1)"
-3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
-7 "Not applicable (PB010 not equal to 2021)"
-8 "FR: missing"
;
label define PL141_VALUE_LABELS
1 "Permanent job/work contract of unlimited duration (PB010<=2020)"
2 "Temporary job/work contract of limited duration (PB010<=2020)"
11 "Fixed-term written contract (PB010>=2021, SI: 11,12->11)"
12 "Fixed-term verbal contract (PB010>=2021)"
21 "Permanent written contract (PB010>=2021, SI: 21,22->21)"
22 "Permanent verbal contract (PB010>=2021)"
;
label define PL141_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (PL040A not equal to 3)"
-3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PL145_VALUE_LABELS
1 "Full-time job"
2 "Part-time job"
;
label define PL145_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (PL032 not equal to 1)"
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PL150_VALUE_LABELS                
1 "Yes"
2 "No"
;
label define PL150_F_VALUE_LABELS              
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (PL040A not equal to 3)"
-3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
;
label define PL200_VALUE_LABELS              
55 "IE: 55 and later" 
;
label define PL200_F_VALUE_LABELS              
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (PL016 not equal to 3 and PL032 not equal to 1)"
-3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
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
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
;
label define PL220_VALUE_LABELS
  1 "Yes, full time"
  2 "Yes, but only partially"
  3 "No, it was not possible because I have no/insufficient internet connection at home"
  4 "No, it was not possible because my job is not adapted to teleworking"
  5 "No, teleworking not allowed/proposed by my employer"
  6 "No, it was not possible for another reason"
;
label define PL220_F_VALUE_LABELS
   1 "Filled"
  -1 "Missing"
  -2 "Not applicable (PL211A-PL211L not in (1,2,3 or 4))"
  -3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
  -4 "Not applicable (The work was finished before pandemic started)"
  -7 "Not applicable (HB010 not equal 2021)"
  -8 "Not applicable (variable not collected)"
;
label define PL271_VALUE_LABELS
31 "SI: 25-36"
48 "SI: 37-59"
;
label define PL271_F_VALUE_LABELS
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (Respondent not in working age 16-74)"
-3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
-7 "Not applicable (PB010 not equal to 2021)"
;
label define PY010G_VALUE_LABELS
0 "No inc."
;
label define PY035G_VALUE_LABELS
0 "No contribution"
;
label define PY010G_F_VALUE_LABELS
-1 "Missing"
-4 "Amount included in another inc. component"
-8 "Variable not collected"
11 "Collected via survey/interview, Net inc. tax at source and social contributions"
12 "Collected via survey/interview, Net inc. tax at source"
13 "Collected via survey/interview, Net of social contributions"
14 "Collected via survey/interview, Mix of different nets"
15 "Collected via survey/interview, Gross"
16 "Collected via survey/interview, inc. component(s) not taxed"
17 "Collected via survey/interview, Mix of net and gross"
18 "Collected via survey/interview, Unknown"
19 "Collected via survey/interview, Not applicable/not collected"
21 "Collected from administrative data, Net inc. tax at source and social contributions"
22 "Collected from administrative data, Net inc. tax at source"
23 "Collected from administrative data, Net of social contributions"
24 "Collected from administrative data, Mix of different nets"
25 "Collected from administrative data, Gross"
26 "Collected from administrative data, inc. component(s) not taxed"
27 "Collected from administrative data, Mix of net and gross"
28 "Collected from administrative data, Unknown"
29 "Collected from administrative data, Not applicable/not collected"
31 "deduc./logic. imp. (incl. top/bot-coding), Net inc. tax at source and social contributions"
32 "deduc./logic. imp. (incl. top/bot-coding), Net inc. tax at source"
33 "deduc./logic. imp. (incl. top/bot-coding), Net of social contributions"
34 "deduc./logic. imp. (incl. top/bot-coding), Mix of different nets"
35 "deduc./logic. imp. (incl. top/bot-coding), Gross"
36 "deduc./logic. imp. (incl. top/bot-coding), inc. component(s) not taxed"
37 "deduc./logic. imp. (incl. top/bot-coding), Mix of net and gross"
38 "deduc./logic. imp. (incl. top/bot-coding), Unknown"
39 "deduc./logic. imp. (incl. top/bot-coding), Not applicable/not collected"
41 "Gross/net conversion, Net inc. tax at source and social contributions"
42 "Gross/net conversion, Net inc. tax at source"
43 "Gross/net conversion, Net of social contributions"
44 "Gross/net conversion, Mix of different nets"
45 "Gross/net conversion, Gross"
46 "Gross/net conversion, inc. component(s) not taxed"
47 "Gross/net conversion, Mix of net and gross"
48 "Gross/net conversion, Unknown"
49 "Gross/net conversion, Not applicable/not collected"
51 "Model-based imputation, Net inc. tax at source and social contributions"
52 "Model-based imputation, Net inc. tax at source"
53 "Model-based imputation, Net of social contributions"
54 "Model-based imputation, Mix of different nets"
55 "Model-based imputation, Gross"
56 "Model-based imputation, inc. component(s) not taxed"
57 "Model-based imputation, Mix of net and gross"
58 "Model-based imputation, Unknown"
59 "Model-based imputation, Not applicable/not collected"
61 "Donor imputation, Net inc. tax at source and social contributions"
62 "Donor imputation, Net inc. tax at source"
63 "Donor imputation, Net of social contributions"
64 "Donor imputation, Mix of different nets"
65 "Donor imputation, Gross"
66 "Donor imputation, inc. component(s) not taxed"
67 "Donor imputation, Mix of net and gross"
68 "Donor imputation, Unknown"
69 "Donor imputation, Not applicable/not collected"
71 "Not poss. to estab. m. comm. source/method, Net inc. tax at source and social contributions"
72 "Not poss. to estab. m. comm. source/method, Net inc. tax at source"
73 "Not poss. to estab. m. comm. source/method, Net of social contributions"
74 "Not poss. to estab. m. comm. source/method, Mix of different nets"
75 "Not poss. to estab. m. comm. source/method, Gross"
76 "Not poss. to estab. m. comm. source/method, inc. component(s) not taxed"
77 "Not poss. to estab. m. comm. source/method, Mix of net and gross"
78 "Not poss. to estab. m. comm. source/method, Unknown"
79 "Not poss. to estab. m. comm. source/method, Not applicable/not collected"
;
label define PY091G_F_VALUE_LABELS
-8 "Variable not collected"
-5 "This scheme does not exist at national level"
-4 "Amount included in another inc. component"
-1 "Missing"
111 "Collected via survey/interview, Net of inc. tax & social contrib, only contrib & means-tested components"
112 "Collected via survey/interview, Net inc. tax at source and social contributions, mixed components"
121 "Collected via survey/interview, Net inc. tax at source, only contrib & means-tested components"
122 "Collected via survey/interview, Net inc. tax at source, mixed components"
131 "Collected via survey/interview, Net of social contrib, only contrib & means-tested components"
132 "Collected via survey/interview, Net of social contrib, mixed components"
141 "Collected via survey/interview, Mix of different nets, only contrib & means-tested components"
142 "Collected via survey/interview, Mix of different nets, mixed components"
151 "Collected via survey/interview, Gross, only contributory and means-tested components"
152 "Collected via survey/interview, Gross, mixed components"
161 "Collected via survey/interview, inc. comp not taxed, only contributory and means-tested components"
162 "Collected via survey/interview, inc. comp not taxed, mixed components"
171 "Collected via survey/interview, Mix of net and gross, only contributory and means-tested components"
172 "Collected via survey/interview, Mix of net and gross, mixed components"
181 "Collected via survey/interview, Unknown, only contrib & means-tested components"
182 "Collected via survey/interview, Unknown, mixed components"
191 "Collected via survey/interview, Not applic/not collected, only contrib & means-tested components"
192 "Collected via survey/interview, Not applic/not collected, mixed components"
211 "Collected from administrative data, Net of inc. tax & social contrib, only contrib & means-tested components"
212 "Collected from administrative data, Net of inc. tax & social contrib, mixed components"
221 "Collected from administrative data, Net inc. tax at source, only contrib & means-tested components"
222 "Collected from administrative data, Net inc. tax at source, mixed components"
231 "Collected from administrative data, Net of social contrib, only contrib & means-tested components"
232 "Collected from administrative data, Net of social contrib, mixed components"
241 "Collected from administrative data, Mix of different nets, only contrib & means-tested components"
242 "Collected from administrative data, Mix of different nets, mixed components"
251 "Collected from administrative data, Gross, only contributory and means-tested components"
252 "Collected from administrative data, Gross, mixed components"
261 "Collected from administrative data, inc. comp not taxed, only contributory and means-tested components"
262 "Collected from administrative data, inc. comp not taxed, mixed components"
271 "Collected from administrative data, Mix of net and gross, only contributory and means-tested components"
272 "Collected from administrative data, Mix of net and gross, mixed components"
281 "Collected from administrative data, Unknown, only contributory and means-tested components"
282 "Collected from administrative data, Unknown, mixed components"
291 "Collected from administrative data, Not applic/not collected, only contrib & means-tested components"
292 "Collected from administrative data, Not applic/not collected, mixed components"
311 "deduc./logic. imp. (incl. top/bot-coding), Net of inc. tax & social contrib, only contrib & means-tested components"
312 "deduc./logic. imp. (incl. top/bot-coding), Net of inc. tax & social contrib, mixed components"
321 "deduc./logic. imp. (incl. top/bot-coding), Net inc. tax at source, only contrib & means-tested components"
322 "deduc./logic. imp. (incl. top/bot-coding), Net inc. tax at source, mixed components"
331 "deduc./logic. imp. (incl. top/bot-coding), Net of social contrib, only contrib & means-tested components"
332 "deduc./logic. imp. (incl. top/bot-coding), Net of social contrib, mixed components"
341 "deduc./logic. imp. (incl. top/bot-coding), Mix of different nets, only contrib & means-tested components"
342 "deduc./logic. imp. (incl. top/bot-coding), Mix of different nets, mixed components"
351 "deduc./logic. imp. (incl. top/bot-coding), Gross, only contributory and means-tested components"
352 "deduc./logic. imp. (incl. top/bot-coding), Gross, mixed components"
361 "deduc./logic. imp. (incl. top/bot-coding), inc. comp not taxed, only contrib and means-tested components"
362 "deduc./logic. imp. (incl. top/bot-coding), inc. comp not taxed, mixed components"
371 "deduc./logic. imp. (incl. top/bot-coding), Mix of net and gross, only contrib & means-tested components"
372 "deduc./logic. imp. (incl. top/bot-coding), Mix of net and gross, mixed components"
381 "deduc./logic. imp. (incl. top/bot-coding), Unknown, only contrib & means-tested components"
382 "deduc./logic. imp. (incl. top/bot-coding), Unknown, mixed components"
391 "deduc./logic. imp. (incl. top/bot-coding), Not applic/not collected, only contrib and means-tested components"
392 "deduc./logic. imp. (incl. top/bot-coding), Not applic/not collected, mixed components"
411 "Gross/net conversion, Net of inc. tax & social contrib, only contrib & means-tested components"
412 "Gross/net conversion, Net inc. tax at source and social contributions, mixed components"
421 "Gross/net conversion, Net inc. tax at source, only contrib & means-tested components"
422 "Gross/net conversion, Net inc. tax at source, mixed components"
431 "Gross/net conversion, Net of social contrib, only contrib & means-tested components"
432 "Gross/net conversion, Net of social contrib, mixed components"
441 "Gross/net conversion, Mix of different nets, only contributory and means-tested components"
442 "Gross/net conversion, Mix of different nets, mixed components"
451 "Gross/net conversion, Gross, only contributory and means-tested components"
452 "Gross/net conversion, Gross, mixed components"
461 "Gross/net conversion, inc. comp not taxed, only contributory and means-tested components"
462 "Gross/net conversion, inc. comp not taxed, mixed components"
471 "Gross/net conversion, Mix of net and gross, only contributory and means-tested components"
472 "Gross/net conversion, Mix of net and gross, mixed components"
481 "Gross/net conversion, Unknown, only contributory and means-tested components"
482 "Gross/net conversion, Unknown, mixed components"
491 "Gross/net conversion, Not applic/not collected, only contrib & means-tested components"
492 "Gross/net conversion, Not applic/not collected, mixed components"
511 "Model-based imputation, Net of inc. tax & social contrib, only contrib & means-tested components"
512 "Model-based imputation, Net of inc. tax & social contrib, mixed components"
521 "Model-based imputation, Net inc. tax at source, only contrib & means-tested components"
522 "Model-based imputation, Net inc. tax at source, mixed components"
531 "Model-based imputation, Net of social contrib, only contrib & means-tested components"
532 "Model-based imputation, Net of social contrib, mixed components"
541 "Model-based imputation, Mix of different nets, only contrib & means-tested components"
542 "Model-based imputation, Mix of different nets, mixed components"
551 "Model-based imputation, Gross, only contributory and means-tested components"
552 "Model-based imputation, Gross, mixed components"
561 "Model-based imputation, inc. comp not taxed, only contributory and means-tested components"
562 "Model-based imputation, inc. comp not taxed, mixed components"
571 "Model-based imputation, Mix of net and gross, only contrib & means-tested components"
572 "Model-based imputation, Mix of net and gross, mixed components"
581 "Model-based imputation, Unknown, only contrib & means-tested components"
582 "Model-based imputation, Unknown, mixed components"
591 "Model-based imputation, Not applic/not collected, only contrib & means-tested components"
592 "Model-based imputation, Not applic/not collected, mixed components"
611 "Donor imputation, Net of inc. tax & social contrib, only contrib & means-tested components"
612 "Donor imputation, Net of inc. tax & social contrib, mixed components"
621 "Donor imputation, Net inc. tax at source, only contrib & means-tested components"
622 "Donor imputation, Net inc. tax at source, mixed components"
631 "Donor imputation, Net of social contrib, only contrib & means-tested components"
632 "Donor imputation, Net of social contrib, mixed components"
641 "Donor imputation, Mix of different nets, only contrib & means-tested components"
642 "Donor imputation, Mix of different nets, mixed components"
651 "Donor imputation, Gross, only contributory and means-tested components"
652 "Donor imputation, Gross, mixed components"
661 "Donor imputation, inc. comp not taxed, only contributory and means-tested components"
662 "Donor imputation, inc. comp not taxed, mixed components"
671 "Donor imputation, Mix of net and gross, only contributory and means-tested components"
672 "Donor imputation, Mix of net and gross, mixed components"
681 "Donor imputation, Unknown, only contrib & means-tested components"
682 "Donor imputation, Unknown, mixed components"
691 "Donor imputation, Not applic/not collected, only contributory and means-tested components"
692 "Donor imputation, Not applic/not collected, mixed components"
711 "Not poss. to estab. m. comm. source/method, Net of inc. tax & social contrib, only contrib & means-tested comp"
712 "Not poss. to estab. m. comm. source/method, Net of inc. tax & social contrib, mixed components"
721 "Not poss. to estab. m. comm. source/method, Net inc. tax at source, only contrib & means-tested comp"
722 "Not poss. to estab. m. comm. source/method, Net inc. tax at source, mixed components"
731 "Not poss. to estab. m. comm. source/method, Net of social contrib, only contrib & means-tested components"
732 "Not poss. to estab. m. comm. source/method, Net of social contrib, mixed components"
741 "Not poss. to estab. m. comm. source/method, Mix of different nets, only contrib & means-tested components"
742 "Not poss. to estab. m. comm. source/method, Mix of different nets, mixed components"
751 "Not poss. to estab. m. comm. source/method, Gross, only contrib & means-tested components"
752 "Not poss. to estab. m. comm. source/method, Gross, mixed components"
761 "Not poss. to estab. m. comm. source/method, inc. comp not taxed, only contrib & means-tested components"
762 "Not poss. to estab. m. comm. source/method, inc. comp not taxed, mixed components"
771 "Not poss. to estab. m. comm. source/method, Mix of net and gross, only contrib & means-tested components"
772 "Not poss. to estab. m. comm. source/method, Mix of net and gross, mixed components"
781 "Not poss. to estab. m. comm. source/method, Unknown, only contributory and means-tested components"
782 "Not poss. to estab. m. comm. source/method, Unknown, mixed components"
791 "Not poss. to estab. m. comm. source/method, Not applic/not collected, only contrib & means-tested comp"
792 "Not poss. to estab. m. comm. source/method, Not applic/not collected, mixed components"
;
label define PY092G_F_VALUE_LABELS
-8 "Variable not collected"
-5 "This scheme does not exist at national level"
-4 "Amount included in another inc. component"
-1 "Missing"
111 "Collected via survey/interview, Net of inc. tax & social contrib, only contrib & means-tested components"
112 "Collected via survey/interview, Net inc. tax at source and social contributions, mixed components"
121 "Collected via survey/interview, Net inc. tax at source, only contrib & means-tested components"
122 "Collected via survey/interview, Net inc. tax at source, mixed components"
131 "Collected via survey/interview, Net of social contrib, only contrib & means-tested components"
132 "Collected via survey/interview, Net of social contrib, mixed components"
141 "Collected via survey/interview, Mix of different nets, only contrib & means-tested components"
142 "Collected via survey/interview, Mix of different nets, mixed components"
151 "Collected via survey/interview, Gross, only contributory and means-tested components"
152 "Collected via survey/interview, Gross, mixed components"
161 "Collected via survey/interview, inc. comp not taxed, only contributory and means-tested components"
162 "Collected via survey/interview, inc. comp not taxed, mixed components"
171 "Collected via survey/interview, Mix of net and gross, only contributory and means-tested components"
172 "Collected via survey/interview, Mix of net and gross, mixed components"
181 "Collected via survey/interview, Unknown, only contrib & means-tested components"
182 "Collected via survey/interview, Unknown, mixed components"
191 "Collected via survey/interview, Not applic/not collected, only contrib & means-tested components"
192 "Collected via survey/interview, Not applic/not collected, mixed components"
211 "Collected from administrative data, Net of inc. tax & social contrib, only contrib & means-tested components"
212 "Collected from administrative data, Net of inc. tax & social contrib, mixed components"
221 "Collected from administrative data, Net inc. tax at source, only contrib & means-tested components"
222 "Collected from administrative data, Net inc. tax at source, mixed components"
231 "Collected from administrative data, Net of social contrib, only contrib & means-tested components"
232 "Collected from administrative data, Net of social contrib, mixed components"
241 "Collected from administrative data, Mix of different nets, only contrib & means-tested components"
242 "Collected from administrative data, Mix of different nets, mixed components"
251 "Collected from administrative data, Gross, only contributory and means-tested components"
252 "Collected from administrative data, Gross, mixed components"
261 "Collected from administrative data, inc. comp not taxed, only contributory and means-tested components"
262 "Collected from administrative data, inc. comp not taxed, mixed components"
271 "Collected from administrative data, Mix of net and gross, only contributory and means-tested components"
272 "Collected from administrative data, Mix of net and gross, mixed components"
281 "Collected from administrative data, Unknown, only contributory and means-tested components"
282 "Collected from administrative data, Unknown, mixed components"
291 "Collected from administrative data, Not applic/not collected, only contrib & means-tested components"
292 "Collected from administrative data, Not applic/not collected, mixed components"
311 "deduc./logic. imp. (incl. top/bot-coding), Net of inc. tax & social contrib, only contrib & means-tested components"
312 "deduc./logic. imp. (incl. top/bot-coding), Net of inc. tax & social contrib, mixed components"
321 "deduc./logic. imp. (incl. top/bot-coding), Net inc. tax at source, only contrib & means-tested components"
322 "deduc./logic. imp. (incl. top/bot-coding), Net inc. tax at source, mixed components"
331 "deduc./logic. imp. (incl. top/bot-coding), Net of social contrib, only contrib & means-tested components"
332 "deduc./logic. imp. (incl. top/bot-coding), Net of social contrib, mixed components"
341 "deduc./logic. imp. (incl. top/bot-coding), Mix of different nets, only contrib & means-tested components"
342 "deduc./logic. imp. (incl. top/bot-coding), Mix of different nets, mixed components"
351 "deduc./logic. imp. (incl. top/bot-coding), Gross, only contributory and means-tested components"
352 "deduc./logic. imp. (incl. top/bot-coding), Gross, mixed components"
361 "deduc./logic. imp. (incl. top/bot-coding), inc. comp not taxed, only contrib and means-tested components"
362 "deduc./logic. imp. (incl. top/bot-coding), inc. comp not taxed, mixed components"
371 "deduc./logic. imp. (incl. top/bot-coding), Mix of net and gross, only contrib & means-tested components"
372 "deduc./logic. imp. (incl. top/bot-coding), Mix of net and gross, mixed components"
381 "deduc./logic. imp. (incl. top/bot-coding), Unknown, only contrib & means-tested components"
382 "deduc./logic. imp. (incl. top/bot-coding), Unknown, mixed components"
391 "deduc./logic. imp. (incl. top/bot-coding), Not applic/not collected, only contrib and means-tested components"
392 "deduc./logic. imp. (incl. top/bot-coding), Not applic/not collected, mixed components"
411 "Gross/net conversion, Net of inc. tax & social contrib, only contrib & means-tested components"
412 "Gross/net conversion, Net inc. tax at source and social contributions, mixed components"
421 "Gross/net conversion, Net inc. tax at source, only contrib & means-tested components"
422 "Gross/net conversion, Net inc. tax at source, mixed components"
431 "Gross/net conversion, Net of social contrib, only contrib & means-tested components"
432 "Gross/net conversion, Net of social contrib, mixed components"
441 "Gross/net conversion, Mix of different nets, only contributory and means-tested components"
442 "Gross/net conversion, Mix of different nets, mixed components"
451 "Gross/net conversion, Gross, only contributory and means-tested components"
452 "Gross/net conversion, Gross, mixed components"
461 "Gross/net conversion, inc. comp not taxed, only contributory and means-tested components"
462 "Gross/net conversion, inc. comp not taxed, mixed components"
471 "Gross/net conversion, Mix of net and gross, only contributory and means-tested components"
472 "Gross/net conversion, Mix of net and gross, mixed components"
481 "Gross/net conversion, Unknown, only contributory and means-tested components"
482 "Gross/net conversion, Unknown, mixed components"
491 "Gross/net conversion, Not applic/not collected, only contrib & means-tested components"
492 "Gross/net conversion, Not applic/not collected, mixed components"
511 "Model-based imputation, Net of inc. tax & social contrib, only contrib & means-tested components"
512 "Model-based imputation, Net of inc. tax & social contrib, mixed components"
521 "Model-based imputation, Net inc. tax at source, only contrib & means-tested components"
522 "Model-based imputation, Net inc. tax at source, mixed components"
531 "Model-based imputation, Net of social contrib, only contrib & means-tested components"
532 "Model-based imputation, Net of social contrib, mixed components"
541 "Model-based imputation, Mix of different nets, only contrib & means-tested components"
542 "Model-based imputation, Mix of different nets, mixed components"
551 "Model-based imputation, Gross, only contributory and means-tested components"
552 "Model-based imputation, Gross, mixed components"
561 "Model-based imputation, inc. comp not taxed, only contributory and means-tested components"
562 "Model-based imputation, inc. comp not taxed, mixed components"
571 "Model-based imputation, Mix of net and gross, only contrib & means-tested components"
572 "Model-based imputation, Mix of net and gross, mixed components"
581 "Model-based imputation, Unknown, only contrib & means-tested components"
582 "Model-based imputation, Unknown, mixed components"
591 "Model-based imputation, Not applic/not collected, only contrib & means-tested components"
592 "Model-based imputation, Not applic/not collected, mixed components"
611 "Donor imputation, Net of inc. tax & social contrib, only contrib & means-tested components"
612 "Donor imputation, Net of inc. tax & social contrib, mixed components"
621 "Donor imputation, Net inc. tax at source, only contrib & means-tested components"
622 "Donor imputation, Net inc. tax at source, mixed components"
631 "Donor imputation, Net of social contrib, only contrib & means-tested components"
632 "Donor imputation, Net of social contrib, mixed components"
641 "Donor imputation, Mix of different nets, only contrib & means-tested components"
642 "Donor imputation, Mix of different nets, mixed components"
651 "Donor imputation, Gross, only contributory and means-tested components"
652 "Donor imputation, Gross, mixed components"
661 "Donor imputation, inc. comp not taxed, only contributory and means-tested components"
662 "Donor imputation, inc. comp not taxed, mixed components"
671 "Donor imputation, Mix of net and gross, only contributory and means-tested components"
672 "Donor imputation, Mix of net and gross, mixed components"
681 "Donor imputation, Unknown, only contrib & means-tested components"
682 "Donor imputation, Unknown, mixed components"
691 "Donor imputation, Not applic/not collected, only contributory and means-tested components"
692 "Donor imputation, Not applic/not collected, mixed components"
711 "Not poss. to estab. m. comm. source/method, Net of inc. tax & social contrib, only contrib & means-tested comp"
712 "Not poss. to estab. m. comm. source/method, Net of inc. tax & social contrib, mixed components"
721 "Not poss. to estab. m. comm. source/method, Net inc. tax at source, only contrib & means-tested comp"
722 "Not poss. to estab. m. comm. source/method, Net inc. tax at source, mixed components"
731 "Not poss. to estab. m. comm. source/method, Net of social contrib, only contrib & means-tested components"
732 "Not poss. to estab. m. comm. source/method, Net of social contrib, mixed components"
741 "Not poss. to estab. m. comm. source/method, Mix of different nets, only contrib & means-tested components"
742 "Not poss. to estab. m. comm. source/method, Mix of different nets, mixed components"
751 "Not poss. to estab. m. comm. source/method, Gross, only contrib & means-tested components"
752 "Not poss. to estab. m. comm. source/method, Gross, mixed components"
761 "Not poss. to estab. m. comm. source/method, inc. comp not taxed, only contrib & means-tested components"
762 "Not poss. to estab. m. comm. source/method, inc. comp not taxed, mixed components"
771 "Not poss. to estab. m. comm. source/method, Mix of net and gross, only contrib & means-tested components"
772 "Not poss. to estab. m. comm. source/method, Mix of net and gross, mixed components"
781 "Not poss. to estab. m. comm. source/method, Unknown, only contributory and means-tested components"
782 "Not poss. to estab. m. comm. source/method, Unknown, mixed components"
791 "Not poss. to estab. m. comm. source/method, Not applic/not collected, only contrib & means-tested comp"
792 "Not poss. to estab. m. comm. source/method, Not applic/not collected, mixed components"
;
label define PY093G_F_VALUE_LABELS
-8 "Variable not collected"
-5 "This scheme does not exist at national level"
-4 "Amount included in another inc. component"
-1 "Missing"
111 "Collected via survey/interview, Net of inc. tax & social contrib, only contrib & means-tested components"
112 "Collected via survey/interview, Net inc. tax at source and social contributions, mixed components"
121 "Collected via survey/interview, Net inc. tax at source, only contrib & means-tested components"
122 "Collected via survey/interview, Net inc. tax at source, mixed components"
131 "Collected via survey/interview, Net of social contrib, only contrib & means-tested components"
132 "Collected via survey/interview, Net of social contrib, mixed components"
141 "Collected via survey/interview, Mix of different nets, only contrib & means-tested components"
142 "Collected via survey/interview, Mix of different nets, mixed components"
151 "Collected via survey/interview, Gross, only contributory and means-tested components"
152 "Collected via survey/interview, Gross, mixed components"
161 "Collected via survey/interview, inc. comp not taxed, only contributory and means-tested components"
162 "Collected via survey/interview, inc. comp not taxed, mixed components"
171 "Collected via survey/interview, Mix of net and gross, only contributory and means-tested components"
172 "Collected via survey/interview, Mix of net and gross, mixed components"
181 "Collected via survey/interview, Unknown, only contrib & means-tested components"
182 "Collected via survey/interview, Unknown, mixed components"
191 "Collected via survey/interview, Not applic/not collected, only contrib & means-tested components"
192 "Collected via survey/interview, Not applic/not collected, mixed components"
211 "Collected from administrative data, Net of inc. tax & social contrib, only contrib & means-tested components"
212 "Collected from administrative data, Net of inc. tax & social contrib, mixed components"
221 "Collected from administrative data, Net inc. tax at source, only contrib & means-tested components"
222 "Collected from administrative data, Net inc. tax at source, mixed components"
231 "Collected from administrative data, Net of social contrib, only contrib & means-tested components"
232 "Collected from administrative data, Net of social contrib, mixed components"
241 "Collected from administrative data, Mix of different nets, only contrib & means-tested components"
242 "Collected from administrative data, Mix of different nets, mixed components"
251 "Collected from administrative data, Gross, only contributory and means-tested components"
252 "Collected from administrative data, Gross, mixed components"
261 "Collected from administrative data, inc. comp not taxed, only contributory and means-tested components"
262 "Collected from administrative data, inc. comp not taxed, mixed components"
271 "Collected from administrative data, Mix of net and gross, only contributory and means-tested components"
272 "Collected from administrative data, Mix of net and gross, mixed components"
281 "Collected from administrative data, Unknown, only contributory and means-tested components"
282 "Collected from administrative data, Unknown, mixed components"
291 "Collected from administrative data, Not applic/not collected, only contrib & means-tested components"
292 "Collected from administrative data, Not applic/not collected, mixed components"
311 "deduc./logic. imp. (incl. top/bot-coding), Net of inc. tax & social contrib, only contrib & means-tested components"
312 "deduc./logic. imp. (incl. top/bot-coding), Net of inc. tax & social contrib, mixed components"
321 "deduc./logic. imp. (incl. top/bot-coding), Net inc. tax at source, only contrib & means-tested components"
322 "deduc./logic. imp. (incl. top/bot-coding), Net inc. tax at source, mixed components"
331 "deduc./logic. imp. (incl. top/bot-coding), Net of social contrib, only contrib & means-tested components"
332 "deduc./logic. imp. (incl. top/bot-coding), Net of social contrib, mixed components"
341 "deduc./logic. imp. (incl. top/bot-coding), Mix of different nets, only contrib & means-tested components"
342 "deduc./logic. imp. (incl. top/bot-coding), Mix of different nets, mixed components"
351 "deduc./logic. imp. (incl. top/bot-coding), Gross, only contributory and means-tested components"
352 "deduc./logic. imp. (incl. top/bot-coding), Gross, mixed components"
361 "deduc./logic. imp. (incl. top/bot-coding), inc. comp not taxed, only contrib and means-tested components"
362 "deduc./logic. imp. (incl. top/bot-coding), inc. comp not taxed, mixed components"
371 "deduc./logic. imp. (incl. top/bot-coding), Mix of net and gross, only contrib & means-tested components"
372 "deduc./logic. imp. (incl. top/bot-coding), Mix of net and gross, mixed components"
381 "deduc./logic. imp. (incl. top/bot-coding), Unknown, only contrib & means-tested components"
382 "deduc./logic. imp. (incl. top/bot-coding), Unknown, mixed components"
391 "deduc./logic. imp. (incl. top/bot-coding), Not applic/not collected, only contrib and means-tested components"
392 "deduc./logic. imp. (incl. top/bot-coding), Not applic/not collected, mixed components"
411 "Gross/net conversion, Net of inc. tax & social contrib, only contrib & means-tested components"
412 "Gross/net conversion, Net inc. tax at source and social contributions, mixed components"
421 "Gross/net conversion, Net inc. tax at source, only contrib & means-tested components"
422 "Gross/net conversion, Net inc. tax at source, mixed components"
431 "Gross/net conversion, Net of social contrib, only contrib & means-tested components"
432 "Gross/net conversion, Net of social contrib, mixed components"
441 "Gross/net conversion, Mix of different nets, only contributory and means-tested components"
442 "Gross/net conversion, Mix of different nets, mixed components"
451 "Gross/net conversion, Gross, only contributory and means-tested components"
452 "Gross/net conversion, Gross, mixed components"
461 "Gross/net conversion, inc. comp not taxed, only contributory and means-tested components"
462 "Gross/net conversion, inc. comp not taxed, mixed components"
471 "Gross/net conversion, Mix of net and gross, only contributory and means-tested components"
472 "Gross/net conversion, Mix of net and gross, mixed components"
481 "Gross/net conversion, Unknown, only contributory and means-tested components"
482 "Gross/net conversion, Unknown, mixed components"
491 "Gross/net conversion, Not applic/not collected, only contrib & means-tested components"
492 "Gross/net conversion, Not applic/not collected, mixed components"
511 "Model-based imputation, Net of inc. tax & social contrib, only contrib & means-tested components"
512 "Model-based imputation, Net of inc. tax & social contrib, mixed components"
521 "Model-based imputation, Net inc. tax at source, only contrib & means-tested components"
522 "Model-based imputation, Net inc. tax at source, mixed components"
531 "Model-based imputation, Net of social contrib, only contrib & means-tested components"
532 "Model-based imputation, Net of social contrib, mixed components"
541 "Model-based imputation, Mix of different nets, only contrib & means-tested components"
542 "Model-based imputation, Mix of different nets, mixed components"
551 "Model-based imputation, Gross, only contributory and means-tested components"
552 "Model-based imputation, Gross, mixed components"
561 "Model-based imputation, inc. comp not taxed, only contributory and means-tested components"
562 "Model-based imputation, inc. comp not taxed, mixed components"
571 "Model-based imputation, Mix of net and gross, only contrib & means-tested components"
572 "Model-based imputation, Mix of net and gross, mixed components"
581 "Model-based imputation, Unknown, only contrib & means-tested components"
582 "Model-based imputation, Unknown, mixed components"
591 "Model-based imputation, Not applic/not collected, only contrib & means-tested components"
592 "Model-based imputation, Not applic/not collected, mixed components"
611 "Donor imputation, Net of inc. tax & social contrib, only contrib & means-tested components"
612 "Donor imputation, Net of inc. tax & social contrib, mixed components"
621 "Donor imputation, Net inc. tax at source, only contrib & means-tested components"
622 "Donor imputation, Net inc. tax at source, mixed components"
631 "Donor imputation, Net of social contrib, only contrib & means-tested components"
632 "Donor imputation, Net of social contrib, mixed components"
641 "Donor imputation, Mix of different nets, only contrib & means-tested components"
642 "Donor imputation, Mix of different nets, mixed components"
651 "Donor imputation, Gross, only contributory and means-tested components"
652 "Donor imputation, Gross, mixed components"
661 "Donor imputation, inc. comp not taxed, only contributory and means-tested components"
662 "Donor imputation, inc. comp not taxed, mixed components"
671 "Donor imputation, Mix of net and gross, only contributory and means-tested components"
672 "Donor imputation, Mix of net and gross, mixed components"
681 "Donor imputation, Unknown, only contrib & means-tested components"
682 "Donor imputation, Unknown, mixed components"
691 "Donor imputation, Not applic/not collected, only contributory and means-tested components"
692 "Donor imputation, Not applic/not collected, mixed components"
711 "Not poss. to estab. m. comm. source/method, Net of inc. tax & social contrib, only contrib & means-tested comp"
712 "Not poss. to estab. m. comm. source/method, Net of inc. tax & social contrib, mixed components"
721 "Not poss. to estab. m. comm. source/method, Net inc. tax at source, only contrib & means-tested comp"
722 "Not poss. to estab. m. comm. source/method, Net inc. tax at source, mixed components"
731 "Not poss. to estab. m. comm. source/method, Net of social contrib, only contrib & means-tested components"
732 "Not poss. to estab. m. comm. source/method, Net of social contrib, mixed components"
741 "Not poss. to estab. m. comm. source/method, Mix of different nets, only contrib & means-tested components"
742 "Not poss. to estab. m. comm. source/method, Mix of different nets, mixed components"
751 "Not poss. to estab. m. comm. source/method, Gross, only contrib & means-tested components"
752 "Not poss. to estab. m. comm. source/method, Gross, mixed components"
761 "Not poss. to estab. m. comm. source/method, inc. comp not taxed, only contrib & means-tested components"
762 "Not poss. to estab. m. comm. source/method, inc. comp not taxed, mixed components"
771 "Not poss. to estab. m. comm. source/method, Mix of net and gross, only contrib & means-tested components"
772 "Not poss. to estab. m. comm. source/method, Mix of net and gross, mixed components"
781 "Not poss. to estab. m. comm. source/method, Unknown, only contributory and means-tested components"
782 "Not poss. to estab. m. comm. source/method, Unknown, mixed components"
791 "Not poss. to estab. m. comm. source/method, Not applic/not collected, only contrib & means-tested comp"
792 "Not poss. to estab. m. comm. source/method, Not applic/not collected, mixed components"
;
label define PY094G_F_VALUE_LABELS
-8 "Variable not collected"
-5 "This scheme does not exist at national level"
-4 "Amount included in another inc. component"
-1 "Missing"
111 "Collected via survey/interview, Net of inc. tax & social contrib, only contrib & means-tested components"
112 "Collected via survey/interview, Net inc. tax at source and social contributions, mixed components"
121 "Collected via survey/interview, Net inc. tax at source, only contrib & means-tested components"
122 "Collected via survey/interview, Net inc. tax at source, mixed components"
131 "Collected via survey/interview, Net of social contrib, only contrib & means-tested components"
132 "Collected via survey/interview, Net of social contrib, mixed components"
141 "Collected via survey/interview, Mix of different nets, only contrib & means-tested components"
142 "Collected via survey/interview, Mix of different nets, mixed components"
151 "Collected via survey/interview, Gross, only contributory and means-tested components"
152 "Collected via survey/interview, Gross, mixed components"
161 "Collected via survey/interview, inc. comp not taxed, only contributory and means-tested components"
162 "Collected via survey/interview, inc. comp not taxed, mixed components"
171 "Collected via survey/interview, Mix of net and gross, only contributory and means-tested components"
172 "Collected via survey/interview, Mix of net and gross, mixed components"
181 "Collected via survey/interview, Unknown, only contrib & means-tested components"
182 "Collected via survey/interview, Unknown, mixed components"
191 "Collected via survey/interview, Not applic/not collected, only contrib & means-tested components"
192 "Collected via survey/interview, Not applic/not collected, mixed components"
211 "Collected from administrative data, Net of inc. tax & social contrib, only contrib & means-tested components"
212 "Collected from administrative data, Net of inc. tax & social contrib, mixed components"
221 "Collected from administrative data, Net inc. tax at source, only contrib & means-tested components"
222 "Collected from administrative data, Net inc. tax at source, mixed components"
231 "Collected from administrative data, Net of social contrib, only contrib & means-tested components"
232 "Collected from administrative data, Net of social contrib, mixed components"
241 "Collected from administrative data, Mix of different nets, only contrib & means-tested components"
242 "Collected from administrative data, Mix of different nets, mixed components"
251 "Collected from administrative data, Gross, only contributory and means-tested components"
252 "Collected from administrative data, Gross, mixed components"
261 "Collected from administrative data, inc. comp not taxed, only contributory and means-tested components"
262 "Collected from administrative data, inc. comp not taxed, mixed components"
271 "Collected from administrative data, Mix of net and gross, only contributory and means-tested components"
272 "Collected from administrative data, Mix of net and gross, mixed components"
281 "Collected from administrative data, Unknown, only contributory and means-tested components"
282 "Collected from administrative data, Unknown, mixed components"
291 "Collected from administrative data, Not applic/not collected, only contrib & means-tested components"
292 "Collected from administrative data, Not applic/not collected, mixed components"
311 "deduc./logic. imp. (incl. top/bot-coding), Net of inc. tax & social contrib, only contrib & means-tested components"
312 "deduc./logic. imp. (incl. top/bot-coding), Net of inc. tax & social contrib, mixed components"
321 "deduc./logic. imp. (incl. top/bot-coding), Net inc. tax at source, only contrib & means-tested components"
322 "deduc./logic. imp. (incl. top/bot-coding), Net inc. tax at source, mixed components"
331 "deduc./logic. imp. (incl. top/bot-coding), Net of social contrib, only contrib & means-tested components"
332 "deduc./logic. imp. (incl. top/bot-coding), Net of social contrib, mixed components"
341 "deduc./logic. imp. (incl. top/bot-coding), Mix of different nets, only contrib & means-tested components"
342 "deduc./logic. imp. (incl. top/bot-coding), Mix of different nets, mixed components"
351 "deduc./logic. imp. (incl. top/bot-coding), Gross, only contributory and means-tested components"
352 "deduc./logic. imp. (incl. top/bot-coding), Gross, mixed components"
361 "deduc./logic. imp. (incl. top/bot-coding), inc. comp not taxed, only contrib and means-tested components"
362 "deduc./logic. imp. (incl. top/bot-coding), inc. comp not taxed, mixed components"
371 "deduc./logic. imp. (incl. top/bot-coding), Mix of net and gross, only contrib & means-tested components"
372 "deduc./logic. imp. (incl. top/bot-coding), Mix of net and gross, mixed components"
381 "deduc./logic. imp. (incl. top/bot-coding), Unknown, only contrib & means-tested components"
382 "deduc./logic. imp. (incl. top/bot-coding), Unknown, mixed components"
391 "deduc./logic. imp. (incl. top/bot-coding), Not applic/not collected, only contrib and means-tested components"
392 "deduc./logic. imp. (incl. top/bot-coding), Not applic/not collected, mixed components"
411 "Gross/net conversion, Net of inc. tax & social contrib, only contrib & means-tested components"
412 "Gross/net conversion, Net inc. tax at source and social contributions, mixed components"
421 "Gross/net conversion, Net inc. tax at source, only contrib & means-tested components"
422 "Gross/net conversion, Net inc. tax at source, mixed components"
431 "Gross/net conversion, Net of social contrib, only contrib & means-tested components"
432 "Gross/net conversion, Net of social contrib, mixed components"
441 "Gross/net conversion, Mix of different nets, only contributory and means-tested components"
442 "Gross/net conversion, Mix of different nets, mixed components"
451 "Gross/net conversion, Gross, only contributory and means-tested components"
452 "Gross/net conversion, Gross, mixed components"
461 "Gross/net conversion, inc. comp not taxed, only contributory and means-tested components"
462 "Gross/net conversion, inc. comp not taxed, mixed components"
471 "Gross/net conversion, Mix of net and gross, only contributory and means-tested components"
472 "Gross/net conversion, Mix of net and gross, mixed components"
481 "Gross/net conversion, Unknown, only contributory and means-tested components"
482 "Gross/net conversion, Unknown, mixed components"
491 "Gross/net conversion, Not applic/not collected, only contrib & means-tested components"
492 "Gross/net conversion, Not applic/not collected, mixed components"
511 "Model-based imputation, Net of inc. tax & social contrib, only contrib & means-tested components"
512 "Model-based imputation, Net of inc. tax & social contrib, mixed components"
521 "Model-based imputation, Net inc. tax at source, only contrib & means-tested components"
522 "Model-based imputation, Net inc. tax at source, mixed components"
531 "Model-based imputation, Net of social contrib, only contrib & means-tested components"
532 "Model-based imputation, Net of social contrib, mixed components"
541 "Model-based imputation, Mix of different nets, only contrib & means-tested components"
542 "Model-based imputation, Mix of different nets, mixed components"
551 "Model-based imputation, Gross, only contributory and means-tested components"
552 "Model-based imputation, Gross, mixed components"
561 "Model-based imputation, inc. comp not taxed, only contributory and means-tested components"
562 "Model-based imputation, inc. comp not taxed, mixed components"
571 "Model-based imputation, Mix of net and gross, only contrib & means-tested components"
572 "Model-based imputation, Mix of net and gross, mixed components"
581 "Model-based imputation, Unknown, only contrib & means-tested components"
582 "Model-based imputation, Unknown, mixed components"
591 "Model-based imputation, Not applic/not collected, only contrib & means-tested components"
592 "Model-based imputation, Not applic/not collected, mixed components"
611 "Donor imputation, Net of inc. tax & social contrib, only contrib & means-tested components"
612 "Donor imputation, Net of inc. tax & social contrib, mixed components"
621 "Donor imputation, Net inc. tax at source, only contrib & means-tested components"
622 "Donor imputation, Net inc. tax at source, mixed components"
631 "Donor imputation, Net of social contrib, only contrib & means-tested components"
632 "Donor imputation, Net of social contrib, mixed components"
641 "Donor imputation, Mix of different nets, only contrib & means-tested components"
642 "Donor imputation, Mix of different nets, mixed components"
651 "Donor imputation, Gross, only contributory and means-tested components"
652 "Donor imputation, Gross, mixed components"
661 "Donor imputation, inc. comp not taxed, only contributory and means-tested components"
662 "Donor imputation, inc. comp not taxed, mixed components"
671 "Donor imputation, Mix of net and gross, only contributory and means-tested components"
672 "Donor imputation, Mix of net and gross, mixed components"
681 "Donor imputation, Unknown, only contrib & means-tested components"
682 "Donor imputation, Unknown, mixed components"
691 "Donor imputation, Not applic/not collected, only contributory and means-tested components"
692 "Donor imputation, Not applic/not collected, mixed components"
711 "Not poss. to estab. m. comm. source/method, Net of inc. tax & social contrib, only contrib & means-tested comp"
712 "Not poss. to estab. m. comm. source/method, Net of inc. tax & social contrib, mixed components"
721 "Not poss. to estab. m. comm. source/method, Net inc. tax at source, only contrib & means-tested comp"
722 "Not poss. to estab. m. comm. source/method, Net inc. tax at source, mixed components"
731 "Not poss. to estab. m. comm. source/method, Net of social contrib, only contrib & means-tested components"
732 "Not poss. to estab. m. comm. source/method, Net of social contrib, mixed components"
741 "Not poss. to estab. m. comm. source/method, Mix of different nets, only contrib & means-tested components"
742 "Not poss. to estab. m. comm. source/method, Mix of different nets, mixed components"
751 "Not poss. to estab. m. comm. source/method, Gross, only contrib & means-tested components"
752 "Not poss. to estab. m. comm. source/method, Gross, mixed components"
761 "Not poss. to estab. m. comm. source/method, inc. comp not taxed, only contrib & means-tested components"
762 "Not poss. to estab. m. comm. source/method, inc. comp not taxed, mixed components"
771 "Not poss. to estab. m. comm. source/method, Mix of net and gross, only contrib & means-tested components"
772 "Not poss. to estab. m. comm. source/method, Mix of net and gross, mixed components"
781 "Not poss. to estab. m. comm. source/method, Unknown, only contributory and means-tested components"
782 "Not poss. to estab. m. comm. source/method, Unknown, mixed components"
791 "Not poss. to estab. m. comm. source/method, Not applic/not collected, only contrib & means-tested comp"
792 "Not poss. to estab. m. comm. source/method, Not applic/not collected, mixed components"
;
label define PX020_VALUE_LABELS               
4  "MT: 15-19"
5  "MT: 20-24"
6  "MT: 25-29"
7  "MT: 30-34"
8  "MT: 35-39"
9  "MT: 40-44"
10 "MT: 45-49"
11 "MT: 50-54"
12 "MT: 55-59"
13 "MT: 60-64"
14 "MT: 65-69"
15 "MT: 70-74"
16 "MT: 75-79"
17 "MT: 80 and over"
80 "80 and over"
-1 "Missing"
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
label define PMH010_VALUE_LABELS
  1 "Yes, has been negatively affected"
  2 "Yes, has been positively affected"
  3 "No, has not been affected"
;
label define PMH010_F_VALUE_LABELS
   1 "Filled"
  -1 "Missing"
  -2 "RS: missing"
  -3 "Not applicable (Non-selected respondent (RB245 equal to 3))"
  -7 "Not applicable (HB010 not equal to 2021)"
  -8 "Not applicable (variable not collected)"
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
label define NO_income
0 "No inc."
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
label values PB205 PB205_VALUE_LABELS ;
label values PB205_F PB205_F_VALUE_LABELS ;
label values PB270 PB270_VALUE_LABELS ;
label values PB270_F PB270_F_VALUE_LABELS ;
label values PB230_F PB230_F_VALUE_LABELS ;
label values PB240_F PB240_F_VALUE_LABELS ;
label values PD020 PD030 PD050 PD060 PD070 PD080 PD020_VALUE_LABELS ;
label values PD020_F PD030_F PD050_F PD060_F PD070_F PD080_F PD020_F_VALUE_LABELS ;
label values PW010 PW010_VALUE_LABELS ;
label values PW010_F PW010_F_VALUE_LABELS ;
label values PW191 PW191_VALUE_LABELS ;
label values PW191_F PW191_F_VALUE_LABELS ;
label values PE010 PE010_VALUE_LABELS ;
label values PE010_F PE010_F_VALUE_LABELS ;
label values PE021 PE021_VALUE_LABELS;
label values PE021_F PE021_F_VALUE_LABELS;
label values PE041 PE041_VALUE_LABELS;
label values PE041_F PE041_F_VALUE_LABELS;
label values PL032 PL032_VALUE_LABELS;
label values PL032_F PL032_F_VALUE_LABELS;
label values PL016 PL016_VALUE_LABELS;
label values PL016_F PL016_F_VALUE_LABELS;
label values PL040A PL040A_VALUE_LABELS;
label values PL040A_F PL040A_F_VALUE_LABELS;
label values PL040B PL040B_VALUE_LABELS;
label values PL040B_F PL040B_F_VALUE_LABELS;
label values PL051A PL051A_VALUE_LABELS;
label values PL051A_F PL051A_F_VALUE_LABELS;
label values PL051B PL051B_VALUE_LABELS;
label values PL051B_F PL051B_F_VALUE_LABELS;
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
label values PL060_F PL060_F_VALUE_LABELS ;
label values PL075 PL080 PL085 PL086 PL087 PL075_VALUE_LABELS ;
label values PL073_F PL074_F PL075_F PL076_F PL080_F PL085_F ///
			 PL086_F PL087_F PL088_F PL089_F PL090_F PL073_F_VALUE_LABELS ;
label values PL100_F PL100_F_VALUE_LABELS ;
label values PL111A PL111B PL111A_VALUE_LABELS ;
label values PL111A_F PL111A_F_VALUE_LABELS ;
label values PL111B_F PL111B_F_VALUE_LABELS ;
label values PL141 PL141_VALUE_LABELS ;
label values PL141_F PL141_F_VALUE_LABELS ;
label values PL145 PL145_VALUE_LABELS ;
label values PL145_F PL145_F_VALUE_LABELS ;
label values PL150 PL150_VALUE_LABELS ;
label values PL150_F PL150_F_VALUE_LABELS ;
label values PL200 PL200_VALUE_LABELS ;
label values PL200_F PL200_F_VALUE_LABELS ;
label values PL211A PL211B PL211C PL211D PL211E PL211F PL211G PL211H PL211I ///
             PL211J PL211K PL211L PL211A_VALUE_LABELS ; 
label values PL211A_F PL211B_F PL211C_F PL211D_F PL211E_F PL211F_F PL211G_F ///
             PL211H_F PL211I_F PL211J_F PL211K_F PL211L_F PL211A_F_VALUE_LABELS ;
label values PL271 PL271_VALUE_LABELS;
label values PL271_F PL271_F_VALUE_LABELS;
label values PY010G PY010N PY020G PY020N PY021G PY021N PY030G PY050G PY050N PY080G PY080N PY090G PY090N ///
PY091G PY092G PY093G PY094G PY100G PY100N PY101G PY102G PY103G PY104G PY110G PY110N PY111G PY112G PY113G ///
PY114G PY120G PY120N PY121G PY122G PY123G PY124G PY130G PY130N PY131G PY132G PY133G PY134G PY140G PY140N ///
PY141G PY142G PY143G PY144G PY010G_VALUE_LABELS;
label values PY035G PY035N PY035G_VALUE_LABELS;
label values PY010G_F PY010N_F PY020G_F PY020N_F PY021G_F PY021N_F PY030G_F PY035G_F PY035N_F PY050G_F PY050N_F PY080G_F ///
PY080N_F PY090G_F PY090N_F PY100G_F PY100N_F PY110G_F PY110N_F PY120G_F PY120N_F PY130G_F PY130N_F PY140G_F ///
PY140N_F PY010G_F_VALUE_LABELS;
label values PY091G_F PY101G_F PY111G_F PY121G_F PY131G_F PY141G_F PY091G_F_VALUE_LABELS;
label values PY092G_F PY102G_F PY112G_F PY122G_F PY132G_F PY142G_F PY092G_F_VALUE_LABELS;
label values PY093G_F PY103G_F PY113G_F PY123G_F PY133G_F PY143G_F PY093G_F_VALUE_LABELS;
label values PY094G_F PY104G_F PY114G_F PY124G_F PY134G_F PY144G_F PY094G_F_VALUE_LABELS;
label values PX020 PX020_VALUE_LABELS ;
label values PX040 PX040_VALUE_LABELS ;
label values PX050 PX050_VALUE_LABELS ;
label values PL220 PL220_VALUE_LABELS ;
label values PL220_F PL220_F_VALUE_LABELS ;
label values PH051 PH051_VALUE_LABELS ;
label values PH051_F PH051_F_VALUE_LABELS ;
label values PH071 PH071_VALUE_LABELS ;
label values PH071_F PH071_F_VALUE_LABELS ;
label values PMH010 PMH010_VALUE_LABELS ;
label values PMH010_F PMH010_F_VALUE_LABELS ;

* Ad-hoc Module ;

label data "Personal data file 2021" ;

compress ;
save "`stata_file'", replace ;

log close ;
set more on
#delimit cr



