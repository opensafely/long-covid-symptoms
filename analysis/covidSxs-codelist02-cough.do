/*=========================================================================
DO FILE NAME:			covidSxs-codelist02-cough

AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-May-18
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for cough
						 				
MORE INFORMATION:	
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-cough-working
																
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
global filename "covidSxs-codelist02-cough"

* open log file
log using "../logs/${filename}", text replace






/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " 	"*cough*" "

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
local exterm " "*no cough*" "*administration of *" "
local exterm " `exterm' "*hiccough *" "hiccough*" "* hiccough*" "psychogenic hiccough*" "
local exterm " `exterm' "*no hiccough*" "hiccough*" "[d]hiccough*" "*psychogenic hiccough*" "
local exterm " `exterm' "* hiccoughs *" "*chronic hiccough*" "*cough reflex*" "
local exterm " `exterm' "*hereditary sensory and autonomic neuropathy*" "*ultrasonic*" "
local exterm " `exterm' "*vaccination*" "*hernia*" "*cough impulse*" "
local exterm " `exterm' "*adverse reaction" "*adverse reaction" "*coughguard*" "
local exterm " `exterm' "*whooping*" "*absent*" "*fistula*" "*vocal cord*" "
local exterm " `exterm' "*morphinian*" "*cough suppressant allergy*" "
local exterm " `exterm' "*arnold's nerve*" "collection of*" "cough culture*" "
local exterm " `exterm' "*kennel cough*" "*morphinan*" "tea-factory*" "tea-taster*" "
local exterm " `exterm' "*weaver*" "

foreach word in `exterm' {
	display "`word'"
	list term if strmatch(term_lc,"`word'")
	drop if strmatch(term_lc,"`word'")
}




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
export delimited using "../codelists/working/snomed-cough-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



