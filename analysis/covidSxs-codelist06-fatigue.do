/*=========================================================================
DO FILE NAME:			covidSxs-codelist06-fatigue

AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-May-18
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for fatigue
						 				
MORE INFORMATION:	Q1. What about chronic fatigue, post viral fatigue, etc, 
					include in here, or leave as only in specific diagnostic 
					category? 
					A1. Include as these are codes that GPs might use here, 
					and fatigue will pick them up.
					+ sens analysis to exclude specific diagnoses
					
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-fatigue-working
																
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
global filename "covidSxs-codelist06-fatigue"

* open log file
log using "../logs/${filename}", text replace






/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*fatigue*" "*tired*" "*weary*" "
local searchterm " `searchterm' "*weariness*" "*lassitude*" "*asthenia*" "
local searchterm " `searchterm' "*weak*" "*energy*" "*sluggish*" "*worn out*" "
local searchterm " `searchterm' "*exhaust*" "*me/cfs*" "*myalgic enceph*" "*lethar*" "
local searchterm " `searchterm' "*drows*" "* me *" "me *" "*tatt*" "*m.e.*" "*cfs*" "


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
* first drop 'retired' codes
drop if strmatch(term_lc,"retired procedure (procedure)")
drop if strmatch(term_lc,"retired procedure")

list term if strmatch(term_lc,"*retired*")
drop if strmatch(term_lc,"*retired*")

* now define other exclusions
local exterm " "*psychasthenia*" "*motor vehicle*" "
local exterm " `exterm' "*myasthenia*" "*electromagnetic*" "
local exterm " `exterm' "*weak pulse*" "*fatigue scale*" "
local exterm " `exterm' "*electroencephalogram*" "*heat*" "
local exterm " `exterm' "*muscle fatigue*" "*muscular fatigue*" "
local exterm " `exterm' "*thromboasthenia*" "*anhidrotic*" "*pediatric*" "
local exterm " `exterm' "*nerve weak*" "*facial weak*" "*psychomotor*" "
local exterm " `exterm' "*muscle weak*" "total*" "*solar*" "*absorptiometry*" "
local exterm " `exterm' "*spinal weakness*" "*velopharyngeal*" "
local exterm " `exterm' "*pelvic*" "*protein*" "*malnutrition*" "*diet*" "
local exterm " `exterm' "*weak d*" "*phenotype*" "
local exterm " `exterm' "*abdominal weak*" "*aryngeal weak*" "*platelets*" "
local exterm " `exterm' "*palatal weak*" "*sided weak*" "*accident caused by exhaustion*" "
local exterm " `exterm' "*polio*" "*movement against resist*" "*tattoo*" "
local exterm " `exterm' "*questionnaire*"  "*voice*" "*fracture*" "*salmonella*" "
local exterm " `exterm' "*weak arter*" "*weakly-reactive*" "*dogs and cats*" "*dogs and/or cats*" "
local exterm " `exterm' "*weak a subgroup*" "*newborn*" "*suicide*" "*labor*" "*labour*" "
local exterm " `exterm' "*exhaust gas*" "*weak vision*" "*exhaust repair*" "
local exterm " `exterm' "*sphincter*" "*weary-kind*" "*exhaust pipe*" "*poikiloderma*" "
local exterm " `exterm' "*thrombasthenia*" "*weakly positive*" "*weak teeth*" "
local exterm " `exterm' "*orgasm*" "*sternomast*" "*neck*" "*eye closure*" "
local exterm " `exterm' "*of back*" "*of arm*" "*of leg*" "*of gait*" "
local exterm " `exterm' "*reaction weak*" "*leg fatigue*" "*of foot*" "*of toe*" "
local exterm " `exterm' "*of hand*" "*quadriceps*" "*bladder*" "*limb*" "
local exterm " `exterm' "*accommodative*" "*post-ictal*" "*weak solution*" "*central nervous*" "
local exterm " `exterm' "*solution*" "*eyes*" "*face muscle*" "*mouth*" "
local exterm " `exterm' "*impact score*" "*assessment scale*" "*scale score*" "
local exterm " `exterm' "*tattler*" "*weakfish*" "*consonants*" "*vocal*" "
local exterm " `exterm' "*weak cry*" "*cage layer fatigue*" "*impact scale*" "
local exterm " `exterm' "*infant attachment*" "*fumes*" "*heart*" "*spiritual*" "
local exterm " `exterm' "*may cause drowsiness*" "*ireducens*" "*(organism)*" "
local exterm " `exterm' "*battery*" "*endometrium*" "*chemotherapy*" "*radiation*" "
local exterm " `exterm' "* of stroke*" "*hemiparesis*" "*gait*" "
local exterm " `exterm' "*acquired immunodeficiency syndrome*" "*focal motor*" "
local exterm " `exterm' "*foetal*" "*fetal*" "*rectovag*" "*pubocerv*" "
local exterm " `exterm' "*urinary*" "*malignant*" "*bilateral hand*" "*facial*" "
local exterm " `exterm' "aids with fatigue*" "*body exhaust system*" "
local exterm " `exterm' "*combat fatigue*" "*fatigue associated with aids*" "
local exterm " `exterm' "*nitratireductor*" "*tatton brown*" "*cerebrovascular*" "
local exterm " `exterm' "*visual perception*" "*tatton brown*" "*of chin*" "
local exterm " `exterm' "*warning*" "*mother-infant*" "*extraocular*" "
local exterm " `exterm' "*bilateral upper*" "*arms and legs*" "
local exterm " `exterm' "*jaw muscle*" "*joint movement*" "
local exterm " `exterm' "*left hand*" "*right hand*" "
local exterm " `exterm' "*side of body*" "*testosterone*" "*motor symptom*" "
local exterm " `exterm' "*cancer*" "*erection*" "*bulbar*" "*pigmentosa*" "
local exterm " `exterm' "*neonatal*" "*shoulder girdle*" "*visual*" "
local exterm " `exterm' "*(qualifier value)*" "*middle ear*" "*perinatal*" "*pcfs*" "
local exterm " `exterm' "*nuclear*" "*nutrition*" "non-*" "*modular energy*" "
local exterm " `exterm' "measured percentage*" "*food*" "*laser*" "
local exterm " `exterm' "increased*" "*expenditure*" "inadequate*" "
local exterm " `exterm' "wave*" "percent energy*" "paediatric*" "
local exterm " `exterm' "predicted*" "*carbohydrate*" "*fat and oil*" "
local exterm " `exterm' "*energy technique*" "*obesity*" "
local exterm " `exterm' "measured intake*" "measured quantity*" "
local exterm " `exterm' "si unit*" "*teletherapy*" "*personal energy*" "
local exterm " `exterm' "*radionuclide*" "proton*" "*energy treatment*" "
local exterm " `exterm' "light-energy*" "*international system of unit*" "
local exterm " `exterm' "*high-energy*" "*high energy*" "gibbs *" "
local exterm " `exterm' "excessive energy*" "estimated*" "energy*" "
local exterm " `exterm' "*dual energy*" "*bio-energy*" "
local exterm " `exterm' "*energy field*" "*absorptiomet*" "
local exterm " `exterm' "*formula*" "% energy*" "
local exterm " `exterm' "*direct energy*" "*gibbs energy*" "
local exterm " `exterm' "*sperm*" "*thought*" "*pupil movement*" "*cerebrospinal fluid*" "



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
export delimited using "../codelists/working/snomed-fatigue-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



