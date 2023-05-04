/*=========================================================================
DO FILE NAME:			covidSxs-codelist26-sorethroat
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-27
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for sore throat
						 				
MORE INFORMATION:	
					
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-sorethroat-working
																
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
global filename "covidSxs-codelist26-sorethroat"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*throat*" "*pharyngitis*" "*tonsil*" "*laryngitis*" "

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
local exterm " "*bacterial*" "*herpes*" "*haemophilus*" "*hemophilus*" "
local exterm " `exterm' "*gangrenous*" "*caused by*" "*carcinoma*" "
local exterm " `exterm' "*ococcal*" "*lectomy*" "*allerg*" "*adverse reaction*" "
local exterm " `exterm' "*emergency*" "*animal*" "*admission*" "*neoplasm*" "
local exterm " `exterm' "*tumour*" "*tumor*" "*throated*" "*burn*" "*chlamydial*" "
local exterm " `exterm' "*chlorhexidine*" "*cicatrix*" "
local exterm " `exterm' "*laceration*" "*contusion*" "*injury*" "
local exterm " `exterm' "*crypt*" "*cut throat*" "*cutting*" "*cut-throat*" "*cyst*" "
local exterm " `exterm' "entire*" "*candida*" "*malformation*" "*abscess*" "
local exterm " `exterm' "*brush*" "*spray*" "*biopsy*" "*bleed*" "
local exterm " `exterm' "*blister*" "*bone*" "*cancer*" "
local exterm " `exterm' "both*" "*cauteri*" "*carbide*" "
local exterm " `exterm' "*lymphoma*" "discharge*" "*viral*" "*did not attend*" "
local exterm " `exterm' "*diamond*" "*division*" "*microscopy*" "
local exterm " `exterm' "*surgical*" "*ear &/or nose*" "*care plan*" "
local exterm " `exterm' "*catheter*" "*cannula*" "*ear, nose and throat*" "
local exterm " `exterm' "*bite*" "*care pathway*" "*drainage*" "
local exterm " `exterm' "*stopped*" "*changed*" "*ear, nose, throat*" "
local exterm " `exterm' "*constriction*" "*cutthroat*" "*cut of throat*" "
local exterm " `exterm' "*structure*" "*ear,nose*" "*ear, nose*" "
local exterm " `exterm' "*ear/nose/throat*" "*oscopy*" "*excision*" "
local exterm " `exterm' "*foreign body*" "*fulguration*" "h/o:*" "
local exterm " `exterm' "*haemorrhage*" "*hemorrhage*" "*haemostasis*" "
local exterm " `exterm' "*hairy*" "*cerebellar*" "*glass*" "*follow-up*" "
local exterm " `exterm' "*glandular fever*" "*nerve*" "*fusospirochetal*" "*fusospirochaetal*" "
local exterm " `exterm' "*hemostasis*" "*hernia*" "history of*" "*melanoma*" "
local exterm " `exterm' "*mucosa*" "*mucous membrane*" "*mycoplasma*" "
local exterm " `exterm' "*necrotic*" "*throat pack*" "*procedure*" "
local exterm " `exterm' "*sulcus*" "*operation*" "*hook*" "finding of*" "
local exterm " `exterm' "*incision*" "*infective*" "
local exterm " `exterm' "*mononucleosis*" "*influenza*" "*inject*" "
local exterm " `exterm' "*sicca*" "*lesser*" "*manipulation*" "no *" "
local exterm " `exterm' "normal *" "o/e*" "on examination*" "*wound*" "
local exterm " `exterm' "*greenthroat*" "*virus*" "*referral*" "*yaws*" "*mutilans*" "
local exterm " `exterm' "*seen by*" "*scratch*" "*ruby*" "*syphilis*" "
local exterm " `exterm' "*septic*" "*throat swab*" "*substance*" "
local exterm " `exterm' "*antibiotic*" "*culture*" "*knife*" "*microphone*" "
local exterm " `exterm' "*food*" "*coxsackie*" "*orange*" "
local exterm " `exterm' "*injuries*" "*service*" "*radiogra*" "*sinus*" "
local exterm " `exterm' "*depressor*" "*artery*" "*fossa*" "*pillar*" "
local exterm " `exterm' "*red throat*" "*lith*" "*tuberculo*" "
local exterm " `exterm' "*vincent*" "*splinter*" "*organism*" "fh:*" "
local exterm " `exterm' "family history*" "healthy*" "normal*" "* normal*" "
local exterm " `exterm' "*congenital*" "* chin *" "*shield*" "*ear nose and throat*" "
local exterm " `exterm' "*nose and throat examination*" "observation of*" "
local exterm " `exterm' "*keratosa*" "*radiotherapy*" "*specimen*" "*fish*" "
local exterm " `exterm' "*lozenge*" "*preparation*" "*bot fly*" "*abrasion*" "
local exterm " `exterm' "*angina*" "*node*" "*mass*" "*(physical object)" "
local exterm " `exterm' "*bacterial*" "*otomy*" "*postoperative*" "*hemorrhag*" "
local exterm " `exterm' "*transplant*" "*punch*" "*repair*" "*scissor*" "
local exterm " `exterm' "*dissect*" "*closure*" "*calculus*" "*actinomy*" "
local exterm " `exterm' "*debris*" "*aspergill*" "*snare*" "*stone*" "
local exterm " `exterm' "*forceps*" "*capsule*" "*remnant*" "*lectome*" "
local exterm " `exterm' "*ring" "*tag" "*bacteria*" "

foreach word in `exterm' {
	display "`word'"
	list term if strmatch(term_lc,"`word'")
	drop if strmatch(term_lc,"`word'")
}


list term if strmatch(term_lc,"*infection*") & strmatch(term_lc,"*or*")!=1 
drop if strmatch(term_lc,"*infection*") & strmatch(term_lc,"*or*")!=1 


	

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
export delimited using "../codelists/working/snomed-sorethroat-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



