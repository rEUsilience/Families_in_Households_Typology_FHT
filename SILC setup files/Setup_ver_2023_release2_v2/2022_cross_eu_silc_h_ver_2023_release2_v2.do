* 2022_cross_eu_silc_h_ver_2023_release2_v2.do 
*
* STATA Command Syntax File
* Stata 17.0;
*
* Transforms the EU-SILC CSV-data (as released by Eurostat) into a Stata systemfile
* Update:
* Update of missing value labels
* Including DOI
* 
* EU-SILC Cross 2022 - release 2023_release2 / DOI: 10.2907/EUSILC2004-2022V1
*
* When publishing statistics derived from the EU-SILC UDB, please state as source:
* "EU-SILC <Type> UDB <yyyy> - version of 2023_release2"
*
* Household data file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_c*country_stub*22H.csv
* 
* (c) GESIS 2024-07-08
*
* PLEASE NOTE
* For Differences between data as described in the guidelines
* and the anonymised user database as well as country specific anonymisation measures see:
* C-2022 DIFFERENCES BETWEEN DATA COLLECTED.doc	
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
* Pforr, Klaus, Johanna Jung and Carl Riemann (2024): 2022_cross_eu_silc_h_ver_2023_release2_v2.do, 1st update.
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

local log_file "$log/eusilc_2022_h" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2020) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2022_h_cs" ;

* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 

tempfile temp ;
save `temp', emptyok ;
foreach CC in AT BE BG /*CH*/ CY CZ DE DK EE EL ES FI FR HR HU IE /*IS*/ IT LT LU LV MT NL /*NO*/ PL PT RO /*RS*/ SE SI SK /*UK*/ { ;
      cd "$csv_path/`CC'/2022" ;
	  import delimited using "UDB_c`CC'22H.csv", case(upper) asdouble clear stringcols(2);
	  * In some countries non-numeric characters are wrongfully included.
		* This command prevents errors in the format. ;
append using `temp' , force ;
save `temp', replace  ;
} ;

* Countries in data file are sorted in alphanumeric order ;
sort HB020 ;

log using "`log_file'", replace text ;


