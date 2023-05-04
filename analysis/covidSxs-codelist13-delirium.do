/*=========================================================================
DO FILE NAME:			covidSxs-codelist13-delirium
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-07
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for delirium	
						Will be used as an outcome in older populations only
						 				
MORE INFORMATION:	
					
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-delirium-working
																
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
global filename "covidSxs-codelist13-delirium"

* open log file
log using "../logs/${filename}", text replace






/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*delirium*" "*deliri*" "*disorienta*" "*confus*" "

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
/*
list term if strmatch(term_lc,"*(finding)") // keep for review
list term if strmatch(term_lc,"*(procedure)") // drop
*/


* define exclusions
list term if strmatch(term_lc,"*toxic*") & strmatch(term_lc,"*acute*")!=1
drop if strmatch(term_lc,"*toxic*") & strmatch(term_lc,"*acute*")!=1


local exterm " "*(procedure)" "*sexual*" "
local exterm " `exterm' "*at risk*"  "*test*" "*scale*" "
local exterm " `exterm' "*alcohol*" "*amphetamine*" "*assessment*" "
local exterm " `exterm' "*score*" "*cannabis*" "*cocaine*" "
local exterm " `exterm' "*concussion*" "*peziza*" "*cannabinoid*" "
local exterm " `exterm' "*withdrawal*" "*cathinone*" "
local exterm " `exterm' "*ketamine*" "*dissociative drug*" "
local exterm " `exterm' "*medication*" "*stimulant*" "*surgical*" "
local exterm " `exterm' "*remission*" "*bacterium*" "*tremens*" "
local exterm " `exterm' "*cottus confusus*" "*education*" "
local exterm " `exterm' "*induced*" "*postop*" "*inhalant*" "
local exterm " `exterm' "*epilepti*" "*ictal*" "*seizure*" "
local exterm " `exterm' "*bacillus*" "*intoxica*" "*opiod*" "
local exterm " `exterm' "*rutland*" "*arteriosclerotic*" "
local exterm " `exterm' "*(organism)" "*tetrameres*" "
local exterm " `exterm' "*weissella*" "*trauma*" "*infarct*" "
local exterm " `exterm' "*endocrine*" "*metabolic*" "
local exterm " `exterm' "*cerebrovascular*" "*ganser*" "

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
export delimited using "../codelists/working/snomed-delirium-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



