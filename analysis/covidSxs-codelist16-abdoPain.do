/*=========================================================================
DO FILE NAME:			covidSxs-codelist16-abdoPain
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-08
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for abdominal pain
						 				
MORE INFORMATION:	Q.
					What about heartburn/indigestion? Gastric flu? IBS?
					
					A.
					Include heartburn indigestion
					
	
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
global filename "covidSxs-codelist16-abdoPain"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*abdom*" "*colic*" "*git pain*" "*epigast*" "*hypogast*" "
local searchterm " `searchterm' "*hypochondri*" "*iliac*" "*irritable bowel syndrome*" "*ibs*" "
local searchterm " `searchterm' "*umbilical*" "*subcostal*" "*abd. pain*" "

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
list term if strmatch(term_lc,"*structure*") // drop
list term if strmatch(term_lc,"*observable entity*") // drop
*/

list term if strmatch(term_lc,"*region") // drop

* define exclusions

list term if strmatch(term_lc,"*movement*") & strmatch(term_lc,"*pain*")!=1 
drop if strmatch(term_lc,"*movement*") & strmatch(term_lc,"*pain*")!=1 

list term if strmatch(term_lc,"*abdominal wall*") & strmatch(term_lc,"*pain*")!=1 
drop if strmatch(term_lc,"*abdominal wall*") & strmatch(term_lc,"*pain*")!=1 

list term if strmatch(term_lc,"*region") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*tender*")!=1 
drop if strmatch(term_lc,"*region") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*tender*")!=1 

list term if strmatch(term_lc,"*muscle*") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*strain*")!=1 
drop if strmatch(term_lc,"*muscle*") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*strain*")!=1 


