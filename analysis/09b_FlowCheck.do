/*==============================================================================
DO FILE NAME:			09_longCovidSymp_cr_analysis_dataset.do
PROJECT:				Long covid symptoms
DATE: 					29th Aug 2022
AUTHOR:					Kevin Wing 										
DESCRIPTION OF FILE:	Creates a file containing the matched cases and comparators ready for analysis, and a file of the cases that could not be matched for descr analysis
DATASETS USED:			.csv
DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir

tgg


sysdir set PLUS "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 
sysdir set PERSONAL "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 


*NEEDS REDONE THIS WEEK SO THAT THE COUNTS AT THE BEGINNING OF EACH FUP HAVE BEEN INCLUDED TO DROP THOSE THAT WERE NO LONGER ELIGIBLE FOR THAT FUP PERIOD (AND ALSO DROPPED ANY
NO LONGER MATCHED AFTER DOING SO). THINK I NEED TO DROP COMPARATORS WHO BECAME CASES IN THE PREVIOUS FUP PERIOD, BUT LIKELY DO A SENSITIVITY ANALYSIS WHERE THESE PEOPLE ARE NOT DROPPED(?). 

OTHER OPTION WOULD BE THAT THESE PEOPLE SHOULD BECOME CASES, MATCHED TO NEW COMPARATORS AND THEN INCLUDED IN THE ANALYIS FOR THE NEXT FUP?

I THINK THE FIRST WAY OF DOING IT SHOULD BE OK THOUGH, CAN REPORT NUMBERS*

							
==============================================================================*/
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
*globals of lists of diagnoses and symptoms etc
do ./analysis/masterLists.do
pwd

*setup so that the code in this file can be used to output analyses for both contemporary and historical comparators (and is called twice by separate .yaml actions)
local dataset `1'

* Open a log file
cap log close
log using ./logs/09b_FlowCheck_`dataset'.log, replace t


*load main analysis file
use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
rename case expStatus
bysort expStatus: sum death_date
bysort expStatus: sum dereg_date

****BUGHUNTING MAIN ANALYSIS FILE******
keep if death_date!=.
set seed 478298
generate random = runiform()
sort random
keep if _n<1000
sort death_date
list death_date



****BUGHUNTING OTHER FILES******
capture noisily import delimited ./output/input_controls_`dataset'CorrectedDeathDate.csv, clear
keep if death_date!=""
set seed 478298
generate random = runiform()
sort random
keep if _n<1000
sort death_date
list death_date


capture noisily import delimited ./output/input_covid_matched_matches_`dataset'_allSTPs.csv, clear
keep if death_date!=""
set seed 478298
generate random = runiform()
sort random
keep if _n<1000
sort death_date
list death_date


if "`1'"=="historical" {
	capture noisily import delimited ./output/input_complete_controls_`dataset'CorrectedDeathDate.csv, clear
	keep if death_date!=""
	set seed 478298
	generate random = runiform()
	sort random
	keep if _n<1000
	sort death_date
	list death_date
}

log close

/*

************************

*Numbers for flowchart check
*(0) Ever during follow-up
*(a) any ineligibility
safetab becameIneligEver expStatus, col
*(b) specific reasons
safetab compBecameCaseEver expStatus, col
safetab caseHospForCOVIDEver expStatus, col
tab diedEver expStatus, col
tab deregEver expStatus, col

*(1) During FUP1
*(a) any ineligibility
safetab becameIneligFUP1 expStatus, col
*(b) specific reasons
safetab compBecameCaseDurFUP1 expStatus, col
safetab caseHospForCOVIDDurFUP1 expStatus, col
safetab diedDuringFUP1 expStatus, col
safetab deregDuringFUP1 expStatus, col


*(2) During FUP2
*(a) any ineligibility
safetab becameIneligFUP2 expStatus, col
*(b) specific reasons
safetab compBecameCaseDurFUP2 expStatus, col
safetab caseHospForCOVIDDurFUP2 expStatus, col
safetab diedDuringFUP2 expStatus, col
safetab deregDuringFUP2 expStatus, col


*(3) During FUP3
*(a) any ineligibility
safetab becameIneligFUP3 expStatus, col
*(b) specific reasons
safetab compBecameCaseDurFUP3 expStatus, col
safetab caseHospForCOVIDDurFUP3 expStatus, col
safetab diedDuringFUP3 expStatus, col
safetab deregDuringFUP3 expStatus, col


safecount


log close





*bughunting code
/*

*check case_index_date is three years before for historical comparators
keep patient_id expStatus set_id case_index_date death_date dereg_date
gsort set_id -expStatus
generate caseCase_index_date=case_index_date if expStatus==1
by set_id: replace caseCase_index_date=caseCase_index_date[1] if caseCase_index_date==.
if "`1'"=="historical" {
	*check if it is three years before (this is what it should be)
	capture noisily assert case_index_date==caseCase_index_date-1096 if expStatus==0
	*check if it is two years before (if it isn't three years before)
	capture noisily assert case_index_date==caseCase_index_date-731 if expStatus==0
}

*have a look at the case_index_dates for a sample of people
keep patient_id expStatus case_index_date dereg_date set_id death_date 
*keep only comparators who have a death_date populated
keep if expStatus==0 & death_date!=.
*number of comparators who died
safecount

*number who died before start of follow_up
safecount if death_date<case_index_date

*number who died during follow-up, and eyeball case_index_date and index_date for these
safecount if death_date>=case_index_date & death_date<case_index_date+365
preserve
	keep if death_date>=case_index_date & death_date<case_index_date+365
	list case_index_date death_date 
restore


*number who died afer end of follow-up
safecount if death_date>=case_index_date+365
*eyeball randome sample of 500 of these
keep if death_date>=case_index_date+365
set seed 74925
generate random = runiform()
sort random
keep if _n<500
list case_index_date death_date

*repeat for total extracted controls just to see if the issue was created after the initial extraction or was there in the initial extraction
capture noisily import delimited ./output/input_controls_`dataset'.csv, clear
keep if death_date!=""
set seed 478298
generate random = runiform()
sort random
keep if _n<500
list death_date




log close
*/
