/*=========================================================================
DO FILE NAME:			covidSxs-codelist23-ptsd
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-20
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for symptoms of PTSD
						 				
MORE INFORMATION:	Aim to include symptoms and diagnoses of PTSD

					Q.
					Other symptoms: problems sleeping, irritability, feelings of 
					isolation, guilt, problems concentrating. 
					This seems to overlap a lot with other things on the list 
					(i.e., sleep problems, anxiety, cognitive impairment) 
					
					A. 
					consider only including PTSD diagnoses here
					
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-ptsd-working
																
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
global filename "covidSxs-codelist23-ptsd"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*post-trauma*" "*post trauma*" "*postraumatic*" "*ptsd*" "*flashback*" "
local searchterm " `searchterm' "*nightmare*" "*combat*" "*shell-shock*" "*shell shock" "

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
list term if strmatch(term_lc,"*(organism)") // drop
list term if strmatch(term_lc,"*(qualifier value)") // drop
list term if strmatch(term_lc,"*(physical object)") // no codes
list term if strmatch(term_lc,"*structure*") // no codes
list term if strmatch(term_lc,"*observable entity*") // drop
list term if strmatch(term_lc,"*(product)") // no codes
list term if strmatch(term_lc,"*(substance)") // no codes
list term if strmatch(term_lc,"*region") // no codes


* define exclusions
local exterm " "*(procedure)" "*operation*" "*repair*" "*scale*" "
local exterm " `exterm' "*(organism)" "*test*" "*combatia*" "*blood flashback*" "
local exterm " `exterm' "*checklist*" "*injury*" "*royal*" "*(occupation)" "
local exterm " `exterm' "*(organism)" "*test*" "*combatia*" "*blood flashback*" "
local exterm " `exterm' "*under general*" "*combativeness*" "
local exterm " `exterm' "*combatant*" "*brain*" "*urethral*" "at risk*" "
local exterm " `exterm' "*military*" "*armed*" "*exposure to combat*" "
local exterm " `exterm' "*headache*" "*morrhage*" "*communicating*" "
local exterm " `exterm' "*osteoarth*" "*recession*" "*arthrosis*" "
local exterm " `exterm' "*bruis*" "*coma*" "*dementia*" "
local exterm " `exterm' "*eczema*" "*epilep*" "*endoph*" "*ingitis*" "
local exterm " `exterm' "*hypopit*" "*hydrocep*" "*macular*" "
local exterm " `exterm' "*wound*" "*syrin*" "*uveitis*" "*skin*" "*pain*" "
local exterm " `exterm' "*necrosis*" "*otorr*" "*nerve*" "*pericard*" "
local exterm " `exterm' "*cyst*" "*scar*" "*steril*" "
local exterm " `exterm' "*pulmon*" "*vestibu*" "*anosmia*" "*stopped*" "

foreach word in `exterm' {
	display "`word'"
	list term if strmatch(term_lc,"`word'")
	drop if strmatch(term_lc,"`word'")
}





list term if strmatch(term_lc,"*combat*") // no codes



	

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
export delimited using "../codelists/working/snomed-ptsd-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