local exterm " "*(procedure)" "*(organism)" "*(qualifier value)" "*(physical object)" "
local exterm " `exterm' "*x-ray*"  "*angiogram*" "*surgery*" "
local exterm " `exterm' "*trauma*" "*injury*" "*rhabdomyolysis*" "*vein*" "*artery*" "
local exterm " `exterm' "*iliaceae*" "*mycolicibacterium*" "*abdominal pressure*" "
local exterm " `exterm' "*sacroiliac*" "*thoracoabdom*" "*abdominis*" "
local exterm " `exterm' "*cavity*" "*hernia*" "*paracentesis*" "*glycolic*" "
local exterm " `exterm' "*decompression*" "*mesh*" "*shunt*" "*paracentesis*" "
local exterm " `exterm' "*stent*" "*rhabdo*" "*transabdom*" "*aorta*" "
local exterm " `exterm' "*atheroscle*" "*iscahem*" "*wound*" "*suture*" "
local exterm " `exterm' "*ultras*" "*scan*" "history of*" "h/o*" "
local exterm " `exterm' "family history*" "fh:*" "*aortic*" " 
local exterm " `exterm' "*lump*" "*mass*" "*abdominoperi*" "*angina*" "
local exterm " `exterm' "* nad*" "*catheter*" "*aortogram*" "*incision*" "
local exterm " `exterm' "*operat*" "*ography*" "*ganglio*" "*bruit*" "
local exterm " `exterm' "*excision*" "*exercise*" "*flap*" "*heart*" "
local exterm " `exterm' "*ectomy*" "*pectoralis*" "*part of*" "
local exterm " `exterm' "*pregnan*" "*tumour*" "*tumor*" "*malig*" "*carninom*" "
local exterm " `exterm' "*lymph*" "*neoplas*" "*obes*" "*node status*" "
local exterm " `exterm' "*esophag*" "*measurement*" "*manipul*" "*approach*" "
local exterm " `exterm' "*repair*" "* tap*" "*belt*" "*vagin*" "*test*" "
local exterm " `exterm' "*status*" "*perfusion*" "*transposit*" "ct*" "
local exterm " `exterm' "entire*" "* normal*" "*skin fold*" "*ptosis*" "
local exterm " `exterm' "*sepsis*" "*opexy*" "*seizure*" "*scissor*" "
local exterm " `exterm' "*scar*" "*thrust*" "*vascular*" "*structure*" "
local exterm " `exterm' "*abscess*" "*organ*" "*fallopian*" "*plexus*" "*vena cava*" "
local exterm " `exterm' "*retractor*" "*pulse*" "*swell*" "
local exterm " `exterm' "*bone*" "*laparoscop*" "*anaesthe*" "*anesthe*" "
local exterm " `exterm' "*procedure*" "*ureter*" "*phelbot*" "
local exterm " `exterm' "*fistula*" "*hernio*" "*plasty*" "*imaging*" "
local exterm " `exterm' "*abdominopel*" "*blastoma*" "*sarcoma*" "
local exterm " `exterm' "*burn*" "*lesion*" "*abrasion*" "*biopsy*" "
local exterm " `exterm' "*magnetic*" "mri*" "*contrast*" "*aorto*" "
local exterm " `exterm' "*obstruct*" "*thorax*" "*arterial*" "
local exterm " `exterm' "*skin*" "*colicus*" "*foetal*" "*fetal*" "
local exterm " `exterm' "*dissect*" "*blister*" "*carbuncle*" "
local exterm " `exterm' "*viscera*" "*ct of*" "*osteo*" "*congenital*" "*heredit*" "
local exterm " `exterm' "*rib*" "*aneurysm*" "*node*" "*contusion*" "*crush*" "
local exterm " `exterm' "*closure*" "*nerve*" "*gland*" "*blodd*" "*observable entity*" "
local exterm " `exterm' "*percussion*" "*auscultat*" "*colicanis*" "*fracture*" "
local exterm " `exterm' "*ct guide*" "*aspiration*" "*bleed*" "intra-abdo*" "
local exterm " `exterm' "*spleen*" "*liver*" "fixation*" "finding of*" "*palpable*" "
local exterm " `exterm' "*fasia*" "*femero*" "*foetus*" "*fetus*" "*actinomycosis*" "
local exterm " `exterm' "*venous*" "*bite*" "*education*" "*cyst*" "
local exterm " `exterm' "*direct current*" "*gibsoniae*" "*hypochondriasis*" "
local exterm " `exterm' "*destruct*" "*debride*" "*delusion*" "*trunk*" "
local exterm " `exterm' "*colicin*" "*edema*" "*oscopy*" "*sound*" "
local exterm " `exterm' "*surface*" "*removal*" "*explora*" "*panniculus*" "
local exterm " `exterm' "*fascia*" "*block*" "*thrill*" "*anastomosis*" "
local exterm " `exterm' "*fluid-filled*" "*haema*" "*hypochondriacal disorder*" "
local exterm " `exterm' "*crest*" "*resect*" "*intraabdominal*" "
local exterm " `exterm' "*peritoneal*" "*lacerat*" "*image*" "
local exterm " `exterm' "*mucosa*" "*injuries*" "muscle of*" "
local exterm " `exterm' "neck*" "no *" "*nodule*" "*noises*" "
local exterm " `exterm' "normal*" "*breathing*" "*intra-abdom*" "
local exterm " `exterm' "*pulsat*" "*sensation*" "*obstetric*" "*tone*" "
local exterm " `exterm' "*gibsoni*" "*anomaly*" "*spine*" "*tympan*" "
local exterm " `exterm' "*air sac*" "*apron*" "*binder*" "*hair*" "
local exterm " `exterm' "*circumfer*" "*compartment*" "*crisis*" "
local exterm " `exterm' "*discolo*" "*fibroma*" "*friction*" "*reflex*" "
local exterm " `exterm' "*stoma*" "*schwan*" "*swab*" "*absent*" "*diagnostic imag*" "
local exterm " `exterm' "*deform*" "*pull through*" "*abdominocentis*" "*weakness*" "
local exterm " `exterm' "examination of*" "*ileocolic*" "*venog*" "*arteries*" "
local exterm " `exterm' "infection of*" "*insertion*" "*amputa*" "
local exterm " `exterm' "*irrigat*" "*arteriog*" "*lacuna*" "
local exterm " `exterm' "*lax*" "*layer*" "*colic flexure*" "
local exterm " `exterm' "*gastrocolicum*" "*abdominalis*" "*liposuc*" "*lipoma*" "
local exterm " `exterm' "*renal failure*" "*uterus*" "*agenesis*" "*sutering*" "
local exterm " `exterm' "*foreign body*" "*splash*" "*subcutaneous*" "
local exterm " `exterm' "*philiac*" "*tuberculo*" "*enteric*" "
local exterm " `exterm' "*transplant*" "*mescolica*" "*bursa*" "
local exterm " `exterm' "*bruis*" "*shifting*dullness*" "*scapular*" "*scaphoid*" "
local exterm " `exterm' "*diameter*" "*dysostosis*" "*scratch*" "*membrane*" "
local exterm " `exterm' "*reopen*" "*tissue*" "*renewal*" "*reconstruct*" "
local exterm " `exterm' "*radiolo*" "*pipecolic*" "*sinogram*" "*sigmoid*" "
local exterm " `exterm' "posterior*" "*phrenicolic*" "*pendulous*" "
local exterm " `exterm' "paracolic*" "*passerella*" "panicum*" "
local exterm " `exterm' "palpation of*" "*peristalsis*" "*wall contour*" "
local exterm " `exterm' "*contour*" "*microwave*" "*measure of*" "interferential*" "
local exterm " `exterm' "*vessel*" "*iliacus*" "*tuberosity*" "
local exterm " `exterm' "*hemang*" "*hemato*" "*glass*" "*adhesion*" "
local exterm " `exterm' "mra*" "mrv*" "*psychosis*" "*jejunum*" "
local exterm " `exterm' "*duoden*" "*ileum*" "*inemia*" "
local exterm " `exterm' "*carcinoma*" "*caecum*" "*cecum*" "
local exterm " `exterm' "*cellulitis*" "*burst*" "*intussusce*" "
local exterm " `exterm' "*appendic*" "anterior*" "*advice to*" "*colocolic*" "
local exterm " `exterm' "cut of*" "*cross-section*" "disease of*" "*drainage*" "
local exterm " `exterm' "*ligament*" "*ulcer*" "*characteristics*" "
local exterm " `exterm' "*neuritis*" "*neuralgia*" "*appearance of abdo*" "
local exterm " `exterm' "*endemic*" "*consistency*" "*combination therapy*" "
local exterm " `exterm' "*biliary*" "*renal*" "*hepatic*" "*dressing*" "*phlebogram*" "
local exterm " `exterm' "*neuropathy*" "*gibson*" "*blood*" "*fishing*" "
local exterm " `exterm' "*desmoid*" "*dullness*" "*implantation*" "*inject*" "
local exterm " `exterm' "*no abnormal*" "*corset*" "*axillary*" "*appearance*" "
local exterm " `exterm' "general finding of*" "general observation of*" "*neurosis*" "
local exterm " `exterm' "*resonant*" "*not distended*" "*not tender*" "
local exterm " `exterm' "*drain*" "*dropsy*" "*mammary*" "*naemia*" "
local exterm " `exterm' "*(navigational concept)" "mouth*" "named sign*" "
local exterm " `exterm' "oblique lie*" "*opening*" "*epigastricus*" "
local exterm " `exterm' "*trocar*" "*varicosit*" "*venotomy*" "*viscus*" "
local exterm " `exterm' "*pull-through*" "*abdominouterotomy*" "*abdominocentesis*" "
local exterm " `exterm' "*fullness*" "*fibser*" "*infectious*" "*arterio*" "
local exterm " `exterm' "*apoplex*" "*resonance*" "*respiration*" "
local exterm " `exterm' "*wood*" "*uroabdo*" "*pelvic*" "*hemorrha*" "*haemorrhage*" "
local exterm " `exterm' "*discharge*" "*tube care*" "*ligator*" "*truss*" "*birth*" "
local exterm " `exterm' "*stump*" "*polyp*" "*granuloma*" "*torsion*" "
local exterm " `exterm' "*umbilical cord*" "*adenoma*" "*arteritis*" "
local exterm " `exterm' "*umbilical fold*" "*umbilical ligature*" "
local exterm " `exterm' "*umbilical piercing*" "*umbilical ring*" "*hippeutis*" "

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
export delimited using "../codelists/working/snomed-abdoPain-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



