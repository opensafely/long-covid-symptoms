/*=========================================================================
DO FILE NAME:			covidSxs-codelist09-headache.do

AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-July-06
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for headache
						 				
MORE INFORMATION:	
					
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-headache-working
																
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
global filename "covidSxs-codelist09-headache"

* open log file
log using "../logs/${filename}", text replace






/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*headache*" "*migraine*" "*cephalalgia*" "
local searchterm " `searchterm' "*cephalgia*" "*cephalodynia*" "*cranial*" "
local searchterm " `searchterm' "*hemicrania*" "*head*" "*migrain*" "

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
* define exclusions
display "*arter*"
list term if strmatch(term_lc,"*arter*") & term_lc!="basilar artery migraine" & term_lc!="cranial arteritis"
drop if strmatch(term_lc,"*arter*") & term_lc!="basilar artery migraine" & term_lc!="cranial arteritis"

list term if strmatch(term_lc,"*procedure*") & strmatch(term_lc, "*referral*")!=1
drop if strmatch(term_lc,"*procedure*") & strmatch(term_lc, "*referral*")!=1

list term if strmatch(term_lc,"*(observable entity)*") & strmatch(term_lc, "*headache*")!=1
drop if strmatch(term_lc,"*(observable entity)*") & strmatch(term_lc, "*headache*")!=1

local exterm " "*blackhead*" "*intracranial*" "
local exterm " `exterm' "*cranial nerve*" "*contusion*" "
local exterm " `exterm' "*aspiration*" "*cellulitis*" "*dysostosis*" "
local exterm " `exterm' "*profession*" "*wound*" "*graft*" "*long head*" "
local exterm " `exterm' "*nerve injury*" "*tarsal*" "*sutures*" "
local exterm " `exterm' "*ahead*" "*fixation*" "*angiogram*" "
local exterm " `exterm' "*fossa*" "*abdominal*" "*ability*" "*diagnostic imaging*" "
local exterm " `exterm' "*abnormal head*" "*abrasion*" "*able to*" "*abscess*" "
local exterm " `exterm' "*absence of*" "*cranial portion*" "
local exterm " `exterm' "*accident*" "*lymphangitis*" "*carcinoma*" "
local exterm " `exterm' "*radiotherapy*" "*head lice*" "*headlice*" "
local exterm " `exterm' "*cranial neuropathy*" "*anaesthesia*" "
local exterm " `exterm' "*extracranial*" "*red-headed*" "
local exterm " `exterm' "*angiotomy*" "*animal bite*" "
local exterm " `exterm' "*fibula*" "*application*" "*arterectomy*" "
local exterm " `exterm' "*imaging*" "*drum head*" "*lymphadenitis*" "
local exterm " `exterm' "*headgear*" "*aneurysmectomy*" "
local exterm " `exterm' "*femoral*" "*radial*" "*femur*" "*(body structure)*" "
local exterm " `exterm' "*armorhead*" "
local exterm " `exterm' "*humeral*" "*humerus*" "*radius*" "*attention to*" "
local exterm " `exterm' "*crowning*" "*ultrasound*" "*fetal*" "*foetal*" "
local exterm " `exterm' "*neoplasm*" "*benign tumour*" "*benign tumor*" "
local exterm " `exterm' "*big-headed*" "*fracture*" "*head tilt*" "back of head" "
local exterm " `exterm' "*barheaded*" "*snake*" "*banging own*" "*beak-head*" "
local exterm " `exterm' "*(physical object)*" "*bighead*" "
local exterm " `exterm' "*biopsy*" "*bird-head*" "*birth head*" "
local exterm " `exterm' "*copperhead*" "*avulsion*" "*bed head*" "
local exterm " `exterm' "*diameter*" "*bullhead*" "*black-headed*" "*blister*" "
local exterm " `exterm' "*blue-headed*" "*bluehead*" "
local exterm " `exterm' "*boil*" "*body cast*" "*blood vessel*" "*black head*" "
local exterm " `exterm' "*bristlehead*" "*bonehead*" "
local exterm " `exterm' "*brown-head*" "*bruise*" "*lymphoma*" "*erythema*" "
local exterm " `exterm' "*forehead*" "*burn*" "*melanoma*" "*bite*" "
local exterm " `exterm' "*arrowhead*" "*thornyhead*" "*antimicrobial*" "
local exterm " `exterm' "*bonnethead*" "*tapeworm*" "*bufflehead*" "*tumor*" "
local exterm " `exterm' "*burrhead*" "*burrhole*" "*congenital*" "*angiography*" "
local exterm " `exterm' "*ct head*" "*ct of head*" "*head and neck flap*" "
local exterm " `exterm' "*deformity*" "*triceps*" "*big head*" "*bone structure*" "
local exterm " `exterm' "*bronchiole*" "*cat scan*" "*ct of *" "*pancreas*" "
local exterm " `exterm' "*ca skin*" "*hematoma*" "*california*" "
local exterm " `exterm' "*carbuncle*" "*household*" "*biceps*" "
local exterm " `exterm' "*casque*" "*lung lobe*" "*caul*" "*cauteris*" "
local exterm " `exterm' "*head ring*" "*headband*" "*tumour*" "
local exterm " `exterm' "*child exam*" "*head position*" "*cannot hold*" "
local exterm " `exterm' "*lymph notes*" "*ct scan*" "*haematoma*" "
local exterm " `exterm' "*projection*" "*cauteriz*" "*delivery*" "
local exterm " `exterm' "*animal head*" "*angle-head*" "appearance of head" "
local exterm " `exterm' "*appendix of head*" "airway obtained*" "*child head*" "
local exterm " `exterm' "*perforator*" "*lymph node*" "*head posture*" "
local exterm " `exterm' "*dysplasia*" "*headings*" "*injury*" "*cord beside*" "
local exterm " `exterm' "*overhead*" "*computed tomography*" "*corrosion*" "
local exterm " `exterm' "*cranial lao*" "*cranial articular*" "
local exterm " `exterm' "*facial bone*" "*cranial bone*" "
local exterm " `exterm' "*cranial bruit*" "*cranial bur*" "
local exterm " `exterm' "*cranial cavity*" "*diabetes*" "*duplication*" "
local exterm " `exterm' "*cranial dystonia*" "*dura mater*" "*cranial lobe*" "
local exterm " `exterm' "*drill*" "*faciitis*" "*hydromeningocele*" "
local exterm " `exterm' "*meningio*" "*meninges*" "*anastomosis*" "
local exterm " `exterm' "*morcelli*" "*hawk*" "*trephine*" "*ligation*" "
local exterm " `exterm' "*rib" "*lesion*" "*debride*" "*cut of*" "*decompress*" "
local exterm " `exterm' "*pollicis*" "*injuries*" "*cranial root*" "*cranial puncture*" "
local exterm " `exterm' "*prosthesis*" "*pia mater*" "*orthosis*" "*osteopath*" "
local exterm " `exterm' "*reservoir*" "*nerotomy*" "*palsy*" "*difficulty*" "
local exterm " `exterm' "*diagnostic radiography*" "*cyst*" "*suture*" "
local exterm " `exterm' "*degenerative*" "*dislocation*" "*cutaneous*" "
local exterm " `exterm' "*skin flap*" "*lympha*" "*fasciitis*" "*cranial rao*" "
local exterm " `exterm' "*epidural*" "*(qualifier value)" "*defect*" "
local exterm " `exterm' "*neurotomy*" "*meningoce*" "*somatic dysfunction*" "
local exterm " `exterm' "*cranial sinus*" "*subdural*" "*subarachnoid*" "
local exterm " `exterm' "*head of rib*" "*crown*" "*head circumference*" "*ossific*" "
local exterm " `exterm' "*nucleus*" "*flap*" "*dementia*" "*ventriculos*" "
local exterm " `exterm' "*metacarpal*" "*radiograph*" "*tomograph*" "
local exterm " `exterm' "*extradural*" "*dermatome*" "*manipulation*" "*resinous*" "
local exterm " `exterm' "*synchondrosis*" "*tap" "*mammary*" "*tympanic*" "
local exterm " `exterm' "*air sac*" "*doll's head*" "*domed head*" "*dressing*" "
local exterm " `exterm' "*dropped head*" "*drainage*" "*yellow-head*" "*turn head*" "
local exterm " `exterm' "*raise head*" "*dropped head*" "*headrest*" "
local exterm " `exterm' "*elevat*" "*fascia*" "*endoscopy*" "
local exterm " `exterm' "*epicranial*" "*follicle*" "*entire*" "*excision*" "
local exterm " `exterm' "*(heading)*" "* mri *" "*dystonia*" "*engagement*" "
local exterm " `exterm' "*forceps*" "*family history*" "fh: *" "
local exterm " `exterm' "*flathead*" "*hammerhead*" "exploration*" "*exploding head syndrome*" "
local exterm " `exterm' "family *" "*cancer*" "*fathead*" "*fishing hook*" "
local exterm " `exterm' "*size of head*" "*flat-head*" "*hardhead*" "
local exterm " `exterm' "*foreign body*" "*furuncle*" "*harvest*" "
local exterm " `exterm' "*sheep*" "*locheah*" "*gray-head*" "*glass in*" "*golden*" "
local exterm " `exterm' "*greenhead*" "*whitehead*" "* ct" "*incision*" "
local exterm " `exterm' "*head ct*" "*approaches" "* mass" "* swelling*" "
local exterm " `exterm' "*barman*" "*chef*" "*centiles*" "
local exterm " `exterm' "*cook*" "*engaged*" "*fistulog*" "
local exterm " `exterm' "*fly" "*fold" "*grub" "*housekeeper*" "*head lag*" "
local exterm " `exterm' "*head louse*" "*phalanx*" "*rib structure*" "
local exterm " `exterm' "*talus*" "*stapes*" "*ulna*" "*head rest*" "
local exterm " `exterm' "*teacher*" "*head thrust*" "*waiter*" "
local exterm " `exterm' "*head-down*" "*head-butt*" "*head-up*" "*head-worn*" "
local exterm " `exterm' "*appliance*" "*imobili*" "*perfusion*" "*lumbar puncture*" "
local exterm " `exterm' "*myelogra*" "*headmist*" "*headmast*" "
local exterm " `exterm' "*catfish*" "*high head*" "*history of*" "
local exterm " `exterm' "*hornyhead*" "*flexor*" "*cleansing*" "*cleaning*" "
local exterm " `exterm' "*twins*" "*congen anom*" "
local exterm " `exterm' "cranial" "head" "cranial approach" "
local exterm " `exterm' "disease of head*" "*skin*" "*division*" "*soft tissue*" "
local exterm " `exterm' "*doll head*" "*doppler*" "*cleft*" "*size of head*" "
local exterm " `exterm' "finding of head region*" "*fluroscopy*" "head and neck" "
local exterm " `exterm' "*joint*" "*shell*" "*head butt*" "*vein*" "
local exterm " `exterm' "*test*" "*impulse*" "*head lifting*" "*head compression*" "
local exterm " `exterm' "*nursing*" "*gastroc*" "*hallucis*" "*malleus*" "
local exterm " `exterm' "*mandible*" "*head of muscle*" "*rectus*" "*skeletal*" "
local exterm " `exterm' "*head region*" "head up*" "*head worn*" "
local exterm " `exterm' "*head-hit*" "*head-bang*" "*imobiliz*" "*reflector*" "
local exterm " `exterm' "*hogkin*" "*magnetic*" "*massage*" "
local exterm " `exterm' "*head cap*" "*thorny-head*" "*inflamm*" "
local exterm " `exterm' "*tremor*" "*gnathism*" "*large head*" "*behead*" "
local exterm " `exterm' "*laceration*" "*lifts head*" "*ligament*" "
local exterm " `exterm' "*lipoma*" "*littlehead*" "*lochhead*" "*loggerhead*" "
local exterm " `exterm' "*narrow head*" "*spectrosc*" "*mra head*" "*local anaesthe*" "
local exterm " `exterm' "*mri of head*" "*mrs of head*" "*mass *" "measure of*" "
local exterm " `exterm' "*surgery*" "*mayfield*" "*red head*" "*sculpin*" "
local exterm " `exterm' "muscle of*" "*mucormycosis*" "*hydrocephalic*" "*noises in*" "
local exterm " `exterm' "o/e - cranial*" "o/e - head*" "
local exterm " `exterm' "o/e-cranial*" "owl*" "observation of *" "
local exterm " `exterm' "on examination - cranials*" "on examination - head*" "
local exterm " `exterm' "*operation*" "*drusen*" "*osteosarcoma*" "
local exterm " `exterm' "*approach" "*wart*" "*head up*" "
local exterm " `exterm' "*nerve structure*" "*pighead*" "*post dural*" "
local exterm " `exterm' "*plain film*" "*phlebogr*" "*spermat*" "*puncture*" "
local exterm " `exterm' "*pancreat*" "*bone study*" "*raises head*" "*head end of bed*" "
local exterm " `exterm' "*redhead*" "*injure*" "*removal*" "*repair*" "
local exterm " `exterm' "*rockhead*" "*roughhead*" "*tendon*" "
local exterm " `exterm' "*salmonella*" "*scratch*" "*short-head*" "*shorthead*" "
local exterm " `exterm' "*conjuctival*" "*shower head*" "*size of *" "
local exterm " `exterm' "*specimen*" "*head frame*" "*stripe-head*" "structure of*" "
local exterm " `exterm' "*head clamp*" "*bruising*" "*lipecto*" "
local exterm " `exterm' "plum-head*" "*pink-head*" "*planehead*" "
local exterm " `exterm' "*ulcer*" "*head wear*" "
local exterm " `exterm' "radi*" "patient in*" "patient position*" "
local exterm " `exterm' "peripheral nerve*" "*headcap*" "region of head" "
local exterm " `exterm' "*schwannoma*" "*x-ray*" "*worm*" "*starhead*" "
local exterm " `exterm' "*sarcoma*" "subcranial" "*breast-feed*" "
local exterm " `exterm' "*surgical*" "swelling of*" "*space*" "*swab*" "
local exterm " `exterm' "*amputation*" "*disfigurement*" "*deficiencies of*" "
local exterm " `exterm' "*swelling in*" "*scan abnormal*" "*lump*" "
local exterm " `exterm' "*head movements*" "yellow*" "
local exterm " `exterm' "*splinter*" "*white-head*" "*stork*" "
local exterm " `exterm' "*white head*" "*wheelchair*" "*plasty*" "
local exterm " `exterm' "*venous structure*" "*venogra*" "*fetus*" "*foetus*" "
local exterm " `exterm' "*vascular structure*" "*ultrason*" "*us scan*" "
local exterm " `exterm' "*osteotomy*" "*oximetry*" "*electrical*" "
local exterm " `exterm' "*emboli*" "top of head" "*lizard*" "
local exterm " `exterm' "toward the head" "*head halter*" "*thickhead*" "
local exterm " `exterm' "pale*" "*anomaly*" "*spider*" "*fluoro*" "
local exterm " `exterm' "*goosehead*" "*pump head*" "*abnormal shape*" "
local exterm " `exterm' "head and neck region*" "head bones" "head bang*" "
local exterm " `exterm' "*head mange" "*head free*" "*region observable*" "
local exterm " `exterm' "*head normal*" "*head pressing*" "*immobili*" "
local exterm " `exterm' "*(environment)" "*headphones*" "*headwear*" "
local exterm " `exterm' "*hernia*" "*hodgkin's*" "*head trauma*" "
local exterm " `exterm' "*infect*" "*ganglion*" "*jolthead*" "
local exterm " `exterm' "*nerve block*" "*longhead*" "
local exterm " `exterm' "*head of bed*" "*melanocytoma*" "
local exterm " `exterm' "*medusa*" "movement of*" "
local exterm " `exterm' "moves head" "*neurofibroma*" "
local exterm " `exterm' "*new zealand*" "no headache*" "*small head*" "
local exterm " `exterm' "*smallhead*" "*fish*" "*transposition*" "
local exterm " `exterm' "*transcranial*" "*turning of head*" "*turns head*" "
local exterm " `exterm' "*mammaria*" "*vertigo*" "*yaquina*" "
local exterm " `exterm' "*head and neck symptoms*" "*symptoms affecting head and neck*" "
local exterm " `exterm' "*head, neck or trunk problems*" "*other specified problem of head, neck or trunk*" "
local exterm " `exterm' "*problem of head*" "*problems with head" "strain of*" "papular*" "*headset*" "
local exterm " `exterm' "*olive-head*" "*ocular posture*" "on examination - cranial*" "
local exterm " `exterm' "on examination - sign -*" "*fringehead*" "
local exterm " `exterm' "o/e -cranial*" "o/e - sign *" "*airway*" "
local exterm " `exterm' "normal head*" "nuclear medi*" "*nervous structure*" "
local exterm " `exterm' "muscle structure*" "*monster*" "left *" "right *" "
local exterm " `exterm' "*pronator*" "*epididymis*" "head and neck*" "
local exterm " `exterm' "h/o *" "finding of appeara*" "finding of head and neck*" "
local exterm " `exterm' "*does not move*" "discharged from*" "*scaphoid*" "
local exterm " `exterm' "*rotating detector*" "oedema of head*" "
local exterm " `exterm' "lighthead*" "light-head*" "headfirst posit*" "
local exterm " `exterm' "head size*" "head part*" "*light headed*" "


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
export delimited using "../codelists/working/snomed-headache-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