* Definition of variable labels ;
label variable HB010 "Year of the survey" ;
label variable HB020 "Country alphanumeric" ;
label variable HB030 "Household ID" ;
label variable HB050 "Quarter of household interview" ;
label variable HB050_F "Flag" ;
label variable HB060 "Year of household interview" ;
label variable HB060_F "Flag" ;
label variable HB070 "Person responding to household questionnaire" ;
label variable HB070_F "Flag" ;
label variable HB100 "Number of minutes to complete the household questionnaire" ; 
label variable HB100_F "Flag" ;
label variable  HB110 "Household type (IT: removed)" ;
label variable  HB110_F "Flag" ;
label variable  HB120 "Household size (DE: deleted 7 or more, MT: top-coded 6=6+)" ;
label variable  HB120_F "Flag" ;
label variable  HB130 "Interview mode used (household)" ;
label variable  HB130_F "Flag" ;
label variable HD080   "Replacing worn-out furniture";
label variable HD080_F "Flag";
label variable HH010 "Dwelling type (5 coded as missing)" ;
label variable HH010_F "Flag" ;
label variable HH021   "Tenure status" ;
label variable HH021_F "Flag" ;
label variable HH030 "Number of rooms available to the household" ;
label variable HH030_F "Flag" ;
label variable HH050 "Ability to keep home adequately warm" ;
label variable HH050_F "Flag" ;
label variable HH060 "Current rent related to occupied dwelling (MT: Top & bottom coding)" ;
label variable HH060_F "Flag" ;
label variable HH070 "Total housing cost (MT: Top & bottom coding)" ;
label variable HH070_F "Flag" ;
label variable HH071 "Mortgage principal repayment (MT: Top & bottom coding)" ;
label variable HH071_F "Flag" ;
label variable HS011 "Arrears on mortgage or rent payments" ;
label variable HS011_F "Flag" ;
label variable HS021 "Arrears on utility bills" ;
label variable HS021_F "Flag" ;
label variable HS022   "Reduced utility costs" ;
label variable HS022_F "Flag" ;
label variable HS031 "Arrears on hire purchase installments or other loan payments" ;
label variable HS031_F "Flag" ;
label variable HS040 "Capacity to afford paying for one week annual holiday away from home" ;
label variable HS040_F "Flag" ;
label variable HS050 "Capacity to afford a meal with meat, chicken, fish (or veg. equiv.) ev. sec. day" ;
label variable HS050_F "Flag" ;
label variable HS060 "Capacity to face unexpected financial expenses" ;
label variable HS060_F "Flag" ;
label variable HS090 "Do you have a computer?" ;
label variable HS090_F "Flag" ;
label variable HS110 "Do you have a car?" ;
label variable HS110_F "Flag" ;
label variable HS120 "Ability to make ends meet" ;
label variable HS120_F "Flag" ;
label variable HS150 "Financial burden of the repayment of debts from hire purchases or loans" ;
label variable HS150_F "Flag" ;
label variable HS200 "Financial burden of medical care (excluding medicines)" ;
label variable HS200_F "Flag" ;
label variable HS210 "Financial burden of dental care" ;
label variable HS210_F "Flag" ;
label variable HS220 "Financial burden of medicines" ;
label variable HS220_F "Flag" ;
* For HY010, HY020, HY022, HY023: Please see Differences Collection vs UDB for more information ;
label variable HY010 "Total household gross inc. (DE, EE, MT, SI, UK: Adjustments; MT: T & b cod)" ; 
label variable HY010_F "Flag" ;
label variable HY010_IF "Imputation factor" ;
label variable HY020 "Total disposable hh inc. (DE,EE,MT,SI,UK: Adj; MT: T&b cod, FR,IE: rounded)" ; 
label variable HY020_F "Flag" ;
label variable HY020_IF "Imputation factor" ;
label variable HY022 "Tt dsp hh inc bf soc trnfs ex o-age & srvvrs ben (DE,EE,FR,IE,MT,SI,UK:modified)" ; 
label variable HY022_F "Flag" ;
label variable HY022_IF "Imputation factor" ;
label variable HY023 "Tt dsp hh inc bf soc trnfs ic o-age & srvvrs ben (DE,EE,FR,IE,MT,SI,UK:modified)" ; 
label variable HY023_F "Flag" ;
label variable HY023_IF "Imputation factor" ;
label variable HY040G "inc. from rental of a property or land (gross, DE,FR,IE,MT,SI: modified)" ;
label variable HY040G_F "Flag" ;
label variable HY040G_IF "Imputation factor" ;
label variable HY050G  "Family/Children related allowances (gross; SI: Top cod; MT: Top & bottom cod)" ;
label variable HY050G_F "Flag" ;
label variable HY050G_IF "Imputation factor" ;
label variable HY051G  "Family/children-related allowances (contributory and means-tested)";
label variable HY051G_F "Flag";
label variable HY051G_IF "Imputation factor" ;
label variable HY052G "Family/children-related allowances (contributory & n. means-tstd, MT: T & b cod)";
label variable HY052G_F "Flag";
label variable HY052G_IF "Imputation factor" ;
label variable HY053G  "Family/children-related allow. (non-contributory & means-tested, MT: T & b cod)";
label variable HY053G_F "Flag";
label variable HY053G_IF "Imputation factor" ;
label variable HY054G "Family/children-related allowance (non-cntrbtry & n. means-tstd, MT: T & b cod)";
label variable HY054G_F "Flag";
label variable HY054G_IF "Imputation factor" ;
label variable HY060G  "Social exclusion not elsewhere classified (gross; SI: Top coding; MT: T & b cod)" ;
label variable HY060G_F "Flag" ;
label variable HY060G_IF "Imputation factor" ;
label variable HY061G "Social exclusion not elsewhere classified (contributory and means-tested)";
label variable HY061G_F "Flag";
label variable HY061G_IF "Imputation factor" ;
label variable HY062G  "Social exclusion not elsewhere classified (contributory and non means-tested)";
label variable HY062G_F "Flag";
label variable HY062G_IF "Imputation factor" ;
label variable HY063G  "Social exclusion not elsewhere class. (non-cntrbtry & means-tstd, MT: T & b cod)";
label variable HY063G_F "Flag";
label variable HY063G_IF "Imputation factor" ;
label variable HY064G  "Social exclusion not elsewhere classified (non-contributory & non means-tested)";
label variable HY064G_F "Flag";
label variable HY064G_IF "Imputation factor" ;
label variable HY070G "Housing allowances (gross; SI: Top coding; MT: Top & bottom coding)" ;
label variable HY070G_F "Flag" ;
label variable HY070G_IF "Imputation factor" ;
label variable HY071G  "Housing allowances (contributory and means-tested)";
label variable HY071G_F "Flag";
label variable HY071G_IF "Imputation factor" ;
label variable HY072G  "Housing allowances (contributory and non means-tested)";
label variable HY072G_F "Flag";
label variable HY072G_IF "Imputation factor" ;
label variable HY073G  "Housing allowances (non-contributory and means-tested, MT: T & b cod)";
label variable HY073G_F "Flag";
label variable HY073G_IF "Imputation factor" ;
label variable HY074G  "Housing allowances (non-contributory and non means-tested, MT: T & b cod)";
label variable HY074G_F "Flag";
label variable HY074G_IF "Imputation factor" ;
label variable HY080G "Regular interhousehold cash transfer received (gross; FR,IE,MT,SI:modified)" ;
label variable HY080G_F "Flag" ;
label variable HY080G_IF "Imputation factor" ;
label variable HY081G "Alimonies received (gross; SI: Top coding; MT: Top & bottom cod, FR,IE: rounded)" ;
label variable HY081G_F "Flag" ;
label variable HY081G_IF "Imputation factor" ;
label variable HY090G "Intrsts, dvdnds, prft fr cptl invmnt in uncrpbsn (DE,FR,IE,MT,SI,UK: modified)"  ;
label variable HY090G_F "Flag" ;
label variable HY090G_IF "Imputation factor" ;
label variable HY100G "Interest repayments on mortgage (gross, MT: Top & bottom coding)" ;
label variable HY100G_F "Flag" ;
label variable HY100G_IF "Imputation factor" ;
label variable HY110G "inc. received by people aged under 16 (gross; SI: Top coding, MT: T & b cod)" ;
label variable HY110G_F "Flag" ;
label variable HY110G_IF "Imputation factor" ;
label variable HY120G "Regular taxes on wealth (gross; SI, UK: Top coding, EE: Adj)" ;
label variable HY120G_F "Flag" ;
label variable HY120G_IF "Imputation factor" ;
label variable HY130G "Regular interhousehold cash transfer paid (gross; FR,IE,MT,SI: modified)" ;
label variable HY130G_F "Flag" ;
label variable HY130G_IF "Imputation factor" ;
label variable HY131G   "Alimonies paid (gross; SI: Top coding, MT: Top & bottom coding, FR,IE: rounded)" ;
label variable HY131G_F "Flag" ;
label variable HY131G_IF "Imputation factor" ;
label variable HY140G "Tax on inc and soc contributions (gross; UK: T cod; DE, MT: T & b cod; EE: Adj)" ;
label variable HY140G_F "Flag" ;
label variable HY140G_IF "Imputation factor" ;
label variable HY170G  "Value of goods produced for own consumption (gross)" ;
label variable HY170G_F "Flag" ;
label variable HY170G_IF "Imputation factor" ;
label variable HY121G "Taxes paid on ownership of household main dwelling";
label variable HY121G_F "Flag";
label variable HY121G_IF "Imputation factor" ;
label variable HY040N "inc. from rental of a property or land (net; DE SI: Top cod, FR,IE: rounded)" ; 
label variable HY040N_F "Flag" ;
label variable HY040N_IF "Imputation factor" ;
label variable HY050N "Family/Children related allowances (net; SI: Top coding)" ;
label variable HY050N_F "Flag" ;
label variable HY050N_IF "Imputation factor" ;
label variable HY060N "Social exclusion not elsewhere classified (net; SI: Top coding)" ;
label variable HY060N_F "Flag" ; 
label variable HY060N_IF "Imputation factor" ;
label variable HY070N "Housing allowances (net; SI: Top coding)" ;
label variable HY070N_F "Flag" ;
label variable HY070N_IF "Imputation factor" ;
label variable HY080N "Regular interhousehold cash received (net; SI: Top coding, FR,IE: rounded)" ;
label variable HY080N_F "Flag" ;
label variable HY080N_IF "Imputation factor" ;
label variable HY081N "Alimonies received (net; SI: Top coding, FR,IE: rounded)" ;
label variable HY081N_F "Flag" ;
label variable HY081N_IF "Imputation factor" ;
label variable HY090N "Intrsts, dvdnds, prft fr cptl invmnt in uncp bsn (DE,FR,IE,MT,SI,UK: modified)" ;
label variable HY090N_F "Flag" ;
label variable HY090N_IF "Imputation factor" ;
label variable HY100N "Interest repayment on mortgage (net)" ;
label variable HY100N_F "Flag" ;
label variable HY100N_IF "Imputation factor" ;
label variable HY110N "inc. received by people aged under 16 (net; SI: Top coding)" ;
label variable HY110N_F "Flag" ;
label variable HY110N_IF "Imputation factor" ;
label variable HY120N "Regular taxes on wealth (net; SI: Top coding)" ;
label variable HY120N_F "Flag" ;
label variable HY120N_IF "Imputation factor" ;
label variable HY130N "Regular inter-household cash transfer paid (net; SI: Top coding, FR,IE: rounded)" ;
label variable HY130N_F "Flag" ;
label variable HY130N_IF "Imputation factor" ;
label variable HY131N   "Alimonies paid (net; SI: Top coding, FR,IE: rounded)" ;
label variable HY131N_F "Flag" ;
label variable HY131N_IF "Imputation factor" ;
label variable HY140N "Tax on inc. and social contribution (net; DE: Top & bottom coding; MT: Adj)" ;
label variable HY140N_F "Flag" ;
label variable HY140N_IF "Imputation factor" ;
label variable HY145N "Repayments or receipts for tax adjustment (net; SI: Top & bot cod, FR,IE: round)" ;
label variable HY145N_F "Flag" ;
label variable HY145N_IF "Imputation factor" ;
label variable HY170N   "Value of goods produced for own consumption (net)" ;
label variable HY170N_F "Flag" ;
label variable HY170N_IF "Imputation factor" ;
label variable HY121N "Taxes paid on ownership of household main dwelling";
label variable HY121N_F "Flag";
label variable HY121N_IF "Imputation factor" ;
label variable HX010 "Change rate" ;
label variable HX040 "Household size (MT: Top coded to '6'; DE: deleted 7 or more)" ;
label variable HX050 "Equivalised household size (MT: Top & bottom coding)" ;
label variable HX060 "Household type";
label variable HX070 "Tenure state";
label variable HX080 "Poverty indicator" ;
label variable HX090 "Equivalised disposable inc. (MT: Top & bottom coding)" ;
label variable HX120 "Overcrowded household";

