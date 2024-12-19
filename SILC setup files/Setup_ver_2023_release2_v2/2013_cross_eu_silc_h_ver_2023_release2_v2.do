* 2013_cross_eu_silc_h_ver_2023_release2_v2.do 
*
* STATA Command Syntax File
* Stata 17;
*
* Transforms the EU-SILC CSV-data (as released by Eurostat) into a Stata systemfile
* Update:
* Update of missing value labels
* Including DOI
* 
* EU-SILC Cross 2013 - release 2023-release2 / DOI: 10.2907/EUSILC2004-2022V1
*
* When publishing statistics derived from the EU-SILC UDB, please state as source:
* "EU-SILC <Type> UDB <yyyy> - version of 2023-release2"
*
* Household data file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_l*country_stub*13H.csv
* 
* (c) GESIS 2024-07-08
* 
* PLEASE NOTE
* For Differences between data as described in the guidelines
* and the anonymised user database as well as country specific anonymisation measures see:
* L-2013 DIFFERENCES BETWEEN DATA COLLECTED.doc	
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
* Pforr, Klaus, Johanna Jung and Carl Riemann (2024): 2013_cross_eu_silc_h_ver_2023_release2_v2.do, 1st update.
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

local log_file "$log/eusilc_2013_h_cs" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2020) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2013_h_cs" ;


* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 

tempfile temp ;
save `temp', emptyok ;

foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HR HU IE IS IT LT LU LV MT NL NO PL PT RO RS SE SI SK UK { ;
      cd "$csv_path/`CC'/2013" ;
	   import delimited using "UDB_c`CC'13H.csv", case(upper) asdouble clear ;
	  append using `temp', force ;
save `temp', replace  ;
} ;

* Countries in data file are sorted in alphanumeric order ;

sort HB020 ;

log using "`log_file'", replace text ;


