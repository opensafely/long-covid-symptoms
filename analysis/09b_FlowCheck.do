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


*load main analysis file
use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
codebook case_index_date

*by case status
codebook case_index_date if case==0
codebook case_index_date if case==1


*check in earlier files
capture noisily import delimited ./output/input_covid_communitycases.csv, clear
codebook case_index_date


capture noisily import delimited ./output/input_covid_communitycases_correctedCaseIndex.csv, clear
codebook case_index_date


log close

/*


rename case expStatus
bysort expStatus: sum death_date
bysort expStatus: sum dereg_date

safecount if death_date>case_index_date & death_date<case_index_date+365 & expStatus==0

*investigation into why so few deaths in the one year follow-up period (particularly for historical comparator)
keep expStatus death_date case_index_date dereg_date set_id
generate oneYrFUP=case_index_date + 365
format oneYrFUP %td


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



