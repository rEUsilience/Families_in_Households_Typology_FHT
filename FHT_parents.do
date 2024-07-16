***********************************************
*** 	Merge MOTHER and FATHER datasets 	***
***********************************************

/*
		In the previous steps (FHT_mothers & FHT_fathers) we created children's ID variables and assigned them to their mothers and fathers.
		This process created two datasets that 
*/


**# 		Merge the fathers' dataset with mothers's dataset

	* 	NOTE: "silc`wave'_mother.dta" (created in "REU_SILC_CS_hhcomp_mothers.do") & "silc`wave'_father.dta" (created in "REU_SILC_CS_hhcomp_fathers.do")

foreach x of global wave {
*** merge the dataset of fathers with the main dataset that already includes mothers (created in REU_SILC_CS_hhcomp_mothers.do)
use "$DATA/silc20`x'_mother.dta", clear

merge m:1 pid hid country year using "$DATA/silc20`x'_father.dta", keep(1 3) // this dataset was created in "REU_SILC_CS_hhcomp_fathers.do"
drop _merge 


sort country hid pid

**# 		Rename child's variables for fathers

	/* 		NOTE: 	the prefix "f_" was created for child's indicators among fathers. Without it, the information doesn't merge and the child ID values
					remain "." for fathers. The prefix makes sure that the information is merged properly. 
					I'm not sure why this is happening but using the prefix was an easy and quick solution. OPEN TO SUGGESTIONS !! 		
					
					This code is replacing the missing values on child's information among fathers with the values on variables 
					with prefix "f_" created in "REU_SILC_CS_hhcomp_fathers" */
					
					
foreach i of numlist 1/30 { // 1/30 refers to the childrank. It's deliberately chosen high to account for the variable number of children per parent in each HH
	
	replace child`i'_id = f_child`i'_id if sex == 1 // replace the missing values of child*_id with f_child*_id for fathers
	drop f_child`i'_id
	
	replace child`i'_dep = f_child`i'_dep if sex == 1 
	drop f_child`i'_dep
	}


**# 		Save the dataset		

save "$DATA/silc20`x'_parents.dta", replace

}