label variable HY150_1 "Financial Support from Covid-19 related support Schemes during 2020 (Optional)" ;
label variable HY150_2 "Financial Support from Covid-19 related support Schemes during 2020 (Optional)" ;
label variable HY150_3 "Financial Support from Covid-19 related support Schemes during 2020 (Optional)" ;
label variable HY150_4 "Financial Support from Covid-19 related support Schemes during 2020 (Optional)" ;
label variable HY150_1_F "Flag" ;
label variable HY150_2_F "Flag" ;
label variable HY150_3_F "Flag" ;
label variable HY150_4_F "Flag" ;
label variable HY155G_1 "Amount received from the Covid-19 related support Schemes during 2020 (Optional)" ;
label variable HY155G_2 "Amount received from the Covid-19 related support Schemes during 2020 (Optional)" ;
label variable HY155G_3 "Amount received from the Covid-19 related support Schemes during 2020 (Optional)" ;
label variable HY155G_4 "Amount received from the Covid-19 related support Schemes during 2020 (Optional)" ;
label variable HY155G_1_F "Flag" ;
label variable HY155G_2_F "Flag" ;
label variable HY155G_3_F "Flag" ;
label variable HY155G_4_F "Flag" ;
label variable HY155G_1_IF "Imputation factor" ;
label variable HY155G_2_IF "Imputation factor" ;
label variable HY155G_3_IF "Imputation factor" ;
label variable HY155G_4_IF "Imputation factor" ;

