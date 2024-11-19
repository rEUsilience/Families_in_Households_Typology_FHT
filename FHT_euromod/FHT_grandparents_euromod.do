***********************************
*** 	GRANDPARENTS in HH 		***
***********************************


foreach x of global wave {
	use "$DATA/BE_euromod_siblings.dta", clear

	gen gp = ((mother_id != . | father_id != .) & child1_id != .)

	egen grandparent = max(gp), by(/*country year*/ hid)
	
	save "$DATA/BE_euromod_grandparent.dta", replace

}
