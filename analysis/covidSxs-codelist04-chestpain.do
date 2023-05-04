/*=========================================================================
DO FILE NAME:			covidSxs-codelist04-chestpain

AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-May-18
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for chest pain
						 				
MORE INFORMATION:	deliberately excluding anything that might be used as a 
					diagnosis for chest pain (e.g., angina) as that will be 
					picked up with diagnostic categories
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-chestpain-working
																
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
global filename "covidSxs-codelist04-chestpain"

* open log file
log using "../logs/${filename}", text replace






/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " 	"*chest pain*" "*costochondritis*" "*rib pain*" "
local searchterm " 	`searchterm' "*parasternal*" "*precordi*" "*praecord*" "
local searchterm " 	`searchterm' "*chest wall*" "*chest discomfort*" "
local searchterm " 	`searchterm' "*retrosternal*" "*painful respir*" "
local searchterm " 	`searchterm' "*retrosternal*" "*painful breath*" "


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
list term if strmatch(term_lc,"*procedure*") & strmatch(term_lc,"*clinic*")!=1 & strmatch(term_lc,"*assessment*")!=1
drop if strmatch(term_lc,"*procedure*") & strmatch(term_lc,"*clinic*")!=1 & strmatch(term_lc,"*assessment*")!=1


local exterm " "*prosthesis*" "*excision*" "*reconstruction*" "
local exterm " `exterm' "*malignant*" "*burn*" "*carcinoma*" "
local exterm " `exterm' "*repair*" "*operation*" "
local exterm " `exterm' "*congenital*" "*biopsy*" "
local exterm " `exterm' "*goitre*" "*ultrasound*" "
local exterm " `exterm' "*lymphadenopathy*" "*radiograph*" "
local exterm " `exterm' "*x-ray*" "*blister*" "
local exterm " `exterm' "*hernia*" "*pulsation*" "
local exterm " `exterm' "*foreign body*" "*incision*" "
local exterm " `exterm' "*laceration" "*carbuncle*" "
local exterm " `exterm' "*abrams bar*" "*furuncle*" "
local exterm " `exterm' "*superficial injury*" "*transplantation*" "
local exterm " `exterm' "*injection" "*erythema*" "
local exterm " `exterm' "*medical procedure*" "*insect bite*" "
local exterm " `exterm' "*neoplasm*" "*manipulation*" "
local exterm " `exterm' "*parasternal region*" "*o/e*" "
local exterm " `exterm' "*fistulogra*" "*fluoroscopy*" "
local exterm " `exterm' "*excise*" "*adhesion*" "
local exterm " `exterm' "*congen.*" "*bruis*" "
local exterm " `exterm' "*contus*" "*wound*" "
local exterm " `exterm' "*resect*" "*correction*" "
local exterm " `exterm' "*fenestrat*" "*lipoma*" "
local exterm " `exterm' "*cellulitis*" "*goiter*" "
local exterm " `exterm' "*abrasion*" "*tumor*" "
local exterm " `exterm' "*tumour*" "*corrosion*" "
local exterm " `exterm' "*injury*" "*murmur*" "
local exterm " `exterm' "*veins*" "*laceration*" "
local exterm " `exterm' "*on examination*" "*(body structure)*" "
local exterm " `exterm' "*thyroid*" "*endoscopy*" "
local exterm " `exterm' "*abscess*" "*injection*" "
local exterm " `exterm' "*lymphangitis*" "*transposition*" "
local exterm " `exterm' "*suture*" "
local exterm " `exterm' "*not present*" "*mass*" "
local exterm " `exterm' "*fetal*" "*foetal*" "
local exterm " `exterm' "*edema*" "*fibroma*" "
local exterm " `exterm' "*haemangioma*" "*deformity*" "
local exterm " `exterm' "*structure of*" "*skin structure*" "
local exterm " `exterm' "*cancer*" "*localized swelling*" "
local exterm " `exterm' "*malig*" "*fluoroscopy*" "
local exterm " `exterm' "*hemangioma*" "*entire*" "
local exterm " `exterm' "*nodule*" "*axis view*" "
local exterm " `exterm' "*stethoscope*" "*esophagogastrostomy*" "
local exterm " `exterm' "*localised swelling*" "*radiotherap*" "
local exterm " `exterm' "*friction*" "*injuries*" "
local exterm " `exterm' "*implantation*" "*lymph node*" "*recoil*" "
local exterm " `exterm' "*voltage*" "*compliance*" "*us scan*" "*sinogr*" "
local exterm " `exterm' "*retraction*" "*signs (finding*" "*sign (finding*" "
local exterm " `exterm' "*boil*" "

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
export delimited using "../codelists/working/snomed-chestpain-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