* Module on inc. change (optional COVID-19 related Variables) ;
label variable HI010 "Change in the household inc. compared to previous year" ;
label variable HI010_F "Flag" ;
label variable HI012 "Change in inc. as an outcome of Covid-19 (Optional)" ;
label variable HI012_F "Flag" ;
label variable HI020 "Reason for increase in inc." ;
label variable HI020_F "Flag" ;
label variable HI030 "Reason for decrease in inc." ;
label variable HI030_F "Flag" ;
label variable HI040 "Expectation of the Household inc. in the next 12 Months" ;
label variable HI040_F "Flag" ;

label variable HD225 "Distance learning courses/school during Covid-19 restrictions (Optional)" ;
label variable HD225_F "Flag" ;

label variable HI130G "Interest expenses (not incl. Interest exp. for purch. main dwelling)(Optional)" ;
label variable HI130G_F "Flag" ;
label variable HI130G_IF "Imputation factor" ;
label variable HI140G "Household debts (Optional)" ;
label variable HI140G_F "Flag" ;
label variable HI140G_IF "Imputation factor" ;


* Definition of category labels ;

label define HB050_VALUE_LABELS       
1 "January, February, March"
2 "April, May, June"
3 "July, August, September"
4 "October, November, December"
;
label define HB050_F_VALUE_LABELS      
 1 "Filled"
-1 "Missing"
;
label define HB060_F_VALUE_LABELS      
1 "Filled"
;
label define HB070_F_VALUE_LABELS      
 1 "Filled"
-1 "Missing"
;
label define HB100_F_VALUE_LABELS      
 1 "Filled"
-1 "Missing"
;
label define HB110_VALUE_LABELS
 1 "One-person household"
 2 "Lone parent with at least one child aged less than 25"
 3 "Lone parent with all children aged 25 or more"
 4 "Couple without any child(ren)"
 5 "Couple with at least one child aged less than 25"
 6 "Couple with all children aged 25 or more"
 7 "Other type of household"
;
label define HB110_F_VALUE_LABELS 
 1 "Filled"
-1 "Missing"
-7 "Not applicable (HB010 < 2021)"
;
label define HB120_F_VALUE_LABELS 
 1 "Filled"
-7 "Not applicable (HB010 < 2021)"
;
label define HB130_VALUE_LABELS 
1 "Paper assisted personal interview (PAPI)"
2 "Computer assisted personal interview (CAPI)"
3 "Computer assisted telephone interview (CATI)"
4 "Computer assisted web-interview (CAWI)"
5 "Other"
;
label define HB130_F_VALUE_LABELS
 1 "Filled"
-1 "Missing"
-7 "Not applicable (HB010 < 2021)"
;
label define HD080_VALUE_LABELS
 1 "Yes"
 2 "No - cannot afford"
 3 "No - other reason"
;
label define HD080_F_VALUE_LABELS
  1 "Filled"
 -1 "Missing"
