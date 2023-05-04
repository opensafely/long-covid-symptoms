/*=========================================================================
DO FILE NAME:			covidSxs-codelist27-lossTasteSmell
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-27
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for loss of taste/smell
						 				
MORE INFORMATION:	
					
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-lossTasteSmell-working
																
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
global filename "covidSxs-codelist27-lossTasteSmell"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*taste*" "*smell*" "*anosmia*" "*hyposmia*" "
local searchterm " `searchterm' "*ageusia*" "*hypogeusia*" "*olfact*" "
local searchterm " `searchterm' "*parageusia*" "*odour*" "*odor*" "


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
local exterm " "*trauma*" "ability to*" "able to*" "*body*" "
local exterm " `exterm' "*urine*" "*vaginal*" "*wound*" "*odoratum*" "
local exterm " `exterm' "*odorsal*" "*odornase*" "*odorata*" "
local exterm " `exterm' "*odorimutans*" "*anodorhy*" "*rhodorus*" "
local exterm " `exterm' "*dressing*" "*congenital*" "
local exterm " `exterm' "*deodora*" "*environment*" "
local exterm " `exterm' "drug*" "*dutasteride*" "
local exterm " `exterm' "*ear smell*" "*odorifera*" "
local exterm " `exterm' "*faeces*" "*feces*" "*exudate*" "
local exterm " `exterm' "*malodoratus*" "*ketot*" "
local exterm " `exterm' "*intox*" "*breath*" "*smegma*" "
local exterm " `exterm' "*cord*" "*placenta*" "*skin*" "
local exterm " `exterm' "finding of*" "*gangrene*" "*ornithodorus*" "
local exterm " `exterm' "*fish*" "*garlic*" "*sputum*" "
local exterm " `exterm' "*genus*" "*glossopharyn*" "*gonadotrophin*" "
local exterm " `exterm' "*hallucination*" "heightened*" "*taster*" "
local exterm " `exterm' "*delusion*" "entire*" "*inodorus*" "
local exterm " `exterm' "*drainage*" "*discharge*" "*odorso*" "*ornithodorus*" "
local exterm " `exterm' "*odoratus*" "*ornithodoros*" "
local exterm " `exterm' "*smellie*" "*odoribacter*" "*vomit*" "*stool*" "
local exterm " `exterm' "*delivery unit*" "*mineral*" "*deodori*" "
local exterm " `exterm' "*odoriferum*" "*gonadism*" "*lochia*" "* ear*" "
local exterm " `exterm' "*specimen*" "*odoriferous*" "*franklin*" "
local exterm " `exterm' "*nodorum*" "*chitwoodorum*" "*unwashed*" "
local exterm " `exterm' "*ammonia*" "*smell bottle*" "*theodor*" "
local exterm " `exterm' "*tephrodornis*" "*trichodorus*" "adaptation to*" "
local exterm " `exterm' "*parolfactory*" "assessment using*" "
local exterm " `exterm' "*aversive*" "*neoplasm*" "*tumour*" "*tumor*" "
local exterm " `exterm' "*nerve*" "*chriodorus*" "*olfactometry*" "
local exterm " `exterm' "*olfactogenitalis*" "has *" "increase*" "
local exterm " `exterm' "*striae*" "*gyrus*" "*gland*" "*vein*" "
local exterm " `exterm' "*blastoma*" "*pathway*" "*pit" "*plate*" "
local exterm " `exterm' "*seizure*" "*sulcus*" "*tract*" "*structure*" "
local exterm " `exterm' "*carcinoma*" "*lioma*" "*olvaction test*" "
local exterm " `exterm' "olfaction" "*cytoma*" "*trigone*" "*uncinate*" "
local exterm " `exterm' "*radiation*" "*odorifer*" "*feet*" "*genitalia*" "
local exterm " `exterm' "*axilla*" "*emic*" "*genital*" "*bulb*" "
local exterm " `exterm' "*evoked potential*" "*epithelium*" "
local exterm " `exterm' "*ryodoraku*" "*odorans*" "

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
export delimited using "../codelists/working/snomed-lossTasteSmell-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



