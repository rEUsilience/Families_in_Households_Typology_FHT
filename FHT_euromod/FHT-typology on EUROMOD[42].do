
*******************
*** MOTHER-FILE ***
*******************

import delimited "C:\Users\tvanhavere\Documents\EUROMOD_RELEASES_I6.39+\Output\be_2019_std.txt", clear

gen inactive = inrange(les, 6, 9)|les==0|les==4

//Child ID variables for mother
	//This code creates child_id variables and links them to mothers in a wide format.

keep idperson idhh idpartner idmother idfather dag dgn les inactive

egen childrank = rank(-dag) if idmother!=0, by (idmother idhh) unique  //rank all children in the HH who have the same mother_id by age 

*** Dependent children ***

//number of dependent chuldren under 18 and 18-24 if in educaiton and living with their parents 

gen dc = (inrange(dag, 18, 24)) & inrange(les, 6, 9)|les==0|les==4 & idmother!=0 
//temporary dependent child variable (assigns 1 to all individuals in the household who are between 18 and 24 and is currently in education and living with their parents) 
	//Alzbeta also took inactives between 18 and 24 into account 
replace dc =  1 if dag < 18 & dag!=. & idmother!=0
egen depchild = sum (dc), by(idhh idmother)

label var depchild "Number of R's dependent children (18-24, inactive)"
drop dc

//flag the children who can be classified as dependent 
gen dep = inrange(dag, 0, 17) //inrange is used to check in Stata whether or not two values fall within a specific range 
replace dep = 1 if dep == 0 & inrange(dag, 18, 24) & inactive==1 & idmother!=0

//create children's IDs 

*The ID numbers of HH members who are childrne in the HH (live with their mother) will be turned into child ID variables. Enventually, mother_id will be named 'pid'

sort idhh
foreach i of numlist 1/30 { // 1/30 refers to the childrank. It's deliberately chosen high to account for the variation in the number of children per mother in each wave
	by idhh: gen double c`i'_id = idperson if childrank == `i' // create temporary child ID variables
	egen double child`i'_id = max(c`i'_id), by(idmother idhh) // this code stretches the temporary child ID variables across the household (i.e. long); this way the child ID variable will be added to the line of the mother's ID.
	format child`i'_id %12.0g
	drop c`i'_id
	
	* the same process is repeated for the identification of dependent children
	by idhh: gen double c`i'_dep = dep if childrank == `i'
	egen double child`i'_dep = max(c`i'_dep), by (idmother idhh)
	format child`i'_dep %12.0g
	drop c`i'_dep
}

drop idperson 
rename idmother idperson

egen po=tag(idhh idperson)

keep if po==1 //keeps only the selected observations
keep if idperson!=. & idperson!=0
keep idperson idhh child*_id child*_dep // keep only the important variables

save "C:\Users\tvanhavere\Documents\FHT werkmap\Data Mother", replace 
clear 

import delimited "C:\Users\tvanhavere\Documents\EUROMOD_RELEASES_I6.39+\Output\be_2019_std.txt", clear
		merge m:1 idperson idhh using "C:\Users\tvanhavere\Documents\FHT werkmap\Data Mother", keep (1 3)

drop _merge 

save "C:\Users\tvanhavere\Documents\FHT werkmap\MERGEFILE_MOTHER_BASEFILE", replace


*******************
*** FATHER-FILE ***
*******************


import delimited "C:\Users\tvanhavere\Documents\EUROMOD_RELEASES_I6.39+\Output\be_2019_std.txt", clear

gen inactive = inrange(les, 6, 9)|les==0|les==4

//Child ID variables for mother 

keep idperson idhh idpartner idmother idfather dag dgn les inactive


//child ID variables for father 

egen childrank = rank(-dag) if idfather!=0, by (idfather idhh) unique  //rank all children in the HH who have the same mother_id by age 

*** Dependent children ***

//number of dependent chuldren under 18 and 18-24 if in educaiton and living with their parents 

gen dc = (inrange(dag, 18, 24)) & inrange(les, 6, 9)|les==0|les==4 & idfather!=0 //temporary dependent child variable (assigns 1 to all individuals in the household who are between 18 and 24 and is currently in education and living with their parents) 
	//Alzbeta also took inactives between 18 and 24 into account 
replace dc = 1 if dag < 18 & dag!=. & idfather!=0
egen depchild = sum (dc), by(idhh idfather)

label var depchild "Number of R's dependent children (18-24, in education)"
drop dc


//flag the children who can be classified as dependent 
gen dep = inrange(dag, 0, 17) //inrange is used to check in Stata whether or not two values fall within a specific range 
replace dep = 1 if dep == 0 & inrange(dag, 18, 24)==0 & inactive==1 & idfather!=0

//create children's IDs 

*The ID numbers of HH members who are childrne in the HH (live with their mother) will be turned into child ID variables. Enventually, mother_id will be named 'pid'