;
label define HD225_VALUE_LABELS
  1 "Yes"
  2 "No, no internet connection/internet connection is not sufficient"
  3 "No, no sufficient computers/mobile devices"
  4 "No, no online courses available/not sufficient extend"
  5 "No, other reasons"
;
label define HD225_F_VALUE_LABELS
   1 "Filled"
  -1 "Missing"
  -2 "Not applicable (no children attending school)"
  -4 "Not applicable (no children aged between 5 to 15)"
  -5 "Not applicable (not restrictions)"
  -7 "Not applicable (HB010 not = 2021)"
  -8 "Not applicable (variable not collected)"
;
label define HH010_VALUE_LABELS         
1 "Detached house"
2 "Semi-detached house"
3 "Apartment or flat in a building with < 10 dwellings"
4 "Apartment or flat in a building with >=10 dwellings"
;
label define HH010_F_VALUE_LABELS       
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
;
label define HH021_VALUE_LABELS         
1 "Owner without outstanding mortgage (HB010>=2010), Owner (HB010<2010)"
2 "Owner with outstanding mortgage (HB010>=2010), Tenant or subtenant paying rent at prevailing or market rate (HB010<2010)"
3 "Tenant, rent at market price (HB010>=2010), Accomm rented at reduced rate (HB010<2010)"
4 "Tenant, rent at reduced price (HB010>=2010), Accommodation is provided free (HB010<2010)"
5 "Tenant, rent free"
;
label define HH021_F_VALUE_LABELS         
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
;
label define HH030_VALUE_LABELS         
2 "MT: 2 or less"
6 "6 or more rooms"
;
label define HH030_F_VALUE_LABELS       
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
;
label define HH050_VALUE_LABELS         
1 "Yes"
2 "No"
;
label define HH050_F_VALUE_LABELS       
 1 "Filled"
-1 "Missing"
;
label define HH060_F_VALUE_LABELS       
1 "Collected via survey/interview (HB010>=2021), Filled (2012<=HB010<2021)"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (HH021 not equal 3 or 4) (HB021>=2012), (HH020 not equal 2 or 3) (HB010<2012)"
;
label define HH070_F_VALUE_LABELS       
1 "Collected via survey/interview"
2 "Collected from administrative data"
3 "Imputed"
4 "Not possible to establish a source"
-1 "Missing"
;
label define HH071_F_VALUE_LABELS       
 1 "Filled"
-1 "Missing"
-2 "Not applicable (HH021 not equal 2)"
;
label define HS011_VALUE_LABELS
1 "Yes, once"
2 "Yes, twice or more"
3 "No"
;
label define HS011_F_VALUE_LABELS
 1 "Filled"
-1 "Missing"
-2 "Not applicable (HH021 equal to 1 or 5)"
;
label define HS021_VALUE_LABELS
1 "Yes, once"
2 "Yes, twice or more"
3 "No"
;
label define HS021_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "Not applicable (no utility bills)"
;
label define HS022_VALUE_LABELS
1 "Yes"
2 "No"
;
label define HS022_F_VALUE_LABELS
 1 "Collected via survey/interview"
 2 "Collected from administrative data"
 3 "Imputed"
 4 "Not possible to establish a source"
-1 "Missing"
-2 "Not applicable (this does not exist in the country)"
-7 "Not applicable (HB010 < 2021)"
;
label define HS031_VALUE_LABELS
1 "Yes, once"
2 "Yes, twice or more"
3 "No"
;
label define HS031_F_VALUE_LABELS
 1 "Filled"
-1 "Missing"
-2 "Not applicable (no hire purchase instalments & no other loan payments)"
;
label define HS040_VALUE_LABELS         
1 "Yes"
2 "No"
;
label define HS040_F_VALUE_LABELS       
 1 "Filled"
-1 "Missing"
;
label define HS050_VALUE_LABELS         
1 "Yes" 
2 "No"
;
label define HS050_F_VALUE_LABELS       
1 "Filled"
-1 "Missing"
;
label define HS060_VALUE_LABELS         
1 "Yes"
2 "No"
;
label define HS060_F_VALUE_LABELS       
1 "Filled"
-1 "Missing"
;
label define HS090_VALUE_LABELS         
1 "Yes"
2 "No - cannot afford"
3 "No - other reason"
;
label define HS090_F_VALUE_LABELS       
 1 "Filled" 
-1 "Missing"
;
label define HS110_VALUE_LABELS         
1 "Yes"
2 "No - cannot afford"
3 "No - other reason"
;
label define HS110_F_VALUE_LABELS       
 1 "Filled" 
-1 "Missing"
;
label define HS120_VALUE_LABELS         
1 "With great difficulty"
2 "With difficulty"
3 "With some difficulty"
4 "Fairly easily"
5 "Easily"
6 "Very easily"
;
label define HS120_F_VALUE_LABELS       
 1 "Filled" 
