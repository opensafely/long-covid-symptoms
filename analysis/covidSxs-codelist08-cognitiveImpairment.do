/*=========================================================================
DO FILE NAME:			covidSxs-codelist08-cognitiveImpairment

AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-June-08
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for brain fog
						 				
MORE INFORMATION:	Diminished or impaired mental and/or intellectual function.	
					Q. What about functional neurological disorders 
					A. +/- sens analysis excluding
					
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-cognitiveImpairment-working
																
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
global filename "covidSxs-codelist08-cognitiveImpairment"

* open log file
log using "../logs/${filename}", text replace






/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*cognitive*" "*brain fog*" "*concentrat*" "
local searchterm " `searchterm' "*memory*" "*amnesia*" "*cognit*" "
local searchterm " `searchterm' "*mental*" "*intellect*" "*remember*" "*absent mind*" "
local searchterm " `searchterm' "*attention*" "*disorient*" "


include "inc_search_snomedcodelist.do"


sort term
order code term_lc

* summarise number of codes
quietly describe
display "*** number of codes to review = `r(N)' ***"




/*******************************************************************************
#2. Exclude obvioiusly irrelevant codes returned by the search
	- to make codes more specific
*******************************************************************************/
* define exclusions
list term if strmatch(term_lc,"*(procedure)") & strmatch(term_lc,"*memory*")!=1 & strmatch(term_lc,"*referral*")!=1
drop if strmatch(term_lc,"*(procedure)") & strmatch(term_lc,"*memory*")!=1 & strmatch(term_lc,"*referral*")!=1


list term if strmatch(term_lc,"*mentally*") & strmatch(term_lc,"*vague*")!=1  & strmatch(term_lc,"*confused*")!=1 & strmatch(term_lc,"*elderly mentally ill*")!=1 
drop if strmatch(term_lc,"*mentally*") & strmatch(term_lc,"*vague*")!=1  & strmatch(term_lc,"*confused*")!=1 & strmatch(term_lc,"*elderly mentally ill*")!=1 

list term if strmatch(term_lc,"*scale*") & strmatch(term_lc,"*cognitive decline*")!=1  
drop if strmatch(term_lc,"*scale*") & strmatch(term_lc,"*cognitive decline*")!=1  



