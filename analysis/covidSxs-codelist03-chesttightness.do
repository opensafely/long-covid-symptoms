/*=========================================================================
DO FILE NAME:			covidSxs-codelist03-chesttightness.do

AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-May-18
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for chest tightness
						 				
MORE INFORMATION:	
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-chesttightness-working
																
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
global filename "covidSxs-codelist03-chesttightness"

* open log file
log using "../logs/${filename}", text replace






/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " 	"*chest tight*" "*tight chest*" "


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
* no obviously irrelevant terms to drop

sort term
list code term

* summarise number of codes
describe
display "*** number of codes to review = `r(N)' ***"



/*******************************************************************************
#3. Display candidate codes that will be imported to OpenCodelists
*******************************************************************************/
sort term
list code term

* summarise number of codes
describe
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
order code term

keep code term

* save in csv format
export delimited using "../codelists/working/snomed-chesttightness-working.csv", replace novarnames 

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