-1 "Missing"
;
label define HS150_VALUE_LABELS         
1 "Repayment is a heavy burden"
2 "Repayment is somewhat a burden"
3 "Repayment is not a burden at all"
;
label define HS150_F_VALUE_LABELS      
1 "Filled" 
-1 "Missing"
-2 "Not applicable (no repayment of debts)"
;
label define HS200_VALUE_LABELS
1 "Heavy burden"
2 "Somewhat burdensome"
3 "Not a burden at all"
;
label define HS200_F_VALUE_LABELS
 1 "Filled"
-1 "Missing"
-2 "Not applicable (no one in hhld needed/had medical care)"
-7 "Not applicable (not collected)"
;
label define HS210_F_VALUE_LABELS
 1 "Filled"
-1 "Missing"
-2 "Not applicable (no one in hhld needed/had dental care)"
-7 "Not applicable (not collected)"
;
label define HS220_F_VALUE_LABELS
 1 "Filled"
-1 "Missing"
-2 "Not applicable (no one in hhld needed/used medicines)"
-7 "Not applicable (not collected)"
;
label def HY040G_VALUE_LABELS
0 "No inc."
;
label def HY010_F_VALUE_LABELS
-8 "Variable not collected"
-5 "This scheme does not exist at national level"
-4 "Amount included in another inc. component"
-1 "Missing"
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
label def HY051G_F_VALUE_LABELS
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
label def HY052G_F_VALUE_LABELS
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
label def HY053G_F_VALUE_LABELS
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
label def HY054G_F_VALUE_LABELS
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
label def HY100G_F_VALUE_LABELS
-8 "Variable not collected"
-7 "Not applicable (HB010 not equal to 2021)"
-4 "Amount included in another inc. component"
-2 "Not applicable (HH021 not equal to 1,2)"
-1 "Missing"
11 "Collected via survey/interview, Net inc. tax at source and social contributions"
21 "Collected from administrative data, Net inc. tax at source and social contributions"
31 "Deductive/logical imputation (incl. top- and bottom-coding), Net inc. tax at source and social contributions"
41 "Gross/net conversion, Net inc. tax at source and social contributions"
51 "Model-based imputation, Net inc. tax at source and social contributions"
61 "Donor imputation, Net inc. tax at source and social contributions"
71 "Not possible to establish the most common source or method, Net inc. tax at source and social contributions"
19 "Collected via survey/interview, Not applicable (the value was not collected)"
29 "Collected from administrative data, Not applicable (the value was not collected)"
39 "Deductive/logical imputation (incl. top- and bottom-coding), Not applicable (the value was not collected)"
49 "Gross/net conversion, Not applicable (the value was not collected)"
59 "Model-based imputation, Not applicable (the value was not collected)"
69 "Donor imputation, Not applicable (the value was not collected)"
79 "Not possible to establish the most common source or method, Not applicable (the value was not collected)"
;
label define HX040_VALUE_LABELS          
 6 "MT: top coding 6 or more"
 7 "DE: deleted 7 or more households"
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
1 "When HH021= 1, 2, 5"
2 "When HH021= 3 or 4"
;
label define HX080_VALUE_LABELS          
0 "When HX090>= at risk of poverty threshold (60% of Median HX090)"
1 "When HX090 < at risk of poverty threshold (60% of Median HX090)"
;
label define HX120_VALUE_LABELS 
0 "Not overcrowded"
1 "Overcrowded"
;

* Ad-hoc module on inc. change *;
label define NO_income
0 "No inc."
;
label define HH071_VALUE_LABELS
0 "No mortgage principal repayment"
;
label define HI010_VALUE_LABELS 
 1 "Increased"
 2 "Remained more or less the same"
 3 "Decreased"
;
label define HI010_F_VALUE_LABELS 
  1 "Filled"
 -1 "Missing"
 -7 "Not applicable (HB010 < 2021)"
;
label define HI012_VALUE_LABELS
  1 "Yes"
  2 "No"
;
label define HI012_F_VALUE_LABELS
   1 "Filled"
  -1 "Missing"
  -2 "Not applicable (HI010=2)"
  -7 "Not applicable (HB010 not = 2020, 2021, 2022)"
  -8 "Not applicable (variable not collected)"
;
label define HI020_VALUE_LABELS 
1 "Indexation/re-evaluation of salary"
2 "Increased working time, wage or salary (same job)"
3 "Come back to job market after illness, child care or to take care of a person with illness or disability"
4 "Starting or changed job"
5 "Change in household composition"
6 "Increase in social benefits"
7 "Other (DE: 7= 1 or 7)"
;
label define HI020_F_VALUE_LABELS 
1 "Filled"
-1 "Missing"
-2 "Not applicable (HI010 is = 2 or 3)"
-7 "Not applicable (HB010 < 2021)"
;
label define HI030_VALUE_LABELS 
1 "Reduced working time, wage or salary (same job), including self-employment (involuntary)"
2 "Parenthood/ parental leave /child care/ to take care of a person with illness or disability"
3 "Changed job"
4 "Lost job/ unemployment/ bankruptcy of (own) enterprise"
5 "Became unable to work because of illness or disability"
6 "Divorce/ partnership ended / other change in household composition"
7 "Retirement"
8 "Cut in social benefits"
9 "Other"
;
label define HI030_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "Not applicable (HI010 is = 1 or 2)"
-7 "Not applicable (HB010 < 2021)"
;
label define HI040_VALUE_LABELS
  1 "Increase"
  2 "Remain the same"
  3 "Decrease"
