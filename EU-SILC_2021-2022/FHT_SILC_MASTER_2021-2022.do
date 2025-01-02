*******************************************************************
*** 	Families in Households Typology (FHT): MASTER file 		***
*******************************************************************


/*
		
		Author: 	Alzbeta Bartova, Center for Sociological Research (CESO), KU Leuven
		
		Description: 	This code creates household typology based on familial relations
						using the EU-SILC cross-sectional files. It's written in Stata 
						and covers data from between 2010 and 2020. 
		
		License: 	
		
		Citation: 
		
		Data: 	EU-SILC 	
		
 
*/



clear all
version 17.0 // set Stata version


* install if needed
//ssc install egenmore
//ssc install fre
//ssc install confirmdir


**#		 Macros

global SILC "/Users/alzbeta/Documents/Data/EU-SILC_merged" // to call the original SILC data
global DATA "/Users/alzbeta/Documents/Data/EU-SILC/FHT_SILC" // to save the created data files
global CODE "/Users/alzbeta/Library/CloudStorage/Box-Box/WORK/_KU LEUVEN/rEUsilience/Families_in_Households_Typology_FHT/EU-SILC_2021-2022" // folder where the code is stored


**# 	PREPARATION FOR FHT AND CONSTRUCTION OF FHT

global wave "22" // to switch between waves

//The following code can only be used once!
/*
foreach x of global wave {
	use "$SILC/SILC20`x'_ver_2023_release2", clear 
	gen inactive = inrange(pl032,3,8)
	save "$SILC/SILC20`x'_ver_2023_release2", replace
}
*/

foreach x of global wave {
**# 	Data Input
use "$SILC/SILC20`x'_ver_2023_release2", clear 


**# 	Country selection & rename key variables

		/* 		NOTE: 	Due to anonymisation, Malta doesn't use some of the crucial variables (age) and categorises others (year of birth).
						Malta is excluded from the analysis until we decide what to do with this issue. 	
		*/

		* drop Malta
		drop if country == "MT"

		* drop Serbia
		//drop if country == "RS"

	** rename ID & crucial variables 

		rename rb220 father_id
		replace father_id = . 		if rb220_f == -1 
		rename rb230 mother_id
		replace mother_id = . 		if rb230_f == -1
		rename rb240 partner_id
		replace partner_id = . 		if rb240_f == -1

		rename rx010 age
		rename rb090 sex
		
	** missing values on "age" => replace missing values with estimate based on year of birth
		replace age = (year - rb080) if age == .
		replace age = 0 if age == (-1)
	
**# 	HOUSEHOLD COMPOSITION

sort country year hid pid

save "$DATA/silc20`x'_hhcomp", replace // Save before identifying the relationships within HH 
}

**# 	RELATIONS within HOUSEHOLDS ***


	* create child ID variables for mothers - creates a dataset
run "$CODE/FHT_SILC_2021-2022_mothers.do"

	* create child ID variables for fathers - creates a dataset
run "$CODE/FHT_SILC_2021-2022_fathers.do"

	* merge mothers & fathers datasets
run "$CODE/FHT_SILC_2021-2022_parents.do"

	* identify unrelated individuals
run "$CODE/FHT_SILC_2021-2022_unrelated.do"
	
	* identify siblings
run "$CODE/FHT_SILC_2021-2022_siblings.do"

	* identify grandparents
run "$CODE/FHT_SILC_2021-2022_grandparents.do"

**# 	Families in Households Typology (FHT) ***
run "$CODE/FHT_SILC_2021-2022_typology.do"




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
