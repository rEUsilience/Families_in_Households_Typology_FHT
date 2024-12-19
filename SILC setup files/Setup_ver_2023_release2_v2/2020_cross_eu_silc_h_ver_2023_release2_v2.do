* 2020_cross_eu_silc_h_ver_2023_release2_v2.do 
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
* Household data file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_c*country_stub*20H.csv
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
* Pforr, Klaus, Johanna Jung and Carl Riemann (2024): 2020_cross_eu_silc_h_ver_2023_release2_v2.do, 1st update.
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

local log_file "$log/eusilc_2020_h" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2020) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2020_h_cs" ;

* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 

tempfile temp ;
save `temp', emptyok ;
* AT BE BG CH CY CZ DK EE EL ES FI FR HR HU IE LT LU LV MT NL NO PL PT RO RS SE SI SK;
foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HR HU IE IT LT LU LV MT NL NO PL PT RO RS SE SI SK { ;
      cd "$csv_path/`CC'/2020" ;
	  import delimited using "UDB_c`CC'20H.csv", case(upper) asdouble clear stringcols(124 132 140);
	  * In some countries non-numeric characters are wrongfully included.
		* This command prevents errors in the format. ;
		destring HB100, ignore ("**") replace ;
		destring HY053G_F, ignore ("**") replace ;
		destring HY063G_F, ignore ("**") replace ;
		destring HY073G_F, ignore ("**") replace ;
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
label variable HB080 "Person 1 responsible for the accommodation" ;
label variable HB080_F "Flag" ;
label variable HB090 "Person 2 responsible for the accommodation" ;
label variable HB090_F  "Flag" ;
label variable HB100 "Number of minutes to complete the household questionnaire" ; 
label variable HB100_F "Flag" ;
label variable HD080   "Replacing worn-out furniture";
label variable HD080_F "Flag";
label variable HH010 "Dwelling type" ;
label variable HH010_F "Flag" ;
label variable HH021   "Tenure status" ;
label variable HH021_F "Flag" ;
label variable HH030 "Number of rooms available to the household" ;
label variable HH030_F "Flag" ;
label variable HH031 "Year of contract or purchasing or installation" ;
label variable HH031_F "Flag" ;
label variable HH040 "Leaking roof, damp walls/floors/foundation, or rot in window frame/floor" ;
label variable HH040_F "Flag" ;
label variable HH050 "Ability to keep home adequately warm" ;
label variable HH050_F "Flag" ;
label variable HH060 "Current rent related to occupied dwelling (MT: Top & bottom coding)" ;
label variable HH060_F "Flag" ;
label variable HH061 "Subjective rent" ;
label variable HH061_F "Flag" ;
label variable HH070 "Total housing cost (MT: Top & bottom coding)" ;
label variable HH070_F "Flag" ;
label variable HH071 "Mortgage principal repayment (MT: Top & bottom coding)" ;
label variable HH071_F "Flag" ;
label variable HH081 "Bath or shower in dwelling" ;
label variable HH081_F "Flag" ;
label variable HH091 "Indoor flushing toilet for sole use of household" ;
label variable HH091_F "Flag" ;
label variable HS011 "Arrears on mortgage or rent payments" ;
label variable HS011_F "Flag" ;
label variable HS021 "Arrears on utility bills" ;
label variable HS021_F "Flag" ;
label variable HS031 "Arrears on hire purchase installments or other loan payments" ;
label variable HS031_F "Flag" ;
label variable HS040 "Capacity to afford paying for one week annual holiday away from home" ;
label variable HS040_F "Flag" ;
label variable HS050 "Capacity to afford a meal with meat, chicken, fish (or veg. equiv.) ev. sec. day" ;
label variable HS050_F "Flag" ;
label variable HS060 "Capacity to face unexpected financial expenses" ;
label variable HS060_F "Flag" ;
label variable HS070 "Do you have a telephone (including mobile phone)? (OPTIONAL)" ;
label variable HS070_F "Flag" ;
label variable HS080 "Do you have a colour TV? (OPTIONAL)" ;
label variable HS080_F "Flag" ;
label variable HS090 "Do you have a computer?" ;
label variable HS090_F "Flag" ;
label variable HS100 "Do you have a washing maschine? (OPTIONAL)" ;
label variable HS100_F "Flag" ;
label variable HS110 "Do you have a car?" ;
label variable HS110_F "Flag" ;
label variable HS120 "Ability to make ends meet" ;
label variable HS120_F "Flag" ;
label variable HS130 "Lowest monthly income to make end meet (MT: Top & bottom coding)" ;
label variable HS130_F "Flag" ;
label variable HS140 "Financial burden of the total housing cost" ;
label variable HS140_F "Flag" ;
label variable HS150 "Financial burden of the repayment of debts from hire purchases or loans" ;
label variable HS150_F "Flag" ;
label variable HS160    "Problems with the dwelling: too dark, not enough light" ;
label variable HS160_F "Flag" ;
label variable HS170   "Noise from neighbours or from the street" ;
label variable HS170_F "Flag" ;
label variable HS180   "Pollution, grime or other environmental problems" ;
label variable HS180_F "Flag" ;
label variable HS190   "Crime violence or vandalism in the area" ;
label variable HS190_F "Flag" ;
* For HY010, HY020, HY022, HY023: Please see Differences Collection vs UDB for more information ;
label variable HY010 "Total household gross income (DE, EE, MT, SI, UK: Adjustments; MT: T & b cod)" ; 
label variable HY010_F "Flag" ;
label variable HY010_I "Imputation factor" ;
label variable HY020 "Total disposable household income (DE, EE, MT, SI, UK: Adj; MT: T & b cod)" ; 
label variable HY020_F "Flag" ;
label variable HY020_I "Imputation factor" ;
label variable HY022 "Tt dsp hh inc bf soc trnfs ex o-age & srvvrs ben (DE,EE,MT,SI,UK:Adj;MT:T&b cod)" ; 
label variable HY022_F "Flag" ;
label variable HY022_I "Imputation factor" ;
label variable HY023 "Tt dsp hh inc bf soc trnfs ic o-age & srvvrs ben (DE,EE,MT,SI,UK:Adj;MT:T&b cod)" ; 
label variable HY023_F "Flag" ;
label variable HY023_I "Imputation factor" ;
label variable HY030G "Imputed rent (gross, MT: Top & bottom coding)" ;
label variable HY030G_F "Flag" ;
label variable HY040G "Income from rental of a property or land (gross; SI: T cod; MT: T & b cod)" ;
label variable HY040G_F "Flag" ;
label variable HY040G_I "Imputation factor" ;
label variable HY050G  "Family/Children related allowances (gross; SI: Top cod; MT: Top & bottom cod)" ;
label variable HY050G_F "Flag" ;
label variable HY050G_I "Imputation factor" ;
label variable HY051G  "Family/children-related allowances (contributory and means-tested)";
label variable HY051G_F "Flag";
label variable HY052G "Family/children-related allowances (contributory & n. means-tstd, MT: T & b cod)";
label variable HY052G_F "Flag";
label variable HY053G  "Family/children-related allow. (non-contributory & means-tested, MT: T & b cod)";
label variable HY053G_F "Flag";
label variable HY054G "Family/children-related allowance (non-cntrbtry & n. means-tstd, MT: T & b cod)";
label variable HY054G_F "Flag";
label variable HY060G  "Social exclusion not elsewhere classified (gross; SI: Top coding; MT: T & b cod)" ;
label variable HY060G_F "Flag" ;
label variable HY060G_I "Imputation factor" ;
label variable HY061G "Social exclusion not elsewhere classified (contributory and means-tested)";
label variable HY061G_F "Flag";
label variable HY062G  "Social exclusion not elsewhere classified (contributory and non means-tested)";
label variable HY062G_F "Flag";
label variable HY063G  "Social exclusion not elsewhere class. (non-cntrbtry & means-tstd, MT: T & b cod)";
label variable HY063G_F "Flag";
label variable HY064G  "Social exclusion not elsewhere classified (non-contributory & non means-tested)";
label variable HY064G_F "Flag";
label variable HY070G "Housing allowances (gross; SI: Top coding; MT: Top & bottom coding)" ;
label variable HY070G_F "Flag" ;
label variable HY070G_I "Imputation factor" ;
label variable HY071G  "Housing allowances (contributory and means-tested)";
label variable HY071G_F "Flag";
label variable HY072G  "Housing allowances (contributory and non means-tested)";
label variable HY072G_F "Flag";
label variable HY073G  "Housing allowances (non-contributory and means-tested, MT: T & b cod; MT: Adj)";
label variable HY073G_F "Flag";
label variable HY074G  "Housing allowances (non-contributory and non means-tested)";
label variable HY074G_F "Flag";
label variable HY080G "Regular interhousehold cash transfer received (gross; SI: T cod, MT: T & b cod)" ;
label variable HY080G_F "Flag" ;
label variable HY080G_I "Imputation factor" ;
label variable HY081G "Alimonies received (gross; SI: Top coding; MT: Top & bottom coding)" ;
label variable HY081G_F "Flag" ;
label variable HY081G_I "Imputation factor" ;
label variable HY090G "Intrsts, dvdnds, prft fr cptl invmnt in uncrpbsn (g;SI: T cod;MT,UK: T&b cod)"  ;
label variable HY090G_F "Flag" ;
label variable HY090G_I "Imputation factor" ;
label variable HY100G "Interest repayments on mortgage (gross, MT: Top & bottom coding)" ;
label variable HY100G_F "Flag" ;
label variable HY100G_I "Imputation factor" ;
label variable HY110G "Income received by people aged under 16 (gross; SI: Top coding, MT: T & b cod)" ;
label variable HY110G_F "Flag" ;
label variable HY110G_I "Imputation factor" ;
label variable HY120G "Regular taxes on wealth (gross; SI, UK: Top coding)" ;
label variable HY120G_F "Flag" ;
label variable HY120G_I "Imputation factor" ;
label variable HY130G "Regular interhousehold cash transfer paid (gross; SI: T cod, MT: T & b cod)" ;
label variable HY130G_F "Flag" ;
label variable HY130G_I "Imputation factor" ;
label variable HY131G   "Alimonies paid (gross; SI: Top coding, MT: Top & bottom coding)" ;
label variable HY131G_F "Flag" ;
label variable HY131G_I "Imputation factor" ;
label variable HY140G "Tax on inc and soc contributions (gross; UK: T cod; DE, MT: T & b cod; MT: Adj)" ;
label variable HY140G_F "Flag" ;
label variable HY140G_I "Imputation factor" ;
label variable HY170G  "Value of goods produced for own consumption (gross)" ;
label variable HY170G_F "Flag" ;
label variable HY170G_I "Imputation factor" ;
label variable HY030N "Imputed rent (net)" ; 
label variable HY030N_F "Flag" ;
label variable HY040N "Income from rental of a property or land (net; SI: Top coding)" ; 
label variable HY040N_F "Flag" ;
label variable HY040N_I "Imputation factor" ;
label variable HY050N "Family/Children related allowances (net; SI: Top coding)" ;
label variable HY050N_F "Flag" ;
label variable HY050N_I "Imputation factor" ;
label variable HY060N "Social exclusion not elsewhere classified (net; SI: Top coding)" ;
label variable HY060N_F "Flag" ; 
label variable HY060N_I "Imputation factor" ;
label variable HY070N "Housing allowances (net; SI: Top coding)" ;
label variable HY070N_F "Flag" ;
label variable HY070N_I "Imputation factor" ;
label variable HY080N "Regular interhousehold cash received (net; SI: Top coding)" ;
label variable HY080N_F "Flag" ;
label variable HY080N_I "Imputation factor" ;
label variable HY081N "Alimonies received (net; SI: Top coding)" ;
label variable HY081N_F "Flag" ;
label variable HY081N_I "Imputation factor" ;
label variable HY090N "Intrsts, dvdnds, prft fr cptl invmnt in uncp bsn (n;MT,SI,UK: T&b cod)" ;
label variable HY090N_F "Flag" ;
label variable HY090N_I "Imputation factor" ;
label variable HY100N "Interest repayment on mortgage (net)" ;
label variable HY100N_F "Flag" ;
label variable HY100N_I "Imputation factor" ;
label variable HY110N "Income received by people aged under 16 (net; SI: Top coding)" ;
label variable HY110N_F "Flag" ;
label variable HY110N_I "Imputation factor" ;
label variable HY120N "Regular taxes on wealth (net; SI: Top coding)" ;
label variable HY120N_F "Flag" ;
label variable HY120N_I "Imputation factor" ;
label variable HY130N "Regular inter-household cash transfer paid (net; SI: Top coding)" ;
label variable HY130N_F "Flag" ;
label variable HY130N_I "Imputation factor" ;
label variable HY131N   "Alimonies paid (net; SI: Top coding)" ;
label variable HY131N_F "Flag" ;
label variable HY131N_I "Imputation factor" ;
label variable HY140N "Tax on income and social contribution (net; DE: Top & bottom coding; MT: Adj)" ;
label variable HY140N_F "Flag" ;
label variable HY140N_I "Imputation factor" ;
label variable HY145N "Repayments or receipts for tax adjustment (net; SI: Top & bottom coding)" ;
label variable HY145N_F "Flag" ;
label variable HY145N_I "Imputation factor" ;
label variable HY170N   "Value of goods produced for own consumption (net)" ;
label variable HY170N_F "Flag" ;
label variable HY170N_I "Imputation factor" ;
label variable HX010 "Change rate" ;
label variable HX040 "Household size (MT: Top coded to '6'; DE: deleted 7 or more)" ;
label variable HX050 "Equivalised household size (MT: Top & bottom coding)" ;
label variable HX060 "Household type";
label variable HX070 "Tenure state";
label variable HX080 "Poverty indicator" ;
label variable HX090 "Equivalised disposable income (MT: Top & bottom coding)" ;
label variable HX120 "Overcrowded household";

