/*=========================================================================
DO FILE NAME:			covidSxs-codelist07-fever

AUTHOR:					Kate Mansfield	
						
VERSION:				v1
DATE VERSION CREATED: 	2022-June-08
					
DATABASE:				
	
DESCRIPTION OF FILE:	Aim: identify SNOMED codes for fever
						 				
MORE INFORMATION:	
					
	
DATASETS USED:		snomedct.csv // all snomed codes supplied by Peter Inglesby

DATASETS CREATED: 	snomed-fever-working
																
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
global filename "covidSxs-codelist07-fever"

* open log file
log using "../logs/${filename}", text replace






/*******************************************************************************
#1. Define search terms
	- search strings and possibly codes
	- run search
*******************************************************************************/
local searchterm " "*fever*" "*pyrexia*" "*rigor*" "
local searchterm " `searchterm' "*high temp*" "*temperature*" "*hot*" "
local searchterm " `searchterm' "*febrile*" "


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
list term if strmatch(term_lc,"*h/o*") & strmatch(term_lc,"*fever*")!=1 & strmatch(term_lc,"*pyrexia*")!=1
drop if strmatch(term_lc,"*h/o*") & strmatch(term_lc,"*fever*")!=1 & strmatch(term_lc,"*pyrexia*")!=1

local exterm " "*tahyna*" "*sunburn*" "
local exterm " `exterm' "*hay fever*" "
local exterm " `exterm' "*milk fever*" "*leptospiral*" "
local exterm " `exterm' "*rickettsioses*" "*photograph*" "
local exterm " `exterm' "*alcoholic*" "*photophobia*" "
local exterm " `exterm' "*catscratch*" "* shot*" "
local exterm " `exterm' "*phosphotransferase*" "*haemorrhagic*" "
local exterm " `exterm' "*aids *" "
local exterm " `exterm' "*water temperature*" "*orthotic*" "
local exterm " `exterm' "*thermostat*" "*psychotropic*" "
local exterm " `exterm' "*gunshot*" "*accident*" "
local exterm " `exterm' "*hemorrhagic*" "*abattoir*" "
local exterm " `exterm' "*food temperature*" "rheumatoid*" "
local exterm " `exterm' "*rheumatic*" "rheumatoid*" "
local exterm " `exterm' "*febrile mucocutaneous*" "*dermatosis*" "
local exterm " `exterm' "*dermatitis*" "*phototoxic*" "
local exterm " `exterm' "*psychotic*" "*adenoviral*" "
local exterm " `exterm' "*frigore*" "*photochemotherapy*" "
local exterm " `exterm' "*amphotericin*" "*psychotherapy*" "
local exterm " `exterm' "*antibody*" "*antigen*" "*hot water bottle*" "
local exterm " `exterm' "*dichotoma*" "*arthropod*" "*sulphotransferase*" "
local exterm " `exterm' "*five-shot*" "*assault*" "*trichothecenolyticum*" "
local exterm " `exterm' "*photorefractive*" "*photosens*" "*axillary*" "
local exterm " `exterm' "*lymphotropic*" "*monitoring*" "*brazilian*" "
local exterm " `exterm' "*lithotrophicum*" "*bancroftian*" "*bartonellosis*" "
local exterm " `exterm' "*basal body temperature*" "*batai*" "*batrachotoxin*" "
local exterm " `exterm' "*bebaru*" "*cat scratch*" "*cat-scratch*" "*catering*" "
local exterm " `exterm' "*phototherapy*" "*cardiac*" "*hotel*" "*ceramic*" "
local exterm " `exterm' "*cervical*" "*chagres*" "*chandipura*" "
local exterm " `exterm' "*changuinola*" "*charcot*" "*lithot*" "
local exterm " `exterm' "*chikungunya*" "*swine*" "*colorado*" "
local exterm " `exterm' "*photon*" "*comparative*" "*conchotomy*" "*integument*" "
local exterm " `exterm' "*congo*" "*corrosive*" "*congenital*" "*incubator*" "
local exterm " `exterm' "*(procedure)*" "control of*" "*tympanic*" "
local exterm " `exterm' "*copper*" "controlled temperature" "*xanthothrix*" "
local exterm " `exterm' "*photocoagulat*" "*photocard*" "*phosphotr*" "
local exterm " `exterm' "*dengue*" "*deer*" "*dichloromethot*" "
local exterm " `exterm' "*photo-activ*" "*ricketts*" "*(physical object)*" "
local exterm " `exterm' "*dichot*" "*different temperature*" "*difficulty*" "*digital*" "
local exterm " `exterm' "*dimorphotheca*" "*spectrophotome*" "*orthot*" "*psychotherap*" "
local exterm " `exterm' "*shotgun*" "*echothiopate*" "*occupational*" "*exposure to extreme*" "
local exterm " `exterm' "*joint*" "*photic*" "*fluke*" "*emprosthotonos*" "
local exterm " `exterm' "*endocarditis*" "*photodynamic*" "*scaphotrapez*" "*episthotonos*" "
local exterm " `exterm' "*esophageal*" "*inguinal*" "*ethotoin*" "*(substance)*" "
local exterm " `exterm' "*q fever*" "*leptospira*" "*phototest*" "*foot*" "
local exterm " `exterm' "*spine*" "*skin*" "*vagina*" "*food*" "
local exterm " `exterm' "*frigoris*" "*photospot*" "*methotrex*" "*forehead*" "
local exterm " `exterm' "*bragg*" "*foundrymen*" "*frigoribacterium*" "*glandular*" "
local exterm " `exterm' "*guaroa*" "*guama*" "*ganjam*" "*photo*" "
local exterm " `exterm' "*hereditary*" "*photcoagulation*" "*acclimat*" "*history of*" "
local exterm " `exterm' "*hot bath*" "*balloon*" "*biopsy*" "*drink*" "
local exterm " `exterm' "*comb*" "*dental*" "*flash*" "*flush*" "
local exterm " `exterm' "*gas inhala*" "*hot mud*" "*liquid*" "*hot oil*" "
local exterm " `exterm' "*hot pot*" "*hot rock*" "*massage*" "* towels *" "
local exterm " `exterm' "*hot water*" "*hot weather*" "*discrimination*" "*(environment)*" "
local exterm " `exterm' "*hot/cold*" "*hot-dip*" "*hot-roller*" "*hottentot*" "
local exterm " `exterm' "*lymphotrophic*" "*typhoid*" "*humidifier*" "*hydrotherapy*" "
local exterm " `exterm' "*hyper-igd*" "*hyperimmu*" "*hyper-imm*" "*hypothalamic*" "
local exterm " `exterm' "*mediterranean*" "*marituba*" "*lassa*" "*canine*" "
local exterm " `exterm' "*canthotomy*" "*yellow*" "*hotomy*" "*too hot*" "
local exterm " `exterm' "*local injury*" "*lone star*" "*lophotus*" "*louse-bourne*" "
local exterm " `exterm' "*trichothecenes*" "*madrid*" "*maguari*" "*filarial*" "
local exterm " `exterm' "*malaria*" "*malayan*" "*malignant*" "*malta*" "
local exterm " `exterm' "*malt *" "*manihot*" "*manzanilla*" "*marseille*" "
local exterm " `exterm' "*marshall*" "*maternal*" "*mayaro*" "*meningococcal*" "
local exterm " `exterm' "*photuris*" "*methotrimeprazine*" "metal*" "
local exterm " `exterm' "fh:*" "*family history*" "*echothiophate*" "*ambient*" "
local exterm " `exterm' "*amyloid*" "*anaesthetic*" "*anaphylaxis*" "*anti-*" "
local exterm " `exterm' "*apeu *" "aphthous*" "aphthus*" "*hot wax*" "
local exterm " `exterm' "*apyrex*" "*artificial*" "*sense change*" "*at risk *" "
local exterm " `exterm' "*matruchotii*" "*banzi*" "*acanthotic*" "*bhanja*" "
local exterm " `exterm' "*birdshot*" "*blackwater*" "*bladder*" "*hotot*" "
local exterm " `exterm' "*bloodshot*" "*boutonneuse*" "*bovine*" "*founder*" "
local exterm " `exterm' "*breast*" "*breakbone*" "*frigoritolerans*" "*brochothrix*" "
local exterm " `exterm' "*tick fever*" "*buhot*" "*bullis*" "*bunyamwera*" "
local exterm " `exterm' "*burn*" "*ability to*" "*able to*" "*adjusted to*" "
local exterm " `exterm' "*advice about*" "*tick-borne*" "*schotti*" "*agnosia*" "
local exterm " `exterm' "*cyprus*" "*aural*" "*bussuquara*" "*bronchotracheal*" "
local exterm " `exterm' "*burdwan*" "*buthotus*" "*bwamba*" "*candiru*" "
local exterm " `exterm' "*calovo*" "*calchaqui*" "*cane cutter*" "*canicola*" "
local exterm " `exterm' "*carparu*" "*cardiopulmonary*" "**cat-bite" "*sheep*" "
local exterm " `exterm' "*catu *" "*childbed*" "*cirrhotic*" "*neonate*" "
local exterm " `exterm' "*crimean*" "*(observable entity)*" "*(organism)*" "*core peripheral*" "
local exterm " `exterm' "*choti*" "*(attribute)*" "*core body temperature*" "*rotheus*" "
local exterm " `exterm' "*decrease*" "*dialysate*" "*dihydropsychotrine*" "*temperature regulation*" "
local exterm " `exterm' "*does not manage*" "*recognise*" "*quotidien*" "*hot wire*" "
local exterm " `exterm' "*drug*" "*ear hot*" "*dum dum*" "*dum-dum*" "
local exterm " `exterm' "*dromedary*" "*dugbe*" "*east coast*" "*spotted*" "
local exterm " `exterm' "*education*" "*echothiopahte*" "*low temp*" "*reduced*" "
local exterm " `exterm' "*electropyrexia*" "*elephantoid*" "*emprosthotonus*" "*enteric*" "
local exterm " `exterm' "*enterov*" "*newborn*" "*ephemeral*" "*everglades*" "
local exterm " `exterm' "*trichothecene*" "*scarlet*" "*encephalopathy*" "
local exterm " `exterm' "*factitious*" "*familial*" "*family*" "*racouchot*" "
local exterm " `exterm' "*immunodeficiency*" "*blister*" "*five day*" "*fog fev*" "
local exterm " `exterm' "*freez*" "*genus*" "germist*" "grain*" "
local exterm " `exterm' "*grain*" "*groin*" "*guaitara*" "
local exterm " `exterm' "*hot pack*" "*harvest*" "*haverhill*" "*hayfever*" "
local exterm " `exterm' "*hot cross*" "*branding*" "*hot spots*" "*hot object*" "
local exterm " `exterm' "*environment*" "*hot stool*" "*hot therapy*" "*hot-cold*" "
local exterm " `exterm' "*hysterical*" "*intravenous*" "*itaqui*" "*ilesha*" "
local exterm " `exterm' "*inappropriate*" "*tick virus*" "*indiana*" "*injury*" "
local exterm " `exterm' "*hepatic*" "*injectate*" "*inkoo*" "
local exterm " `exterm' "*bartonella*" "*hotv*" "*gibraltar*" "*haemoglobinuric*" "
local exterm " `exterm' "*nucleic acid*" "*(si)*" "*intravescial*" "*isfahan*" "
local exterm " `exterm' "*izumi*" "*japanese*" "*katayama*" "*kedani*" "
local exterm " `exterm' "*kemerovo*" "*kunjin*" "*lophotrichus*" "*louse*" "
local exterm " `exterm' "*phosphatase*" "*mill fever*" "*minhota*" "*monday*" "
local exterm " `exterm' "*monitor*" "*morphotyp*" "*mosquito*" "*rhothoecum*" "
local exterm " `exterm' "*murutuca*" "*mud fever*" "*mucambo*" "*pseudoshottsii*" "
local exterm " `exterm' "*mycoplasm*" "*nanukayami*" "*facial hair*" "*nasopharyngeal*" "
local exterm " `exterm' "*neoplitan*" "*neopsephotus*" "*no temperature*" "*newcastle*" "
local exterm " `exterm' "*nepuyo*" "*panniculitis*" "*normal temperature*" "*not aware of*" "
local exterm " `exterm' "*nyong*" "*temperature not taken*" "*oral temperature*" "*opisthotonos*" "
local exterm " `exterm' "*ocoton*" "*lophotes*" "*okhotskiy*" "*oriboca*" "
local exterm " `exterm' "*oroya*" "*orungo*" "*ossa*" "*ovulat*" "
local exterm " `exterm' "*mallory*" "*pappataci*" "*parrot*" "*nasogastric*" "
local exterm " `exterm' "*red water*" "*borrelia*" "*africa*" "*america*" "
local exterm " `exterm' "*asia*" "*mexico*" "*united states*" "*rhabdoviral*" "
local exterm " `exterm' "*rift valley*" "*mortis*" "*rib bravo*" "*room temp*" "
local exterm " `exterm' "*ross river*" "*siphotrol*" "*chotzen*" "*saddleback*" "
local exterm " `exterm' "*schottmuelleri*" "*valley fever*" "*river fever*" "*sandfly*" "
local exterm " `exterm' "*sao paulo*" "*forest fever*" "*sennetsu*" "*sepik*" "
local exterm " `exterm' "*day fever*" "*shipping*" "*shot size*" "*shotfire*" "
local exterm " `exterm' "*shotty lymph*" "*shuni*" "*sinbis*" "*slingshot*" "
local exterm " `exterm' "*photism*" "*tick-bite*" "*spillary*" "*rat-bite*" "
local exterm " `exterm' "*splenic*" "*spondweni*" "*opisthothelae*" "*frigoramans*" "
local exterm " `exterm' "*swamp*" "*sympathot*" "*syntrophothermus*" "*tnf receptor*" "
local exterm " `exterm' "*tacaiuma*" "*tataguine*" "*target*" "temperature" "
local exterm " `exterm' "temperature (property)*" "*temperature chart*" "*temperature change*" "
local exterm " `exterm' "*zika*" "*west nile*" "*wolhynian*" "*wyeomyia*" "
local exterm " `exterm' "*xanthotox*" "*zinga*" "*zalophotrema*" "*zinc*" "
local exterm " `exterm' "*hot air*" "*hot engine*" "*hot heating*" "*hot household*" "
local exterm " `exterm' "*hot tap*" "*hot substance*" "*hot fluid*" "*hot metal*" "
local exterm " `exterm' "*hot vapour*" "*typhus*" "*below normal*" "*below ref*" "
local exterm " `exterm' "*brass*" "*caraparu*" "*cat-bite*" "*controlled core*" "
local exterm " `exterm' "*etiocholanolone*" "*equipment temp*" "*hyperbaric*" "*heat exchanger*" "
local exterm " `exterm' "*rochalimaea*" "*feverfew*" "*inspired gas*" "*system of units*" "
local exterm " `exterm' "*katamaya*" "*murutucu*" "*non-si unit*" "*ochoton*" "
local exterm " `exterm' "*oropouche*" "*opisthotonus*" "*pestilential*" "*phlembotomus*" "
local exterm " `exterm' "*phosphotungstic*" "*picket fence*" "*pistol*" "*piry fever*" "
local exterm " `exterm' "*pinna*" "*pleurothotonos*" "*polymer*" "*pontiac*" "
local exterm " `exterm' "*vaccination*" "*alopecia*" "*postoperative*" "*postprocedural*" "
local exterm " `exterm' "*potomac*" "*pretibial*" "*psephotus*" "*puerperal*" "
local exterm " `exterm' "*postnatal*" "*puerperium*" "*quaranfil*" "*rabbit*" "
local exterm " `exterm' "*bravo fever*" "*quintan*" "*queensland*" "*radiator heater*" "
local exterm " `exterm' "*hot-wire*" "*hot spot*" "*rat bite*" "*shot-fire*" "
local exterm " `exterm' "*hotanense*" "*spelter*" "*streptobacil*" "*teach temp*" "
local exterm " `exterm' "*hand*" "*digit*" "*of toe*" "*oseophagus*" "
local exterm " `exterm' "*subnormal*" "*waveform*" "*temperature-sensitive*" "*temperature-control*" "
local exterm " `exterm' "*temperature-associated*" "*tensaw*" "*tertian*" "*texas*" "
local exterm " `exterm' "*thogoto*" "*thottapalayam*" "*toxic inhalation*" "
local exterm " `exterm' "*transfusion*" "*transit*" "*transport*" "*trench*" "
local exterm " `exterm' "*trichoth*" "*receptor-associated periodic fever syndrome*" "*uganda*" "*undershot*" "
local exterm " `exterm' "*absence of*" "*afebrile*" "*anesthetic*" "assess temp*" "
local exterm " `exterm' "*fever, thrombocytopenia, and leucopenia syndrome*" "*black water*" "*febrile agglutinins*" "
local exterm " `exterm' "*mucha-habermann*" "*pityriasis*" "*photinus*" "*pixuna*" "
local exterm " `exterm' "*postpartum*" "*pleurothotonus*" "*okhotskensis*" "*postprocedure*" "
local exterm " `exterm' "*quartan*" "*radiant heater*" "*caucasus*" "*unit of temperature*" "
local exterm " `exterm' "*severe fever with thrombocytopenia syndrome*" "*sindbis*" "*spirillary*" "*telehealth*" "
local exterm " `exterm' "*(foundation metadata concept)*" "*temperature taking*" "*tooth*" "*tissue*" "
local exterm " `exterm' "*tribec*" "*trivittatus*" "*undulant fever*" "*uruma*" "*wesselsbron*" "
local exterm " `exterm' "*uukuniemi*" "*uveoparotid*" "*aquashot*" "*equine*" "
local exterm " `exterm' "*stomatitis*" "*warming*" "*phlebotomus*" "*(navigational concept)*" "
local exterm " `exterm' "*ebstein*" "*dutch type*" "*paraneoplastic*" "o/e - rectal temperature*" "
local exterm " `exterm' "*method fever taken*" "*method fever registered*" "*temperature normal*" "*temperature low*" "
local exterm " `exterm' "*overshot*" "*neonatal*" "*hectic*" "*hemoglobinuric*" "
local exterm " `exterm' "*afebrile*" "*cryogenic*" "*rhotheus*" "*dhoti*" "
local exterm " `exterm' "*does manage body temp*" "*fever, thrombocytopenia, and leukopenia syndrome*" "*intravesical*" "


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

keep code term
compress

* save in csv format
export delimited using "../codelists/working/snomed-fever-working.csv", replace novarnames

/*
Export will be imported into OpenCodelists for review and sign off
*/




log close



