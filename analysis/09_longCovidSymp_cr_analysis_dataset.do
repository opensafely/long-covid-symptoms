/*==============================================================================
DO FILE NAME:			08_longCovidSymp_cr_analysis_dataset.do
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
log using ./logs/09_longCovidSymp_cr_analysis_dataset.do.log, replace t


*(1)=========Append case and control files============
*import (matched) comparators and save as tempfile
capture noisily import delimited ./output/input_complete_controls_contemporary.csv, clear
tempfile matched_controls
save `matched_controls', replace

*import (matched) cases and append to comparators
capture noisily import delimited ./output/input_complete_covid_communitycases.csv, clear
tempfile matched_cases
save `matched_cases', replace
capture noisily append using `matched_controls'



*(2)=========Create a file of unmatched cases for descriptive analysis============
*import list of all cases (pre-matching)
preserve
	capture noisily import delimited ./output/input_covid_communitycases.csv, clear
	tempfile allCases
	save `allCases', replace
	use `matched_cases', clear
	keep patient_id
	merge 1:1 patient_id using `allCases'
	keep if _merge==3
	*save file for descriptive analysis
	save output/longCovidSymp_UnmatchedCases_analysis_dataset.dta, replace
restore









log close