* Module on income change (optional COVID-19 related Variables) ;
label variable HI011 "Change in income compared to previous year (OPTIONAL)" ;
label variable HI011_F "Flag" ;
label variable HI012 "Did the change happen as an impact of COVID-19 (OPTIONAL)" ;
label variable HI012_F "Flag" ;
label variable HI020 "Reason for increase in income (OPTIONAL)" ;
label variable HI020_F "Flag" ;
label variable HI030 "Reason for decrease in income (OPTIONAL)" ;
label variable HI030_F "Flag" ;

* Ad-hoc modules ;
label variable HI022 "Arrears on non-housing bills" ;
label variable HI022_F "Flag";
label variable HI090 "Number of loans (excluding mortgages on purchase of main residence; SI: t cod)" ;
label variable HI090_F "Flag";
label variable HI100_1 "Purpose of loans: Property (incl hh furniture, appliances & interior decoration)";
label variable HI100_1_F "Flag";
label variable HI100_2 "Purpose of loans: Car, motorcylce, caravan, van, bike or oth means of transport";
label variable HI100_2_F "Flag";
label variable HI100_3 "Purpose of loans: Holidays";
label variable HI100_3_F "Flag";
label variable HI100_4 "Purpose of loans: Healthcare";
label variable HI100_4_F "Flag";
label variable HI100_5 "Purpose of loans: Education";
label variable HI100_5_F "Flag";
label variable HI100_6 "Purpose of loans: To cover daily living expenses";
label variable HI100_6_F "Flag";
label variable HI100_7 "Purpose of loans: Personal loan to finance own business";
label variable HI100_7_F "Flag";
label variable HI100_8 "Purpose of loans: To refinance loan";
label variable HI100_8_F "Flag";
label variable HI100_9 "Purpose of loans: Other (not listed above)";
label variable HI100_9_F "Flag";
label variable HI110_1 "Source of loans: Bank, oth fin inst (e.g. credit union, microcredit provider)";
label variable HI110_1_F "Flag";
label variable HI110_2 "Source of loans: Payday loan company or pawnbroker/cash converter";
label variable HI110_2_F "Flag";
label variable HI110_3 "Source of loans: Private sources (e.g. family, friends)";
label variable HI110_3_F "Flag";
label variable HI110_4 "Source of loans: Other";
label variable HI110_4_F "Flag";
label variable HI120 "Amount spent last month on loans (excl. mortgages on purchase of main residence)" ;
label variable HI120_F "Flag";
label variable HC010 "Food at home (SI: top coding)" ;
label variable HC010_F "Flag";
label variable HC020 "Food or drink outside home (SI: top coding)" ;
label variable HC020_F "Flag";
label variable HC030 "Public transport (SI: top coding)" ;
label variable HC030_F "Flag";
label variable HC040 "Private transport (SI: top coding)" ;
label variable HC040_F "Flag";
label variable HC050 "Savings (in a typical month)" ;
label variable HC050_F "Flag";