;
label define HI040_F_VALUE_LABELS
   1 "Filled"
  -1 "Missing"
  -7 "Not applicable (HB010 < 2021)"
;
label define HI130G_VALUE_LABELS
  0 "No inc."
;
label define HI130G_F_VALUE_LABELS
  11 "Collected via survey/interview"
  19 "Collected via survey/interview"
  21 "Collected from administrative data"
  29 "Collected from administrative data"
  31 "Deductive/logical imputation"
  39 "Deductive/logical imputation"
  41 "Gross/net conversion"
  49 "Gross/net conversion"
  51 "Model-based imputation"
  59 "Model-based imputation"
  61 "Donor imputation"
  69 "Donor imputation"
  71 "Not possible to establish the most common source or method"
  79 "Not possible to establish the most common source or method"
  -1 "Missing"
  -4 "Amount included in another inc. component"
  -5 "This scheme does not exist at national level"
  -7 "Not applicable (HB010 not equal to 2021, 2022)"
  -8 "Not applicable (variable not collected)"
;
label define HY150_VALUE_LABELS
  1 "Yes"
  2 "No"
;
label define HY150_F_VALUE_LABELS
   1 "Collected via survey/interview"
   2 "Collected from administrative data"
   3 "Imputed"
   4 "Not possible to establish a source"
  -1 "Missing"
  -2 "Not applicable (No benefits schemes were applied in country)"
  -4 "Amount included in another inc. component"
  -5 "This scheme does not exist at national level"
  -7 "Not applicable (HB010 not = 2021)"
  -8 "Not applicable (variable not collected)"
;
label define HY155G_VALUE_LABELS
  0 "No inc."
;
label define HY155G_F_VALUE_LABELS
   11 "Collected via survey/interview & Net inc. tax at source and social contributions"
   19 "Collected via survey/interview & Not applicable (the value was not collected)"
   21 "Collected from administrative data & Net inc. tax at source and social contributions"
   29 "Collected from administrative data & Not applicable (the value was not collected)"
   31 "Deductive/logical imputation & Net inc. tax at source and social contributions"
   39 "Deductive/logical imputation & Not applicable (the value was not collected)"
   41 "Gross/net conversion & Net inc. tax at source and social contributions"
   49 "Gross/net conversion & Not applicable (the value was not collected)"
   51 "Model-based imputation & Net inc. tax at source and social contributions"
   59 "Model-based imputation & Not applicable (the value was not collected)"
   61 "Donor imputation & Net inc. tax at source and social contributions"
   69 "Donor imputation & Not applicable (the value was not collected)"
   71 "Not possible to establish the most common source or method & Net inc. tax at source and social contributions"
   79 "Not possible to establish the most common source or method & Not applicable (the value was not collected)"
   -1 "Missing"
   -2 "Not applicable (No benefits schemes were applied in country)"
   -4 "Amount included in another inc. component"
   -5 "This scheme does not exist at national level"
   -7 "Not applicable (HB010 not equal to 2021, 2022)"
   -8 "Not applicable (variable not collected)"
