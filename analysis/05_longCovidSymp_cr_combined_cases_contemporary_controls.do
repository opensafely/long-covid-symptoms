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
log using ./logs/05_longCovidSymp_cr_combined_cases_contemporary_controls.log, replace t


*(1)=========Append separate cases files============
capture noisily import delimited ./output/input_covid_matched_cases_stp5.csv, clear
generate case=1
keep case set_id case_index_date stp
save ./output/input_covid_matched_cases_allSTPs.dta, replace

forvalues i = 6/49 {
	capture noisily import delimited ./output/input_covid_matched_cases_stp`i'.csv, clear
	capture noisily generate case=1
	capture noisily keep case set_id case_index_date stp
	capture noisily append using ./output/input_covid_matched_cases_allSTPs.dta, replace
	capture noisily count
	capture noisily safetab stp
}


*(2)=========Append separate control files============
capture noisily import delimited ./output/matched_matches_stp5.csv, clear
generate case=0
keep case set_id case_index_date stp
save ./output/input_covid_matched_matches_allSTPs.dta, replace

forvalues i = 6/49 {
	capture noisily import delimited ./output/input_covid_matched_matches_stp`i'.csv, clear
	capture noisily generate case=0
	capture noisily keep case set_id case_index_date stp
	capture noisily append using ./output/input_covid_matched_matches_allSTPs.dta, replace
	capture noisily count
	capture noisily safetab stp
}


*erase separate case and files
foreach num of numlist 5/49 {
		capture noisily erase ./output/input_covid_matched_cases_stp`num'.csv
		capture noisily erase ./output/input_covid_matched_matches_stp`num'.csv
}


log close



