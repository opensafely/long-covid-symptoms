/*=========================================================================
DO FILE NAME:			covidSxs-codelist15-visualImpairment
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-07
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for visual impairment	
						Will be used as an outcome in older populations only
						 				
MORE INFORMATION:	Q.
					What about hemeralopia, macropsia, metamorphopsia, 
					micropsia? 
					Unlikely to be used a lot (I needed to look them up!) 
					so probably not an issue
					
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-visualImpairment-working
																
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
global filename "covidSxs-codelist15-visualImpairment"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*visual*" "*vision*" "*diplopia*" "*blind*" "*amblyopia*" "
local searchterm " `searchterm' "*scotoma*" "*blur*" "*photophobia*" "


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
list term if strmatch(term_lc,"*(procedure)") // drop
list term if strmatch(term_lc,"*(organism)") // drop
list term if strmatch(term_lc,"*(qualifier value)") // drop
list term if strmatch(term_lc,"*(physical object)") // drop
*/


* define exclusions
/*
list term if strmatch(term_lc,"*walker*") & strmatch(term_lc,"*mobilize*")!=1 & strmatch(term_lc,"*mobilise*")!=1
drop if strmatch(term_lc,"*walker*") & strmatch(term_lc,"*mobilize*")!=1 & strmatch(term_lc,"*mobilise*")!=1
*/

local exterm " "*(procedure)" "*(organism)" "*(qualifier value)" "*(physical object)" "
local exterm " `exterm' "*keratitis*"  "*provision*" "*snow blind*" "
local exterm " `exterm' "*trauma*" "injury*" "
local exterm " `exterm' "*corrected visual acuity*" "
local exterm " `exterm' "*glaucoma*" "*supervision*" "aids*" "ability to*" "able to*" "
local exterm " `exterm' "*revision*" "*cataract*" "*cerebrovascular*" "
local exterm " `exterm' "*division*" "*blindfold*" "*scale*" "*score*" "
local exterm " `exterm' "*audio-visual*" "*audiovisual*" "*pregancy*" "
local exterm " `exterm' "*believe*" "visual acuity test*" "*evoked*" "
local exterm " `exterm' "*(navigational concept)" "*(situation)" "*testing done*" "
local exterm " `exterm' "fh*" "*alcohol*" "*angiomatous*" "*angioscotoma*" "
local exterm " `exterm' "*bjerrum*" "*blind biopsy*" "*lavage*" "*boil*" "
local exterm " `exterm' "*snake*" "*fistula*" "*poisoning*" "* goby*" "
local exterm " `exterm' "*teacher*" "*auditory*" "*disc margin*" "
local exterm " `exterm' "*immunodeficiency*" "*with aids*" "*cervix*" "
local exterm " `exterm' "*child*" "*night blind*" "*television*" "
local exterm " `exterm' "*visulisation*" "*color blind*" "*colour blind*" "
local exterm " `exterm' "*colour vision defi*" "*color vision defi*" "
local exterm " `exterm' "*colour vision test*" "*color vision test*" "
local exterm " `exterm' "*colour vision exam*" "*color vision exam*" "
local exterm " `exterm' "cv -*" "cvf -*" "*cortical blind*" "
local exterm " `exterm' "*deafblind*" "*deaf-blind*" "
local exterm " `exterm' "*deprivation*" "*visualization*" "*visualisation*" "
local exterm " `exterm' "*early*" "etdrs*" "*drug related*" "
local exterm " `exterm' "*dysplasia*" "*examination normal*" "
local exterm " `exterm' "family history*" "*x-linked*" "
local exterm " `exterm' "fitting of*" "finding of*" "*eyeglasses*" "eye/vision*" "
local exterm " `exterm' "eye / vision*" "feature of*" "frostig*" "
local exterm " `exterm' "general visual*" "growth*" "h/o:*" "hvf*" "*hereditary*" "
local exterm " `exterm' "history of*" "*follicularis*" "iq*" "*infarction*" "
local exterm " `exterm' "logmar*" "*blind loop*" "*non-visualised*" "
local exterm " `exterm' "*nutritional*" "*color vision*" "*colour vision*" "
local exterm " `exterm' "*vision - color" "*vision - colour" "
local exterm " `exterm' "*acuity r-eye" "*acuity l-eye" "*visual fields normal*" "
local exterm " `exterm' "*squint*" "*deaf and blind*" "delayed visual*" "
local exterm " `exterm' "deposits*" "*driver*" "*education*" "
local exterm " `exterm' "enteral*" "entire*" "examination*" "head posture*" "
local exterm " `exterm' "heightened*" "in practice*" "movement*" "nasal*" "
local exterm " `exterm' "*visual fields nos*" "*suction*" "*osteoporosis*" "
local exterm " `exterm' "*ultraviolet*" "physiologic concept*" "
local exterm " `exterm' "pinhole*" "psychologic*" "quadrantic visual*" "
local exterm " `exterm' "*sound/vision*" "*(occupation)" "*leukoma*" "
local exterm " `exterm' "*deaf blind*" "*hallucination*" "o/e colour*" "o/e color*" "
local exterm " `exterm' "*sequential memory*" "*unblinding*" "structure of*" "
local exterm " `exterm' "*taste-blind*" "*visualized*" "*visualised*" "
local exterm " `exterm' "*tobacco*" "*blindcat*" "*uterus*" "
local exterm " `exterm' "va -*" "var -*" "vare - *" "vl -*" "vr -*" "vra -*" "vrd -*" "
local exterm " `exterm' "vision care*" "*no abnormality detected*" "*hallusinat*" "
local exterm " `exterm' "*testing not done*" "*pinhole*" "(visual testing)*" "
local exterm " `exterm' "*neoplasm*" "lead dog*" "left eye*" "right eye*" "*deposits*" "
local exterm " `exterm' "*california*" "fgp -*" "ftc -*" "ftvp -*" "
local exterm " `exterm' "normal vision" "*music*" "*family history*" "
local exterm " `exterm' "visual testing normal*" "visual testing" "visual testing (&*" "
local exterm " `exterm' "[v]examination of*" "*diabetic*" "*epilepsy*" "*diabetes*" "
local exterm " `exterm' "*word blind*" "

foreach word in `exterm' {
	display "`word'"
	list term if strmatch(term_lc,"`word'")
	drop if strmatch(term_lc,"`word'")
}




