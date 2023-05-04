/*=========================================================================
DO FILE NAME:			covidSxs-codelist19-weightLossReducedAppetite
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-13
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for weight loss and reduced appetite
						 				
MORE INFORMATION:	Q. Exclude anorexia nervosa, as obviously a distinct entity?

					A. consider sens analysis dropping people with subsequent
						anorexia nervosa diagnosis
						exclude anorexia nervosa codes from main analysis
					
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-weightLossReducedAppetite-working
																
DO FILES NEEDED:	

ADO FILES NEEDED: 	

*=========================================================================*/

/*******************************************************************************
>> HOUSEKEEPING
*******************************************************************************/
version 15
clear all
capture log close

* create a filename global that can be used throughout the file
global filename "covidSxs-codelist19-weightLossReducedAppetite"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*weight loss*" "*weight reduc*" "*anorexi*" "*appetite*" "*under*weight*" "
local searchterm " `searchterm' "*lost weight*" "*loosing weight*" "*off food*" "*interest in food*" "

include "inc_search_snomedcodelist.do"

sort term
order code term_lc

* summarise number of codes
quietly describe
display "*** number of codes to review = `r(N)' ***"

compress


/*******************************************************************************
#2. Exclude obvioiusly irrelevant codes returned by the search
	- to make codes more specific
*******************************************************************************/
* review potential exclusions
list term if strmatch(term_lc,"*(procedure)") // drop
list term if strmatch(term_lc,"*(organism)") // no codes
list term if strmatch(term_lc,"*(qualifier value)") // drop
list term if strmatch(term_lc,"*(physical object)") // no codes
list term if strmatch(term_lc,"*structure*") // no codes
list term if strmatch(term_lc,"*observable entity*") // drop
list term if strmatch(term_lc,"*(product)") // drop
list term if strmatch(term_lc,"*(substance)") // drop

list term if strmatch(term_lc,"*region") // no codes

* define exclusions
local exterm " "*(procedure)"  "*(qualifier value)" "*(structure)" "*observable entity)*" "
local exterm " `exterm' "*(product)" "*(substance)" "*nervosa*" "
local exterm " `exterm' "*aids*" "*assessment*" "*anorexiant*" "
local exterm " `exterm' "*product*" "*to promote*" "*diabet*" "*dieting*" "*score*" "
local exterm " `exterm' "*advice for weight*" "*difficulty maintaining*" "
local exterm " `exterm' "*immunodefi*" "* intentional*" "intentional*" "*questionnaire*" "
local exterm " `exterm' "*anomalies*" "*attempted weight*" "
local exterm " `exterm' "*gestational*" "*fetal*" "*foetal*" "
local exterm " `exterm' "moderate*" "*encephalop*" "
local exterm " `exterm' "percentage*" "*target*" "*advised*" "
local exterm " `exterm' "*diet*" "*consultation*" "*process" "*assistance*" "
local exterm " `exterm' "*regimen*" "*sexual*" "*poison*" "*increased appetite*" "
local exterm " `exterm' "*appetite suppressant*" "*appetite control*" "
local exterm " `exterm' "*accident*" "

 
foreach word in `exterm' {
	display "`word'"
	list term if strmatch(term_lc,"`word'")
	drop if strmatch(term_lc,"`word'")
}






/*******************************************************************************
#3. Display candidate codes that will be imported to OpenCodelists
*******************************************************************************/
sort term
list term

* summarise number of codes
quietly describe


display "*** number of codes to review = `r(N)' ***"






/*******************************************************************************
#4. Cross check with other files
		- There are no relevant codelists to cross check with
*******************************************************************************/

/* N/A */



/*******************************************************************************
#5. Tidy up and save working codelist - codes from all sources
*******************************************************************************/
* reorder and sort
compress
order code term
keep code term


* save in csv format
export delimited using "../codelists/working/snomed-weightLossReducedAppetite-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



