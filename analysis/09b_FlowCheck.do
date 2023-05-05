/*==============================================================================
DO FILE NAME:			09_longCovidSymp_cr_analysis_dataset.do
PROJECT:				Long covid symptoms
DATE: 					29th Aug 2022
AUTHOR:					Kevin Wing 										
DESCRIPTION OF FILE:	Creates a file containing the matched cases and comparators ready for analysis, and a file of the cases that could not be matched for descr analysis
DATASETS USED:			.csv
DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir

tg


sysdir set PLUS "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 
sysdir set PERSONAL "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 

							
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


*load file
use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
rename case expStatus
bysort expStatus: sum death_date
bysort expStatus: sum dereg_date

/*
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
*/


*due to the weirdness of dereg date, check in the source files
*(1)In cohort of cases
capture noisily import delimited ./output/input_covid_communitycases_correctedCaseIndex.csv, clear
codebook death_date
codebook dereg_date

*(2)In original cohort of controls
capture noisily import delimited ./output/input_controls_`dataset'.csv, clear
codebook death_date
codebook dereg_date

*(3)In matched controls
capture noisily import delimited ./output/input_covid_matched_matches_`dataset'_allSTPs.csv, clear
codebook death_date
codebook dereg_date



safecount


log close



