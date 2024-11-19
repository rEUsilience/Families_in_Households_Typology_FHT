***********************************************
*** 	identify UNRELATED members of HH 	***
***********************************************

/*
		This code identifies people who are not related to anyone in the household.
		
		Unrelated person is a person who does not live alone, but does not cohabit
		with their mother, father, partner or a child. 
		
		Limitations: 
		The number of unrelated persons in EU-SILC are likely to be overestimated.
		Some people can still be related but this relationship couldn't be detected
		with the data. For example, siblings can only be detected if they share the 
		household with at least one of their parents. 
		
*/


//foreach x of global wave {

use "$DATA/BE_euromod_parents.dta", clear

bys hid: egen hx040 = count(hid)

gen unrel = (mother_id == . & father_id == . & partner_id == . & child1_id == . & hx040 != 1)

egen unrelated = max(unrel), by(/*country year*/ hid)

save "$DATA/BE_euromod_unrelated.dta", replace

//}
