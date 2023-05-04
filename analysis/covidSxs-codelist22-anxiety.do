/*=========================================================================
DO FILE NAME:			covidSxs-codelist22-anxiety
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-20
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for anxiety
						 				
MORE INFORMATION:	Aim to include symptoms and diagnoses of anxiety
					
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-anxiety-working
																
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
global filename "covidSxs-codelist22-anxiety"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*anxiety*" "*anxio*" "*nueroses*" "*neurosis*" "*neurotic*" "
local searchterm " `searchterm' "*worry*" "*worried*" "*hypervigilan*" "
local searchterm " `searchterm' "*angst*" "*panic*" "*phobia*" "
local searchterm " `searchterm' "*fear*" "*adjustment*" "
local searchterm " `searchterm' "*stress*" "*nervous*" "*unease*" "*terror*" "
local searchterm " `searchterm' "*terrify*" "*terrified*" "*hysteri*" "*afraid*" "
local searchterm " `searchterm' "*apprenhen*" "


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


list term if strmatch(term_lc,"*adjustment*") & strmatch(term_lc,"*reaction*")!=1 & strmatch(term_lc,"*disorder*")!=1 
drop if strmatch(term_lc,"*adjustment*") & strmatch(term_lc,"*reaction*")!=1 & strmatch(term_lc,"*disorder*")!=1 


local exterm " "*x-ray*" "*operation*" "*injection*" "*tympanic*" "
local exterm " `exterm' "*nervous system*" "*stress test*" "*tomography*" "
local exterm " `exterm' "*stress study*" "*aponeurosis*" "*apanicolaou*" "
local exterm " `exterm' "*magnetic*" "*urinary*" "*exercise stress*" "
local exterm " `exterm' "*endoscop*" "*spiritual*" "*nutrition*" "
local exterm " `exterm' "*chiropractic*" "*cardiovascular*" "*bladder*" "
local exterm " `exterm' "*incontinence*" "adjustment to*" "adjustment of*" "
local exterm " `exterm' "*(organism)" "*terrorism*" "*angstrom*" "*stress exercise*" "
local exterm " `exterm' "*(physical object)" "*tongue*" "*-adjustment*" "*shower*" "
local exterm " `exterm' "*denture*" "*diabetes*" "entire*" "*nervous tissue*" "
local exterm " `exterm' "*nervous plexus*" "*nervous structure*" "*aponeurotic*" "
local exterm " `exterm' "*structure*" "*scale*" "*score*" "*questionnaire*" "
local exterm " `exterm' "*ischemia*" "*ischaemia*" "*photosress*" "
local exterm " `exterm' "*urethra*" "*(product)" "*panicum*" "*(substance)" "
local exterm " `exterm' "*stressbits*" "*biotic*" "*central nervous*" "
local exterm " `exterm' "*angio*" "*tumor*" "*tumour*" "*birth*" "*fetal*" "*foetal*" "
local exterm " `exterm' "*ejaculation*" "*personality*" "*respiratory*" "*photophobia*" "
local exterm " `exterm' "*cramp*" "*accident*" "*maladjustment*" "
local exterm " `exterm' "able to*" "*inventory*" "*trauma*" "*checklist*" "
local exterm " `exterm' "*attribute*" "* action*" "*absence of*" "*schizophren*" "
local exterm " `exterm' "*psychotic disorder*" "*hispanic*" "*withdrawal*" "
local exterm " `exterm' "*-induced*" "*caused by*" "*agent*" "*anxiopsis*" "
local exterm " `exterm' "assessment of*" "at risk*" "*grass*" "
local exterm " `exterm' "*ulcer*" "*cape fear*" "*mri*" "*magnetic*" "*papanicolau*" "
local exterm " `exterm' "fh:*" "*survey*" "family history*" "famity distress*" "
local exterm " `exterm' "*trophoneurosis*" "*general nervous symptom*" "
local exterm " `exterm' "*dependence*" "*maternal*" "*marital problem*" "
local exterm " `exterm' "*metabolic stress*" "*imaging*" "*abuse*" "*remission*" "
local exterm " `exterm' "*perfusion*" "*radionuclide*" "*repetitive stress*" "
local exterm " `exterm' "*resp*" "*ography*" "*delirium*" "*rabies*" "
local exterm " `exterm' "*anxiolytic-related*" "*biplolar*" "*fracture*" "
local exterm " `exterm' "*polycyth*" "*musculoskeletal*" "*delusion*" "*adverse effect*" "
local exterm " `exterm' "h/o:*" "history of*" "*terrorist*" "*gait*" "
local exterm " `exterm' "*perception*" "*globus hysteric*" "*rufulum*" "*simulation*" "
local exterm " `exterm' "*opsia*" "*fever*" "*edema*" "*hysteriales*" "*kick *" "
local exterm " `exterm' "*ganser*" "*tired all the time*" "

foreach word in `exterm' {
	display "`word'"
	list term if strmatch(term_lc,"`word'")
	drop if strmatch(term_lc,"`word'")
}





********************************************************************************
********************************************************************************
* not sure if specific phobias should be included
* aim to list things that might be excluded if we drop fears and phobias about 
* specific things
list term if strmatch(term_lc,"*ophobia*")
list term if strmatch(term_lc,"*fear of*")
list term if strmatch(term_lc,"*worried about*")
list term if strmatch(term_lc,"*afraid of*")
list term if strmatch(term_lc,"anxiety about*")

list term if strmatch(term_lc,"* phobia*") | strmatch(term_lc,"phobia*")



	

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
export delimited using "../codelists/working/snomed-anxiety-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



