***********************************************
*** 	CHILD ID variables for MOTHERS 		***
***********************************************


/* 
		This code creates child_id variables and links them to mothers in a wide format. 
		
		The code includes all children, including adult children. 
		
*/


//foreach x of global wave {
use "$DATA/BE_euromod_hhcomp", clear

keep hid pid partner_id mother_id father_id age sex inactive // keep only the necessary variables 


**# 		Rank Children

/* 	All children in the HH are ranked from oldest to the youngest by mother_id. 
	The rank number will be then used in numbering children's ID variables.
	Example: rank = 1 => child1_id = ID number of the woman's first child who live with her in the household
*/

egen childrank = rank(-age) if mother_id != ., by(mother_id hid /*country year*/) unique // rank all the children in the HH who have the same "mother_id" by age from the oldest to the youngest
//fre childrank



**#			Dependent children

/*
* number of dependent children = under 18 & 18-24 if inactive and living with their parent/s
gen dc = (inrange(age,18,24) & inrange(pl031,6,11) & mother_id != . // creates temporary 'dependent child' variable (dc). It assigns value of 1 to all individuals in the household who is between the age of 18 and 24, is currently economically inactive and lives with their mother or father 
replace dc = 1 	if age < 18 & age != . & mother_id != .
egen depchild = sum(dc), by(hid mother_id country year) 

lab var depchild "Number of R's dependent children (18-24, inactive)"
drop dc
*/

* flag the children who can be classified as dependent
gen dep = inrange(age,0,17) 
replace dep = 1 if dep == 0 & inrange(age,18,24) & inactive == 1 & mother_id != .


**# 		Create children's IDs

/* 		The ID numbers of HH members who are children in the HH (i.e. live with their mother) 
		will be turned into child ID variables. Eventually, "mother_id" will be renamed to 
		"pid" and linked the original dataset. 
		
		This will produce a set of child ID variables for those respondents who are women 
		and live with their children. 
*/

sort /*country year*/ hid
foreach i of numlist 1/30 { // 1/30 refers to the childrank. It's deliberately chosen high to account for the variation in the number of children per mother in each wave
	by /*country year*/ hid: gen double c`i'_id = pid if childrank == `i' // create temporary child ID variables
	egen double child`i'_id = max(c`i'_id), by(mother_id /*country year*/ hid) // this code stretches the temporary child ID variables across the household (i.e. long); this way the child ID variable will be added to the line of the mother's ID.
	format child`i'_id %12.0g
	drop c`i'_id
	
	* the same process is repeated for the identification of dependent children
	by /*country year*/ hid: gen double c`i'_dep = dep if childrank == `i'
	egen double child`i'_dep = max(c`i'_dep), by (mother_id /*country year*/ hid)
	format child`i'_dep %12.0g
	drop c`i'_dep
}


* to link the children's information to mother, drop the child's pid and turn mother_id into a pid 
drop pid
rename mother_id pid // renames mother_id into pid so it can be merged with the original dataset

egen po = tag(/*country year*/ hid pid) // tags one observation per pid (formerly mother_id), household, country and year

keep if po == 1 // keeps only the selected observarvations
keep pid hid /*country year*/ child*_id child*_dep // keep only the important variables

save "$DATA/mother_BE_euromod", replace // save temporary file only containing mothers for merging purposes


**# 		Merge the mother's dataset with the SILC dataset

*** merge the children with the mothers in the main dataset
use "$DATA/BE_euromod_hhcomp", clear
//drop _merge

merge m:1 pid hid /*country year*/ using "$DATA/mother_BE_euromod", keep(1 3)
drop _merge


**# 		Save dataset
save "$DATA/BE_euromod_mother", replace // dataset containing original data and basic information about children who live with their mother


erase "$DATA/mother_BE_euromod.dta" // delete useless files
//}

