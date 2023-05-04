/*=========================================================================
DO FILE NAME:			covidSxs-codelist14-mobilityImpairment
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-07
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for mobility impairment	
						Will be used as an outcome in older populations only
						 				
MORE INFORMATION:	
					
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-mobilityImpairment-working
																
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
global filename "covidSxs-codelist14-mobilityImpairment"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*mobility*" "*ambulation*" "*walk*" "*gait*" "
local searchterm " `searchterm' "*ambulate*" "*mobile*" "*unsteady*" "*off legs*" "
local searchterm " `searchterm' "*balance*" "*postural sway*" "


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
* drop terms that will be included in dizziness list
list term if strmatch(term_lc,"*unsteady*") & strmatch(term_lc,"*dizziness*")==1
drop if strmatch(term_lc,"*unsteady*") & strmatch(term_lc,"*dizziness*")==1


* define exclusions
list term if strmatch(term_lc,"*walker*") & strmatch(term_lc,"*mobilize*")!=1 & strmatch(term_lc,"*mobilise*")!=1
drop if strmatch(term_lc,"*walker*") & strmatch(term_lc,"*mobilize*")!=1 & strmatch(term_lc,"*mobilise*")!=1

list term if strmatch(term_lc,"*(procedure)") & strmatch(term_lc,"*walking stick*")!=1 & strmatch(term_lc,"*using mobility aid*")!=1 & strmatch(term_lc, "*provision of mobility device*")!=1
drop if strmatch(term_lc,"*(procedure)") & strmatch(term_lc,"*walking stick*")!=1 & strmatch(term_lc,"*using mobility aid*")!=1 & strmatch(term_lc, "*provision of mobility device*")!=1

list term if strmatch(term_lc,"*education*") & strmatch(term_lc,"*mobility*")!=1
drop if strmatch(term_lc,"*education*") & strmatch(term_lc,"*mobility*")!=1

local exterm " "*point*" "*amputation*" "
local exterm " `exterm' "*intensity*"  "*walking frame*" "*test*" "
local exterm " `exterm' "*walk time*" "ability to*" "able to*" "
local exterm " `exterm' "*mobile home*" "*acetobacter*" "
local exterm " `exterm' "*child health*" "*assessment*" "*training*" "
local exterm " `exterm' "*walker syndrome*" "*poisoning*" "
local exterm " `exterm' "*walk in*"  "
local exterm " `exterm' "*rehabilitation system*" "
local exterm " `exterm' "*(organism)" "*(physical object)" "
local exterm " `exterm' "*injection*" "*unit, mobile*" "
local exterm " `exterm' "*intensif*" "*hypermobil*" "*norwalk*" "
local exterm " `exterm' "*antalgic*" "*walk-in*" "*arthri*" "
local exterm " `exterm' "*arytenoid*" "*assault*" "*automobile*" "
local exterm " `exterm' "*asthma*" "*ataxic*" "*athetotic*" "
local exterm " `exterm' "*tumour*" "*tumor*" "*bacterium*" "
local exterm " `exterm' "*sleep*" "*buttocks*" "*baculum*" "
local exterm " `exterm' "*bouncy*" "*tongue*" "*mobile medical*" "*child*" "
local exterm " `exterm' "*telephone*" "*amputee*" "*mobile procedure*" "
local exterm " `exterm' "*clown*" "*choreic*" "*charcot*" "
local exterm " `exterm' "*tympanic*" "*autism*" "*phone*" "
local exterm " `exterm' "*drop*" "*drunk*" "*score*" "*tooth*" "
local exterm " `exterm' "*calcane*" "*cerebellar*" "*cast*" "
local exterm " `exterm' "*crouch*" "*balance/mobility*" "
local exterm " `exterm' "*walked out*" "*does walk*" "*duck*" "
local exterm " `exterm' "*sclae*" "*nasal*" "*cleaner*" "
local exterm " `exterm' "*patella*" "*elbow*" "exercise therapy*" "
local exterm " `exterm' "external*" "*sidewalk*" "*extrapyram*" "fear of*" "
local exterm " `exterm' "feature of*" "*festinat*" "
local exterm " `exterm' "*incus*" "finding of*" "finding related to*" "
local exterm " `exterm' "*flat-foot*" "first*" "*mount*" "*forward trunk*" "
local exterm " `exterm' "*freezing*" "foot*" "frontal gait*" "fully mobile*" "
local exterm " `exterm' "* normal*" "*glute*" "normal*" "
local exterm " `exterm' "*mobile missile*" "*heart rate*" "
local exterm " `exterm' "*thorax*" "*plegic*" "*stapes*" "*malleus*" "
local exterm " `exterm' "*ossicle*" "*horse*" "*largimobile*" "*circl*" "
local exterm " `exterm' "*walkway*" "*(qualifier value)" "
local exterm " `exterm' "*scale*" "*equin*" "*index*" "general*" "
local exterm " `exterm' "*extensor*" "*discharge*" "*electrical*" "
local exterm " `exterm' "*haemoglobin*" "*sensorimotor*" "*hip hitch*" "
local exterm " `exterm' "found*" "*(regime/therapy)" "*hemoglobin*" "
local exterm " `exterm' "*hip circum*" "*heart valve*" "*bed mobility*" "
local exterm " `exterm' "independent*" "*injury*" "*ischaemic*" "
local exterm " `exterm' "*intellectual*" "joint*" "*kidney*" "*laryng*" "
local exterm " `exterm' "loan of*" "*questionnaire*" "*allowance*" "
local exterm " `exterm' "*magnetic*" "*venous*" "*x-ray*" "*bariatric*" "
local exterm " `exterm' "*military*" "*cecum*" "*caecum*" "*extracorporeal*" "
local exterm " `exterm' "mobile in home*" "*camera*" "*intraoperative*" "
local exterm " `exterm' "mobile joint*" "*mobile lump*" "
local exterm " `exterm' "*vascular*" "*pharynx*" "*salesman*" "*(occupation)" "
local exterm " `exterm' "*mobile clinic*" "*methanomicrobium*" "*retardation*" "
local exterm " `exterm' "*lifting system*" "mobility" "mobility of*" "*metadata*" "
local exterm " `exterm' "*agoraphobia*" "*mycoplasma*" "*mycopathic*" "not yet*" "
local exterm " `exterm' "*parkinson*" "o/e *" "observat*" "on examination*" "
local exterm " `exterm' "*oppenheim*" "*pain*" "*paralytic*" "*petren*" "
local exterm " `exterm' "*private*" "primary walk*" "procedure*" "promot*" "
local exterm " `exterm' "propul*" "*prosthet*" "*provision*" "*radiation*" "
local exterm " `exterm' "*social*" "*traction system*" "*sling/harness*" "
local exterm " `exterm' "*tabetic*" "*metre walk*" "*toe-walking*" "
local exterm " `exterm' "*tripod*" "*uterus*" "walking distance" "
local exterm " `exterm' "*walks*meters*" "*snowmobile*" "*skimobile*" "
local exterm " `exterm' "*walks in 1 minute*" "*spinning*" "*spastic*" "
local exterm " `exterm' "*scissor*" "*retropul*" "
local exterm " `exterm' "stable*" "*steppage*" "*started walking*" "
local exterm " `exterm' "teach*" "*trunk*" "timed*" "*graft*" "*trendelenburg*" "
local exterm " `exterm' "pretended*" "*sirota*" "*crosswalk*" "*maxilla*" "
local exterm " `exterm' "*sink system*" "*epidural*" "*maximum distance*" "
local exterm " `exterm' "measure of*" "*airflow*" "*disinfect*" "
local exterm " `exterm' "*all.rep.claim*" "*all.report*" "mobility fair*" "
local exterm " `exterm' "*reference set*" "*warming*" "*teach*" "*myopath*" "
local exterm " `exterm' "optimum*" "patient found*" "*mobile-crane*" "*(attribute)" "
local exterm " `exterm' "mobility nos*" "*allow med nos*" "*screening*" "
local exterm " `exterm' "walks up*" "walks down*" "*treatment light*" "
local exterm " `exterm' "*knee*" "injected*" "no aid for*" "walking" "
local exterm " `exterm' "walking distance:*" "walking, nos" "walks" "
local exterm " `exterm' "walking distance (obs*" "walking distance - find*" "
local exterm " `exterm' "*laryngeal*" "manner of walking" "*intoeing*" "
local exterm " `exterm' "*large toy*" "age when first*" "*alkalispiri*" "
local exterm " `exterm' "ambulation ability" "ambulation therapy*" "*dystrophic*" "
local exterm " `exterm' "gait" "gait type" "gait speed" "gait*function*" "
local exterm " `exterm' "does not walk*" "does start*" "does stop*" "
local exterm " `exterm' "*double step*" "*dystonic*" "evaluating progress*" "
local exterm " `exterm' "*barefoot*" "*apraxi*" "*analysis system*" "
local exterm " `exterm' "*electrolyte*" "*acid-base*" "*acid base*" "
local exterm " `exterm' "*traction*" "*temperature*" "*nutrition*" "
local exterm " `exterm' "*septal defect*" "*tension*" "*autosomal*" "*diet*" "
local exterm " `exterm' "*rearrangement*" "*salt solution*" "*chromosom*" "
local exterm " `exterm' "*translocat*" "*fluid balance*" "*atrioventri*" "
local exterm " `exterm' "*congenital*" "*hydration*" "*hyperemesis*" "
local exterm " `exterm' "*food intake*" "*hydrotherapy*" "*water-balance*" "
local exterm " `exterm' "*electrolytic*" "*ventricular*" "*hemivertebr*" "
local exterm " `exterm' "*error scoring*" "*probalance*" "
local exterm " `exterm' "*obesity*" "*nitrogen*" "*balance error scoring*" "
local exterm " `exterm' "*eye" "*ocular*" "*fibre*" "*nutrient*" "
local exterm " `exterm' "fluid*" "*aortic*" "*electronic*" "
local exterm " `exterm' "water balance*" "*newborn*" "*counterbalance*" "
local exterm " `exterm' "*preparation" "*product)" "*substance)" "
local exterm " `exterm' "*fluid volume*" "

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
export delimited using "../codelists/working/snomed-mobilityImpairment-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



