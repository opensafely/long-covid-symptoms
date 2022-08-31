/*==============================================================================
DO FILE NAME:			05_longCovidSymp_cr_combined_cases_contemporary_controls.do
PROJECT:				Long covid symptoms
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
pwd


* Open a log file
cap log close
log using ./logs/06b_longCovidSymp_cr_combine_COMPARATORstps_after_matching.log, replace t



*(1)=========Append separate control files after matching============
capture noisily import delimited ./output/matched_matches_stp5.csv, clear
capture noisily keep case set_id case_index_date stp
tempfile matches_for_allSTPs
save `matches_for_allSTPs', replace

forvalues i = 6/49 {
	capture noisily import delimited ./output/matched_matches_stp`i'.csv, clear
	capture noisily keep patient_id case set_id case_index_date stp
	capture noisily append using `matches_for_allSTPs'
	capture noisily save `matches_for_allSTPs', replace
}
*count of total cases and STPs
capture noisily safetab stp
capture noisily count
*save as .csv file for input into study definitions that add further variables
capture noisily export delimited using "./output/input_covid_matched_matches_allSTPs.csv", replace

*erase separate control files
foreach num of numlist 5/49 {
	capture noisily erase ./output/matched_matches_stp`num'.csv
}

log close



