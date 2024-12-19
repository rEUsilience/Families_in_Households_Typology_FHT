*** Merge Belgian SILC and Euromod files

use "/Users/alzbeta/Documents/Data/EU-SILC_merged/SILC2019_ver_2023_release1.dta", clear

keep if country == "BE"

save "/Users/alzbeta/Documents/Data/EU-SILC_merged/SILC2019_BE.dta", replace

drop _merge
mer 1:1 hid pid using "/Users/alzbeta/Documents/Data/EU-SILC/FHT_SILC/BE_euromod_hhcomp.dta", keep(1 3)


*** compare FHT's

use "/Users/alzbeta/Documents/Data/EU-SILC/FHT_SILC/BE_euromod__FHT.dta", clear

rename partner_id id_partner
rename mother_id id_mother
rename father_id id_father

save "/Users/alzbeta/Documents/Data/EU-SILC/FHT_SILC/BE_euromod_fhttest.dta", replace

use "/Users/alzbeta/Documents/Data/EU-SILC/FHT_SILC/silc2019_FHT", clear

keep if country == "BE"
rename fht7 fht7_eusilc
lab var fht7_eusilc "FHT7 eusilc"
rename fht11 fht11_eusilc
lab var fht11_eusilc "FHT11 eusilc"

save "/Users/alzbeta/Documents/Data/EU-SILC/FHT_SILC/silc2019_FHT_BE.dta", replace

mer 1:1 hid pid using "/Users/alzbeta/Documents/Data/EU-SILC/FHT_SILC/BE_euromod_fhttest.dta", keep(1 3)


tab fht7_eusilc fht7, m
