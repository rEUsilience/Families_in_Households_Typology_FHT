*******************************************************************
*** 	Families in Households Typology (FHT): MASTER file 		***
*******************************************************************


clear all
version 17.0 // set Stata version


* install if needed
//ssc install egenmore
//ssc install fre
//ssc install confirmdir


**#		 Macros

global SILC "/Users/alzbeta/Documents/Data/EU-SILC_merged" // to call the original SILC data
global DATA "/Users/alzbeta/Documents/Data/EU-SILC/FHT_SILC" // to save the created data files
global CODE "/Users/alzbeta/Library/CloudStorage/Box-Box/WORK/_KU LEUVEN/rEUsilience/FHT_updated/FHT_euromod" // folder where the code is stored

import delimited "$SILC/be_2019_std[58].txt", clear 
save "$SILC/be_2019_std[58].dta", replace

lab var les "Economic activity"
lab def lesl 0 "pre-school" 1 "farmer" 2 "employer/self-employed" 3 "employer" 4 "pensioner" 5 "unemployed" 6 "student" 7 "inactive" 8 "sick or disabled" 9 "other"
lab val les lesl

tab dag if les == 0 // les == 0 are children of pre-school age 

rename dag age

**# 	PREPARATION FOR FHT AND CONSTRUCTION OF FHT

//global wave "10 11 12 13 14 15 16 17 18 19 20" // to switch between waves
//global wave "19"

//The following code can only be used once!

//use "$SILC/be_2019_std[58].dta", clear 
//gen inactive = inrange(rb211,3,8)
gen inactive = inrange(les,5,9) if age >= 18 // les contains children - they are coded separately based on their age => exclude them here
//save "$SILC/SILC2021_ver_2023_release1", replace

/*
foreach x of global wave {
	use "$SILC/SILC20`x'_ver_2023_release1", clear 
	gen inactive = inrange(pl031,6,11)
	save "$SILC/SILC20`x'_ver_2023_release1", replace
}
*/

//foreach x of global wave {
**# 	Data Input


**# 	Country selection & rename key variables

		/* 		NOTE: 	Due to anonymisation, Malta doesn't use some of the crucial variables (age) and categorises others (year of birth).
						Malta is excluded from the analysis until we decide what to do with this issue. 	
		*/

		* drop Malta
//		drop if country == "MT"

		* drop Serbia
		//drop if country == "RS"

	** rename ID & crucial variables 
/*
		rename rb220 father_id
		replace father_id = . 		if rb220_f == -1 
		rename rb230 mother_id
		replace mother_id = . 		if rb230_f == -1
		rename rb240 partner_id
		replace partner_id = . 		if rb240_f == -1
		
		rename rx010 age
		rename rb090 sex
*/

		rename idhh hid
		rename idperson pid
		
		rename idmother mother_id
		replace mother_id = . if mother_id == 0
		
		rename idfather father_id
		replace father_id = . if father_id == 0
		
		rename idpartner partner_id
		replace partner_id = . if partner_id == 0
		
	** missing values on "age" => replace missing values with estimate based on year of birth
//		replace age = (year - rb080) if age == .
//		replace age = 0 if age == (-1)
			
		
		rename dgn sex
		
**# 	HOUSEHOLD COMPOSITION

sort /*country year*/ hid pid

save "$DATA/BE_euromod_hhcomp", replace // Save before identifying the relationships within HH 
//}

**# 	RELATIONS within HOUSEHOLDS ***


	* create child ID variables for mothers - creates a dataset
run "$CODE/FHT_mothers_euromod.do"

	* create child ID variables for fathers - creates a dataset
run "$CODE/FHT_fathers_euromod.do"

	* merge mothers & fathers datasets
run "$CODE/FHT_parents_euromod.do"

	* identify unrelated individuals
run "$CODE/FHT_unrelated_euromod.do"
	
	* identify siblings
run "$CODE/FHT_siblings_euromod.do"

	* identify grandparents
run "$CODE/FHT_grandparents_euromod.do"

**# 	Families in Households Typology (FHT) ***
run "$CODE/FHT_typology_euromod.do"


/*

**# 	Delete irrelevant datasets

foreach x of global wave {

	erase "$DATA/silc20`x'_mother.dta"
	erase "$DATA/silc20`x'_father.dta"
	erase "$DATA/silc20`x'_parents.dta"
	erase "$DATA/silc20`x'_unrelated.dta"
	erase "$DATA/silc20`x'_siblings.dta"
	erase "$DATA/silc20`x'_grandparent.dta"
	erase "$DATA/silc20`x'_hhcomp.dta" 
}
*/