sort idhh
foreach i of numlist 1/30 { // 1/30 refers to the childrank. It's deliberately chosen high to account for the variation in the number of children per father in each wave
	by idhh: gen double c`i'_id = idperson if childrank == `i' // create temporary child ID variables
	egen double f_child`i'_id = max(c`i'_id), by (idfather idhh) // this code stretches the temporary child ID variables across the household (i.e. long); this way the child ID variable will be added to the line of the father's ID.
	format f_child`i'_id %12.0g
	drop c`i'_id
	
	* the same process is repeated for the identification of dependent children
	by idhh: gen double c`i'_dep = dep if childrank == `i'
	egen double f_child`i'_dep = max(c`i'_dep), by (idfather idhh)
	format f_child`i'_dep %12.0g
	drop c`i'_dep
}

drop idperson 
rename idfather idperson

egen po = tag (idhh idperson)

keep if po==1
keep if idperson!=. & idperson!=0

keep idperson idhh f_child*_id f_child*_dep // keep only the important variables

save "C:\Users\tvanhavere\Documents\FHT werkmap\Data Father", replace

use  "C:\Users\tvanhavere\Documents\FHT werkmap\MERGEFILE_MOTHER_BASEFILE", clear
		merge m:1 idperson idhh using "C:\Users\tvanhavere\Documents\FHT werkmap\Data Father"

drop _merge 

save "C:\Users\tvanhavere\Documents\FHT werkmap\Baseline_FHT", replace

*** renaming child variable for the father 
sort idhh idperson 

foreach i of numlist 1/30 { // 1/30 refers to the childrank. It's deliberately chosen high to account for the variable number of children per parent in each HH
	replace child`i'_id = f_child`i'_id if dgn == 1 // replace the missing values of child*_id with f_child*_id for fathers
	drop f_child`i'_id
	
	replace child`i'_dep = f_child`i'_dep if dgn == 1 
	drop f_child`i'_dep
	}

save "C:\Users\tvanhavere\Documents\FHT werkmap\Baseline_FHT", replace


*** Calculate number of household members

use "C:\Users\tvanhavere\Documents\FHT werkmap\Baseline_FHT", clear



***********************************************
*** 	identify UNRELATED members of HH 	***
***********************************************

//drop hx040

bys idhh: egen hx040 = count(idhh)

//generate unrelated persons: person who does not live alone, but does not cohabit with their morher, father, partner or a child
gen unrel = (idmother == 0 & idfather == 0 & idpartner == 0 & child1_id == . & hx040 != 1)

egen unrelated = max(unrel), by(idhh)

*******************************
*** 	SIBLINGS ID 		***
*******************************

* number of maternal siblings (i.e. share mother)

egen sib = rank(idperson) if idmother != 0, by(idmother idhh)
egen sib2 = rank(idperson) if idmother == 0 & idfather != 0, by(idhh idfather)

//replace sib = sib2 if sib == . & sib2 != . 

egen siblings = max(sib) if idmother != 0, by(idmother idhh)
egen siblings2 = max(sib2) if idmother == 0 & idfather != 0, by(idhh idfather)

replace siblings = siblings2 if siblings == . & siblings2 != .
replace siblings = siblings - 1 if siblings != . // to indicate how many siblings R has in the HH
replace siblings = 0 if siblings == .

lab var siblings "Number of siblings in the HH"

drop sib sib2 siblings2

* rank the siblings to create their ID
egen sibrank = rank(idperson) if siblings != 0 & idmother != 0, by(idhh idmother)
egen sibrank2 = rank(idperson) if siblings != 0 & idmother == 0, by(idhh idfather)

replace sibrank = sibrank2 if sibrank == . & sibrank2 != .
drop sibrank2


* create each sibling's ID - maternal siblings
sort idhh idmother
foreach i of numlist 1/12 {
	
	by idhh idmother: gen long sib`i'_id = idperson if sibrank == `i' 
	
	egen long sibling`i'_id = max(sib`i'_id), by(idmother idhh)
	egen long sibling`i'_id2 = max(sib`i'_id), by(idfather idhh)
	
	replace sibling`i'_id = sibling`i'_id2 if idmother == 0 & idfather != 0 & sibling`i'_id == .
	
	replace sibling`i'_id = . if sibling`i'_id == idperson
	
	drop sib`i'_id sibling`i'_id2
}

sort idhh idperson 

***********************************
*** 	GRANDPARENTS in HH 		***
***********************************

gen gp = ((idmother != 0 | idfather != 0) & child1_id != .)
egen grandparent = max(gp), by(idhh)

***************************************************
*** 	Families in Households Typology (FHT) 	***
***************************************************


/*

*/


gen sp = (child1_id != .)
egen single_parents = total(sp), by(idhh)
lab var single_parents "Number of single parents in the HH"

