/*=========================================================================
DO FILE NAME:			covidSxs-codelist28-nasalCongestion
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-27
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for nasal congestion
						 				
MORE INFORMATION:	
					
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-nasalCongestion-working
																
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
global filename "covidSxs-codelist28-nasalCongestion"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*nasal congest**" "*blocked nose*" "*nose block*" "*nose clog*" "
local searchterm " `searchterm' "*clogged nose*" "*catarrh*" "*rhinitis*" "
local searchterm " `searchterm' "*nose congest*" "*coryza*" "*sniffle*" "*snuffle*" "
local searchterm " `searchterm' "*nasal drip*" "*nasal disch*" "*nasal mucosa*" "
local searchterm " `searchterm' "*nose drip*" "*rhinorrhoea*" "*rhinorrhea*" "*coryza*" "
local searchterm " `searchterm' "*congested nose*" "*discharge from nose*" "
local searchterm " `searchterm' "*stuffed*nose*" "*sinus congest*" "*nose run*" "


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
list term if strmatch(term_lc,"*body structure*")


* define exclusions
local exterm " "*allergic*" "*vasomotor*" "hay fever*" "*hayfever*" "
local exterm " `exterm' "*bronchitis*" "*tonsil*" "*infect*" "*otitis*" "
local exterm " `exterm' "*asphyxia*" "*atopic*" "*catarrhalis*" "*tubotympanic*" "
local exterm " `exterm' "*bronchial*" "*eustachian*" "*conjunctivitis*" "
local exterm " `exterm' "*gingivitis*" "*pneumoni*" "*tracheitis*" "
local exterm " `exterm' "*syphilitic*" "*minks*" "*equine*" "*rabbit*" "
local exterm " `exterm' "*fowl*" "*gastric*" "*dust mite*" "*irritant*" "
local exterm " `exterm' "*malignant*" "*gustatory*" "*swine*" "*inclusion*" "
local exterm " `exterm' "*necrotic*" "*caused by*" "*due to*" "*turkey*" "
local exterm " `exterm' "*appendicitis*" "*ultrasound*" "*sicca*" "*pregnancy*" "


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
export delimited using "../codelists/working/snomed-nasalCongestion-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



