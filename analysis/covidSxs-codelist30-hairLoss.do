/*=========================================================================
DO FILE NAME:			covidSxs-codelist30-hairLoss
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-27
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for hair loss
						 				
MORE INFORMATION:	
					
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-hairLoss-working
																
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
global filename "covidSxs-codelist30-hairLoss"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*hair*loss*" "*loss*hair*" "*hair*fall*" "*alopecia*" "
local searchterm " `searchterm' "*bald*" "*losing*hair*" "*thin*hair*" "*hair*thin*" "
local searchterm " `searchterm' "*atrichosis*" "*thin*hair*" "*telogen effluvium*" "
local searchterm " `searchterm' "*fall*hair*" "


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
local exterm " "*syndrome*" "*congenital*" "*drug*" "*baldri*" "
local exterm " `exterm' "*antibody*" "*areata*" "*trauma*" "*due to*" "
local exterm " `exterm' "*caused by*" "*heredit*" "*anomaly*" "
local exterm " `exterm' "*androgen*" "*thyroid*" "*blenny*" "
local exterm " `exterm' "*pig*" "*hornet*" "*tongue*" "*eagle*" "
local exterm " `exterm' "*sculpin*" "*chair*" "*cattle*" "
local exterm " `exterm' "fh:*" "family history*" "*endocrine*" "
local exterm " `exterm' "*frostbite*" "*garibaldi*" "
local exterm " `exterm' "*retardation*" "*graft*" "
local exterm " `exterm' "*hot comb*" "*ichthyosis follicularis*" "
local exterm " `exterm' "*dysplasia*" "*radiation*" "*score*" "*tool*" "
local exterm " `exterm' "*sebaldella*" "*sutural*" "*burn*" "
local exterm " `exterm' "*traction*" "*rickets*" "*cicatricial*" "
local exterm " `exterm' "*syphilitic*" "*baldwini*" "
local exterm " `exterm' "*theobaldia*" "*uterus*" "*postpartum*" "
local exterm " `exterm' "*involutional*" "*friction*" "
local exterm " `exterm' "*dwarfism*" "*lymphoma*" "*nutritional*" "
local exterm " `exterm' "*ibis*" "*massage*" "*male pattern*" "
local exterm " `exterm' "*postmenopaus*" "*piebald*" "
local exterm " `exterm' "scarring*" "*triangular*" "*mutant*" "
local exterm " `exterm' "*medicamen*" "*women*" "*skin flap*" "*cicatrisata*" "
local exterm " `exterm' "*agent*" "*vertical*" "*lipedematous*" "


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
export delimited using "../codelists/working/snomed-hairLoss-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



