/*=========================================================================
DO FILE NAME:			covidSxs-codelist01-breathless

AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-May-11
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for breathlessness
						 				
MORE INFORMATION:	
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-breathless-working
																
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
global filename "covidSxs-codelist01-breathless"

* open log file
log using "../logs/${filename}", text replace






/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " 	"*breathless*" "*short*of breath*" "*dyspnoea*" "
local searchterm " 	`searchterm' "*dyspnea*" "*sob*" "*gasping*" "
local searchterm " 	`searchterm' "*orthopnoea*" "*orthopnea*" "
local searchterm " 	`searchterm' "*tachypnea*" "*tachypnoea*" "*respiratory*" "

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
list term if strmatch(term_lc,"*due to*") & strmatch(term_lc,"*sars-cov-2*")!=1 & strmatch(term_lc,"*coronavirus*")!=1
drop if strmatch(term_lc,"*due to*") & strmatch(term_lc,"*sars-cov-2*")!=1 & strmatch(term_lc,"*coronavirus*")!=1

list term if strmatch(term_lc,"*caused by*") & strmatch(term_lc,"*sars-cov-2*")!=1 & strmatch(term_lc,"*coronavirus*")!=1 & strmatch(term_lc,"*2019-nCoV*")!=1 
drop if strmatch(term_lc,"*caused by*") & strmatch(term_lc,"*sars-cov-2*")!=1 & strmatch(term_lc,"*coronavirus*")!=1 & strmatch(term_lc,"*2019-nCoV*")!=1 

list term if strmatch(term_lc,"*therapy*") & strmatch(term_lc,"*opioid*")!=1 & strmatch(term_lc,"*opiate*")!=1 & strmatch(term_lc,"*breathlessness care*")!=1 
drop if strmatch(term_lc,"*therapy*") & strmatch(term_lc,"*opioid*")!=1 & strmatch(term_lc,"*opiate*")!=1 & strmatch(term_lc,"*breathlessness care*")!=1 

list term if strmatch(term_lc,"*procedure*") & strmatch(term_lc,"*opioid*")!=1 & strmatch(term_lc,"*opiate*")!=1 
drop if strmatch(term_lc,"*procedure*") & strmatch(term_lc,"*opioid*")!=1 & strmatch(term_lc,"*opiate*")!=1 

// originally dropped questionnaires/scales/indexes as considered that they indicated an assessment was
// made not that the symptom was present
// however, V disagreed 
// so now including codes where a score is included making it clear the px had dyspnoea
// but still dropping codes that are just saying a particular instrument was used to assess

local exterm " "* sling*" "*mesoblast*" "*disobedience*" "
local exterm " `exterm' "*isobut*"  "
local exterm " `exterm' "*transobturator*" "*fusobact*" "
local exterm " `exterm' "*hyphessobryconis*" "*hypsoblennius*" "
local exterm " `exterm' "*soboliphyme*" "*sobria*" "
local exterm " `exterm' "*nasobiliary*" "*prosobranchiata*" "
local exterm " `exterm' "*(organism)" "*lysobact*" "
local exterm " `exterm' "*necropsob*" "*sobrerol*" "
local exterm " `exterm' "*mesobrach*" "*isobamate*" "
local exterm " `exterm' "*sulisobenzone" "*mesobronchus*" "
local exterm " `exterm' "*sobrinus*" "*isobornyl*" "
local exterm " `exterm' "*soursob*" "*lysobisphosphatidic*" "
local exterm " `exterm' "*sobradhino" "*mesobuthus*" "
local exterm " `exterm' "*mesobronchus*" "*isobaculum*" "
local exterm " `exterm' "*thalassobac*" "
local exterm " `exterm' "*body mass, airflow obstruction, dyspnoea and exercise capacity*" " 
local exterm " `exterm' "*body mass, airflow obstruction, dyspnea and exercise capacity*" "
local exterm " `exterm' "*sulisobenzone*" "*assessment using*" "
local exterm " `exterm' "*questionnaire*" "*subscale*" "*index*" "*aids with*" "
local exterm " `exterm' "*acquired immunodef*" "*sobradhino*" "
local exterm " `exterm' "*sobemovirus*" "*necrotic*" "
local exterm " `exterm' "*tuberculosis*" "*poison*" "*malignant*" "
local exterm " `exterm' "*perinatal*" "*family history*" "
local exterm " `exterm' "*haemorrhage*" "*hemorrhage*" "*corrosion*" "
local exterm " `exterm' "*congenital*" "*carcinoma*" "*burn*" "
local exterm " `exterm' "*newborn*"  "*other specified*" "
local exterm " `exterm' "*connective tissue*" "
local exterm " `exterm' "*other diseases of*" "*postprocedural*" "
local exterm " `exterm' "*other respiratory diseases*" "*other acute*" "
local exterm " `exterm' "*specimens*" "*ingestion*" "*screening*" "
local exterm " `exterm' "*neoplasm*" "*influenza*" "*respiratory organ*" "
local exterm " `exterm' "*agents*" "*foreign body*" "
local exterm " `exterm' "*circulatory and respiratory*" "*history*" "
local exterm " `exterm' "*chronic*" "*cardioresp*" "*circulat+*" "
local exterm " `exterm' "*other diseases*" "*vaccine*" "*hypersensitivity*" "
local exterm " `exterm' "*cavity*" "*allergy*" "*sample*" "*fluid*" "
local exterm " `exterm' "*ultrason*" "*respiratory team*" "*tumor*" "*tumour*" "
local exterm " `exterm' "*tobramycin*" "*tiotropium*" "*coefficient*" "
local exterm " `exterm' "*tyloxapol*" "*structure*" "*mucus*" "
local exterm " `exterm' "*respiratory dosage*" "
local exterm " `exterm' "*specimen*" "*obstruction*" "
local exterm " `exterm' "*infection*" "*cycle*" "*equipment*" "
local exterm " `exterm' "*respiratory sounds*" "*viraemia*" "*viremia*" "
local exterm " `exterm' "*aspiration*" "*telephone*" "
local exterm " `exterm' "*teach*" "*respiratory rate*" "*antibody*" "
local exterm " `exterm' "*swab for*" "*suspected*" "*muscular atrophy*" "
local exterm " `exterm' "*respiratory frequency*" "*precautions*" "
local exterm " `exterm' "*procedure*" "*muscle*" "*antigen*" "
local exterm " `exterm' "*monitoring*" "*operation*" "*medication*" "*endoscopy*" "
local exterm " `exterm' "*photodynamic therapy*" "*culture*" "*assay*" "*education*" "
local exterm " `exterm' "*flow rate*" "*scan*" "*referral*" "
local exterm " `exterm' "*radio*" "*resuscitation*" "*operative*" "
local exterm " `exterm' "*admission*" "*respiratory function*" "*intravenous*" "
local exterm " `exterm' "*drug*" "*endoscopic*" "endotrach*" "
local exterm " `exterm' "*immunisation*" "*immunoglobulin*" "seen in*" "
local exterm " `exterm' "seen by*" "*sepsis*" "*vaccination*" "*ribonucleic*" "
local exterm " `exterm' "*infantile*" "*physical object*" "*pneumothorax*" "
local exterm " `exterm' "ability to*" "*arrest*" "*examination of respiratory*" "
local exterm " `exterm' "able to*" "*acidosis*" "*alkalosis*" "* nad*" "
local exterm " `exterm' "*laboratory*" "*bronchitis*" "*kidney*" "
local exterm " `exterm' "*respiratory failure*" "*distress syndrome*" "
local exterm " `exterm' "*admit to*" "*respiratory use*" "
local exterm " `exterm' "*device*" "*respiratory mask*" "*score*" "
local exterm " `exterm' "*syncytial*" "*respiratory form*" "
local exterm " `exterm' "*respiratory support*" "*anesthesia*" "*anaesthesia*" "
local exterm " `exterm' "*antagonist*" "*arthropath*" "*aspirat*" "
local exterm " `exterm' "*attend*" "*at*risk*" "*respiratory use*" "
local exterm " `exterm' "*abscess*" "acute disease*" "
local exterm " `exterm' "*allergic*" "*emergency*" "*aspirin*" "
local exterm " `exterm' "*brain stem*" "*cardiomyopath*" "*stimulant*" "
local exterm " `exterm' "*chemical*" "*cerebral*" "*secretions*" "
local exterm " `exterm' "*coronavirus disease*" "*conjunctivitis*" "*delivery*" "
local exterm " `exterm' "*depth of*" "*imaging*" "*detection of*" "
local exterm " `exterm' "*diphtheria*" "*discharge from*" "*additional*" "
local exterm " `exterm' "*bovine*" "*adenoviral*" "*cancer*" "
local exterm " `exterm' "*respiratory chain*" "*cilia*" "
local exterm " `exterm' "*oral/resp*" "disease caused by*" "
local exterm " `exterm' "*pregnancy*" "disorder of*" "disease of*" "
local exterm " `exterm' "*immunity*" "entire*" "*enzyme*" "exposure to*" "
local exterm " `exterm' "expector*" "exam*" "exploration*" "
local exterm " `exterm' "*external agent*" "fh*" "fear of*" "
local exterm " `exterm' "*fetal*" "*foetal*" "fever caused by*" "
local exterm " `exterm' "*respiratory volume*" "*crackles*" "*crepitations*" "
local exterm " `exterm' "*gastroenter*" "h/o:*" "*healthcare*" "
local exterm " `exterm' "*clinic*" "*humidifier*" "inhalation*" "
local exterm " `exterm' "inflammatory disorder*" "*dilatation*" "characteristic of*" "
local exterm " `exterm' "*feline*" "*follow-up*" "finding*" "
local exterm " `exterm' "*injury*" "functional finding*" "
local exterm " `exterm' "lower respiratory*" "*lack of*" "
local exterm " `exterm' "*lymphocytopenia*" "*middle east*" "
local exterm " `exterm' "*mechanical*" "*metastases*" "*myocarditis*" "
local exterm " `exterm' "*named resp*" "*neonatal*" "*nervous*" "
local exterm " `exterm' "no*" "*surgical*" "*lesion*" "
local exterm " `exterm' "*occupational*" "other*" "*otitis media*" "
local exterm " `exterm' "*paediatric*" "*porcine*" "
local exterm " `exterm' "*pneumonia*" "*radiation*" "*spirometry*" "
local exterm " `exterm' "*papillomatosis*" "*acidemia*" "*acidaemia*" "
local exterm " `exterm' "*alkalaemia*" "*alkalemia*" "*angio*" "
local exterm " `exterm' "*anthrax*" "*auscultat*" "*bronchiol*" "
local exterm " `exterm' "*beclome*" "*budesonide*" "*respiratory care*" "
local exterm " `exterm' "*center*" "*clicking*" "*complication*" "*cannula*" "
local exterm " `exterm' "*corticosteroid*" "*specialist*" "*treatment started*" "
local exterm " `exterm' "*syncitial*" "ards*" "chest respiratory movement*" "
local exterm " `exterm' "*limb*" "*metastasis*" "*mask*" "
local exterm " `exterm' "*necroti*" "*respiratory death*" "
local exterm " `exterm' "*flutica*" "*loop measurement*" "
local exterm " `exterm' "*intensive care*" "*care plan*" "*medicine*" "
local exterm " `exterm' "*isolation*" "*measurements*" "*dilation*" "*encephalop*" "
local exterm " `exterm' "*does not consent*" "*nitrate*" "
local exterm " `exterm' "full*" "*system examination*" "*dermatomyo*" "
local exterm " `exterm' "*murine*" "*intubation*" "*gas exchange*" "
local exterm " `exterm' "*monitor*" "*quotient*" "*nose*" "
local exterm " `exterm' "*rhythm*" "*simulat*" "*squeak*" "
local exterm " `exterm' "*agent*" "*surfactant*" "*implant*" "
local exterm " `exterm' "*occupation*" "*polymerase chain*" "
local exterm " `exterm' "respiratory tract*" "
local exterm " `exterm' "*rhabdomy*" "*massage*" "
local exterm " `exterm' "*detection*" "*rna" "*booster*" "
local exterm " `exterm' "*protection maintenance*" "
local exterm " `exterm' "severe actute respiratory*" "sars-cov-2*" "
local exterm " `exterm' "smoker's*" "*somatoform*" "*thrombocyto*" "
local exterm " `exterm' "upper respiratory*" "under care of*" "via resp*" "
local exterm " `exterm' "*respiratory abnormal*" "*biofeedback*" "
local exterm " `exterm' "acute respiratory distress*" "*exchange*" "
local exterm " `exterm' "refer to*" "*respiratory itu*" "
local exterm " `exterm' "*volume dynamic*" "*appliances*" "*airway*" "
local exterm " `exterm' "*sacrum*" "*reflex*" "*treatment changed*" "
local exterm " `exterm' "*associated with aids*" "*microscopic*" "
local exterm " `exterm' "*drainage*" "*epithelium*" "*event*" "
local exterm " `exterm' "*endoscope*" "*exercise*" "*thermometer*" "*prematur*" "
local exterm " `exterm' "*electric*" "*palpation*" "*mometasone*" "*movement*" "
local exterm " `exterm' "probable s*" "*discharge by*" "*disorder excluded*" "
local exterm " `exterm' "*gas heating*" "*measure*" "*mechanism*" "
local exterm " `exterm' "*murmur*" "*muscular*" "*physician*" "*physiology*" "
local exterm " `exterm' "*process*" "* ratio*" "*naphazoline*" "
local exterm " `exterm' "*secretion*" "*shunt*" "*ventilation*" "
local exterm " `exterm' "*fluoroscopy*" "*subdivision*" "respiratory test*" "
local exterm " `exterm' "*respiratory tent*" "*therapist*" "*screen*" "*thermal*" "
local exterm " `exterm' "serotype*" "severe acute*" "
local exterm " `exterm' "transfer factor*" "*preparation*" "covid-19*" "
local exterm " `exterm' "*terminal*" "*tomography*" "*treatment stopped*" "
local exterm " `exterm' "*percentage*" "*pressure*" "*squawk*" "
local exterm " `exterm' "*site descriptor*" "*anomaly*" "*no abnormality*" "
local exterm " `exterm' "*respiratory system diseases*" "*navigational*" "
local exterm " `exterm' "respiratory virus*" "specified resp*" "
local exterm " `exterm' "rehabili*" "*gastroscop*" "*real-time*" "*mc&s*" "
local exterm " `exterm' "*not examined*" "*lymphopen*" "*mycoplasma*" "
local exterm " `exterm' "*morbidity*" "


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
sort code

keep code term

* save in csv format
export delimited using "../codelists/working/snomed-breathless-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



