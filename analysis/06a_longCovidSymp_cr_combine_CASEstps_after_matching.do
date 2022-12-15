/*==============================================================================
DO FILE NAME:			05_longCovidSymp_cr_combined_cases_contemporary_controls.do
PROJECT:				Long covid symptom
DATE: 					26th Aug 2022
AUTHOR:					Kevin Wing 										
DESCRIPTION OF FILE:	Combines all stp cases into a single file, and all stp comparators into a single file
DATASETS USED:			.csv files outputted by each "match" study definition (which match by separate spt)
DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir

t


sysdir set PLUS "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 
sysdir set PERSONAL "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 

							
==============================================================================*/
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
*globals of lists of diagnoses and symptoms etc
do ./analysis/masterLists.do
pwd

*setup so that the code in this file can be used to output analyses for both contemporary, historical and 2019 comparators (and is called twice by separate .yaml actions)
local dataset `1'


* Open a log file
cap log close
log using ./logs/06a_longCovidSymp_cr_combine_`1'_CASEstps_after_matching.log, replace t

if "`1'"=="contemporary" {
	*(1)=========Change source files to stata format============
	*change source files to stata format
	foreach i of numlist 5/10 12/17 20/27 29 33 35/37 40/44 49 {
		capture noisily import delimited ./output/matched_cases_stp`i'.csv, clear
		capture noisily tempfile matched_cases_stp`i'
		capture noisily save `matched_cases_stp`i'', replace
	}
	*(2)=========Append separate cases files==========
	use `matched_cases_stp5', clear
	foreach i of numlist 6/10 12/17 20/27 29 33 35/37 40/44 49 {
		capture noisily append using `matched_cases_stp`i'', force
	}
}
else {
	*(1)=========Change source files to stata format============
	*change source files to stata format
	foreach i of numlist 5/10 12/17 20/27 29 33 35/37 40/44 49 {
		capture noisily import delimited ./output/matched_cases_`1'_stp`i'.csv, clear
		capture noisily tempfile matched_cases_`1'_stp`i'
		capture noisily save `matched_cases_`1'_stp`i'', replace
	}
	*(2)=========Append separate cases files==========
	use `matched_cases_`1'_stp5', clear
	foreach i of numlist 6/10 12/17 20/27 29 33 35/37 40/44 49 {
		capture noisily append using `matched_cases_`1'_stp`i'', force
	}
}
codebook

*count of total cases and STPs
capture noisily safetab stp
capture noisily count
*save as .csv file for input into study definitions that add further variables, erase dta version
capture noisily export delimited using "./output/input_covid_matched_cases_`1'_allSTPs.csv", replace

log close



