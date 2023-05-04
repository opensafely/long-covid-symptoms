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

*(0) Ever during follow-up
*(a) any ineligibility
safetab becameIneligEver expStatus
*(b) specific reasons
safetab compBecameCaseEver expStatus
safetab caseHospForCOVIDEver expStatus
safetab diedEver expStatus
safetab deregEver expStatus

*(1) During FUP1
*(a) any ineligibility
safetab becameIneligFUP1 expStatus
*(b) specific reasons
safetab compBecameCaseDurFUP1 expStatus
safetab caseHospForCOVIDDurFUP1 expStatus
safetab diedDuringFUP1 expStatus
safetab deregDuringFUP1 expStatus


*(2) During FUP2
*(a) any ineligibility
safetab becameIneligFUP2 expStatus
*(b) specific reasons
safetab compBecameCaseDurFUP2 expStatus
safetab caseHospForCOVIDDurFUP2 expStatus
safetab diedDuringFUP2 expStatus
safetab deregDuringFUP2 expStatus


*(3) During FUP3
*(a) any ineligibility
safetab becameIneligFUP3 expStatus
*(b) specific reasons
safetab compBecameCaseDurFUP3 expStatus
safetab caseHospForCOVIDDurFUP3 expStatus
safetab diedDuringFUP3 expStatus
safetab deregDuringFUP3 expStatus



safecount


log close



