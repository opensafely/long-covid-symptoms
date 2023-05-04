/*=========================================================================
DO FILE NAME:			covidSxs-codelist29-rashes
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-27
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for skin rashes
						 				
MORE INFORMATION:	
					
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-rashes-working
																
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
global filename "covidSxs-codelist29-rashes"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*rash**" "*erythem*" "*dermatitis*" "*skin lesion*" "
local searchterm " `searchterm' "*skin eruption*" "*desquamation*" "
local searchterm " `searchterm' "*skin*lesion*" "*skin*eruption*" "

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
local exterm " "*contact*" "*toxic*" "*heat*" "*bite*" "
local exterm " `exterm' "*septic*" "*score*" "*aids with*" "*accident*" "
local exterm " `exterm' "*acroangiodermatitis*" "*atopic*" "
local exterm " `exterm' "*acral lick*" "*acrodermatitis*" "
local exterm " `exterm' "*lupus*" "*candiosis*" "*radio*" "
local exterm " `exterm' "*bacteria*" "*scoring*" "*crash*" "
local exterm " `exterm' "*allergic*" "*burn*" "*thrasher*" "
local exterm " `exterm' "*butterfly*" "*candidal*" "
local exterm " `exterm' "*cauteri*" "*caterpillar*" "*avian*" "
local exterm " `exterm' "change in*" "changing*" "
local exterm " `exterm' "*chemical peel*" "*radiation*" "
local exterm " `exterm' "*cold erythema*" "*conjunctivitis*" "
local exterm " `exterm' "*cryotherapy*" "*curettage*" "
local exterm " `exterm' "*cyanosis*" "*deformity*" "*infestation*" "
local exterm " `exterm' "*caused by*" "*due to*" "*diathermy*" "
local exterm " `exterm' "*hereditary*" "*drainage*" "
local exterm " `exterm' "*drash*" "*drug*induced*" "*mycosis*" "*drug*" "
local exterm " `exterm' "*yaws*" "*trash*" "*enucleation*" "
local exterm " `exterm' "*rheumatic*" "*histology*" "
local exterm " `exterm' "*familial*" "*feline*" "
local exterm " `exterm' "*cattle*" "*fistula*" "*flea collar*" "
local exterm " `exterm' "*verrucous*" "*flagellate*" "*fungal*" "
local exterm " `exterm' "*freezing*" "*frozen*" "*friction*" "*gonococcal*" "
local exterm " `exterm' "*gingival*" "*gravel*" "*herpes*" "
local exterm " `exterm' "*halogen*" "*histamine*" "*hot tub*" "
local exterm " `exterm' "*hyfrecation*" "*arthritis*" "*human immunodef*" "
local exterm " `exterm' "*contagious*" "*biopsy*" "*excision*" "*coral*" "
local exterm " `exterm' "*grashey*" "*destruction*" "*ligation*" "
local exterm " `exterm' "*meadow*" "*mixed colour*" "*mixed color*" "
local exterm " `exterm' "*rabbit*" "*napkin*" "*nappy*" "*nettle*" "
local exterm " `exterm' "*north american*" "*rash absent*" "*dribble*" "
local exterm " `exterm' "*parasit*" "*traumatic*" "*quinolone*" "*syphilis*" "
local exterm " `exterm' "*incision*" "*injection*" "*photography*" "*dialysis*" "
local exterm " `exterm' "*assessment*" "*tubercul*" "*us therapy*" "
local exterm " `exterm' "*varicose*" "*waterbrash*" "*applicaiton site*" "
local exterm " `exterm' "*varicose*" "*waterbrash*" "*applicaiton site*" "
local exterm " `exterm' "*freshwater*" "*ruminant*" "*electrolysis*" "
local exterm " `exterm' "*bitterash*" "*saurashtrense*" "*cautery*" "*cdags*" "
local exterm " `exterm' "*electrodessic*" "*leprosum*" "*dermatitis herpetiformis*" "
local exterm " `exterm' "*dermatitis factitia*" "*dermatitis medicamentosa*" "*erythema ab igne*" "
local exterm " `exterm' "*pregnancy*" "infectious*" "*infected*" "*infective*" "
local exterm " `exterm' "*industrial*" "*newborn*" "*microcephaly*" "
local exterm " `exterm' "auto*" "*rashkind*" "*barbers'*" "*childhood*" "
local exterm " `exterm' "*prashadi*" "*kurashiki*" "*incontinence*" "
local exterm " `exterm' "*infantile*" "*infant*" "*ingestion*" "
local exterm " `exterm' "*juvenile*" "*leptospi*" "*marsupiali*" "
local exterm " `exterm' "*meningococcal*" "*neonatal*" "*phototherapy*" "
local exterm " `exterm' "*rubelliform*" "*scarlatiniform*" "
local exterm " `exterm' "*schistos*" "*sea mat*" "*self*inflict*" "
local exterm " `exterm' "*stoma*" "*swimming pool*" "*tattoo*" "
local exterm " `exterm' "*rhuemato*" "*tick*associated*" "*narashino*" "
local exterm " `exterm' "*sarcoid*" "*smallpox*" "*spider mite*" "*solar*" "
local exterm " `exterm' "*candidosis*" "*tonsil*" "*phytophotodermatitis*" "
local exterm " `exterm' "*ammonia*" "*administration site*" "


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
export delimited using "../codelists/working/snomed-rashes-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



