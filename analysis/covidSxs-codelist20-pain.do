/*=========================================================================
DO FILE NAME:			covidSxs-codelist20-pain
AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-13
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for pain
						 				
MORE INFORMATION:	Q. 
					Feel an urge to include arthritis (and possibly arthropathy), 
					but suspect that more diagnosis than symptom, so we'll find 
					it under the broad diagnostic category stuff. However, 
					previous experience suggests that these are labels given 
					to older people with joint pain without necessarily having 
					any confirmatory testing (and let's face it most of us have 
					some sort of osteoarthritic change unless we're very young). 
					Also, I'm assuming we include any pain in here, we already 
					have chest and abdominal pain as separate categories on the 
					list, so do we drop them from here or include them?

					A. 
					Be inclusive here given that many diagnoses are made without
					confirmatory investigation, include:
					arthritis, arthropathy, tendinitis, tendinopathy, epicondylitis, 
					tenosynovitis, bursitis, epicondylitis, rotator cuff syndrome, 
					sprain, strain, spondylo*, crick, *arthrosis, painful arc, 
					capsulitis, sciatica
					
					Consider sensitivity analysis only including non-specific pain
					
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-pain-working
																
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
global filename "covidSxs-codelist20-pain"

* open log file
log using "../logs/${filename}", text replace





/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*pain*" "*ache*" "*myalgia*" "*arthralgia*" "*sore*" "
local searchterm " `searchterm' "*tender*" "*stiff*" "*lumbago*" "
local searchterm " `searchterm' "*rheumatism*" "*joint*" "*fibromyalgia*" "
local searchterm " `searchterm' "*arthritis*" "*arthropathy*" "
local searchterm " `searchterm' "*tendinitis*" "*tendinopathy*" "
local searchterm " `searchterm' "*epicondylitis*" "*synovitis*" "*enthesitis*" "
local searchterm " `searchterm' "*bursitis*" "*epicondylitis*" "*enthesopath*" "
local searchterm " `searchterm' "*rotator cuff syndrome*" "*sprain*" "*strain*" "
local searchterm " `searchterm' "*crick*" "*arthrosis*" "*capsulitis*" "
local searchterm " `searchterm' "*sciatica*" "*algia*" "*radiculitis*" "*radiculopathy*" "

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
list term if strmatch(term_lc,"*structure*") // review
list term if strmatch(term_lc,"*observable entity*") // review
list term if strmatch(term_lc,"*(product)") // drop
list term if strmatch(term_lc,"*(substance)") // drop
list term if strmatch(term_lc,"*region") // review


* define exclusions
list term if strmatch(term_lc,"*structure*") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*tender*")!=1 
drop if strmatch(term_lc,"*structure*") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*tender*")!=1 


list term if strmatch(term_lc,"*facet joint*") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*tender*")!=1 & strmatch(term_lc,"*arth*")!=1 
drop if strmatch(term_lc,"*facet joint*") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*tender*")!=1 & strmatch(term_lc,"*arth*")!=1 


list term if strmatch(term_lc,"*passive*") & strmatch(term_lc,"*pain*")!=1
drop if strmatch(term_lc,"*passive*") & strmatch(term_lc,"*pain*")!=1


local exterm " "*(procedure)" "*(organism)" "*(qualifier value)" "
local exterm " `exterm' "*(physical object)" "
local exterm " `exterm' "*(product)" "*(substance)" "*trachea*" "*extender*" "
local exterm " `exterm' "*fracture*" "*operat*" "*surgery*" "structure of*" "
local exterm " `exterm' "*trauma*" "*sachet*" "*tracheitis*" "*paint*" "*papain*" "
local exterm " `exterm' "*vaccine*" "*teacher*" "*crystal*" "
local exterm " `exterm' "*charcot*" "*headache*" "*kaschin*" "*secondary*" "
local exterm " `exterm' "*tracheo*" "*congenital*" "*calcifica*" "
local exterm " `exterm' "*pruritus*" "*lung*" "*skin*" "*ulcer*" "
local exterm " `exterm' "*attender*" "*scale*" "*cachexia*" "*score*" "
local exterm " `exterm' "*acetyl*" "*aphasia*" "*pregnan*" "*abdominal*" "
local exterm " `exterm' "able to*" "absence of*" "
local exterm " `exterm' "accessory mobili*" "aids with*" "
local exterm " `exterm' "abductor*" "adductor*" "ability to*" "
local exterm " `exterm' "*attached*" "*accident*" "*accommodative*" "
local exterm " `exterm' "*repair*" "*acheiria*" "*acheiropodia*" "
local exterm " `exterm' "*deformity*" "*acheta*" "*x-ray*" "
local exterm " `exterm' "ct*" "*ultrasound*" "*imaging*" "*bacteria*" "
local exterm " `exterm' "*suppurative*" "*adnexal*" "*pyogenic*" "
local exterm " `exterm' "*restraint*" "*ontalgia*" "*allerg*" "*cancer*" "
local exterm " `exterm' "*tumor*" "*tumour*" "*amput*" "*amyloid*" "
local exterm " `exterm' "*anaesthe*" "*anesthe*" "*injur*" "* anal *" "anal *" "*perianal*" "*vasular*" "
local exterm " `exterm' "*agnosia*" "*zoster*" "entire*" "*viral*" "
local exterm " `exterm' "*haemarthro*" "*hemarthro*" "*ankylosis*" "*infective*" "
local exterm " `exterm' "*muscle acting on*" "stability of*" "site of*" "
local exterm " `exterm' "*circumference*" "*range of*movement" "*temperature*" "
local exterm " `exterm' "*range of movement*" "*joint stability*" "
local exterm " `exterm' "passive movement*" "range of*" "time from onset*" "
local exterm " `exterm' "*gastrointestinal*" "*joint count*" "*reaches*" "
local exterm " `exterm' "*implant*" "active range*" "*joint mobili*" "
local exterm " `exterm' "*questionnaire*" "*test*" "*disloc*" "*arthrogram*" "
local exterm " `exterm' "*due to*" "*caused by*" "*apache*" "*plasty*" "
local exterm " `exterm' "*alveo*" "*joint colour*" "*joint color*" "
local exterm " `exterm' "*synovial fluid*" "*virus*" "*antigen*" "
local exterm " `exterm' "*apatite*" "*approaches*" "*approach*" "
local exterm " `exterm' "*arthrodesis*" "*arthrocentesis*" "
local exterm " `exterm' "*ultrason*" "*arteri*" "*arthropathy associated with*" "
local exterm " `exterm' "*bechet*" "*helminth*" "*biopsy*" "
local exterm " `exterm' "*arthroscop*" "*arthrotomy*" "aspiration*" "
local exterm " `exterm' "assessment*" "*at risk*" "*poacher*" "
local exterm " `exterm' "attention to*" "*replacement*" "*reiter*" "
local exterm " `exterm' "*infection*" "*pressure sore*" "
local exterm " `exterm' "*artificial*" "*neoplasm*" "*benign neop*" "
local exterm " `exterm' "*microglobu*" "*gout*" "*non-tender*" "
local exterm " `exterm' "*prosthet*" "*autosomal*" "*bed sore*" "
local exterm " `exterm' "*autonomic*" "*avian*" "*bachelor*" "
local exterm " `exterm' "*bacillus*" "*yaws*" "*prosthesis*" "
local exterm " `exterm' "*breast*" "*nventory*" "*vaccinal*" "
local exterm " `exterm' "*brachydactyly*" "*epigastric*" "*urinat*" "
local exterm " `exterm' "*vulv*" "*diabetic*" "*rheumatoid*" "
local exterm " `exterm' "*decompression*" "juvenile*" "*psoriat*" "
local exterm " `exterm' "*seropositive*" "*swelling*" "*warm*" "
local exterm " `exterm' "l1*" "*l2*" "*l3*" "*l4*" "*l5*" "
local exterm " `exterm' "*iliac fossa*" "*lachesine*" "*laparotrachelotomy*" "
local exterm " `exterm' "ligament of*" "lesion of*" "
local exterm " `exterm' "*leprosy*" "*legionella*" "*legal*" "
local exterm " `exterm' "limitation of*" "*(environment)" "
local exterm " `exterm' "*substrain*" "*liver*" "*detached*" "
local exterm " `exterm' "*excision*" "*destruction*" "loose body in*" "
local exterm " `exterm' "*alphanumeric*" "*lysis of*" "*lyme*" "
local exterm " `exterm' "*anomaly*" "*lutembacher*" "
local exterm " `exterm' "mri*" "manipulation*" "mass of*" "
local exterm " `exterm' "*mastalgia*" "*mastiff*" "*physiological joint movement*" "
local exterm " `exterm' "medial*" "*bodies in joint*" "*cectomy*" "
local exterm " `exterm' "*mesorectal*" "*joint lax*" "*equine*" "*nipple*" "
local exterm " `exterm' "no *" "*throat*" "*constrained*" "*erosive*" "
local exterm " `exterm' "*trachelotomy*" "normal*" "nose *" "
local exterm " `exterm' "*prostate*" "*uterine*" "*hypogastri*" "*epigastrium*" "
local exterm " `exterm' "*umbilic*" "*hypochondri*" "*abdo*" "
local exterm " `exterm' "*abnormal joint*" "*not painful*" "*chelitis*" "
local exterm " `exterm' "*spain*" "*reached*" "*jointer*" "*cahce*" "
local exterm " `exterm' "*canker*" "capsule of*" "*carcinoma*" "
local exterm " `exterm' "*capsulotomy*" "*role strain*" "
local exterm " `exterm' "cardiac*" "*central chest pain*" "
local exterm " `exterm' "*post-stroke*" "*vaginal*" "*chemical*" "
local exterm " `exterm' "*dennervation*" "*childbirth*" "
local exterm " `exterm' "*ectomy*" "*calcinosis*" "*instability*" "
local exterm " `exterm' "*chemotherapy*" "mri*" "* mri *" "
local exterm " `exterm' "*reactive arthritis*" "*clicking*" "collateral lig*" "
local exterm " `exterm' "*urine*" "*colonoscope*" "*mycoplas*" "
local exterm " `exterm' "*loving*" "*tache*" "*tooth*" "
local exterm " `exterm' "*sublux*" "*manipulate*" "
local exterm " `exterm' "*systemic*" "*lupus*" "*syphilli*" "*uterus*" "
local exterm " `exterm' "*genitalia*" "*injection*" "*denervation*" "*computed tomography*" "
local exterm " `exterm' "*us guided*" "*us scan*" "*release*" "*revision*" "
local exterm " `exterm' "*reconstruct*" "*fusion*" "*surgical*" "*suture*" "*physiological mobili*" "
local exterm " `exterm' "*resect*" "*removal*" "*endoscop*" "*debride*" "*irrigat*" "
local exterm " `exterm' "*villonodular*" "*ureteric*" "*urethral*" "*vas def*" "*sickle*" "
local exterm " `exterm' "*vancomy*" "*urinary*" "*family history*" "fh:*" "*blood*" "
local exterm " `exterm' "*parasi*" "*hypersensi*" "*cheilitis*" "
local exterm " `exterm' "*rectal*" "*micturi*" "*menstruat*" "*menorrhea*" "
local exterm " `exterm' "*lymph node*" "*opthalmo*" "*orgasm*" "*erection*" "
local exterm " `exterm' "*periods*" "*papules*" "*orchialgia*" "*division*" "
local exterm " `exterm' "*oriental*" "*metasta*" "*orchidalgia*" "*seronegative*" "
local exterm " `exterm' "*pyalgia*" "*pyoarthr*" "*rebound*" "*reactive*" "
local exterm " `exterm' "*painful memor*" "*retropharyn*" "*sexual*" "
local exterm " `exterm' "*labour pain*" "*labor pain*" "*pancreat*" "*septic*" "*sero neg*" "*sero pos*" "
local exterm " `exterm' "*short stature*" "*silicone*" "*git pain*" "*bacher*" "



foreach word in `exterm' {
	display "`word'"
	list term if strmatch(term_lc,"`word'")
	drop if strmatch(term_lc,"`word'")
}



list term if strmatch(term_lc,"*joint*") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*tender*")!=1 & strmatch(term_lc,"*arth*")!=1 ///
	& strmatch(term_lc,"*sprain*")!=1 & strmatch(term_lc,"*strain*")!=1 & strmatch(term_lc,"*tendinitis*")!=1 ///
	& strmatch(term_lc,"*stiff*")!=1 & strmatch(term_lc,"*syndrome*")!=1 & strmatch(term_lc,"*inflam*")!=1 ///
	& strmatch(term_lc,"*synovitis*")!=1 & strmatch(term_lc,"*enthesis*")!=1 & strmatch(term_lc,"*algia*")!=1 ///
	& strmatch(term_lc,"*disorder*")!=1 & strmatch(term_lc,"*dysfunction*")!=1 & strmatch(term_lc,"*symptom*")!=1
drop if strmatch(term_lc,"*joint*") & strmatch(term_lc,"*pain*")!=1 & strmatch(term_lc,"*tender*")!=1 & strmatch(term_lc,"*arth*")!=1 ///
	& strmatch(term_lc,"*sprain*")!=1 & strmatch(term_lc,"*strain*")!=1 & strmatch(term_lc,"*tendinitis*")!=1 ///
	& strmatch(term_lc,"*stiff*")!=1 & strmatch(term_lc,"*syndrome*")!=1 & strmatch(term_lc,"*inflam*")!=1 ///
	& strmatch(term_lc,"*synovitis*")!=1 & strmatch(term_lc,"*enthesis*")!=1 & strmatch(term_lc,"*algia*")!=1 ///
	& strmatch(term_lc,"*disorder*")!=1 & strmatch(term_lc,"*dysfunction*")!=1 & strmatch(term_lc,"*symptom*")!=1


	
	
	

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
export delimited using "../codelists/working/snomed-pain-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



