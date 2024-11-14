***********************************************************
*** 	CWF Research Note: Response to the reviewers 	***
***********************************************************



*** 	REVIEWER 1 	***

/*		COMMENT:
		With respect to the differentiation between dependent and adult children, 
		I was surprised that single parents with adult children outnumber single 
		parents with dependent children (see Table 2). Usually, you would expect 
		most children to move out of the parental home once they become economically 	
		independent, and therefore families with dependent children should be more 
		frequent than those with adult children. In the other categories (couple 
		parents and multigenerational families), the categories with dependent 
		children indeed by far outweigh those with adult children. Therefore, 
		I was wondering if the values for the single parents are correct?
*/ 

/* 		RESPONSE: 
		
		
		Children are also returning to their parental home. We suspect that if 
		this is the case, we will be able to observe higher prevalence of single 
		parents with adult children in countries where this strategy is more common.
		
		Note: see the literature for more reference
*/

egen po = tag(country hid) // select one person per household per country

fre fht11 if country != "IT" & po == 1 // check whether single parents with adult children indeed outnumber single parents with dependent children
// yes, they do

* What is the distribution of single parents with dependent and adult children across countries?
tab country fht11 if inlist(fht11,3,4) & po == 1 & country != "IT", col nof

* What is the number of observations that might be incorrectly classified as "single parent with adult child"?
	/* 	there are two ways a household could be incorrectly classified as "single 
		parent with adult child" category:
		(1) Mistake in identifying adult children living with a single parent 
				- if lives with both parents 
				- doesn't live with any of their parents and has no child
				- if the adult child has a child themselves 	
	*/
count if country != "IT" & fht11 == 4 & mother_id == . & father_id == . & child1_id == .
count if country != "IT" & fht11 == 4 & mother_id != . & father_id != . & child1_id == .

	/*  (2) Mistake in identifying a single parent with a child		 */
count if country != "IT" & fht11 == 4 & child1_id == . & mother_id == . & father_id == . & partner_id != . // parent's perspective

// we didn't find any misclassification

tab country fht11 if inlist(fht11,3,4) & po == 1 & country != "IT", col nof // are single parents with dependent/adult children more common in some countries than other?


* Include row percentages
	* Table 1
	
tab hx060 fht11 if country != "IT" & po == 1, row nof

tab hb110 fht11 if country != "IT" & po == 1, row nof