label variable HV010 "Value of main residence (SI: top & bottom coding, rounded)" ;
label variable HV010_F "Flag";
label variable HV070 "Total left to repay for the mortgage on main residence (OPTIONAL)" ;
label variable HV070_F "Flag";
label variable HV020 "Possession of real estate other than main residence" ;
label variable HV020_F "Flag";
label variable HV080 "Ability to maintain the same standard of living using savings" ;
label variable HV080_F "Flag";


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
label define HB080_F_VALUE_LABELS      
 1 "Filled"
-1 "Missing"
-8 "PL: missing"
;
label define HB090_F_VALUE_LABELS     
 1 "Filled"               
-1 "Missing"
-2 "Not applicable (no 2nd responsible)"
-8 "PL: missing"
;
label define HB100_F_VALUE_LABELS      
 1 "Filled"
-1 "Missing"
;
label define HD080_VALUE_LABELS
 1 "Yes"
 2 "No - household cannot afford it"
 3 "No - other reason"
;
label define HD080_F_VALUE_LABELS
  1 "Filled"
 -1 "Missing"
;
label define HH010_VALUE_LABELS         
1 "Detached house"
2 "Semi-detached house"
3 "Apartment or flat in a building with < 10 dwellings"
4 "Apartment or flat in a building with >=10 dwellings"
5 "Some other kind of accommodation"
;
label define HH010_F_VALUE_LABELS       
1 "Filled"
-1 "Missing"
;
label define HH021_VALUE_LABELS         
1 "Outright owner"
2 "Owner paying mortgage"
3 "Tenant/subtenant paying rent at prevailing or market rate"
4 "Accommodation is rented at a reduced rate (lower price that the market price)"
5 "Accommodation is provided free"
;
label define HH021_F_VALUE_LABELS         
 1 "Filled"