* Definition of variablelabels ;
label variable HB010 "Year of the survey" ;
label variable HB020 "Country alphanumeric" ;
label variable HB030 "Household ID" ;
label variable HB050 "Quarter of household interview" ;
label variable HB050_F "Flag" ;
label variable HB060 "Year of household interview" ;
label variable HB060_F "Flag" ;
label variable HB070 "Person responding to household questionnaire" ;
label variable HB070_F "Flag" ;
label variable HB080 "Person 1 responsible for the accommodation" ;
label variable HB080_F "Flag" ;
label variable HB090 "Person 2 responsible for the accommodation" ;
label variable HB090_F "Flag" ;
label variable HB100 "Number of minutes to complete the household questionnaire" ;
label variable HB100_F "Flag" ;
label variable HY010 "Total household gross income" ;
label variable HY010_F "Flag" ;
label variable HY010_I "Imputation factor" ;
label variable HY020 "Total disposable household income" ;
label variable HY020_F "Flag" ;
label variable HY020_I "Imputation factor" ;
label variable HY022 "Tt disp. Hhld Inc. Bef. social trnsfrs other than old-age and survivors benefits" ;
label variable HY022_F "Flag" ;
label variable HY022_I "Imputation factor" ;
label variable HY023 "Tt disp. Hhld inc. Bef. social trnsfrs including old-age and survivors benefits" ;
label variable HY023_F "Flag" ;
label variable HY023_I "Imputation factor" ;
label variable HY030N "Imputed rent (net)" ; 
label variable HY030N_F "Flag" ;
label variable HY040N "Income from rental of a property or land (net)" ; 
label variable HY040N_F "Flag" ;
label variable HY040N_I "Imputation factor" ;
label variable HY050N "Family/Children-related allowances (net)" ;
label variable HY050N_F "Flag" ;
label variable HY050N_I "Imputation factor" ;
label variable HY060N "Social exclusion not elsewhere classified (net)" ;
label variable HY060N_F "Flag" ; 
label variable HY060N_I "Imputation factor" ;
label variable HY070N "Housing allowances (net)" ;
label variable HY070N_F "Flag" ;
label variable HY070N_I "Imputation factor" ;
label variable HY080N "Regular interhousehold cash received (net)" ;
label variable HY080N_F "Flag" ;
label variable HY080N_I "Imputation factor" ;
label variable HY090N "Interests, dividends, profit from capital investment in uncorp. business (net)" ;
label variable HY090N_F "Flag" ;
label variable HY090N_I "Imputation factor" ;
label variable HY100N "Interest repayment on mortgage (net)" ;
label variable HY100N_F "Flag" ;
label variable HY100N_I "Imputation factor" ;
label variable HY110N "Income received by people aged under 16 (net)" ;
label variable HY110N_F "Flag" ;
label variable HY110N_I "Imputation factor" ;
label variable HY120N "Regular taxes on wealth (net)" ;
label variable HY120N_F "Flag" ;
label variable HY120N_I "Imputation factor" ;
label variable HY130N "Regular interhousehold cash transfer paid" ;
label variable HY130N_F "Flag" ;
label variable HY130N_I "Imputation factor" ;
label variable HY140N "Tax on income and social contribution" ;
label variable HY140N_F "Flag" ;
label variable HY140N_I "Imputation factor" ;
label variable HY145N "Repayments/receipts for tax adjustment (net)" ;
label variable HY145N_F "Flag" ;
label variable HY145N_I "Imputation factor" ;
label variable HY030G "Imputed rent (gross)" ;
label variable HY030G_F "Flag" ;
label variable HY040G "Income from rental of a property or land (gross)" ;
label variable HY040G_F "Flag" ;
label variable HY040G_I "Imputation factor" ;
label variable HY050G "Family/Children-related allowances (gross)" ;
label variable HY050G_F "Flag" ;
label variable HY050G_I "Imputation factor" ;
label variable HY060G "Social exclusion not elsewhere classified (gross)" ;
label variable HY060G_F "Flag" ;
label variable HY060G_I "Imputation factor" ;
label variable HY070G "Housing allowances (gross)" ;
label variable HY070G_F "Flag" ;
label variable HY070G_I "Imputation factor" ;
label variable HY080G "Regular Interhousehold cash transfer received (gross)" ;
label variable HY080G_F "Flag" ;
label variable HY080G_I "Imputation factor" ;
label variable HY090G "Interests, dividends, profit from capital investment in uncorp. business (gross)" ;
label variable HY090G_F "Flag" ;
label variable HY090G_I "Imputation factor" ;
label variable HY100G "Interest repayments on mortgage (gross)" ;
label variable HY100G_F "Flag" ;
label variable HY100G_I "Imputation factor" ;
label variable HY110G "Income received by people aged under 16 (gross)" ;
label variable HY110G_F "Flag" ;
label variable HY110G_I "Imputation factor" ;
label variable HY120G "Regular taxes on wealth (gross)" ;
label variable HY120G_F "Flag" ;
label variable HY120G_I "Imputation factor" ;
label variable HY130G "Regular interhousehold cash transfer paid (gross)" ;
label variable HY130G_F "Flag" ;
label variable HY130G_I "Imputation factor" ;
label variable HY140G "Tax on income and social contributions (gross)" ;
label variable HY140G_F "Flag" ;
label variable HY140G_I "Imputation factor" ;
label variable HS011 "Arrears on mortgage or rent payments" ;
label variable HS011_F "Flag" ;
label variable HS021 "Arrears on utility bills" ;
label variable HS021_F "Flag" ;
label variable HS031 "Arrears on hire purchase instalments or other loan payments" ;
label variable HS031_F "Flag" ;
label variable HS040 "Capacity to afford paying for one week annual holiday away from home" ;
label variable HS040_F "Flag" ;
label variable HS050 "Capacity to afford a meal with meat, chicken, fish (or veg. equiv.) ev. sec. day" ;
label variable HS050_F "Flag" ;
label variable HS060 "Capacity to face unexpected financial expenses" ;
label variable HS060_F "Flag" ;
label variable HS070 "Do you have a telephone (including mobile phone)?" ;
label variable HS070_F "Flag" ;
label variable HS080 "Do you have a colour TV?" ;
label variable HS080_F "Flag" ;
label variable HS090 "Do you have a computer?" ;
label variable HS090_F "Flag" ;
label variable HS100 "Do you have a washing machine?" ;
label variable HS100_F "Flag" ;
label variable HS110 "Do you have a car?" ;
label variable HS110_F "Flag" ;
label variable HS120 "Ability to make ends meet" ;
label variable HS120_F "Flag" ;
label variable HS130 "Lowest monthly income to make end meet" ;
label variable HS130_F "Flag" ;
label variable HS140 "Financial burden of the total housing cost" ;
label variable HS140_F "Flag" ;
label variable HS150 "Financial burden of the repayment of debts from hire purchases or loans" ;
label variable HS150_F "Flag" ;
label variable HH010 "Dwelling type" ;
label variable HH010_F "Flag" ;
label variable HH030 "Number of rooms available to the household" ;
label variable HH030_F "Flag" ;
label variable HH031 "Year of contract or purchasing or installation" ;
label variable HH031_F "Flag" ;
label variable HH040 "Leaking roof, damp walls/floors/foundation, or rot in window frame or floor" ;
label variable HH040_F "Flag" ;
label variable HH050 "Ability to keep home adequately warm" ;
label variable HH050_F "Flag" ;
label variable HH060 "Current rent related to occupied dwelling" ;
label variable HH060_F "Flag" ;
label variable HH061 "Subjective rent" ;
label variable HH061_F "Flag" ;
label variable HH081 "Bath or shower in dwelling" ;
label variable HH081_F "Flag" ;
label variable HH091 "Indoor flushing toilet for sole use of household" ;
label variable HH091_F "Flag" ;
label variable HX040 "Household size (MT: top coding to 6)" ;
label variable HX050 "Equivalised household size" ;
label variable HX090 "Equivalised disposable income" ;
label variable HX010 "Change rate" ;
label variable HY081G "Alimonies received (gross)" ;
label variable HY081G_F "Flag" ;
label variable HY081G_I "Imputation factor" ;
label variable HY081N "Alimonies received (net)" ;
label variable HY081N_F "Flag" ;
label variable HY081N_I "Imputation factor" ;
label variable HY131G "Alimonies paid (gross)" ;
label variable HY131G_F "Flag" ;
label variable HY131G_I "Imputation factor" ;
label variable HY131N "Alimonies paid (net)" ;
label variable HY131N_F "Flag" ;
label variable HY131N_I "Imputation factor" ;
label variable HX120 "Overcrowded household";
label variable HX060 "Household type";
label variable HX070 "Tenure state";
label variable HH070 "Total housing cost" ;
label variable HH070_F "Flag" ;
label variable HH071 "Mortgage principal repayment" ;
label variable HH071_F "Flag" ;
label variable HH021 "Tenure status" ;
label variable HH021_F "Flag" ;
label variable HS160 "Problems with the dwelling: Too dark, not enough light" ;
label variable HS160_F "Flag" ;
label variable HS170 "Noise from neighbours or from the street" ;
label variable HS170_F "Flag" ;
label variable HS180 "Pollution, grime or other environmental problems" ;
label variable HS180_F "Flag" ;
label variable HS190 "Crime violence or vandalism in the area" ;
label variable HS190_F "Flag" ;
label variable HY170G "Value of goods produced for own consumption (gross)" ;
label variable HY170G_F "Flag" ;
label variable HY170G_I "Imputation factor" ;
label variable HY170N "Value of goods produced for own consumption (net)" ;
label variable HY170N_F "Flag" ;
label variable HY170N_I "Imputation factor" ;
label variable HX080 "Poverty indicator" ;
label variable HD080 "Replacing worn-out furniture";
label variable HD080_F "Flag";
label variable HD100 "Some new (not second-hand) clothes";
label variable HD100_F "Flag";
label variable HD110 "Two pairs of properly fitting shoes (incl. a pair of all-weather shoes)";
label variable HD110_F "Flag";
label variable HD120 "Fruit and vegetables once a day (variable part. dffrs frm 2009 module var HD120)";
label variable HD120_F "Flag";
label variable HD140 "One meal with meat,chicken orfish (or vegetarian equivalant) at least once a day";
label variable HD140_F "Flag";
label variable HD150 "Books at home suitable for the age";
label variable HD150_F "Flag";
label variable HD160 "Outdoor leisure equipment (bicycle, roller skates, etc.)";
label variable HD160_F "Flag";
label variable HD170 "Indoor games (educational baby toys, building blcks, board gms, cmptrgms, etc.)";
label variable HD170_F "Flag";
label variable HD180 "Regular leisure activity (swmmng, plyng an instrment, youth organisations, etc.)";
label variable HD180_F "Flag";
label variable HD190 "Celebrations on special occasions (birthdays, name days, religious events, etc.)";
label variable HD190_F "Flag";
label variable HD200 "Invite friends round to play and eat from time to time";
label variable HD200_F "Flag";
label variable HD210 "Participate in school trips and school events that cost money";
label variable HD210_F "Flag";
label variable HD220 "Suitable place to study or do homework";
label variable HD220_F "Flag";
label variable HD240 "Go on holiday away frm hme at lst 1 week/year (Slight chng cmprd to 2009 HD240)";
label variable HD240_F "Flag";


