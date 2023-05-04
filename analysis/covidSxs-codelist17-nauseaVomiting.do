/*=========================================================================
DO FILE NAME:			covidSxs-codelist17-nauseaVomiting
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-13
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for nausea and vomiting
						 				
MORE INFORMATION:	
	
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
global filename "covidSxs-codelist17-nauseaVomiting"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*nausea*" "*vomit*" "*emesis*" "*emetic*" "*motion sick*" "
local searchterm " `searchterm' "*sick*" "

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
list term if strmatch(term_lc,"*(procedure)") // keep for review
list term if strmatch(term_lc,"*(organism)") // drop
list term if strmatch(term_lc,"*(qualifier value)") // drop
list term if strmatch(term_lc,"*(physical object)") // drop
list term if strmatch(term_lc,"*structure*") // drop
list term if strmatch(term_lc,"*observable entity*") // keep for review
list term if strmatch(term_lc,"*(product)") // drop
list term if strmatch(term_lc,"*(substance)") // drop


list term if strmatch(term_lc,"*region") // no codes

* define exclusions
/*
list term if strmatch(term_lc,"*movement*") & strmatch(term_lc,"*pain*")!=1 
drop if strmatch(term_lc,"*movement*") & strmatch(term_lc,"*pain*")!=1 

list term if strmatch(term_lc,"*abdominal wall*") & strmatch(term_lc,"*pain*")!=1 
drop if strmatch(term_lc,"*abdominal wall*") & strmatch(term_lc,"*pain*")!=1 

list term if strmatch(term_lc,"*region") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*tender*")!=1 
drop if strmatch(term_lc,"*region") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*tender*")!=1 

list term if strmatch(term_lc,"*muscle*") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*strain*")!=1 
drop if strmatch(term_lc,"*muscle*") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*strain*")!=1 
*/

local exterm " "*(organism)" "*(qualifier value)" "*(physical object)" "*(structure)" "*(product)" "*(substance)" "
local exterm " `exterm' "*sickle*" "*absence*" "*benefit*" "*sick pay*" "*self-induced*" "
local exterm " `exterm' "*pregnan*" "*gravid*" "*holiday*" "*travel*" "
local exterm " `exterm' "*induction*" "*ipecac*" "*decompression*" "*diver*" "
local exterm " `exterm' "*sinus*" "*homesick*" "*sick leave*" "*sick role*" "
local exterm " `exterm' "*adverse reaction*" "*african*" "*air sick*" "
local exterm " `exterm' "*analgesic*" "*overdose*" "*anxiety*" "
local exterm " `exterm' "*pneumonia*" "*at risk*" "*car *" "*mountain*" "
local exterm " `exterm' "*blood*" "*haematem*" "*hematem*" "*coffee*" "*surgery*" "
local exterm " `exterm' "*operat*" "*sickling*" "*poison*" "*radiation*" "
local exterm " `exterm' "*chemoth*" "*care of sick*" "*cannabis*" "
local exterm " `exterm' "*sleeping*" "*notif*" "*admission*" "
local exterm " `exterm' "*administrat*" "*antiallerg*" "*advice to*" "
local exterm " `exterm' "*allergy*" "*cares for*" "*calf*" "*vomitoria*" "
local exterm " `exterm' "*concealed*" "*drugs used in*" "*basin*" "*bowl*" "
local exterm " `exterm' "*drugs*" "*emetic therapeutic*" "*gestat*" "
local exterm " `exterm' "*on leave cert*" "*foreign body*" "
local exterm " `exterm' "history of*" "*anaesthet*" "*anesthet" "
local exterm " `exterm' "*jamaica*" "*notification*" "*loc 3*" "*airway*" "
local exterm " `exterm' "*alpine*" "*aspirat*" "*loc1*" "*loc2*" "*loc3*" "
local exterm " `exterm' "looks after*" "*noxious food*" "*inhal*" "
local exterm " `exterm' "*toxic*" "*antiemetic*" "*bag*" "*emetic*" "
local exterm " `exterm' "chronic sick*" "*erotic*" "*ghost*" "*making self*" "
local exterm " `exterm' "measure*" "*mckusick*" "*microscop*" "*lame sick*" "
local exterm " `exterm' "no *" "*outerspace*" "*outer space*" "*parasite*" "
local exterm " `exterm' "*prison*" "*private*" "*sick day*" "*pus in*" "*sea sick*" "
local exterm " `exterm' "*serum*" "*sick child*" "*sick note*" "*relative*" "
local exterm " `exterm' "*euthyroid*" "*sickening*" "*certificate*" "*payment*" "
local exterm " `exterm' "*injury*" "*allowance*" "*surreptit*" "*stiff*" "
local exterm " `exterm' "*train*" "*unable to care*" "
local exterm " `exterm' "*viral*" "*visick*" "*ova*" "
local exterm " `exterm' "*infectious*" "*gastroenteritis*" "*railroad*" "*motion*" "
local exterm " `exterm' "*face*" "*headache*" "*drug-induced*" "*encounter with*" "
local exterm " `exterm' "*accompanying*" "*in the family*" "
local exterm " `exterm' "*impact profile*" "*score*" "*gallsick*" "*deliver*" "
local exterm " `exterm' "*hyperemesis*" "*morning*" "*milk*" "*mepyramine*" "
local exterm " `exterm' "*radiothe*" "*animal*" "*1994*" "*building*" "
local exterm " `exterm' "*domperidone*" "*infective*" "*swine*" "*piglet*" "
 
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
export delimited using "../codelists/working/snomed-nauseaVomiting-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



