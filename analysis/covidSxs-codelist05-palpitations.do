/*=========================================================================
DO FILE NAME:			covidSxs-codelist05-palpitations

AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-May-18
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for palpitations
						 				
MORE INFORMATION:	
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-palpitations-working
																
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
global filename "covidSxs-codelist05-palpitations"

* open log file
log using "../logs/${filename}", text replace






/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*palpitat*" "*irregular heart*" "*heart irreg*" "
local searchterm " `searchterm' "*flutter*" "*dropped beat*" "*heart pound*" "
local searchterm " `searchterm' "*pounding heart*" "
local searchterm " `searchterm' "*heart bump*" "*fibrillat*" "*awareness of heart*" "
local searchterm " `searchterm' "*aware of heart*" "*a-fib*" "* af *" "


include "inc_search_snomedcodelist.do"






/*******************************************************************************
#2. Exclude obvioiusly irrelevant codes returned by the search
	- to make codes more specific
*******************************************************************************/
* dropped assessments and investigations as these do not confirm symptoms
local exterm " "*ocular*" "*defibrill*" "*deactivat*" "
local exterm " `exterm' "*at risk*" "*high risk*" "
local exterm " `exterm' "*oscillometric blood pressure monitor*" "
local exterm " `exterm' "*quality and outcomes framework*" "*quality indicators*" "
local exterm " `exterm' "*monitoring*" "*(administrative concept)*" "
local exterm " `exterm' "*percutaneous transluminal*" "*fibrillator*" "
local exterm " `exterm' "*provision of written information*" "
local exterm " `exterm' "*oscillating positive*" "*diaphragmatic*" "*family history*" "
local exterm " `exterm' "*pacemaker*" "h/o*" "history of*" "*eye*" "*muscle fibrillation*" "
local exterm " `exterm' "*neonatal*" "*resolved*" "*not detected*" "assessment using*" "
local exterm " `exterm' "*excluded*" "*gfr calctd*" "
local exterm " `exterm' "*fontanelle*" "
local exterm " `exterm' "*bleeding risk score*" "

foreach word in `exterm' {
	display "`word'"
	list term if strmatch(term_lc,"`word'")
	drop if strmatch(term_lc,"`word'")
}

sort term
list code term

* summarise number of codes
describe
display "*** number of codes to review = `r(N)' ***"




/*******************************************************************************
#3. Cross check with other files
		- There are no relevant codelists to cross check with
*******************************************************************************/

/* N/A */



/*******************************************************************************
#4. Tidy up and save working codelist - codes from all sources
*******************************************************************************/
* reorder and sort
order code term

keep code term


* save in csv format
export delimited using "../codelists/working/snomed-palpitations-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



