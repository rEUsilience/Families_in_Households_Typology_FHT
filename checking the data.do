
use "$DATA/silc2021_FHT.dta", clear

egen po = tag(country year hid) // select one observation per HH

tab hx060 fht11 if country != "IT" & po == 1

tab hb110 fht11 if po == 1



browse country hid pid age mother_id father_id partner_id child1_id unrelated ///
partners siblings grandparent dc dependent_child depchild single_parents hx040 /// 
fht11 hx060 inactive single parent complex_hh ///
if fht11 == 3 & hx060 == 10