-1 "Missing"
;
label define HH030_VALUE_LABELS         
2 "MT: 2 or less"
6 "6 or more rooms"
;
label define HH030_F_VALUE_LABELS       
 1 "Filled"
-1 "Missing"
;
label define HH031_VALUE_LABELS       
 1964 "PT: 1964 and earlier"
 1948 "SI: 1948 and earlier"
;
label define HH031_F_VALUE_LABELS      
 1 "Filled"
-1 "Missing"
-2 "Not applicable"
-8 "PL: missing"
;
label define HH040_VALUE_LABELS         
1 "Yes"
2 "No"
;
label define HH040_F_VALUE_LABELS       
 1 "Filled"
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
 1 "Filled"
-1 "Missing"
-2 "Not applicable (HH021 not equal 3 or 4)"
;
label define HH061_F_VALUE_LABELS       
 1 "Filled"
-1 "Missing"
-2 "Not applicable (HH021 equal 3) or (MS do not use subjective method to calculate imputed rent)"
-8 "PL: missing"
;
label define HH070_F_VALUE_LABELS       
 1 "Filled"
-1 "Missing"
;
label define HH071_F_VALUE_LABELS       
 1 "Filled"
-1 "Missing"
-2 "Not applicable (HH021 not equal 2)"
;
label define HH081_VALUE_LABELS
1 "Yes, for sole use of the household"
2 "Yes, shared"
3 "No"
;
label define HH081_F_VALUE_LABELS
 1 "Filled"
