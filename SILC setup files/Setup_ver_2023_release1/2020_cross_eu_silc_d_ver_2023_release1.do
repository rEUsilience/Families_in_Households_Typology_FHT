* 2020_cross_eu_silc_d_ver_2023_release1.do 
*
* STATA Command Syntax File
* Stata 17.0;
*
* Transforms the EU-SILC CSV-data (as released by Eurostat) into a Stata systemfile
* 
* EU-SILC Cross 2020 - release 2023-release1 / DOI: TBD
*
* When publishing statistics derived from the EU-SILC UDB, please state as source:
* "EU-SILC <Type> UDB <yyyy> - version of 2023-release1"
*
* Household register file:
* This version of the EU-SILC has been delivered in form of seperate country files. 
* The following do-file transforms the raw data into a single Stata file using all available country files.
* Country files are delivered in the format UDB_c*country_stub*20D.csv
* 
* (c) GESIS 2023-07-07
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
* Pforr, Klaus and Johanna Jung (2023): 2020_cross_eu_silc_d_ver_2023_release1.do.
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

local log_file "$log/eusilc_2020_d" ;

* The following command should contain the complete path where the CSV data files are stored
* Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2019) 
* Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR;

//global csv_path "CSV_PATH" ;

* The following command should contain the complete path and
* name of the STATA file, usual file extension "dta".
* Change STATA_FILENAME to your final filename ;

local stata_file "$log/eusilc_2020_d_cs" ;

* CONFIGURATION SECTION - End ;

* There should be probably nothing to change below this line ;
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

* Loop to open and convert csv files into one dta file ; 

tempfile temp ;
save `temp', emptyok ;

foreach CC in AT BE BG CH CY CZ DE DK EE EL ES FI FR HR HU IE /*IS*/ IT LT LU LV MT NL NO PL PT RO RS SE SI SK /*UK*/ { ;
      cd "$csv_path/`CC'/2020" ;		
	  import delimited using "UDB_c`CC'20D.csv", case(upper) asdouble clear ;
	  * In some countries DB040 is missing and read as numeric.
		* To prevent errors in the append command, it needs to be set to string ;
		tostring DB040, replace ; 
	append using `temp', force ;
	save `temp', replace  ;
} ;

* No info on region is available for some countries ;

replace DB040="" if DB040=="." ;

* Countries in data file are sorted in alphanumeric order ;

sort DB020 ;

log using "`log_file'", replace text ;

* Definition of variable labels ;

label variable DB010 "Year of the survey" ;
label variable DB020 "Country alphanumeric" ;
label variable DB030 "Household ID" ;
label variable DB040 "Region (NL: missing)";
label variable DB040_F "Flag" ;
label variable DB050 "Primary strata (Only CH)";
label variable DB050_F "Flag" ;
label variable DB060 "PSU-1 (First stage)" ;
label variable DB060_F "Flag" ;
label variable DB062 "PSU-2 (Second stage)" ;			
label variable DB062_F "Flag" ;							
label variable DB070 "Order of selection of PSU" ;
label variable DB070_F "Flag" ;
label variable DB075 "Rotation Group" ;
label variable DB075_F "Flag" ;
label variable DB090 "Household cross-sectional weight" ;
label variable DB090_F "Flag" ;
label variable DB100 "Degree of urbanisation (NL, SI: missing; EE, LV:1,2 = 1; MT:2,3 = 2)" ;
label variable DB100_F "Flag" ;


* Definition of category labels ;

label define DB040_F_VALUE_LABELS           
-1 "Missing"
 1 "Filled according to NUTS-10"
;
label define DB050_F_VALUE_LABELS           
1 "Filled"
2 "Self-representing PSU"
3 "Collapsed stratum due to single PSU (only for households selected in the stratum with the single PSU)"
-1 "Missing"
-2 "Not applicable (no stratification)"
;
label define DB060_F_VALUE_LABELS            
 1 "Rotation is implemented at PSU level (the PSU rotates in and out of the sample)"
 2 "Rotation is implemented at SSU or household level (The PSU remains in the sample for the entire duration of EU-SILC)"
-2 "Not applicable (no first or second sampling stage)"
;
label define DB070_F_VALUE_LABELS            
 1 "Filled"
-2 "Not applicable (no systematic selection)"
11 "Order on sampl.frame is fixed for all survey years/PSUs have equal probability of selection (within explicit strata)"
12 "Order on sampl.frame is fixed for all survey years/PSUs have unequal probability of selection (within explicit strata)"
21 "Order on sampl.frame may change over time/PSUs have equal probability of selection (within explicit strata)"
22 "Order on sampl.frame may change over time/PSUs have unqual probability of selection (within explicit strata)" 
;
label define DB075_F_VALUE_LABELS            
 1 "Filled"
-2 "Not applicable (no rotational design is used)"
;
label define DB090_F_VALUE_LABELS            
1 "Filled"
-7 "Not applicable: DB010 not equal last year" 
; 
label define DB100_VALUE_LABELS              
1 "Densely populated area (EE,LV:1,2=1)"
2 "Intermediate area (MT:2,3=2)"
3 "Thinly populated area"
;
label define DB100_F_VALUE_LABELS  
 1 "Filled"
-1 "Missing"
;

* Attachment of category labels to variable ;

label values DB040_F DB040_F_VALUE_LABELS ;
label values DB050_F DB050_F_VALUE_LABELS ;
label values DB060_F DB062_F DB060_F_VALUE_LABELS ;
label values DB070_F DB070_F_VALUE_LABELS ;
label values DB075_F DB075_F_VALUE_LABELS ;
label values DB090_F DB090_F_VALUE_LABELS ;
label values DB100   DB100_VALUE_LABELS ;
label values DB100_F DB100_F_VALUE_LABELS ; 

label data "Household register file 2020" ;

compress ;
save "`stata_file'", replace ;

log close ;
set more on
#delimit cr