local exterm " "*developmental*" "*environmental*" "
local exterm " `exterm' "*one concentration*" "*mental health service*" "
local exterm " `exterm' "*concentration in serum*" "*(product)" "
local exterm " `exterm' "*(substance)" "*above average*" "*submental*" "
local exterm " `exterm' "*amino*" "*at-hook dna binding motif*" "
local exterm " `exterm' "*liquid concentrate*" "*cognitive exam*" "*assessment scale*" "
local exterm " `exterm' "*subscale*" "*subscore*" "*mental state observation*" "
local exterm " `exterm' "*mental state finding*" "*mental health act*" "*mental illness*" "
local exterm " `exterm' "*handicap*" "*elemental*" "
local exterm " `exterm'  "*mental health care plan*" "*airway concentration*" "
local exterm " `exterm' "*intellectual disability*" "*mental defence*" "
local exterm " `exterm' "*mental defense*" "*mental retardation*" "*scale score*" "
local exterm " `exterm' "*mental capacity act*" "*mental disorder*" "*segmental*" "
local exterm " `exterm' "*glucose concentration*" "*aa concentration*" "*anticholinergic*" "
local exterm " `exterm' "*haemodialysis*" "*mental health home*" "*mental health nurse*" "
local exterm " `exterm' "*mental health team*" "*anaerobes*" "*alveolar concentration*" "
local exterm " `exterm' "*airborne lead*" "*albumin mass*" "*plasma*" "
local exterm " `exterm' "*insfusion concentrate*" "*screening score*" "*allergen*" "
local exterm " `exterm' "*screening tool*" "*/ml*" "*haemoglobin*" "
local exterm " `exterm' "*hemoglobin*" "*expired*" "*inspired*" "
local exterm " `exterm' "*respired*" "*anesthetic*" "*anaesthetic*" "
local exterm " `exterm' "*antibiotic*" "*antigen*" "*serum*" "
local exterm " `exterm' "*recognition*" "*oxygen*" "*assault*" "
local exterm " `exterm' "*mental health care*" "*instrumental*" "*assess mental health*" "
local exterm " `exterm' "*psychiatrist*" "*anticholinergic*" "*caarms*" "
local exterm " `exterm' "*occupational therapy*" "*autism*" "*autobiographical*" "
local exterm " `exterm' "*fundamental*" "*infusion concentrate*" "*in urine*" "
local exterm " `exterm' "*forensic mental health*" "*tegmental*" "*carer*" "
local exterm " `exterm' "*caregiver*" "*blood*" "*antibody*" "*acid*" "
local exterm " `exterm' "*tidal*" "*nitrogen*" "*oxide*" "
local exterm " `exterm' "*saliv*" "*sperm*" "*substance*" "
local exterm " `exterm' "*inspiratory*" "*health of the nation*" "*urine*" "
local exterm " `exterm' "*mental test*" "*performance test*" "
local exterm " `exterm' "*amelocemental*" "*intellectual deficit*" "
local exterm " `exterm' "*renal*" "*poison*" "*supplemental*" "
local exterm " `exterm' "*perinatal*" "*simmental*" "*fertility*" "
local exterm " `exterm' "*cognitive therapy*" "*below average*" "*compartmental*" "
local exterm " `exterm' "*specialist service*" "*(property)*" "*auditory*" "
local exterm " `exterm' "*judgemental*" "average intellect*" "*autosomal*" "
local exterm " `exterm' "*mental nerve*" "*for solution*" "*alcohol*" "
local exterm " `exterm' "*ethanol*" "*cognitive behav*" "*cbt*" "
local exterm " `exterm' "*cognitive stim*" "*learning experience*" "*catalytic*" "
local exterm " `exterm' "*cemental*" "*sample*" "*globulin*" "
local exterm " `exterm' "*clinical psychiatric*" "*omental*" "*clustering*" "
local exterm " `exterm' "*cognitive - behavior therapy*" "*cognitive analytic therapy*" "*stroke*" "
local exterm " `exterm' "*cognitive and behavioural*" "*cognitive behavioral therapy*" "*cerebrovascular*" "
local exterm " `exterm' "*concussion*" "*nutrition*" "dna*" "
local exterm " `exterm' "*oral concentrate*" "*spray concentrate*" "*decremental*" "
local exterm " `exterm' "*departmental*" "*did not attend*" "*mental health unit*" "
local exterm " `exterm' "*disability assessment*" "*discharged*" "discussion*" "
local exterm " `exterm' "*platelet*" "*dufourmental*" "*emergency*" "
local exterm " `exterm' "*mother*" "*mental nurse*" "*mental region*" "
local exterm " `exterm' "*concentrate products*" "*faecal*" "*family history*" "
local exterm " `exterm' "*financial*" "*no cognitive decline*" "
local exterm " `exterm' "*gpcog*" "*bile*" "*general practitioner assessment *" "
local exterm " `exterm' "*within normal limits*" "*concentration strength*" "*mental capacity*" "
local exterm " `exterm' "*cannula*" "*history taking*" "*home oxy*" "
local exterm " `exterm' "*mental health clinic*" "*ornamental*" "*immunodef*" "
local exterm " `exterm' "*hydrogen*" "*imbecile*" "*idiot*" "
local exterm " `exterm' "*immunolo*" "*immobili*" "*mobility*" "
local exterm " `exterm' "*urinary*" "*mental hospital*" "*protein*" "
local exterm " `exterm' "*infant*" "*incognitum*" "*assessment declined*" "
local exterm " `exterm' "*injection*" "*inpatient mental*" "*development*" "
local exterm " `exterm' "*precocity*" "*bright*" "*gifted*" "
local exterm " `exterm' "*international system of units*" "*intraligamental*" "
local exterm " `exterm' "*intrinsic factor*" "*ringer*" "*lethal*" "
local exterm " `exterm' "*lubricant*" "*lay member*" "*legal member*" "
local exterm " `exterm' "*risk of injury*" "*leucocyte*" "*recall*" "
local exterm " `exterm' "*coagulation*" "*fungicidal*" "*mental health in-reach*" "
local exterm " `exterm' "*inhibitory*" "*cattle*" "*macrocephaly*" "
local exterm " `exterm' "*mass concentration*" "*mean cell*" "*peak*" "
local exterm " `exterm' "*trough*" "*measurement*" "*tribunal*" "
local exterm " `exterm' "*anxious cognitions*" "*at risk*" "*bilirubin*" "
local exterm " `exterm' "*calcium*" "*intimates*" "*cannot remember*" "
local exterm " `exterm' "*concentrated solution*" "*reference set*" "*cognitive - behaviour*" "
local exterm " `exterm' "*intracerebral*" "*cognitive-behaviour*" "*evoked potential*" "
local exterm " `exterm' "*cognitive-linguistic*" "*modify behaviour*" "*community mental health*" "
local exterm " `exterm' "*crisis plan*" "*at-risk*" "*cutaneous*" "
local exterm " `exterm' "*rectal*" "*microscopy*" "*comprehensive health assessment tool*" "
local exterm " `exterm' "*gargle*" "concentration" "*ova*" "
local exterm " `exterm' "*concentration camp*" "*airway gas*" "*parasite*" "
local exterm " `exterm' "*skills training*" "*cooperative*" "*double a*" "
local exterm " `exterm' "*percentage*" "*discharge*" "*dwarfism*" "
local exterm " `exterm' "*equi-lyte*" "*mentalis*" "*entire mental*" "
local exterm " `exterm' "*emmental*" "*informed dissent*" "*exception reporting*" "
local exterm " `exterm' "*goniodysgenesis*" "*haemoconcentrator*" "*chorionic*" "
local exterm " `exterm' "*cognitive delay*" "*loss of consciousness*" "*logarithmic*" "
local exterm " `exterm' "*bactericidal*" "*cancer*" "*manage mental*" "
local exterm " `exterm' "*t-cell*" "*subarachnoid*" "*organic brain damage*" "
local exterm " `exterm' "*abuse*" "*artery*" "*foramen*" "
local exterm " `exterm' "*national public health classification*" "*mental health cpa*" "*addiction*" "
local exterm " `exterm' "*mental health admin*" "*annual physical examination*" "normal*" "* normal*" "
local exterm " `exterm' "*no abnormalities*" "*counsellor*" "*counseling*" "
local exterm " `exterm' "*counselor*" "*crisis*" "*functional therapies*" "
local exterm " `exterm' "*leaflet given*" "*medication review*" "*mental health monitoring*" "
local exterm " `exterm' "*nursing*" "*promotion*" "*record sharing status*" "
local exterm " `exterm' "*registration status*" "*rehabilitation service*" "*residential*" "
local exterm " `exterm' "*mental health review*" "*risk indicator*" "*mental health support*" "
local exterm " `exterm' "*follow-up*" "*nurse*" "*psychosocial function*" "
local exterm " `exterm' "*mental health worker*" "*self-help lit*" "*advocate*" "
local exterm " `exterm' "*mental health community service*" "*primary care mental health gateway worker*" "*referral to primary care mental health*" "
local exterm " `exterm' "*mental health assessment team*" "*regimental*" "*si-derived unit of concentration*" "
local exterm " `exterm' "*swemwbs*" "*craniostenosis*" "*primary care graduate mental health*" "
local exterm " `exterm' "*primary care mental health gateway*" "self management*" "*sepsis*" "
local exterm " `exterm' "*warwick-edinburgh*" "*common mental health conditions*" "*subligamental*" "
local exterm " `exterm' "skills relating to*" "social prescrib*" "
local exterm " `exterm' "*chloride*" "*strategy training*" "*supramentale*" "
local exterm " `exterm' "*urea*" "*drench*" "*repellent*" "
local exterm " `exterm' "*tactile*" "*tempramental*" "*incognita*" "
local exterm " `exterm' "*grave perm*" "*epileptic*" "*dipstick*" "
local exterm " `exterm' "*chlorhexidine*" "*opioid*" "*puerperium*" "
local exterm " `exterm' "*tobacco*" "*cannabin*" "*cocaine*" "*experimental*" "
local exterm " `exterm' "*hallucinogens*" "*other stimulants*" "*sedatives*" "
local exterm " `exterm' "*volatile solvents*" "*arbitrary*" "log *" "
local exterm " `exterm' "*national service framework*" "*feed*" "*wormer*" "*unit of concentration*" "
local exterm " `exterm' "*paramnesia*" "*mha 1983*" "*sub-mental*" "
local exterm " `exterm' "*opcs*" "*lymphadenopathy*" "*judgmental*" "*mental state general examination*" "
local exterm " `exterm' "*planned mental health assessment *" "*nitrite*"  "*nhs health check*" "
local exterm " `exterm' "*udder*" "*personal health plan*" "*prothrombin*" "
local exterm " `exterm' "*hemoconcentrator*" "*dual diagnosis service*" "*counselling*" "*contingency plan*" "
local exterm " `exterm' "*excepted from mental health quality indicators*" "*hemodialysis*"  "*equipment*" "
local exterm " `exterm' "*purina*" "*people with mental health problem*" "*phencyclidine*" "*planned mental health assessment*" "
local exterm " `exterm' "*factor ix*" "*psychotherapy*" "*quality and outcomes framework*" "*tetanus*" "
local exterm " `exterm' "*treatment stopped*" "*additional mental state observ*" "*chronic mental disease*" "
local exterm " `exterm' "*surgical procedure*" "*general mental state*" "*h^+^*" "*hyoidmental*" "*middlesex*" "
local exterm " `exterm' "*personal history*" "*strain related to work*" "*yard*" "*skeletal dysplasia*" "
local exterm " `exterm' "*mental welfare officer*" "*mental subnormality*" "*mental wellbeing*" "mental well-being*" "
local exterm " `exterm' "*condensation*" "*mental and psychological observations*" "
local exterm " `exterm' "*mental health event*" "*psychot*" "*therapy*" "*fish*" "
local exterm " `exterm' "*flysect*" "*family wellbeing*" "*body fluid*" "
local exterm " `exterm' "*disability*" "*emotional*" "*finding of*" "
local exterm " `exterm' "[v]*" "visual*" "*deficit disorder*" "
local exterm " `exterm' "other specified attention to*" "other attention to*" "
local exterm " `exterm' "*sensory inattention*" "*accident*" "*atttention rating*" "
local exterm " `exterm' "integrated*" "excessively focused*" "
local exterm " `exterm' "focused*" "inattention*" "
local exterm " `exterm' "*endotrachel*" "*motor control*" "
local exterm " `exterm' "*test score*" "*behavioural*" "
local exterm " `exterm' "*capacity test*" "*public attention*" "
local exterm " `exterm' "attention to*" "adhd*" "able to*" "

foreach word in `exterm' {
	display "`word'"
	list term if strmatch(term_lc,"`word'")
	drop if strmatch(term_lc,"`word'")
}




/*******************************************************************************
NB: I've explicitly dropped the following replating to mental state testing:
	- mini-mental
	- score
	- ability to
	- test
	- able to
	- questionnaire
	- screen
	- assessment using

I'm not sure if this is the correct approach.
Laurie please review the codes dropped by these terms in particular to 
make sure that you agree they should be dropped 
before I finalise the candidate code list for review on OpenCodelists
********************************************************************************/
* drop controversial codes
local exterm " "*mini-mental*" "*ability to*" "*score*" "
local exterm " `exterm' "*test*" "able to*" "*questionnaire*" "
local exterm " `exterm' "*screen*" "assessment using*" "*conversation*" "
local exterm " `exterm' "*interview*" "*cognitive assessment*" "*mental well-being scale*" "
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
export delimited using "../codelists/working/snomed-cognitiveImpairment-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