-1 "Missing"
;
label define HH091_VALUE_LABELS
1 "Yes, for sole use of the household"
2 "Yes, shared"
3 "No"
;
label define HH091_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
;
label define HS011_VALUE_LABELS
1 "Yes, once"
2 "Yes, twice or more"
3 "No"
;
label define HS011_F_VALUE_LABELS
 1 "Filled"
-1 "Missing"
-2 "Not applicable"
;
label define HS021_VALUE_LABELS
1 "Yes, once"
2 "Yes, twice or more"
3 "No"
;
label define HS021_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "Not applicable"
;
label define HS031_VALUE_LABELS
1 "Yes, once"
2 "Yes, twice or more"
3 "No"
;
label define HS031_F_VALUE_LABELS
 1 "Filled"
-1 "Missing"
-2 "Not applicable"
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
label define HS070_VALUE_LABELS         
1 "Yes"
2 "No - cannot afford"
3 "No - other reason"
;
label define HS070_F_VALUE_LABELS       
1 "Filled"
-1 "Missing"
-8 "PL: missing"
;
label define HS080_VALUE_LABELS         
1 "Yes"
2 "No - cannot afford"
3 "No - other reason"
;
label define HS080_F_VALUE_LABELS       
1 "Filled"
-1 "Missing"
-8 "PL: missing"
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
label define HS100_VALUE_LABELS         
1 "Yes"
2 "No - cannot afford"
3 "No - other reason"
;
label define HS100_F_VALUE_LABELS       
 1 "Filled" 
-1 "Missing"
-8 "PL: missing"
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
label define HS130_F_VALUE_LABELS       
 1 "Filled"