gen prtnr = (idpartner != 0)
egen partners = total(prtnr), by(idhh)
lab var partners "Number of persons with partners in the HH"
 

gen typ_7 = 1 			if hx040 == 1 // single person household
replace typ_7 = 2 		if hx040 == 2 & idpartner != 0 // couples
replace typ_7 = 3 		if child1_id != . & idpartner == 0 & idmother == 0 & idfather == 0 & unrelated == 0 // single parent
replace typ_7 = 4 		if child1_id != . & idpartner != 0 & idmother == 0 & idfather == 0 & unrelated == 0 // couple with child(ren)
replace typ_7 = 5		if child1_id != . & idpartner == 0 & (idmother != 0 | idfather != 0) & unrelated == 0 // single parent & grandparent
replace typ_7 = 6 		if child1_id != . & idpartner != 0 & (idmother != 0 | idfather != 0) & unrelated == 0 // couple with child(ren) & grandparent

egen fht7 = max(typ_7), by(idhh)
replace fht7 = 7 		if fht7 == .

lab var fht7 "Families in Household Typology (7 categories)" 
lab def fht7_l 1 "Single adult HH" 2 "Couples" 3 "Single parents" 4 "Couples with children" 5 "Single parents, grandparents" 6 "Couples with children, grandparents" 7 "Other"
lab val fht7 fht7_l 

egen dc = rowtotal(child*_dep)
egen depchild = max(dc), by(idhh)

egen dependent_child = max(depchild), by(idhh)
lab var dependent_child "Number of dependent children in the HH"

egen sibs = max(siblings), by(idhh)

gen parent = (child1_id != .)

gen complex = (parent == 1 & siblings != 0)
egen complex_hh = max(complex), by(idhh)
lab var complex_hh "Potentially complex HH"

* single person HH
gen typ_11 = 1 			if hx040 == 1 

* couples
replace typ_11 = 2 		if hx040 == 2 & idpartner != 0 

* single parent w/dependent children (i.e. at least one dependent child in the HH)
replace typ_11 = 3 		if child1_id != . & idpartner == 0 & idmother == 0 & idfather == 0 & unrelated == 0 & depchild != 0 & single_parents == 1 & partners == 0 

* single parent w/adult children (i.e. all children in the HH are non-dependent)
replace typ_11 = 4 		if child1_id != . & idpartner == 0 & idmother == 0 & idfather == 0 & unrelated == 0 & dependent_child == 0 & single_parents == 1 & partners == 0 

* couple w/dependent children (i.e. at least one dependent child in the HH)
replace typ_11 = 5 		if child1_id != . & idpartner != 0 & idmother == 0 & idfather == 0 & unrelated == 0 & depchild != 0 & partners == 2 & grandparent == 0

//replace typ_11 = 5 if child1_id != . & idpartner != 0 & unrelated == 0 & depchild != 0 & partners == 2 & sibs == 0 & grandparent == 0

* couple w/adult children (i.e. all children in the HH are non-dependent)
replace typ_11 = 6 		if child1_id != . & idpartner != 0 & idmother == 0 & idfather == 0 & unrelated == 0 & depchild == 0 & partners == 2 & grandparent == 0

* single parent w/dependent children & grandparents
replace typ_11 = 7		if child1_id != . & idpartner == 0 & (idmother != 0 | idfather != 0) & unrelated == 0 & depchild != 0 & grandparent == 1 & complex_hh == 0

* single parent w/adult children & grandparents
replace typ_11 = 8		if child1_id != . & idpartner == 0 & (idmother != 0 | idfather != 0) & unrelated == 0 & dependent_child == 0 & grandparent == 1 & complex_hh == 0

* couple w/dependent children & grandparents
replace typ_11 = 9 		if child1_id != . & idpartner != 0 & (idmother != 0 | idfather != 0) & unrelated == 0 & depchild != 0 & grandparent == 1 & complex_hh == 0

* couple w/adult children & grandparent
replace typ_11 = 10 	if child1_id != . & idpartner != 0 & (idmother != 0 | idfather != 0) & unrelated == 0 & dependent_child == 0 & grandparent == 1 & complex_hh == 0

* other types of households
replace typ_11 = 11 	if child1_id != . & idmother == 0 & idfather == 0 & idpartner == 0 & !inrange(typ_11,1,4)

							
egen fht11 = max(typ_11), by(idhh)
* other types of households
replace fht11 = 11		if fht11 == .


lab var fht11 "Families in Household Typology (11 categories)" 
lab def fht11_l 1 "Single adult HH" 2 "Couples" 3 "Single parents with dependent child" 4 "Single parents with adult child" 5 "Couples with dependent children" 6 "Couples with adult children" 7 "Single parents with dependent children, grandparents" 8 "Single parents with adult children, grandparents" 9 "Couples with dependent children, grandparents" 10 "Couples with adult chilren, grandparents" 11 "Other"
lab val fht11 fht11_l 
