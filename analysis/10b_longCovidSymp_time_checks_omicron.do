/*==============================================================================
DO FILE NAME:			10_longCovidSymp_data_checks.do
PROJECT:				Long covid symptoms
DATE: 					29th Aug 2022
AUTHOR:					Kevin Wing 										
DESCRIPTION OF FILE:	Creates a file containing the matched cases and comparators ready for analysis, and a file of the cases that could not be matched for descr analysis
DATASETS USED:			.csv
DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir

t
g


sysdir set PLUS "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 
sysdir set PERSONAL "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 

							
==============================================================================*/
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
*globals of lists of diagnoses and symptoms etc
do ./analysis/masterLists.do
pwd


* Open a log file
cap log close
log using ./logs/10b_longCovidSymp_time_checks_contemporary_omicron.log, replace t


*setup so that the code in this file can be used to output analyses for both contemporary and historical comparators (and is called twice by separate .yaml actions)
*local dataset `1'

*extra code to check earliest date in various files preceding the main analysis one
*(A) RAW EXTRACTED DATA ON CASES
import delimited "./output/input_covid_communitycases_omicron.csv", clear
*destring case_index_date
confirm string variable case_index_date
generate case_index_dateORIG=case_index_date
rename case_index_date case_index_date_dstr
gen case_index_date = date(case_index_date_dstr, "YMD")
format case_index_date %td 
*Earliest case index date
sort case_index_date
display string(case_index_date[_n==1], "%tdDDmonYY")


*(B) COHORT OF CASES AFTER SETTING DEATH DATE
import delimited "./output/input_covidcommunitycasesCorrectedDeathDate_omicron.csv", clear
*destring case_index_date
confirm string variable case_index_date
generate case_index_dateORIG=case_index_date
rename case_index_date case_index_date_dstr
gen case_index_date = date(case_index_date_dstr, "YMD")
format case_index_date %td 
*Earliest case index date
sort case_index_date
display string(case_index_date[_n==1], "%tdDDmonYY")

*(C) COHORT OF CASES AFTER SETTING INDEX DATE
import delimited "./output/input_covid_communitycases_correctedCaseIndex_omicron.csv", clear
*destring case_index_date
confirm string variable case_index_date
generate case_index_dateORIG=case_index_date
rename case_index_date case_index_date_dstr
gen case_index_date = date(case_index_date_dstr, "YMD")
format case_index_date %td 
*Earliest case index date
sort case_index_date
display string(case_index_date[_n==1], "%tdDDmonYY")


*(D) CASES AND CONTROLS AFTER MATCHING (ONE EXAMPLE)
*CASES
import delimited ./output/input_covid_matched_cases_contemporary_allSTPs_omicron.csv, clear
*destring case_index_date
confirm string variable case_index_date
generate case_index_dateORIG=case_index_date
rename case_index_date case_index_date_dstr
gen case_index_date = date(case_index_date_dstr, "YMD")
format case_index_date %td 
*Earliest case index date for matched cases
sort case_index_date
display string(case_index_date[_n==1], "%tdDDmonYY")

*CONTROLS
import delimited ./output/input_covid_matched_matches_contemporary_allSTPs_omicron.csv, clear
*destring case_index_date
confirm string variable case_index_date
generate case_index_dateORIG=case_index_date
rename case_index_date case_index_date_dstr
gen case_index_date = date(case_index_date_dstr, "YMD")
format case_index_date %td 
*Earliest case index for matched controls
sort case_index_date
display string(case_index_date[_n==1], "%tdDDmonYY")






*(0)=========Load file and check total numbers and cases and controls============
use ./output/longCovidSymp_analysis_dataset_contemporary_omicron.dta, clear


codebook case_index_date


*(1)==========check earliest, latest and median case_index_date (overall and by case status)================
sort case_index_date
*(A) EARLIEST CASE INDEX DATE
*Earliest case index date overall
display string(case_index_date[_n==1], "%tdDDmonYY")

*Earliest case index date for those with COVID during omicron wave
preserve
	drop if case==0
	sort case_index_date
	display string(case_index_date[_n==1], "%tdDDmonYY")
restore
*Earliest case index date for those without COVID
preserve
	drop if case==1
	sort case_index_date
	display string(case_index_date[_n==1], "%tdDDmonYY")
restore



*(B) LATEST CASE INDEX DATE
*Latest case index date overall:
display string(case_index_date[_N], "%tdDDmonYY")

*Latest case index date for those with COVID during omicron wave
preserve
	drop if case==0
	sort case_index_date
	display string(case_index_date[_N], "%tdDDmonYY")
restore
*Latest case index date for those without COVID
preserve
	drop if case==1
	sort case_index_date
	display string(case_index_date[_N], "%tdDDmonYY")
restore



*(C) MEDIAN CASE INDEX DATE
*median case indexdate overall
sum case_index_date, detail
local 25percentile=string(r(p25), "%tdDDmonYY")
local median=string(r(p50), "%tdDDmonYY")
local 75percentile=string(r(p75), "%tdDDmonYY")
display "25 percentile case_index_date overall: `25percentile'"
display "Median case_index_date overall: `median'"
display "75 percentile case_index_date overall: `75percentile'"

