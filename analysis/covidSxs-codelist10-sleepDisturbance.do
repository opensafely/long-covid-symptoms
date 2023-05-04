/*=========================================================================
DO FILE NAME:			covidSxs-codelist10-sleepDisturbance.do

AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-06
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for sleep disturbance
						 				
MORE INFORMATION:	
					
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-sleepDisturbance-working
																
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
global filename "covidSxs-codelist10-sleepDisturbance"

* open log file
log using "../logs/${filename}", text replace






/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*sleep*" "*insomnia*" "*waking*" "*awake*" "
local searchterm " `searchterm' "*awakening*" "*dyssomnia*" "
local searchterm " `searchterm' "*somnol*" "*somnia*" "*sleep walk*" "*somnambul*" "

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
list term if strmatch(term_lc,"*(procedure)") // keep for review
list term if strmatch(term_lc,"*(qualifier value)") // drop
*/

* define exclusions
local exterm " "*dysmorph*" "*accident*" "
local exterm " `exterm' "*child's sleep*" "*sleeping sickness*" "
local exterm " `exterm' "*asthma*" "at risk of*" "*intubation*" "
local exterm " `exterm' "*(qualifier value)" "*amphetamine*" "*intellectual*" "
local exterm " `exterm' "asleep" "*asleep (finding)" "
local exterm " `exterm' "*bimse*" "awake*" "before sleeping" "
local exterm " `exterm' "*epilepsy*" "*myoclonus*" "
local exterm " `exterm' "*copd*" "*cannabis*" "*caffeine*" "
local exterm " `exterm' "*chronic obstructive pulmonary disease*" "*cocaine*" "
local exterm " `exterm' "*drug-induced*" "*drug induced*" "*while awake" "*whilst awake" "
local exterm " `exterm' "*eleotridae*" "*(organism)" "*alcohol*" "
local exterm " `exterm' "*shift work*" "
local exterm " `exterm' "*emerald*" "*fat sleeeper*" "*fatal familial*" "
local exterm " `exterm' "*anaesthetic*" "*anesthetic*" "
local exterm " `exterm' "*good sleep pattern*" "*sleeping out*" "*sleeping rough*" "
local exterm " `exterm' "*learning disabilitites*" "*high-altitute*" "*injury*" "
local exterm " `exterm' "*tobacco*" "*musculoskeletal health*" "*eating disorder*" "
local exterm " `exterm' "*sleepwear*" "*poisoning*" "sleep disorder caused by*" "
local exterm " `exterm' "*hypoxaemia*" "*hypoxemia*" "*shelter*" "*friends home*" "
local exterm " `exterm' "sleeping pattern" "*vehicle*" "
local exterm " `exterm' "*attendant*" "*sleepygrass*" "*secondary parasomnia*" "
local exterm " `exterm' "*substance-induced*" "*synthetic ca*" "*induced sleep disorder*" "
local exterm " `exterm' "*safe sleeping assessment*" "*sleepaway*" "
local exterm " `exterm' "*biological function*" "*endoscopy*" "sleep observation*" "
local exterm " `exterm' "*caused by substance*" "*erection*" "
local exterm " `exterm' "*respiratory failure*" "sleep finding*" "
local exterm " `exterm' "*sleep medicine*" "*unknown*" "*vertigo*" "
local exterm " `exterm' "*personal child health*" "*adverse reaction to*" "
local exterm " `exterm' "on waking" "*pacific sleeper*" "
local exterm " `exterm' "*caused by drug*" "*positioning patient*" "
local exterm " `exterm' "*inps+developmental*" "*leg movements of sleep*" "
local exterm " `exterm' "*high altitude*" "*learning disabilities*" "
local exterm " `exterm' "*overdose*" "*history of *" "
local exterm " `exterm' "able to sleep" "able to sleep (fin*" "
local exterm " `exterm' "*duration of sleep*" "during sleep" "
local exterm " `exterm' "*epilepticus*" "spinycheek*" "spotted*" "*sleepy foal*" "
local exterm " `exterm' "*cramp*" "*head bang*" "*due to get lag*" "*cusk-eel*" "



foreach word in `exterm' {
	display "`word'"
	list term if strmatch(term_lc,"`word'")
	drop if strmatch(term_lc,"`word'")
}







/*******************************************************************************
NB: I've explicitly dropped codes relating to:
	- assessment of sleep problems
	- sleep apnoea
	- EEGs
	- sleep education
	- sleep studies
	- sleep restriction
	- sleep clinic
	
I'm not sure if this is the correct approach.

**************************
**************************
**************************
**************************
LAURIE PLEASE REVIEW THE CODES DROPPED BY THESE TERMS IN PARTICULAR 
**************************
**************************
**************************

make sure that you agree they should be dropped 
before I finalise the candidate code list for review on OpenCodelists
********************************************************************************/
* drop controversial codes
local exterm " "*assessment*" "assess*" "
local exterm " `exterm' "*apnea*" "*apnoea*" "*breathing-related sleep*" "
local exterm " `exterm' "*hypoventilation*" "*hypopnea*" "*hypopnoea*" "
local exterm " `exterm' "*tachypnoea*" "*tachypnea*" "
local exterm " `exterm' "*sleepiness scale*" "*severity index*" "
local exterm " `exterm' "*pittsburgh*" "*assessment scale*" "*questionnaire*" "
local exterm " `exterm' "*sleep eeg*" "*electroencephalo*" "*test*" "
local exterm " `exterm' "*education*" "*sleep management*" "
local exterm " `exterm' "*sleep studies*" "
local exterm " `exterm' "*sleep restriction*" "*sleep clinic*" "
local exterm " `exterm' "*cognitive behav*" "*sleep study*" "
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

display "***************************"
display "***************************"
display "***************************"
display "*** number of codes to review = `r(N)' ***"
display "***************************"
display "***************************"
display "***************************"






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
export delimited using "../codelists/working/snomed-sleepDisturbance-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



