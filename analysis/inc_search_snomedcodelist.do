/*=========================================================================
DO FILE NAME:			inc_search_snomedmedcodelist.doi

AUTHOR:					Kate Mansfield		
VERSION:				v1
DATE VERSION CREATED: 	2022-May-11
					
DATABASE:	uses snomed code list file with the following variables:
				- code
				- concept_is_active
				- term
				- term_is_active
				- term_is_fsn
				
		Dataset contains one row for each term in SNOMED.  
		A concept can have multiple terms.  
		Concepts and terms can be active or inactive.  
		For almost every active concept, there is a exactly one special active 
		term, called the "fully specified name" -- this is indicated by the is_fsn column.
	
DESCRIPTION OF FILE:	
			aim: given a list of search terms identifies matching codes

			Search terms are a list of specific conditions
			These search terms are used to identify records within the term 
			variable

DATASETS USED: snomedct.csv
									
DATASETS CREATED: 
	creates a dataset containing records for any snomed terms matching the
	supplied search terms in any of the following var: term
	and any records where codes match the supplied search codes.
	
HOW TO USE:
	need to have declared the following local macros:
		searchterm // list of search strings to use to search the clinical term variable
		searchcode // list of codes to use to search the code variable


*=========================================================================*/



/*******************************************************************************
#inc1. OPEN DATA AND PREP FOR SEARCH
*******************************************************************************/
import delimited using "../codelists/snomedct.csv", delimiters(",") clear stringcols(1) bindquotes(strict)

* Make readterm lower case
generate term_lc=lower(term)



/*******************************************************************************
#inc3. WORD SEARCH
*******************************************************************************/
* Search productname and drugsubstance variables for words in the searchterm string
generate disease=.
foreach word in `searchterm' {
	replace disease=1 if strmatch(term_lc, "`word'")
}




/*******************************************************************************
#inc4. Search for any specified Read codes
*******************************************************************************/
foreach code in `searchcode' {
	replace disease=1 if strmatch(code, "`code'")
}




/*******************************************************************************
#inc5. Sort
*******************************************************************************/
keep if disease==1
drop disease



* end