*median case index date for those with COVID during omicron wave
sum case_index_date if case==1, detail
local 25percentile=string(r(p25), "%tdDDmonYY")
local median=string(r(p50), "%tdDDmonYY")
local 75percentile=string(r(p75), "%tdDDmonYY")
display "25 percentile case_index_date in those with COVID: `25percentile'"
display "Median case_index_date in those with COVID: `median'"
display "75 percentile case_index_date in those with COVID: `75percentile'"


*median case index date for those without COVID
sum case_index_date if case==0, detail
local 25percentile=string(r(p25), "%tdDDmonYY")
local median=string(r(p50), "%tdDDmonYY")
local 75percentile=string(r(p75), "%tdDDmonYY")
display "25 percentile case_index_date in those without COVID: `25percentile'"
display "Median case_index_date in those without COVID: `median'"
display "75 percentile case_index_date in those without COVID: `75percentile'"


*(2)==============Check what proportion were followed up until 31-03-2023, and what the median length of follow-up was for these people==============
*number that became ineligible during the three periods
tab becameIneligEver

*as above but by case status
tab becameIneligEver case

*for those that were followed up until the end, how long was total follow-up - overall and by case status
generate latestFUP=date("31mar2023", "DMY") if becameIneligEver==0
format latestFUP %td
generate followUpLength=latestFUP-case_index_date if becameIneligEver==0

*overall
sum followUpLength if becameIneligEver==0, detail
local 25percentile=r(p25)/365.25
local median=r(p50)/365.25
local 75percentile=r(p75)/365.25
display "25 percentile length of FUP overall (years): `25percentile'"
display "Median length of FUP overall (years): `median'"
display "75 percentile length of FUP overall (years): `75percentile'"

*for those with COVID
sum followUpLength if becameIneligEver==0 & case==1, detail
local 25percentile=r(p25)/365.25
local median=r(p50)/365.25
local 75percentile=r(p75)/365.25
display "25 percentile length of FUP for those with COVID (years): `25percentile'"
display "Median length of FUP for those with COVID (years): `median'"
display "75 percentile length of FUP for those with COVID (years): `75percentile'"

*for those without COVID
sum followUpLength if becameIneligEver==0 & case==0, detail
local 25percentile=r(p25)/365.25
local median=r(p50)/365.25
local 75percentile=r(p75)/365.25
display "25 percentile length of FUP for those without COVID (years): `25percentile'"
display "Median length of FUP for those without COVID (years): `median'"
display "75 percentile length of FUP for those without COVID (years): `75percentile'"


log close