* Definition of category labels ;

label define HB050_VALUE_LABELS       
1 "January, February, March"
2 "April, May, June"
3 "July, August, September"
4 "October, November, December"
;
label define HB050_F_VALUE_LABELS      
 1 "filled"
-1 "missing"
;
label define HB060_F_VALUE_LABELS      
1 "filled"
;
label define HB070_F_VALUE_LABELS      
 1 "filled"
-1 "missing"
;
label define HB080_F_VALUE_LABELS      
 1 "filled"
-1 "missing"
;
label define HB090_F_VALUE_LABELS     
 1 "filled"               
-1 "missing"
-2 "not applicable (no 2nd responsible)"
;
label define HB100_F_VALUE_LABELS      
 1 "filled"
-1 "missing"
;
label define HY010_F_VALUE_LABELS      
 0 "no income"
 1 "data collection:net" 
 2 "data collection:gross" 
 3 "data collection:net and gross"
 4 "data collection:unknown"
-1 "missing"
-5 "not filled: no conversion to gross is done"
; 
label define HY020_F_VALUE_LABELS      
0 "no income"
1 "data collection:net"
2 "data collection:gross"
3 "data collection:net and gross"
4 "data collection:unknown"   
-1 "missing" 
;
label define HY022_F_VALUE_LABELS      
0 "no income"
1 "data collection:net"
2 "data collection:gross"
3 "data collection:net and gross"
4 "data collection:unknown"
-1 "missing"
;
label define HY023_F_VALUE_LABELS      
0 "no income"
1 "data collection:net"
2 "data collection:gross"
3 "data collection:net and gross"
4 "data collection:unknown"
-1 "missing"
;
label define HY030N_F_VALUE_LABELS      
0 "no income"
1 "income(variable is filled)"
-1 "Missing"
-2 "value not defined in data documentation"
-5 "not filled: variable of gross series is filled"
;
label define HY040N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collec. net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collec. & recorded net of tax on social contrib."
41 "collec. gross/recorded net of tax on income & social contrib."
42 "collec. gross/recorded net of tax on income at source"
43 "collec. gross/recorded net of tax on social contrib."
51 "collec. unknown/recorded net of tax on income & social contrib."
52 "collec. unknown/recorded net of tax on income at source"
53 "collec. unknown/recorded net of tax on social contrib."
55 "unknown"
61 "mix(parts of the component collec. according to different ways/deductive imputation)"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY050N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collec. net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collec. & recorded net of tax on social contrib."
41 "collec. gross/recorded net of tax on income & social contrib."
42 "collec. gross/recorded net of tax on income at source"
43 "collec. gross/recorded net of tax on social contrib."
51 "collec. unknown/recorded net of tax on income & social contrib."
52 "collec. unknown/recorded net of tax on income at source"
53 "collec. unknown/recorded net of tax on social contrib."
55 "unknown"
61 "mix(parts of the component collec. according to different ways/deductive imputation)"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY060N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collec. net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collec. & recorded net of tax on social contrib."
41 "collec. gross/recorded net of tax on income & social contrib."
42 "collec. gross/recorded net of tax on income at source"
43 "collec. gross/recorded net of tax on social contrib."
51 "collec. unknown/recorded net of tax on income & social contrib."
52 "collec. unknown/recorded net of tax on income at source"
53 "collec. unknown/recorded net of tax on social contrib."
55 "unknown"
61 "mix(parts of the component collec. according to different ways/deductive imputation)"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY070N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collec. net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collec. & recorded net of tax on social contrib."
41 "collec. gross/recorded net of tax on income & social contrib."
42 "collec. gross/recorded net of tax on income at source"
51 "collec. unknown/recorded net of tax on income & social contrib."
55 "unknown"
61 "mix(parts of the component collec. according to different ways/deductive imputation)"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY080N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collec. net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collec. & recorded net of tax on social contrib."
41 "collec. gross/recorded net of tax on income & social contrib."
42 "collec. gross/recorded net of tax on income at source"
51 "collec. unknown/recorded net of tax on income & social contrib."
55 "unknown"
61 "mix(parts of the component collec. according to different ways/deductive imputation)"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY081N_F_VALUE_LABELS        
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collec. net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collec. & recorded net of tax on social contrib."
41 "collec. gross/recorded net of tax on income & social contrib."
42 "collec. gross/recorded net of tax on income at source"
51 "collec. unknown/recorded net of tax on income & social contrib."
55 "unknown"
61 "mix(parts of the component collec. according to different ways/deductive imputation)"
-1 "missing"
-2 "value not defined in data documentation"
-5 "not filled: variable of gross series is filled"
;
label define HY090N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
13 "collec.net of tax on inc. at source & soc.contrib./recorded net of tax on inc.& soc.contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collec. net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collec. & recorded net of tax on social contrib."
41 "collec. gross/recorded net of tax on income & social contrib."
42 "collec. gross/recorded net of tax on income at source"
43 "collec. gross/recorded net of tax on social contrib."
51 "collec. unknown/recorded net of tax on income & social contrib."
55 "unknown"
61 "mix(parts of the component collec. according to different ways/deductive imputation)"
1 "net of tax on income at source and social contribution"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY100N_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-2 "value not defined in data documentation"
-5 "not filled:variable of the gross series is filled"
;
label define HY110N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
12 "collec. net of tax on income at source & social contrib. recorded net of tax on income at source"
22 "collec. & recorded net of tax on income at source" 
31 "collec. net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collec. & recorded net of tax on social contrib."
41 "collec. gross/recorded net of tax on income & social contrib."
42 "collec. gross/recorded net of tax on income at source"
51 "collec. unknown/recorded net of tax on income & social contrib."
55 "unknown"
61 "mix(parts of the component collec. according to different ways/deductive imputation)"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY120N_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-4 "Amount included in another income component"
-5 "Not filled: variable of the gross series is filled"
;
label define HY130N_F_VALUE_LABELS      
0 "no income"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collec. net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collec. & recorded net of tax on social contrib."
41 "collec. gross/recorded net of tax on income & social contrib."
42 "collec. gross/recorded net of tax on income at source"
51 "collec. unknown/recorded net of tax on income & social contrib."
55 "unknown"
61 "mix(parts of the component collec. according to different ways/deductive imputation)"
-1 "missing"
-5 "not filled: variable of gross series is filled"
;
label define HY131N_F_VALUE_LABELS        
0 "none"
11 "collec. & recorded net of tax on income at source & social contrib."
22 "collec. & recorded net of tax on income at source" 
31 "collec. net of tax on social contrib./recorded net of tax on income & social contrib."
33 "collec. & recorded net of tax on social contrib."
41 "collec. gross/recorded net of tax on income & social contrib."
42 "collec. gross/recorded net of tax on income at source"
51 "collec. unknown/recorded net of tax on income & social contrib."
55 "unknown"
61 "mix(parts of the component collec. according to different ways/deductive imputation)"
-1 "missing"
-2 "value not defined in data documentation"
-5 "not filled: variable of gross series is filled"
;
label define HY140N_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-5 "Not filled: variable of the gross series is filled"
;
label define HY145N_F_VALUE_LABELS      
 0 "no income"
 1 "variable is filled"
