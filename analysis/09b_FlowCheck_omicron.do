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
*local dataset `1'

* Open a log file
cap log close
*log using ./logs/09b_FlowCheck_`dataset'_omicron.log, replace t
log using ./logs/09b_FlowCheck_contemporary_omicron.log, replace t

*load main analysis file
*use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
use ./output/longCovidSymp_analysis_dataset_contemporary_omicron.dta, clear
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


/*
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
*/



*use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
use ./output/longCovidSymp_analysis_dataset_contemporary_omicron.dta, clear
rename case expStatus

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





