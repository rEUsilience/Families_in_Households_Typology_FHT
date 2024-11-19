***********************************************
*** 	CHILD ID variables for FATHERS 		***
***********************************************

/* 
		This code creates child_id variables and links them to fathers in a wide format. 
		
		The code includes all children, including adult children. 
*/


foreach x of global wave {
use "$DATA/silc20`x'_hhcomp", clear

keep country year hid pid partner_id father_id father_id age sex inactive // keep only the necessary variables 


**# 		Rank Children

/* 	All children in the HH are ranked from oldest to the youngest by father_id. 
	The rank number will be then used in numbering children's ID variables.
	Example: rank = 1 => child1_id = ID number of the woman's first child who live with her in the household
*/

egen childrank = rank(-age) if father_id != ., by(father_id hid country year) unique // rank all the children in the HH who have the same "father_id" by age from the oldest to the youngest
//fre childrank



**#			Dependent children

/*
* number of dependent children = under 18 & 18-24 if inactive and living with their parent/s
gen dc = (inrange(age,18,24) & inrange(pl031,6,10) & father_id != . // creates temporary 'dependent child' variable (dc). It assigns value of 1 to all individuals in the household who is between the age of 18 and 24, is currently economically inactive and lives with their father or father 
replace dc = 1 	if age < 18 & age != . & father_id != .
egen depchild = sum(dc), by(hid father_id country year) 

lab var depchild "Number of R's dependent children (18-24, inactive)"
drop dc
*/

* flag the children who can be classified as dependent
gen dep = inrange(age,0,17) 
//replace dep = 1 if dep == 0 & inrange(age,18,24) & inrange(inactive,6,11) & father_id != .
replace dep = 1 if dep == 0 & inrange(age,18,24) & inactive == 1 & father_id != .


**# 		Create children's IDs

/* 		The ID numbers of HH members who are children in the HH (i.e. live with their father) 
		will be turned into child ID variables. Eventually, "father_id" will be renamed to 
		"pid" and linked the original dataset. 
		
		This will produce a set of child ID variables for those respondents who are women 
		and live with their children. 
*/

sort country year hid
foreach i of numlist 1/30 { // 1/30 refers to the childrank. It's deliberately chosen high to account for the variation in the number of children per father in each wave
	by country year hid: gen double c`i'_id = pid if childrank == `i' // create temporary child ID variables
	egen double f_child`i'_id = max(c`i'_id), by(father_id country year hid) // this code stretches the temporary child ID variables across the household (i.e. long); this way the child ID variable will be added to the line of the father's ID.
	format f_child`i'_id %12.0g
	drop c`i'_id
	
	* the same process is repeated for the identification of dependent children
	by country year hid: gen double c`i'_dep = dep if childrank == `i'
	egen double f_child`i'_dep = max(c`i'_dep), by (father_id country year hid)
	format f_child`i'_dep %12.0g
	drop c`i'_dep
}


* to link the children's information to father, drop the child's pid and turn father_id into a pid 
drop pid
rename father_id pid // renames father_id into pid so it can be merged with the original dataset

egen po = tag(country year hid pid) // tags one observation per pid (formerly father_id), household, country and year

keep if po == 1 // keeps only the selected observarvations
keep pid hid country year f_child*_id f_child*_dep // keep only the important variables

**#  		Save dataset

save "$DATA/silc20`x'_father", replace // creates dataset of fathers, which will be merged with the "silc`wave'_mother.dta" in "REU_SILC_CS_hhcomp_parents.do"

/* 		Contrary to "REU_SILC_CS_hhcome_mothers", the newly created dataset is not merged with the original dataset. 
		Instead it will merge with the "silc20`x'_mother.dta" in the next do-file (REU_SILC_CS_hhcomp_parents).
*/

}