-1 "missing"
-5 "Not filled: variable of gross series is filled"
;
label define HY030G_F_VALUE_LABELS      
 0 "no income"
 1 "income (variable is filled)"
-1 "missing"
-2 "value not defined in data documentation"
-5 "not filled:variable of net (...g)gross (...n) series is filled"
;
label define HY040G_F_VALUE_LABELS      
 0 "no income"
 1 "collec.:net of tax on income at source and social contributions"
 2 "collec.:net of tax on income at source"
 3 "collec.:net of tax on social contributions"
 4 "collec.:gross"
 5 "collec.:unknown"
 6 "mix(parts of the component collec. according to different ways"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY050G_F_VALUE_LABELS      
 0 "no income"
 1 "collec.:net of tax on income at source and social contributions"
 2 "collec.:net of tax on income at source"
 3 "collec.:net of tax on social contributions"
 4 "collec.:gross"
 5 "collec.:unknown"
 6 "mix(parts of the component collec. according to different ways"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY060G_F_VALUE_LABELS      
0 "no income"
1 "collec.:net of tax on income at source and social contributions"
2 "collec.:net of tax on income at source"
3 "collec.:net of tax on social contributions"
4 "collec.:gross"
5 "collec.:unknown"
6 "mix(parts of the component collec. according to different ways"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY070G_F_VALUE_LABELS      
0 "no income"
1 "collec.:net of tax on income at source and social contributions"
2 "collec.:net of tax on income at source"
3 "collec.:net of tax on social contributions"
4 "collec.:gross"
5 "collec.:unknown"
6 "mix(parts of the component collec. according to different ways"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY080G_F_VALUE_LABELS      
0 "no income"
1 "collec.:net of tax on income at source and social contributions"
2 "collec.:net of tax on income at source"
3 "collec.:net of tax on social contributions"
4 "collec.:gross"
5 "collec.:unknown"
6 "mix(parts of the component collec. according to different ways"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY081G_F_VALUE_LABELS        
0 "no income"
1 "collec.:net of tax on income at source and social contributions"
2 "collec.:net of tax on income at source"
3 "collec.:net of tax on social contributions"
4 "collec.:gross"
5 "collec.:unknown"
6 "mix(parts of the component collec. according to different ways"
-1 "missing"
-2 "value not defined in data documentation"
-5 "not filled:variable of net series is filled"
;
label define HY090G_F_VALUE_LABELS      
0 "no income"
1 "collec.:net of tax on income at source and social contributions"
2 "collec.:net of tax on income at source"
3 "collec.:net of tax on social contributions"
4 "collec.:gross"
5 "collec.:unknown"
6 "mix(parts of the component collec. according to different ways"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY100G_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-2 "value not defined in data documentation"
-5 "not filled: variable of netgross series is filled"
;
label define HY110G_F_VALUE_LABELS      
0 "no income"
1 "collec.:net of tax on income at source and social contributions"
2 "collec.:net of tax on income at source"
3 "collec.:net of tax on social contributions"
4 "collec.:gross"
5 "collec.:unknown"
6 "mix(parts of the component collec. according to different ways"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY120G_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-4 "amount included in another income component"
-5 "not filled: variable of the net series is filled"
;
label define HY130G_F_VALUE_LABELS      
0 "no income"
1 "collec.:net of tax on income at source and social contributions"
2 "collec.:net of tax on income at source"
3 "collec.:net of tax on social contributions"
4 "collec.:gross"
5 "collec.:unknown"
6 "mix(parts of the component collec. according to different ways"
-1 "missing"
-5 "not filled:variable of net series is filled"
;
label define HY131G_F_VALUE_LABELS        
0 "none"
1 "collec.:net of tax on income at source and social contributions"
2 "collec.:net of tax on income at source"
3 "collec.:net of tax on social contributions"
4 "collec.:gross"
5 "collec.:unknown"
6 "mix(parts of the component collec. according to different ways"
-1 "missing"
-2 "value not defined in data documentation"
-5 "not filled:variable of net series is filled"     
;
label define HY140G_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-5 "not filled: variable of the netgross series is filled"
;
label define HS011_VALUE_LABELS
1 "yes, once"
2 "yes, twice or more"
3 "no"
;
label define HS011_F_VALUE_LABELS
 1 "filled"