/*******************************************************************************
NB: I've explicitly dropped the following results of testing visual acuity
and distance vision:
	- "*visual acuity of left*" 
	- "*visual acuity of right*"
	- visual acuity of
	- distance vis*

I'm not sure if this is the correct approach.
As I'm concerned that some of the numbers reflect poor vision
However, I'm rubbish with this sort of thing, so don't know what is bad vision.
I also wonder reaslistically, just how much these codes will be used

Laurie please review the codes dropped by these terms in particular to 
make sure that you agree they should be dropped 
before I finalise the candidate code list for review on OpenCodelists
********************************************************************************/
* drop controversial codes
local exterm " "*visual acuity of left*" "*visual acuity of right*" "
local exterm " `exterm' "*visual acuity of*" "distance vis*" "
local exterm " `exterm' "*jaeger*" "near visual acuity*" "o/e - l-eye visual acuity*" "
local exterm " `exterm' "o/e - r-eye visual acuity*" "
local exterm " `exterm' "o/e - right eye visual acuity*" "o/e - left eye visual acuity*" "
local exterm " `exterm' "o/e - visual acuity l*" "o/e - visual acuity r*" "
local exterm " `exterm' "o/e- visual acuity l-eye*" "o/e- visual acuity r-eye*" "
local exterm " `exterm' "o/e visual acuity right eye*" "o/e visual acuity left eye*" "
local exterm " `exterm' "*(corrected)*" "
local exterm " `exterm' "on examination - left eye visual acuity*" "on examination - right eye visual acuity*" "
local exterm " `exterm' "on examination - visual acuity l-eye*" "on examination - visual acuity r-eye*" "
local exterm " `exterm' "on examination - visual acuity left eye*" "on examination - visual acuity right eye*" "
local exterm " `exterm' "vision equip*" "*not completed*" "

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
export delimited using "../codelists/working/snomed-visualImpairment-working.csv", replace novarnames
 
/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