-1 "Missing"
-8 "PL: missing"
;
label define HS140_VALUE_LABELS         
1 "A heavy burden"
2 "Somewhat a burden"
3 "Not a burden at all"
;
label define HS140_F_VALUE_LABELS       
1 "Filled" 
-1 "Missing"
-2 "Not applicable (no housing costs)"
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
label define HS160_VALUE_LABELS        
1 "Yes"
2 "No"
;
label define HS160_F_VALUE_LABELS       
 1 "Filled"
-1 "Missing"
-8 "PL: missing"
;
label define HS170_VALUE_LABELS         
1 "Yes"
2 "No"
;
label define HS170_F_VALUE_LABELS       
 1 "Filled"
-1 "Missing"
-8 "PL: missing"
;
label define HS180_VALUE_LABELS         
1 "Yes"
2 "No"
;
label define HS180_F_VALUE_LABELS       
 1 "Filled"
-1 "Missing"
-8 "PL: missing"
;
label define HS190_VALUE_LABELS         
1 "Yes"
2 "No"
;
label define HS190_F_VALUE_LABELS       
1 "Filled"
-1 "Missing"
-8 "PL: missing"
;
label define HY010_F_VALUE_LABELS      
 0 "No income"
 1 "Data collection: net" 
 2 "Data collection: gross" 
 3 "Data collection: net and gross"
 4 "Data collection: unknown"
 7 "FR: value not defined"
-1 "Missing"
-5 "Not filled: no conversion to gross is done"
; 
label define HY030G_F_VALUE_LABELS      
0 "No income"
1 "Filled"
-1 "Missing"
-5 "Not filled: variable of net (...g)gross (...n) series is filled"
-8 "PL: missing (value set to 0)"
;
label define HY040G_F_VALUE_LABELS      
 0 "No income"
 1 "Collected net of tax on income at source and social contributions"
 2 "Collected net of tax on income at source"
 3 "Collected net of tax on social contributions"
 4 "Collected gross"
 5 "Collected unknown"
 6 "Mix (parts of the component collected according to different ways"
-1 "Missing"
-4 "Missing (amount included in another income component)"
-5 "Not filled: variable of net series is filled"
;
label define HY051G_F_VALUE_LABELS
2 "Filled with mixed components"
1 "Filled with only contributory and means-tested components"
0 "No income"
-1 "Missing"
-2 "Not available (This scheme does not exist at national level)"
-5 "FR: missing"
-7 "Not applicable (HB010 < 2014)"
;
label define HY030N_F_VALUE_LABELS      
0 "No income"
1 "Filled"
-1 "Missing"
-5 "Not filled: variable of gross series is filled"
-8 "PL: missing (value set to 0)"
;
label define HY040N_F_VALUE_LABELS      
0 "No income"
1 "Net of tax on income at source and social contributions"
3 "Collected net of tax on social contributions"
5 "Collected unknown"
7 "FR: missing"
11 "Collected & recorded net of tax on income at source & social contributions"
13 "Collected net of tax on income at source & social contributions & recorded net of tax on social contributions"
21 "Collected net of tax on income at source/recorded net of tax on income at source and social contributions"
22 "Collected & recorded net of tax on income at source" 
31 "Collected net of tax on social contribution/recorded net of tax on income & social contributions"
32 "Collected net of tax on social contribution/rec. net of tax on income at source"
33 "Collected & recorded net of tax on social contributions"
41 "Collected gross/recorded net of tax on income & social contributions"
42 "Collected gross/recorded net of tax on income at source"
43 "Collected gross/recorded net of tax on social contributions"
51 "Collected unknown/recorded net of tax on income & social contributions"
52 "Collected unknown/recorded net of tax on income at source"
53 "Collected unknown/recorded net of tax on social contributions"
55 "Unknown"
56 "Collected unknown/recorded mixed"
61 "Mix (parts of the component collected according to different ways/deductive imputation)"
-1 "Missing"
-4 "Missing (amount included in another income component)"
-5 "Not filled: variable of gross series is filled"
;
label define HY140N_F_VALUE_LABELS      
0 "no income"
1 "variable is filled"
-1 "missing"
-5 "Not filled: variable of the gross series is filled"
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