-1 "missing"
-2 "not applicable"
-5 "missing value of HS011 because HS010 is still used"
;
label define HS021_VALUE_LABELS
1 "yes, once"
2 "yes, twice or more"
3 "no"
;
label define HS021_F_VALUE_LABELS
1 "filled"
-1 "missing"
-2 "not applicable"
-5 "missing value of HS021 because HS020 is used"
;
label define HS031_VALUE_LABELS
1 "yes, once"
2 "yes, twice or more"
3 "no"
;
label define HS031_F_VALUE_LABELS
 1 "filled"
-1 "missing"
-2 "not applicable"
-5 "missing value of HS031 because HS030 is used"
;
label define HS040_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HS040_F_VALUE_LABELS       
 1 "filled"
-1 "missing"
;
label define HS050_VALUE_LABELS         
1 "yes" 
2 "no"
;
label define HS050_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HS060_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HS060_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HS070_VALUE_LABELS         
1 "yes"
2 "no - cannot afford"
3 "no - other reason"
;
label define HS070_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HS080_VALUE_LABELS         
1 "yes"
2 "no - cannot afford"
3 "no - other reason"
;
label define HS080_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HS090_VALUE_LABELS         
1 "yes"
2 "no - cannot afford"
3 "no - other reason"
;
label define HS090_F_VALUE_LABELS       
 1 "filled" 
