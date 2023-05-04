/*=========================================================================
DO FILE NAME:			covidSxs-codelist18-diarrhoea
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-13
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for diarrhea
						 				
MORE INFORMATION:	non-infective gastroenteritis
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-abdoPain-working
																
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
global filename "covidSxs-codelist18-diarrhoea"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*diarrhoea*" "*diarrhea*" "*loose stool*" "*stool loose*" "
local searchterm " `searchterm' "*watery stool*" "*stool watery*" "*loose faeces*" "
local searchterm " `searchterm' "*loose feces*" "*faeces loose*" "*feces loose*" "
local searchterm " `searchterm' "*watery faeces*" "*watery feces*" "
local searchterm " `searchterm' "*faeces watery*" "
local searchterm " `searchterm' "*feces watery*" "
local searchterm " `searchterm' "*loose bowel*" "*bowel loose*" "

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
list term if strmatch(term_lc,"*(procedure)") // drop
list term if strmatch(term_lc,"*(organism)") // drop
list term if strmatch(term_lc,"*(qualifier value)") // drop
list term if strmatch(term_lc,"*(physical object)") // drop
list term if strmatch(term_lc,"*structure*") // drop
list term if strmatch(term_lc,"*observable entity*") // drop
list term if strmatch(term_lc,"*(product)") // drop
list term if strmatch(term_lc,"*(substance)") // drop

list term if strmatch(term_lc,"*region") // no codes

* define exclusions
local exterm " "*(procedure)" "*(organism)" "*(qualifier value)" "*(physical object)" "*(structure)" "
local exterm " `exterm' "*(product)" "*(substance)" "* infect*" "infec*" "*neonatal*" "*dietetic*" "
local exterm " `exterm' "*viral*" "*allerg*" "*adverse reaction*" "*equine*" "
local exterm " `exterm' "*drug*" "*travel*" "*agent*" "*antigen*" "*at risk*" "
local exterm " `exterm' "*bovine*" "*vaccine*" "*virus*" "*antibiotic*" "anti-diarrh*" "
local exterm " `exterm' "*poison*" "*antidiarrh*" "*carcin*" "*campylo*" "
local exterm " `exterm' "*deficiency*" "*clostrid*" "*congenit*" "*atrophy*" "
local exterm " `exterm' "*surgery*" "*operat*" "
local exterm " `exterm' "*caused by*" "*due to*" "*diabetes*" "*pregan*" "
local exterm " `exterm' "*uremic*" "*uraemic*" "*dystent*" "*dientamebal*" "
local exterm " `exterm' "*epizoo*" "*nodosa*" "*flagella*" "*escherich*" "
local exterm " `exterm' "*haemorr*" "hemorr*" "*formula*" "*erythroderma*" "
local exterm " `exterm' "*phenotyp*" "post*" "*protozoa*" "*osmotic*" "*dysent*" "
local exterm " `exterm' "*prototheca*" "*patella*" "*milk*" "*vagotomy*" "
local exterm " `exterm' "*atresia*" "*hill dia*" "*ea-infective*" "*bact*" "
local exterm " `exterm' "*pregnan*" "*not present*" "*achlorhydric*" "*brainerd*" "
local exterm " `exterm' "*mouse*" "*defecation reflex*" "

 
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
export delimited using "../codelists/working/snomed-diarrhoea-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



