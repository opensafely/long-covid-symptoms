/*=========================================================================
DO FILE NAME:			covidSxs-codelist21-depression
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-20
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for depression
						 				
MORE INFORMATION:	Aim to include symptoms and diagnoses of depression
					
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-depression-working
																
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
global filename "covidSxs-codelist21-depression"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*depress*" "*dysthymia*" "*sad*" "*melanchol*" "*dysthymic*" "
local searchterm " `searchterm' "*mood*" "*unhappy*" "

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
list term if strmatch(term_lc,"*(procedure)") // review
list term if strmatch(term_lc,"*(organism)") // drop
list term if strmatch(term_lc,"*(qualifier value)") // review
list term if strmatch(term_lc,"*(physical object)") // drop
list term if strmatch(term_lc,"*structure*") // drop
list term if strmatch(term_lc,"*observable entity*") // review
list term if strmatch(term_lc,"*(product)") // drop
list term if strmatch(term_lc,"*(substance)") // drop
list term if strmatch(term_lc,"*region") // no codes


* define exclusions
list term if strmatch(term_lc,"*psychosis*") & strmatch(term_lc,"*without*")!=1 
drop if strmatch(term_lc,"*psychosis*") & strmatch(term_lc,"*without*")!=1 

list term if strmatch(term_lc,"*psychotic*") & strmatch(term_lc,"*without*")!=1 
drop if strmatch(term_lc,"*psychotic*") & strmatch(term_lc,"*without*")!=1 



local exterm " "assessment*" "*(organism)" "
local exterm " `exterm' "*(physical object)" "*structure*" "
local exterm " `exterm' "*(product)" "*(substance)" "*saddle*" "*overdose*" "
local exterm " `exterm' "*poison*" "*scale*" "*score*" "*adverse reaction*" "
local exterm " `exterm' "*alcohol*" "*antenatal*" "*segment*" "*misadventure*" "
local exterm " `exterm' "*postpartum*" "*inventory*" "*bone marrow*" "
local exterm " `exterm' "*cardiac*" "*central depressant*" "*anaesthet*" "
local exterm " `exterm' "*newborn*" "*sadistic*" "*fracture*" "*allergy*" "
local exterm " `exterm' "*disadvantage*" "*postnatal*" "*dementia*" "
local exterm " `exterm' "*soft palate*" "*torsades*" "*drug-induced*" "
local exterm " `exterm' "entire*" "*puerperal*" "fh*" "family history*" " 
local exterm " `exterm' "history of*" "*elevated*" "*depression quality indicators*" "
local exterm " `exterm' "*expansive*" "*uterine*" "*palisades*" "h/o*" "
local exterm " `exterm' "happy*" "*hallucinogen*" "*[antidepressant]" "
local exterm " `exterm' "*good*" "*freezing*" "*pasadena*" "
local exterm " `exterm' "*glissade*" "*-induced*" "*mania*" "*bipolar*" "
local exterm " `exterm' "*abuse*" "*home problems*" "*manic*" "*angry*" "
local exterm " `exterm' "*drug" "*respiratory*" "*misuse*" "*stopped*" "
local exterm " `exterm' "*remission*" "*apprehens*" "at risk*" "
local exterm " `exterm' "*identification*" "*unhappy at home*" "
local exterm " `exterm' "*induced*" "*sadism*" "*sadler*" "
local exterm " `exterm' "*central nervous system*" "*cheerful*" "
local exterm " `exterm' "characteristic of*" "*constipation*" "
local exterm " `exterm' "*(navigational concept)" "*reflex depress*" "
local exterm " `exterm' "*depressor*" "*personality disorder*" "
local exterm " `exterm' "*posadasii*" "*congenital*" "*provisional problem*" "
local exterm " `exterm' "*rib*" "*anatomical*" "*alzheimer*" "*motion*" "*delusion*" "
local exterm " `exterm' "*personality*" "*dermoodonto*" "*dextrodepression*" "
local exterm " `exterm' "has had*" "hb novi sad*" "*improved*" "*irritable*" "
local exterm " `exterm' "knowledge level*" "*laevodepression*" "*levodepression*" "
local exterm " `exterm' "*checklist*" "*questionnaire*" "*swing*" "
local exterm " `exterm' "*moody*" "no history of*" "*negative screen*" "
local exterm " `exterm' "normal*" "*myocardial*" "*fearful*" "
local exterm " `exterm' "*organic*" "*pasadenensis*" "*palisade*" "
local exterm " `exterm' "*pcp mood*" "*profile*" "*parkinson*" "
local exterm " `exterm' "*medication regime*" "*spinosad*" "*quality and outcomes*" "
local exterm " `exterm' "*removal from*" "*denervation*" "*st depression*" "*sadi*" "
local exterm " `exterm' "*saddan*" "*sadomasoch*" "*sada*" "*sadji*" "
local exterm " `exterm' "*schizoaffective*" "*shoulder*" "*muscle*" "
local exterm " `exterm' "*saddling*" "sociable*" "*nose*" "*tresaderm*" "
local exterm " `exterm' "*tu depression*" "*torsade*" "
local exterm " `exterm' "*unhappy at work*" "unhappy home*" "*childhood*" "
local exterm " `exterm' "*unpredictable*" "*vapor*" "*vapour*" "
local exterm " `exterm' "*screen" "*postop*" "[v]screening for*" "*adverse effect*" "
local exterm " `exterm' "*partum*" "*caused by*" "*plant producing*" "
local exterm " `exterm' "*post-schizophre*" "*phencyclidine*" "
local exterm " `exterm' "*porroc*" "*antidepressant" "*perinatal*" "*overdepression*" "
local exterm " `exterm' "pr depression*" "


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
export delimited using "../codelists/working/snomed-depression-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