-1 "missing"
;
label define HS100_VALUE_LABELS         
1 "yes"
2 "no - cannot afford"
3 "no - other reason"
;
label define HS100_F_VALUE_LABELS       
 1 "filled" 
-1 "missing"
;
label define HS110_VALUE_LABELS         
1 "yes"
2 "no - cannot afford"
3 "no - other reason"
;
label define HS110_F_VALUE_LABELS       
 1 "filled" 
-1 "missing"
;
label define HS120_VALUE_LABELS         
1 "with great difficulty"
2 "with difficulty"
3 "with some difficulty"
4 "fairly easily"
5 "easily"
6 "very easily"
;
label define HS120_F_VALUE_LABELS       
 1 "filled" 
-1 "missing"
;
label define HS130_F_VALUE_LABELS       
 1 "filled"
-1 "missing"
;
label define HS140_VALUE_LABELS         
1 "A heavy burden"
2 "somewhat a burden"
3 "not a burden at all"
;
label define HS140_F_VALUE_LABELS       
1 "filled" 
-1 "missing"
-2 "not applicable (no housing costs)"
;
label define HS150_VALUE_LABELS         
1 "repayment is a heavy burden"
2 "repayment is somewhat a burden"
3 "repayment is not a burden at all"
;
label define HS150_F_VALUE_LABELS      
1 "filled" 
-1 "missing"
-2 "not applicable (no repayment of debts)"
;
label define HH010_VALUE_LABELS         
1 "detached house"
2 "semi-detached house"
3 "apartment or flat in a building with < 10 dwellings"
4 "apartment or flat in a building with >=10 dwellings"
;
label define HH010_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;
label define HH030_VALUE_LABELS         
6 "six or more rooms"
;
label define HH030_F_VALUE_LABELS       
 1 "filled"
-1 "missing"
;
label define HH031_VALUE_LABELS       
 1960 "PT: 1960 and earlier"
;
;label define HH031_F_VALUE_LABELS      
 1 "filled"
-1 "missing"
-2 "n.a."
;
label define HH040_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HH040_F_VALUE_LABELS       
 1 "filled"
-1 "missing"
;
label define HH050_VALUE_LABELS         
1 "yes"
2 "no"
;
label define HH050_F_VALUE_LABELS       
 1 "filled"
-1 "missing"
;
label define HH060_F_VALUE_LABELS       
 1 "filled"
-1 "missing"
-2 "not applicable (HH021 not = 3 or 4)"
;
label define HH061_F_VALUE_LABELS       
 1 "filled"
-1 "missing"
-2 "not applicable (HH021 = 3) or (MS do not use subjective method to calculate imputed rent)"
;
label define HH071_F_VALUE_LABELS       
 1 "filled"
-1 "missing"
-2 "not applicable (HH021 ne 2)"
;
label define HH081_VALUE_LABELS
1 "yes, for sole use of the household"
2 "yes, shared"
3 "no"
;
label define HH081_F_VALUE_LABELS
 1 "filled"
-1 "missing"
-5 "missing value of HH081 because HH080 is still used"
;
label define HH091_VALUE_LABELS
1 "yes, for sole use of the household"
2 "yes, shared"
3 "no"
;
label define HH091_F_VALUE_LABELS
1 "filled"
-1 "missing"
-5 "missing value of HH091 because HH090 is still used"
;

label define HX120_VALUE_LABELS 
0 "not overcrowded"
1 "overcrowded"
;

label define HX060_VALUE_LABELS          
 5 "One person household"
 6 "2 adults, no dependent children, both adults under 65 years"
 7 "2 adults, no dependent children, at least one adult >=65 years"
 8 "Other households without dependent children"
 9 "Single parent household, one or more dependent children"
10 "2 adults, one dependent child"
11 "2 adults, two dependent children"
12 "2 adults, three or more dependent children"
13 "Other households with dependent children"
16 "Other (these household are excluded from Laeken indicators calculation)"
;

label define HX070_VALUE_LABELS                 
1 "when HH021= 1, 2 or 5"
2 "when HH021= 3 or 4"
;

label define HX080_VALUE_LABELS          
0 "when HX090>= at risk of poverty threshold (60% of Median HX090)"
1 "when HX090 < at risk of poverty threshold (60% of Median HX090)"
;
label define HS160_VALUE_LABELS        
1 "yes"
2 "no"
;

