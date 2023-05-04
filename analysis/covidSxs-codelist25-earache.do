/*=========================================================================
DO FILE NAME:			covidSxs-codelist25-earache
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-20
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for ear ache
						 				
MORE INFORMATION:	
					
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-earache-working
																
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
global filename "covidSxs-codelist25-earache"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*earache*" "*ear ache*" "*aching ear*" "*otalgia*" "*otitis*" "
local searchterm " `searchterm' "*ear pain*" "*painful ear*" "*pain in ear*" "
local searchterm " `searchterm' "*ear auricle pain*" "*painful ear auricle *" "

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
* define exclusions
local exterm " "*infect*" "*glue*" "*mumps*" "
local exterm " `exterm' "*suppurative*" "*allergic*" "history of*" "h/o*" "
local exterm " `exterm' "*chemical*" "*fungal*" "*irritant*" "
local exterm " `exterm' "*eczema*" "*mucoid*" "*myring*" "*necroti*" "
local exterm " `exterm' "*effusion*" "*purulent*" "*serous*" "
local exterm " `exterm' "*seborrheic*" "*adhesive*" "*barotitis*" "
local exterm " `exterm' "*fungus*" "*candid*" "*exudat*" "*mycotic*" "
local exterm " `exterm' "*viral*" "*catarrhal*" "*bacterial*" "
local exterm " `exterm' "*perforat*" "*grommet*" "
local exterm " `exterm' "*tube*" "*aero-otitis*" "*radiation*" "*externa*" "
local exterm " `exterm' "*secretory*" "*(organism)" "*no earache*" "
local exterm " `exterm' "*seromucin*" "*transuda*" "*alloioco*" "*parotitis*" "
local exterm " `exterm' "*measles*" "*serosang*" "*sanguinous*" "*influen*" "*notalgia*" "

foreach word in `exterm' {
	display "`word'"
	list term if strmatch(term_lc,"`word'")
	drop if strmatch(term_lc,"`word'")
}


list term if strmatch(term_lc,"*due to*") & strmatch(term_lc,"*coronavirus*")!=1 & strmatch(term_lc,"*cov*")!=1
drop if strmatch(term_lc,"*due to*") & strmatch(term_lc,"*coronavirus*")!=1 & strmatch(term_lc,"*cov*")!=1


list term if strmatch(term_lc,"*caused by*") & strmatch(term_lc,"*coronavirus*")!=1 & strmatch(term_lc,"*cov*")!=1
drop if strmatch(term_lc,"*caused by*") & strmatch(term_lc,"*coronavirus*")!=1 & strmatch(term_lc,"*cov*")!=1


	

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
export delimited using "../codelists/working/snomed-earache-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