;
* Attachment of category labels to variable ;
label values HB050 HB050_VALUE_LABELS ;
label values HB050_F HB050_F_VALUE_LABELS ;
label values HB060_F HB060_F_VALUE_LABELS ;
label values HB070_F HB070_F_VALUE_LABELS ;
label values HB100_F HB100_F_VALUE_LABELS ;
label values HB110 HB110_VALUE_LABELS ;
label values HB110_F HB110_F_VALUE_LABELS ;
label values HB120_F HB120_F_VALUE_LABELS ;
label values HB130 HB130_VALUE_LABELS ;
label values HB130_F HB130_F_VALUE_LABELS ;
label values HD080 HD080_VALUE_LABELS;
label values HD080_F HD080_F_VALUE_LABELS;
label values HH010 HH010_VALUE_LABELS ;
label values HH010_F HH010_F_VALUE_LABELS ;
label values HH021 HH021_VALUE_LABELS ;
label values HH021_F HH021_F_VALUE_LABELS ;
label values HH030 HH030_VALUE_LABELS ;
label values HH030_F HH030_F_VALUE_LABELS ;
label values HH050 HH050_VALUE_LABELS ;
label values HH050_F HH050_F_VALUE_LABELS ;
label values HH060_F HH060_F_VALUE_LABELS ;
label values HH070_F HH070_F_VALUE_LABELS ;
label values HH071_F HH071_F_VALUE_LABELS ;
label values HS011 HS011_VALUE_LABELS ;
label values HS011_F HS011_F_VALUE_LABELS ;
label values HS021 HS021_VALUE_LABELS ;
label values HS021_F HS021_F_VALUE_LABELS ;
label values HS022 HS022_VALUE_LABELS ;
label values HS022_F HS022_F_VALUE_LABELS ;
label values HS031 HS031_VALUE_LABELS ;
label values HS031_F HS031_F_VALUE_LABELS ;
label values HS040 HS040_VALUE_LABELS ;
label values HS040_F HS040_F_VALUE_LABELS ;
label values HS050 HS050_VALUE_LABELS ;
label values HS050_F HS050_F_VALUE_LABELS ;
label values HS060 HS060_VALUE_LABELS ;
label values HS060_F HS060_F_VALUE_LABELS ;
label values HS090 HS090_VALUE_LABELS ;
label values HS090_F HS090_F_VALUE_LABELS ;
label values HS110 HS110_VALUE_LABELS ;
label values HS110_F HS110_F_VALUE_LABELS ;
label values HS120 HS120_VALUE_LABELS ;
label values HS120_F HS120_F_VALUE_LABELS ;
label values HS150 HS150_VALUE_LABELS ;
label values HS150_F HS150_F_VALUE_LABELS ;
label values HS200 HS210 HS220 HS200_VALUE_LABELS ;
label values HS200_F HS200_F_VALUE_LABELS ;
label values HS210_F HS210_F_VALUE_LABELS ;
label values HS220_F HS220_F_VALUE_LABELS ;

label val HY040G HY040N HY050G HY050N HY051G HY052G HY053G HY054G HY060G HY060N HY061G HY062G
HY063G HY064G HY070G HY070N HY071G HY072G HY073G HY074G HY080G HY080N HY081G HY081N
HY090G HY090N HY100G HY100N HY110G HY110N HY120G HY120N HY121G HY121N HY130G HY130N
HY131G HY131N HY140G HY140N HY145N HY170G HY170N HY040G_VALUE_LABELS ;
label val HY010_F HY020_F HY022_F HY023_F HY040G_F HY040N_F HY050G_F HY050N_F HY060G_F HY060N_F
HY070G_F HY070N_F HY080G_F HY080N_F HY081G_F HY081N_F HY090G_F HY090N_F HY110G_F HY110N_F
HY130G_F HY130N_F HY131G_F HY131N_F HY140G_F HY140N_F HY170G_F HY170N_F HY010_F_VALUE_LABELS ;
label val HY051G_F HY061G_F HY071G_F HY051G_F_VALUE_LABELS ;
label val HY052G_F HY062G_F HY072G_F HY052G_F_VALUE_LABELS ;
label val HY053G_F HY063G_F HY073G_F HY053G_F_VALUE_LABELS ;
label val HY054G_F HY064G_F HY074G_F HY054G_F_VALUE_LABELS  ;
label val HY100G_F HY100N_F HY120G_F HY120N_F HY121G_F HY121N_F HY145N_F HY100G_F_VALUE_LABELS ;

label values HX040 HX040_VALUE_LABELS ;	
label values HX060 HX060_VALUE_LABELS ;
label values HX070 HX070_VALUE_LABELS ;
label values HX080 HX080_VALUE_LABELS ;
label values HX120 HX120_VALUE_LABELS ;
label values HH071 HH071_VALUE_LABELS ;

* Ad-hoc module on inc. change * ;
label values HI010 HI010_VALUE_LABELS ;
label values HI010_F HI010_F_VALUE_LABELS ;
label values HI020 HI020_VALUE_LABELS ;
label values HI020_F HI020_F_VALUE_LABELS ;
label values HI030 HI030_VALUE_LABELS ;
label values HI030_F HI030_F_VALUE_LABELS ;

label values HI012 HI012_VALUE_LABELS ;
label values HI012_F HI012_F_VALUE_LABELS ;
label values HY150_1 HY150_2 HY150_3 HY150_4 HY150_VALUE_LABELS ;
label values HY150_1_F HY150_2_F HY150_3_F HY150_4_F HY150_F_VALUE_LABELS ;
label values HY155G_1 HY155G_2 HY155G_3 HY155G_4 HY155G_VALUE_LABELS ;
label values HY155G_1_F HY155G_2_F HY155G_3_F HY155G_4_F HY155G_F_VALUE_LABELS ;
label values HD225 HD225_VALUE_LABELS ;
label values HD225_F HD225_F_VALUE_LABELS ;
label values HI130G HI140G HI130G_VALUE_LABELS ;
label values HI130G_F HI140G_F HI130G_F_VALUE_LABELS ;
label values HI040 HI040_VALUE_LABELS ;
label values HI040_F HI040_F_VALUE_LABELS ;

label data "Household data file 2022" ;

compress ;
save "`stata_file'", replace ;

log close ;
set more on
#delimit cr