label define HS160_F_VALUE_LABELS       
 1 "filled"
-1 "missing"
;

label define HS170_VALUE_LABELS         
1 "yes"
2 "no"
;

label define HS170_F_VALUE_LABELS       
 1 "filled"
-1 "missing"
;

label define HS180_VALUE_LABELS         
1 "yes"
2 "no"
;

label define HS180_F_VALUE_LABELS       
 1 "filled"
-1 "missing"
;

label define HS190_VALUE_LABELS         
1 "yes"
2 "no"
;

label define HS190_F_VALUE_LABELS       
1 "filled"
-1 "missing"
;

label define HY170G_F_VALUE_LABELS      
0 "no income"
1 "collec.:net of tax on income at source and social contributions"
2 "collec.:net of tax on income at source"
3 "collec.:net of tax on social contributions"
4 "collec.:gross"
5 "collec.:unknown"
6 "mix (parts of the component collec. according to different ways)"
-1 "missing"
-4 "amount included in another income component"
-5 "not filled: variable of the net series is filled"
;
label define HY170N_F_VALUE_LABELS      
0 "no income"
1  "collec. net of tax on income at source & social contrib."
11 "collec. & recorded net of tax on income at source & social contrib."
12 "collec.net of tax on income at source and social contributions/recorded net of tax on income at source"
22 "collec. & recorded net of tax on income at source" 
31 "collec. net of tax on social contrib.recorded net of tax on income & social contrib."
32 "collec.net of tax on social contributions/recorded net of tax on income at source."
33 "collec. & recorded net of tax on social contrib."
41 "collec. gross/recorded net of tax on income & social contrib."
42 "collec. gross/recorded net of tax on income at source"
43 "collec. gross/recorded net of tax on social contrib."
51 "collec. unknown/recorded net of tax on income & social contrib."
55 "unknown"
61 "mix(parts of the component collec. according to different ways/deductive imputation)"
-1 "missing"
-4 "Amount included in another income component"
-5 "not filled: variable of gross series is filled"
;
label define HH021_VALUE_LABELS         
1 "Outright owner"
2 "Owner paying mortgage"
3 "Tenant/subtenant paying rent at prevailing or market rate"
4 "Accommodation is rented at a reduced rate (lower price that the market price)"
5 "Accommodation is provided free"
;
label define HH021_F_VALUE_LABELS         
 1 "filled"
-1 "missing"
-5 "mv of HH021 because HH021 is still used"
;
label define HH070_F_VALUE_LABELS       
 1 "filled"
-1 "missing"
;
label define HD080_VALUE_LABELS
 1 "Yes"
 2 "No - household cannot afford it"
 3 "No - other reason"
;
label define HD080_F_VALUE_LABELS
  1 "filled"
 -1 "missing"
 -2 "not applicable (no children aged between 1 and 15)"
 -5 "Not collected"
;
label define HD210_F_VALUE_LABELS
 1 "Filled"
-1 "Missing"
-2 "Not applicable (no children aged between 1 and 15)"
-4 "Not applicable (no children attending school)"
-5 "Not collected"
;


* Attachement of category labels to variable ;

