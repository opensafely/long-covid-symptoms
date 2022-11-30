/*==============================================================================
DO FILE NAME:			09_longCovidSymp_cr_analysis_dataset.do
PROJECT:				Long covid symptoms
DATE: 					29th Aug 2022
AUTHOR:					Kevin Wing 										
DESCRIPTION OF FILE:	Creates a file containing the matched cases and comparators ready for analysis, and a file of the cases that could not be matched for descr analysis
DATASETS USED:			.csv
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
log using ./logs/08f_getHistoricalMatchedCases.log, replace t





*(0)=========Get list of cases matched to current comparators=================
capture noisily import delimited ./output/input_covid_matched_cases_contemporary_allSTPs.csv, clear
keep patient_id
safecount
tempfile current_cases
save `current_cases'


*(1)=========Get list of cases matched to historical comparators=================
*case
capture noisily import delimited ./output/input_covid_matched_cases_historical_allSTPs.csv, clear
keep patient_id
safecount


*(2)=========Merge current with historical and have a look=================
merge 1:1 patient_id using `current_cases'


*(3)=========save 2 files that I need==============
*firstly, list of historical-matched cases that ARE also current-matched cases i.e. those that were matched
preserve
	keep if _merge==3
	drop _merge
	save "./output/input_historical_and_current_cases.dta", replace
restore
*then, csv file of those records that were only historical i.e. _merge==1 which is records that were NOT MATCHED from the master file of all my historical cases
keep if _merge==1
capture noisily export delimited using "./output/input_historical_cases_only.csv", replace

log close



