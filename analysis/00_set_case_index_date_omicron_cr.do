/*==============================================================================
DO FILE NAME:			00_set_case_index_date_an.do
PROJECT:				Long covid symptoms
DATE: 					22nd Sep 2022
AUTHOR:					Kevin Wing									
DESCRIPTION OF FILE:	Corrects case index date (adds 28 days, which wasn't possible to do directly in the study definition), specifcally does the following:

0. Codebook for cases and for controls
1. Updates the first_known_covid date (cases only in this file) so that it is set to "" and is not checked by matching program as otherwise all cases will be dropped
2. Takes the case index date and adds 28 days to it
3. Upates the has_follow_up, covid_hosp AND has_died variables so that they include having checked the 28 day period
4. Upates the death_date & dereg_date variable so they reflect the 28 day period


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
log using ./logs/00_set_case_index_date_omicron_cr.log, replace t



*(0)=========Check variables in cases and controls============
*cases
*import delimited ./output/input_covid_communitycases.csv, clear
*codebook

*controls
*import delimited ./output/input_controls_contemporary.csv, clear
*codebook


*(1)=============Create a variable that is the same as first_known_covid but has all the dates on or before the temp_index_date dropped (called first_known_covidORIGINAL)============================== 
*import cases
import delimited ./output/input_covidcommunitycasesCorrectedDeathDate_omicron.csv, clear
generate first_known_covid19ORIGINAL=first_known_covid19
la var first_known_covid19 "Original first known covid varialble (for checking code)"
*for cases, remove all first known covid dates to prevent all the cases being dropped when searching for first known covid prior to the new (28 days later) index date
replace first_known_covid19=""


*(2)=========Create new case_index_date that is 28 days later than the temp_case_index_date============
*destring the temp_case_index_date variable
confirm string variable case_index_date
generate case_index_dateORIG=case_index_date
rename case_index_date case_index_date_dstr
gen case_index_date = date(case_index_date_dstr, "YMD")
format case_index_date %td 


*create new variable case_index_date that is 28 days later than the temporary file
generate case_index_date_nonString=case_index_date + 28
format case_index_date_nonString %td
drop case_index_date_dstr

*restring the new case_index_date variable and delete/rename those I don't need
generate case_index_dateNEW = string(case_index_date_nonString, "%tdCCYY-NN-DD")
drop case_index_date
rename case_index_dateNEW case_index_date
/*for dummy data*/
replace case_index_date="" if case_index_date=="."



*(3)=========Updates the has_follow_up AND has_died variables so that they include having checked the 28 day period============
*drop case if has_follow_up is zero for the 28 day period
drop if has_follow_up_28dys==0 
drop has_follow_up_28dys

*drop if has_died is 1 in the 28 day period
drop if has_died_28dys==1
drop has_died_28dys 


/*These are after case index date so shouldn't matter, as they return a date that is checked when matching, and that check will be against the new case index date
*(4)=========Updates the death_date & dereg_date variable so they reflect the 28 day period============
*If person died in the 28 day period, update the death_date variable so it includes this deathdate
replace death_date=death_date_28dys if death_date_28dys!="" & death_date==""
drop death_date_28dys
*If a person dereg in the 28 days, update the dereg_date variable so it includes this dereg_date
replace dereg_date=dereg_date_28dys if dereg_date_28dys!="" & death_date==""
drop death_date_28dys
*/


*save file
capture noisily export delimited using "./output/input_covid_communitycases_correctedCaseIndex_omicron.csv", replace

log close



