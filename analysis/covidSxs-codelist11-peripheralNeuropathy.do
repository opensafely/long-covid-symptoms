/*=========================================================================
DO FILE NAME:			covidSxs-codelist11-peripheralNeuropathy

AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-06
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for peripheral neuropathy and
							pins and needles
						 				
MORE INFORMATION:	Q:
					are we only looking for generalised neuropathy, or do we include mononeuropathy (including 		
					individual nerve compression that's more likely to have a mechanical cause? and things like 
					radiculopathy?). What about things with clear precipitating causes, e.g., diabetic peripheral 
					neuropathy? Do I include everything and then exclude the monon-neuropathies in a sens analysis?
					
					A: 
					include mononeuropathy
					
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-peripheralNeuropathy-working
																
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
global filename "covidSxs-codelist11-peripheralNeuropathy"

* open log file
log using "../logs/${filename}", text replace






/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*numb*" "*pins*" "*needles*" "*peripheral neuro*" "
local searchterm " `searchterm' "*peripheral nerve*" "*neuralgia*" "
local searchterm " `searchterm' "*neuritis*" "*neuropath*" "*radiculopath*" "
local searchterm " `searchterm' "*tingling*" "*tingle*" "*bells*" "*bell's*" "
local searchterm " `searchterm' "*paresthesia*" "*paraesthesia*" "*pricking*" "
local searchterm " `searchterm' "*prickling*" "*cranial nerve*" "*facial nerve*" "

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
* review potential exclusions, including new search terms added after 
* initial review
list term if strmatch(term_lc,"*(finding)") // keep for review
list term if strmatch(term_lc,"*(procedure)") // drop
list term if strmatch(term_lc,"*(qualifier value)") // drop
list term if strmatch(term_lc,"*tingle*") // no results
list term if strmatch(term_lc,"*tingling*") // all look potentially relevant
list term if strmatch(term_lc,"*bells*")
list term if strmatch(term_lc,"*bell's*")
list term if strmatch(term_lc,"*paresthesia*")
list term if strmatch(term_lc,"*paraesthesia*")
list term if strmatch(term_lc,"*pricking*")
list term if strmatch(term_lc,"*prickling*")
list term if strmatch(term_lc,"*cranial nerve*") 
list term if strmatch(term_lc,"*facial nerve*")

* multi-term exclusions
list term if strmatch(term_lc,"*facial nerve*") & strmatch(term_lc,"*branch*")==1
drop if strmatch(term_lc,"*facial nerve*") & strmatch(term_lc,"*branch*")==1

list term if strmatch(term_lc,"*facial nerve*") & strmatch(term_lc,"*root*")==1
drop if strmatch(term_lc,"*facial nerve*") & strmatch(term_lc,"*root*")==1

* only want to include 7th CN, not the others
list term if strmatch(term_lc,"*cranial nerve*") & strmatch(term_lc,"*7*")!=1 & strmatch(term_lc,"*seven*")!=1 & strmatch(term_lc,"*facial*")!=1 & strmatch(term_lc,"*vii*")!=1
drop if strmatch(term_lc,"*cranial nerve*") & strmatch(term_lc,"*7*")!=1 & strmatch(term_lc,"*seven*")!=1 & strmatch(term_lc,"*facial*")!=1 & strmatch(term_lc,"*vii*")!=1


* define exclusions
local exterm " "*(qualifier value)" "*number*" "
local exterm " `exterm' "*(procedure)" "*headache*" "
local exterm " `exterm' "*zoster*" "*aids with*" "
local exterm " `exterm' "*clean needles*" "*poisoning*" "*abscess*" "
local exterm " `exterm' "*epilepsy*" "*dysgenesis*" "*copper*" "*lipoprotein*" "
local exterm " `exterm' "*allograft*" "*diabetes*" "*diabetic*" "
local exterm " `exterm' "*anaesthetic*" "*anesthetic*" "
local exterm " `exterm' "*alcohol*" "admission *" "*(organism)" "
local exterm " `exterm' "*affenpinscher*" "*neurostimulator*" "*amyloid*" "*otropins*" "
local exterm " `exterm' "*anastomosis*" "*stimulation*" "assessment using*" "
local exterm " `exterm' "at risk for*" "*pinscher*" "
local exterm " `exterm' "*autosomal*" "*metabolic*" "*sodium*" "
local exterm " `exterm' "drug*" "*medication*" "*avulsion*" "
local exterm " `exterm' "*due to drug*" "*caused by drug*" " 
local exterm " `exterm' "*endocrine*" "*tangier*" "*refsum*" "
local exterm " `exterm' "*heart rate*" "*neoplasm*" "*tumour*" "*tumor*" "
local exterm " `exterm' "*agglutinin*" "*congenital*" "*cancer*" "
local exterm " `exterm' "*canine*" "*carcinoma*" "*injury*" "
local exterm " `exterm' "clean*" "*fabry*" "*beriberi*" "*chemotherap*" "
local exterm " `exterm' "*contusion*" "core build*" "
local exterm " `exterm' "*disposal*" "*hereditary*" "*division*" "
local exterm " `exterm' "*clean*" "*encephalomyeloneuropathy*" "entire*" "*acrodystrophic*" "
local exterm " `exterm' "*thyroid*" "*cutting*" "*cryotherap*" "*encephaloneuropathy*" "
local exterm " `exterm' "*decompression*" "*destruction*" "*diagnostic*" "
local exterm " `exterm' "*dental*" "*diphtheritic*" "*debridement*" "*crushing*" "*curettage*" "
local exterm " `exterm' "discharge by*" "*epineural*" "*epiperineural*" "
local exterm " `exterm' "*morton*" "*excision*" "*exploration*" "*fungal*" "
local exterm " `exterm' "*extirpation*" "*familial*" "*family history*" "fear of*" "
local exterm " `exterm' "*fixation*" "*ablation*" "*adhesion*" "*graft*" "*gouty*" "
local exterm " `exterm' "*hiv*" "*hepatic*" "*surgery*" "*history of*" "
local exterm " `exterm' "*human immunodeficiency virus*" "*pre-filled*" "
local exterm " `exterm' "h/o*" "*hairpins*" "*horton*" "*hunt's*" "*hunt neuralgia*" "
local exterm " `exterm' "*syringes*" "*(physcial object)" "*anticardiolipins*" "
local exterm " `exterm' "*implantation*" "*incision*" "*nerve block*" "
local exterm " `exterm' "*total score*" "*inherited*" "*removal*" "
local exterm " `exterm' "*injection*" "*insertion*" "*insulin*" "
local exterm " `exterm' "*bladder*" "*vitamin*" "*paraneoplast*" "
local exterm " `exterm' "*vestibular*" "*optic*" "*retrobulbar*" "
local exterm " `exterm' "*x-linked*" "*dysmorphism*" "
local exterm " `exterm' "*uremic*" "*vidian*" "*tropical*" "
local exterm " `exterm' "*trigeminal*" "*transposition*" "*transplantation*" "
local exterm " `exterm' "*syphilitic*" "*acoustic*" "*thamine*" "
local exterm " `exterm' "*testicular*" "*swanson*" "*suture*" "structure of*" "
local exterm " `exterm' "spinster*" "*cerebellar*" "*sphenopalatine*" "
local exterm " `exterm' "*tick-borne*" "*transection*" "*trauma*" "seen by*" "
local exterm " `exterm' "*release*" "*repair*" "section of*" "*sarcoid*" "
local exterm " `exterm' "*neoplas*" "*nutritional*" "*in other diseases*" "
local exterm " `exterm' "*referral to*" "radiation*" "*pyrophosphate*" "
local exterm " `exterm' "*abdominal polyradiculopathy*" "*nerve structure*" "
local exterm " `exterm' "*auditory*" "*antibodies" "*combined disorder of muscle and peripheral nerve*" "
local exterm " `exterm' "*cranial neur*" "*deafness*" "*enuculeation*" "
local exterm " `exterm' "*glossopharyng*" "*harvest*" "*visceral*" "*hypoglossal*" "
local exterm " `exterm' "*lead*" "*leprosy*" "*motor neuropathy syndrome*" "*antineutrophil*" "
local exterm " `exterm' "*lock pin*" "*lyme*" "*malignant*" "*lyon*" "*hypogonadism syndrome*" "
local exterm " `exterm' "*ciliary*" "*mumps*" "*myxedema*" "*needles source*" "
local exterm " `exterm' "*biopsy*" "*with aids*" "*amputation*" "*navajo neuropathy*" "
local exterm " `exterm' "*facialis vera*" "neuropathy due to*" "neuropathy in*" "neuropathy" "
local exterm " `exterm' "neuropathy (*" "neuropathy associated with*" "neuropathy caused by*" "
local exterm " `exterm' "neurophathologist*" "neuropathology*" "
local exterm " `exterm' "neuropathy check*" "*hearing impairment" "neuropathy with*" "
local exterm " `exterm' "*neuropathologist*" "*declined*" "*niacin*" "*niemann*" "*nigerian*" "
local exterm " `exterm' "*deficiency*" "*neurotmesis*" "*neuroplasty*" "patient unsuitable*" "
local exterm " `exterm' "peripheral nerve of*" "*operation*" "
local exterm " `exterm' "*pregnancy*" "*collagen*" "*cytomegalovir*" "*mononucleo*" "
local exterm " `exterm' "*poems*" "*menopause*" "*cataract*" "*rheumatoid*" "
local exterm " `exterm' "*porphyric*" "*gammopathy*" "*post-herpetic*" "
local exterm " `exterm' "*radium*" "radio*" "*(body structure)" "*pain scale*" "*pain score*" "
local exterm " `exterm' "*sacrifice*" "*postherpetic*" "selective*" "*denervation*" "
local exterm " `exterm' "*serum*" "*sexual*" "shares*" "*sluder*" "spastic paraplegia*" "*stump*" "
local exterm " `exterm' "*uraemic*" "*vascultitic*" "*parasitic*" "*connective tissue*" "
local exterm " `exterm' "abdominal*" "agenesis of*" "approximation*" "
local exterm " `exterm' "*autonomic*" "*dermatitis syndrome*" "*fungus*" "
local exterm " `exterm' "*jacobson*" "*jamaican*" "*hyperhidrosis*" "*multiple conduction block*" "
local exterm " `exterm' "*melnick-needles*" "*metastasis*" "*microcephal*" "*charcot*" "
local exterm " `exterm' "*corneal*" "*leprae*" "*pins procedure*" "*waardenburg*" "
local exterm " `exterm' "*pellagra*" "*suturing*" "*injected*" "*nerve fib*" "
local exterm " `exterm' "*in situ" "*thickening*" "*neuroblastoma*" "*sclerotic*" "
local exterm " `exterm' "*radiation*" "*cystic fibrosis*" "*lupus*" "*polyarteritis*" "*cardiolipin*" "
local exterm " `exterm' "*porphyria*" "*electricity*" "*gaucher*" "*glycoprotein*" "*systemic sclerosis*" "
local exterm " `exterm' "*fothergill*" "*migrain*" "*classification*" "*campbell's*" "
local exterm " `exterm' "*blister*" "*intact*" "*viii*" "*nucleus*" "*nerve function*" "
local exterm " `exterm' "*motor root*" "*allerg*" "*mri*" "

foreach word in `exterm' {
	display "`word'"
	list term if strmatch(term_lc,"`word'")
	drop if strmatch(term_lc,"`word'")
}



list term if strmatch(term_lc,"*cranial nerve*") & strmatch(term_lc,"*disorder*")!=1 & strmatch(term_lc,"*palsy*")!=1 
drop if strmatch(term_lc,"*cranial nerve*") & strmatch(term_lc,"*disorder*")!=1 & strmatch(term_lc,"*palsy*")!=1 
list term if strmatch(term_lc,"*cranial nerve*")







/*******************************************************************************
#3. Display candidate codes that will be imported to OpenCodelists
*******************************************************************************/
sort term
list term

* summarise number of codes
quietly describe

/*
*******************************************************************************
*******************************************************************************
*******************************************************************************
*/
display "*** number of codes to review = `r(N)' ***"
/*
*******************************************************************************
*******************************************************************************
*******************************************************************************
*/






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
export delimited using "../codelists/working/snomed-peripheralNeuropathy-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



