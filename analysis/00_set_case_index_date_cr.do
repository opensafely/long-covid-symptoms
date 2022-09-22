/*==============================================================================
DO FILE NAME:			00_set_case_index_date_an.do
PROJECT:				Long covid symptoms
DATE: 					22nd Sep 2022
AUTHOR:					Kevin Wing									
DESCRIPTION OF FILE:	Corrects case index date (adds 28 days, which wasn't possible to do directly in the study definition)
DATASETS USED:			.csv files from study definitioons
DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir

t


sysdir set PLUS "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 
sysdir set PERSONAL "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 

							
==============================================================================*/
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
pwd


* Open a log file
cap log close
log using ./logs/00_set_case_index_date_cr.log, replace t


*(1)=========Import cases============
import delimited ./output/input_covid_communitycases.csv, clear

*(2)=========Create new variable that is 28 days later than temp_case_index_date============
*destring the temp_case_index_date variable
confirm string variable temp_case_index_date
rename temp_case_index_date temp_case_index_date_dstr
gen temp_case_index_date = date(temp_case_index_date_dstr, "YMD")
format temp_case_index_date %td 

*create new variable case_index_date that is 28 days later than the temporary file
generate case_index_date_nonString=temp_case_index_date + 28
format case_index_date_nonString %td

*restring the new case_index_date variable and delete/rename those I don't need
generate case_index_date = string(case_index_date_nonString, "%tdCCYY-NN-DD")
drop case_index_date_nonString temp_case_index_date
rename temp_case_index_date_dstr temp_case_index_date

*save file
capture noisily export delimited using "./output/input_covid_communitycases_correctedCaseIndex.csv", replace

log close