label values HB050 HB050_VALUE_LABELS ;
label values HB050_F HB050_F_VALUE_LABELS ;
label values HB060_F HB060_F_VALUE_LABELS ;
label values HB070_F HB070_F_VALUE_LABELS ;
label values HB080_F HB080_F_VALUE_LABELS ;
label values HB090_F HB090_F_VALUE_LABELS ;
label values HB100_F HB100_F_VALUE_LABELS ;
label values HY010_F HY010_F_VALUE_LABELS ;
label values HY020_F HY020_F_VALUE_LABELS ;
label values HY022_F HY022_F_VALUE_LABELS ;
label values HY023_F HY023_F_VALUE_LABELS ;
label values HY030N_F HY030N_F_VALUE_LABELS ;
label values HY040N_F HY040N_F_VALUE_LABELS ;
label values HY050N_F HY050N_F_VALUE_LABELS ;
label values HY060N_F HY060N_F_VALUE_LABELS ;
label values HY070N_F HY070N_F_VALUE_LABELS ;
label values HY080N_F HY080N_F_VALUE_LABELS ;
label values HY081N_F HY081N_F_VALUE_LABELS ;
label values HY090N_F HY090N_F_VALUE_LABELS ;
label values HY100N_F HY100N_F_VALUE_LABELS ;
label values HY110N_F HY110N_F_VALUE_LABELS ;
label values HY120N_F HY120N_F_VALUE_LABELS ;
label values HY130N_F HY130N_F_VALUE_LABELS ;
label values HY131N_F HY131N_F_VALUE_LABELS ;
label values HY140N_F HY140N_F_VALUE_LABELS ;
label values HY145N_F HY145N_F_VALUE_LABELS ;
label values HY030G_F HY030G_F_VALUE_LABELS ;
label values HY040G_F HY040G_F_VALUE_LABELS ;
label values HY050G_F HY050G_F_VALUE_LABELS ;
label values HY060G_F HY060G_F_VALUE_LABELS ;
label values HY070G_F HY070G_F_VALUE_LABELS ;
label values HY080G_F HY080G_F_VALUE_LABELS ;
label values HY081G_F HY081G_F_VALUE_LABELS ; 
label values HY090G_F HY090G_F_VALUE_LABELS ;
label values HY100G_F HY100G_F_VALUE_LABELS ;
label values HY110G_F HY110G_F_VALUE_LABELS ;
label values HY120G_F HY120G_F_VALUE_LABELS ;
label values HY130G_F HY130G_F_VALUE_LABELS ;
label values HY131G_F HY131G_F_VALUE_LABELS ;
label values HY140G_F HY140G_F_VALUE_LABELS ;
label values HS011 HS011_VALUE_LABELS ;
label values HS011_F HS011_F_VALUE_LABELS ;
label values HS021 HS021_VALUE_LABELS ;
label values HS021_F HS021_F_VALUE_LABELS ;
label values HS031 HS031_VALUE_LABELS ;
label values HS031_F HS031_F_VALUE_LABELS ;
label values HS040 HS040_VALUE_LABELS ;
label values HS040_F HS040_F_VALUE_LABELS ;
label values HS050 HS050_VALUE_LABELS ;
label values HS050_F HS050_F_VALUE_LABELS ;
label values HS060 HS060_VALUE_LABELS ;
label values HS060_F HS060_F_VALUE_LABELS ;
label values HS070 HS070_VALUE_LABELS ;
label values HS070_F HS070_F_VALUE_LABELS ;
label values HS080 HS080_VALUE_LABELS ;
label values HS080_F HS080_F_VALUE_LABELS ;
label values HS090 HS090_VALUE_LABELS ;
label values HS090_F HS090_F_VALUE_LABELS ;
label values HS100 HS100_VALUE_LABELS ;
label values HS100_F HS100_F_VALUE_LABELS ;
label values HS110 HS110_VALUE_LABELS ;
label values HS110_F HS110_F_VALUE_LABELS ;
label values HS120 HS120_VALUE_LABELS ;
label values HS120_F HS120_F_VALUE_LABELS ;
label values HS130_F HS130_F_VALUE_LABELS ;
label values HS140 HS140_VALUE_LABELS ;
label values HS140_F HS140_F_VALUE_LABELS ;
label values HS150 HS150_VALUE_LABELS ;
label values HS150_F HS150_F_VALUE_LABELS ;
label values HH010 HH010_VALUE_LABELS ;
label values HH010_F HH010_F_VALUE_LABELS ;
label values HH030 HH030_VALUE_LABELS ;
label values HH030_F HH030_F_VALUE_LABELS ;
label values HH031 HH031_VALUE_LABELS ;
label values HH031_F HH031_F_VALUE_LABELS ;
label values HH040  HH040_VALUE_LABELS ;
label values HH040_F HH040_F_VALUE_LABELS ;
label values HH050 HH050_VALUE_LABELS ;
label values HH050_F HH050_F_VALUE_LABELS ;
label values HH060_F HH060_F_VALUE_LABELS ;
label values HH061_F HH061_F_VALUE_LABELS ;
label values HH071_F HH071_F_VALUE_LABELS ;
label values HH081 HH081_VALUE_LABELS ;
label values HH081_F HH081_F_VALUE_LABELS ;
label values HH091 HH091_VALUE_LABELS ;
label values HH091_F HH091_F_VALUE_LABELS ;
label values HX060 HX060_VALUE_LABELS ;
label values HX070 HX070_VALUE_LABELS ;
label values HX080 HX080_VALUE_LABELS ;
label values HX120 HX120_VALUE_LABELS ;
label values HH070_F HH070_F_VALUE_LABELS ;
label values HH021 HH021_VALUE_LABELS ;
label values HH021_F HH021_F_VALUE_LABELS ;
label values HS160 HS160_VALUE_LABELS ;
label values HS160_F HS160_F_VALUE_LABELS ;
label values HS170 HS170_VALUE_LABELS ;
label values HS170_F HS170_F_VALUE_LABELS ;
label values HS180 HS180_VALUE_LABELS ;
label values HS180_F HS180_F_VALUE_LABELS ;
label values HS190 HS190_VALUE_LABELS ;
label values HS190_F HS190_F_VALUE_LABELS ;
label values HY170N_F HY170N_F_VALUE_LABELS ;
label values HY170G_F HY170G_F_VALUE_LABELS ;
label values HD080 HD100 HD110 HD120 HD140 HD150 HD160 HD170 HD180 HD190 HD200 HD210 HD220 HD240 HD080_VALUE_LABELS;
label values HD080_F  HD110_F HD100_F HD120_F HD140_F HD150_F HD160_F HD170_F HD180_F HD190_F HD200_F  HD240_F HD080_F_VALUE_LABELS;
label values HD210_F HD220_F HD210_F_VALUE_LABELS;

label data "Household data file 2013" ;

compress ;
save "`stata_file'", replace ;


log close ;
set more on
#delimit cr