* Ad-hoc module on income change *;
label define NO_INCOME
0 "No income"
;
label define HH071_VALUE_LABELS
0 "No mortgage principal repayment"
;
label define HI022_VALUE_LABELS
1 "Yes, once"
2 "Yes, twice or more"
3 "No"
;
label define HI022_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "N/A (no non-housing bills)"
-7 "N/A (HB010 is not 2020)"
-8 "IT: missing"
;
label define HI090_VALUE_LABELS
6 "SI: 6 or more"
;
label define HI090_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-7 "N/A (HB010 is not 2020)"
-8 "IT: missing"
;
label define HI120_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "N/A (HI090 (number of loans) = 0)"
-7 "N/A (HB010 is not 2020)"
-8 "IT: missing"
;
label define HI100_1_VALUE_LABELS
1 "selected"
2 "not selected"
;
label define HC010_F_VALUE_LABELS 
1 "Filled"
-1 "Missing"
-7 "N/A (HB010 is not 2020)"
;
label define HC020_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "N/A (no food ouside home)"
-7 "N/A (HB010 is not 2020)"
;
label define HC030_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "N/A (no public transport used)"
-7 "N/A (HB010 is not 2020)"
;
label define HC040_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "N/A (no private transport used)"
-7 "N/A (HB010 is not 2020)"
;
label define HC050_VALUE_LABELS
1 "Household puts money aside"
2 "Household needs to draw on savings"
3 "Household needs to borrow money"
4 "Household neither puts money aside nor needs to draw on savings or borrow"
;
label define HC050_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-7 "N/A (HB010 is not 2020)"
;
label define HV010_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "N/A (not an owner HH021 is not 1 or 2)"
-7 "N/A (HB010 is not 2020)"
;
label define HV070_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "N/A (no mortgage on main residence HH021 is not 2)"
-7 "N/A (HB010 is not 2020)"
-8 "CY, CZ, IT, PL, RS, SE, SI: missing"
;
label define HV020_VALUE_LABELS
1 "Yes"
2 "No"
;
label define HV020_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-7 "N/A (HB010 is not 2020)"
;
label define HV080_VALUE_LABELS
1 "< 3 months"
2 "=< 3 to 6 months"
3 "=< 6 to 12 months"
4 "more than 12 months"
;
label define HV080_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "Not applicable (no savings)"
-7 "N/A (HB010 is not 2020)"
-8 "IT: missing"
;
label define HI011_VALUE_LABELS
1 "Increased"
2 "Remained more or less the same"
3 "Decreased"
;
label define HI011_F_VALUE_LABELS
11 "-Filled- interview based"
12 "-Filled- derived"
-1 "Missing"
-7 "Not applicable (HB010 not 2020)"
-8 "Not applicable (variable not collected)"
;
label define HI012_VALUE_LABELS
1 "Yes"
2 "No"
;
label define HI012_F_VALUE_LABELS
1 "Filled"
-1 "Missing"
-2 "Not applicable (HI011=2)"
-7 "Not applicable (HB010 is not 2020)"
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
-2 "Not applicable (HI010 is not 1)"
-7 "Not applicable (HB010 is not 2020)"
-8 "Not applicable (variable not collected)"
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
-2 "Not applicable (HI010 is not 3)"
-7 "Not applicable (HB010 is not 2020)"
-8 "Not applicable (variable not collected)"
;


* Attachment of category labels to variable ;
label values HB050 HB050_VALUE_LABELS ;
label values HB050_F HB050_F_VALUE_LABELS ;
label values HB060_F HB060_F_VALUE_LABELS ;
label values HB070_F HB070_F_VALUE_LABELS ;
label values HB080_F HB080_F_VALUE_LABELS ;
label values HB090_F HB090_F_VALUE_LABELS ;
label values HB100_F HB100_F_VALUE_LABELS ;
label values HD080 HD080_VALUE_LABELS;
label values HD080_F HD080_F_VALUE_LABELS;
label values HH010 HH010_VALUE_LABELS ;
label values HH010_F HH010_F_VALUE_LABELS ;
label values HH021 HH021_VALUE_LABELS ;
label values HH021_F HH021_F_VALUE_LABELS ;
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
label values HH070_F HH070_F_VALUE_LABELS ;
label values HH071_F HH071_F_VALUE_LABELS ;
label values HH081 HH081_VALUE_LABELS ;
label values HH081_F HH081_F_VALUE_LABELS ;
label values HH091 HH091_VALUE_LABELS ;
label values HH091_F HH091_F_VALUE_LABELS ;
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
label values HS160 HS160_VALUE_LABELS ;
label values HS160_F HS160_F_VALUE_LABELS ;
label values HS170 HS170_VALUE_LABELS ;
label values HS170_F HS170_F_VALUE_LABELS ;
label values HS180 HS180_VALUE_LABELS ;
label values HS180_F HS180_F_VALUE_LABELS ;
label values HS190 HS190_VALUE_LABELS ;
label values HS190_F HS190_F_VALUE_LABELS ;
label values HY010_F HY020_F HY022_F HY023_F HY010_F_VALUE_LABELS ;
label values HY030G_F HY030G_F_VALUE_LABELS ;
label values HY040G_F HY050G_F HY060G_F HY070G_F HY080G_F ///
             HY081G_F HY090G_F HY100G_F HY110G_F HY120G_F ///
			 HY130G_F HY131G_F HY140G_F HY170G_F HY040G_F_VALUE_LABELS ;
