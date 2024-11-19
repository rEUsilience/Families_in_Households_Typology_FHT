***************************************************
*** 	Families in Households Typology (FHT) 	***
***************************************************


/*

*/


foreach x of global wave {

use "$DATA/BE_euromod_grandparent.dta", clear

browse /*country year*/ hid pid mother_id father_id partner_id child1_id hx040

gen sp = (child1_id != .)
egen single_parents = total(sp), by(/*country year*/ hid)
lab var single_parents "Number of single parents in the HH"

gen prtnr = (partner_id != .)
egen partners = total(prtnr), by(/*country year*/ hid)
lab var partners "Number of persons with partners in the HH"
 

gen typ_7 = 1 			if hx040 == 1 // single person household
replace typ_7 = 2 		if hx040 == 2 & partner_id != . // couples
replace typ_7 = 3 		if child1_id != . & partner_id == . & mother_id == . & father_id == . & unrelated == 0 // single parent
replace typ_7 = 4 		if child1_id != . & partner_id != . & mother_id == . & father_id == . & unrelated == 0 // couple with child(ren)
replace typ_7 = 5		if child1_id != . & partner_id == . & (mother_id != . | father_id != .) & unrelated == 0 // single parent & grandparent
replace typ_7 = 6 		if child1_id != . & partner_id != . & (mother_id != . | father_id != .) & unrelated == 0 // couple with child(ren) & grandparent

egen fht7 = max(typ_7), by(/*country year*/ hid)
replace fht7 = 7 		if fht7 == .

lab var fht7 "Families in Household Typology (7 categories)" 
lab def fht7_l 1 "Single adult HH" 2 "Couples" 3 "Single parents" 4 "Couples with children" 5 "Single parents, grandparents" 6 "Couples with children, grandparents" 7 "Other"
lab val fht7 fht7_l 

egen dc = rowtotal(child*_dep)
egen depchild = max(dc), by(/*country year*/ hid)

egen dependent_child = max(depchild), by(/*country year*/ hid)
lab var dependent_child "Number of dependent children in the HH"

egen sibs = max(siblings), by(/*country year*/ hid)

gen parent = (child1_id != .)
lab var parent "R is a parent"

gen complex = (parent == 1 & siblings != 0)
egen complex_hh = max(complex), by(/*country year*/ hid)
lab var complex_hh "Potentially complex HH"

* single person HH
gen typ_11 = 1 			if hx040 == 1 

* couples
replace typ_11 = 2 		if hx040 == 2 & partner_id != . 

* single parent w/dependent children (i.e. at least one dependent child in the HH)
replace typ_11 = 3 		if child1_id != . & partner_id == . & mother_id == . & father_id == . ///
						& unrelated == 0 & depchild != 0 & single_parents == 1 & partners == 0 

* single parent w/adult children (i.e. all children in the HH are non-dependent)
replace typ_11 = 4 		if child1_id != . & partner_id == . & mother_id == . & father_id == . /// 
						& unrelated == 0 & dependent_child == 0 & single_parents == 1 & partners == 0 

* couple w/dependent children (i.e. at least one dependent child in the HH)
replace typ_11 = 5 		if child1_id != . & partner_id != . & mother_id == . & father_id == . /// 
						& unrelated == 0 & depchild != 0 & partners == 2 & grandparent == 0

//replace typ_11 = 5 		if child1_id != . & partner_id != . & unrelated == 0 & depchild != 0 & partners == 2 & sibs == 0 & grandparent == 0

* couple w/adult children (i.e. all children in the HH are non-dependent)
replace typ_11 = 6 		if child1_id != . & partner_id != . & mother_id == . & father_id == . /// 
						& unrelated == 0 & depchild == 0 & partners == 2 & grandparent == 0

* single parent w/dependent children & grandparents
replace typ_11 = 7		if child1_id != . & partner_id == . & (mother_id != . | father_id != .) /// 
						& unrelated == 0 & depchild != 0 & grandparent == 1 & complex_hh == 0

* single parent w/adult children & grandparents
replace typ_11 = 8		if child1_id != . & partner_id == . & (mother_id != . | father_id != .) /// 
						& unrelated == 0 & dependent_child == 0 & grandparent == 1 & complex_hh == 0

* couple w/dependent children & grandparents
replace typ_11 = 9 		if child1_id != . & partner_id != . & (mother_id != . | father_id != .) /// 
						& unrelated == 0 & depchild != 0 & grandparent == 1 & complex_hh == 0

* couple w/adult children & grandparent
replace typ_11 = 10 		if child1_id != . & partner_id != . & (mother_id != . | father_id != .) ///
							& unrelated == 0 & dependent_child == 0 & grandparent == 1 & complex_hh == 0

* other types of households
//replace typ_11 = 11 		if child1_id != . & mother_id == . & father_id == . & partner_id == . & !inrange(typ_11,1,4)

							
egen fht11 = max(typ_11), by(/*country year*/ hid)
* other types of households
replace fht11 = 11		if fht11 == .


lab var fht11 "Families in Household Typology (11 categories)" 
lab def fht11_l 1 "Single adult HH" 2 "Couples" 3 "Single parents with dependent child" 4 "Single parents with adult child" 5 "Couples with dependent children" 6 "Couples with adult children" 7 "Single parents with dependent children, grandparents" 8 "Single parents with adult children, grandparents" 9 "Couples with dependent children, grandparents" 10 "Couples with adult chilren, grandparents" 11 "Other"
lab val fht11 fht11_l 

save "$DATA/BE_euromod__FHT.dta", replace

}