label values HY051G_F HY061G_F HY071G_F HY052G_F HY062G_F ///
             HY072G_F HY053G_F HY063G_F HY073G_F HY054G_F ///
			 HY064G_F HY074G_F HY051G_F_VALUE_LABELS;
label values HY030N_F HY030N_F_VALUE_LABELS ;
label values HY040N_F HY050N_F HY060N_F HY070N_F HY080N_F ///
             HY081N_F HY090N_F HY100N_F HY110N_F HY120N_F ///
             HY130N_F HY131N_F HY145N_F HY170N_F HY040N_F_VALUE_LABELS ;
label values HY140N_F HY140N_F_VALUE_LABELS ;
label values HX040 HX040_VALUE_LABELS ;	
label values HX060 HX060_VALUE_LABELS ;
label values HX070 HX070_VALUE_LABELS ;
label values HX080 HX080_VALUE_LABELS ;
label values HX120 HX120_VALUE_LABELS ;
label values HY030N HY040N HY050N HY060N HY070N HY080N HY081N HY090N ///
			 HY100N HY110N HY120N HY130N HY131N HY140N HY145N HY170N ///
			 HY030G HY040G HY050G HY060G HY070G HY080G HY081G HY090G ///
			 HY100G HY110G HY110G HY120G HY130G HY131G HY140G HY170G ///
			 HY051G HY052G HY053G HY054G HY061G HY062G HY063G HY064G ///
			 HY071G HY072G HY073G HY074G NO_INCOME ;
label values HH071 HH071_VALUE_LABELS ;

* Ad-hoc module on income change * ;
label values HI011 HI011_VALUE_LABELS ;
label values HI011_F HI011_F_VALUE_LABELS ;
label values HI012  HI012_VALUE_LABELS ;
label values HI012_F HI012_F_VALUE_LABELS ;
label values HI020 HI020_VALUE_LABELS ;
label values HI020_F HI020_F_VALUE_LABELS ;
label values HI030 HI030_VALUE_LABELS ;
label values HI030_F HI030_F_VALUE_LABELS ;

label values HI022 HI022_VALUE_LABELS ;
label values HI022_F HI022_F_VALUE_LABELS ;
label values HI090 HI090_VALUE_LABELS ;
label values HI090_F HI090_F_VALUE_LABELS ;
label values HI120_F HI100_1_F HI100_2_F HI100_3_F HI100_4_F ///
             HI100_5_F HI100_6_F HI100_7_F HI100_8_F HI100_9_F HI110_1_F ///
			 HI110_2_F HI110_3_F HI110_4_F HI120_F_VALUE_LABELS ;
label values HI100_1 HI100_2 HI100_3 HI100_4 HI100_5 HI100_6 HI100_7 ///
             HI100_8 HI100_9 HI110_1 HI110_2 HI110_3 HI110_4 HI100_1_VALUE_LABELS;
label values HC010_F HC010_F_VALUE_LABELS ;
label values HC020_F HC020_F_VALUE_LABELS ;
label values HC030_F HC030_F_VALUE_LABELS ;
label values HC040_F HC040_F_VALUE_LABELS ;
label values HC050 HC050_VALUE_LABELS ;
label values HC050_F HC050_F_VALUE_LABELS ;
label values HV010_F HV010_F_VALUE_LABELS ;
label values HV070_F HV070_F_VALUE_LABELS ;
label values HV020 HV020_VALUE_LABELS ;
label values HV020_F HV020_F_VALUE_LABELS ;
label values HV080 HV080_VALUE_LABELS ;
label values HV080_F HV080_F_VALUE_LABELS ;

label data "Household data file 2020" ;

compress ;
save "`stata_file'", replace ;

log close ;
set more on
#delimit cr



