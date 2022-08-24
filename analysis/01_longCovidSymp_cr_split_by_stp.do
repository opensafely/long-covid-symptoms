/*==============================================================================
DO FILE NAME:			01_longCovidSymp_check_case_control_source.do
PROJECT:				Long covid symptoms
DATE: 					28th May 2022
AUTHOR:					Kevin Wing adapted from R Mathur H Forbes, A Wong, A Schultze, C Rentsch,K Baskharan, E Williamson 										
DESCRIPTION OF FILE:	Checks that source case and control files are only specific to one region (can't so this in dummy data as you specify the regions yourself!)
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
log using ./logs/01_longCovidSymp_split_by_stp.log, replace t


*(1)=========Split cases into separate stp files============
import delimited ./output/input_covid_communitycases.csv, clear
*tab just so I can see list of stps
safetab stp

*stp is always set to 1 in dummy data so manually splitting up here (just for dummy data)
*COMMENT OUT THE FOLLOWING WHEN NOT RUNNING ON DUMMY DATA
*replace stp="STP2" if _n>300
**END OF COMMENT OUT

*stps are coded E54000005-9, 10, 12-17, 20-27, 29, 33, 35-37, 40-44, 49
*files need to be .csv format as this is what the matching program needs as input
forvalues i = 5/9 {
	preserve
		capture noisily keep if stp=="E5400000`i'"
		capture noisily export delimited using "./output/input_covid_communitycases_stp`i'.csv", replace
	restore
}

forvalues i = 10/49 {
	preserve
		capture noisily keep if stp=="E540000`i'"
		capture noisily export delimited using "./output/input_covid_communitycases_stp`i'.csv", replace
	restore
}


*(2)=========Split controls into separate stp files============
import delimited ./output/input_controls_contemporary.csv, clear
safetab stp

*stp is always set to 1 in dummy data so manually splitting up here (just for dummy data)
*COMMENT OUT THE FOLLOWING WHEN NOT RUNNING ON DUMMY DATA
	*replace stp="STP2" if _n>300
	**END OF COMMENT OUT

	*stps are coded E54000005-9, 10, 12-17, 20-27, 29, 33, 35-37, 40-44, 49
forvalues i = 5/9 {
	preserve
		capture noisily keep if stp=="E5400000`i'"
		capture noisily export delimited using "./output/input_controls_contemporary_stp`i'.csv", replace
	restore
}

forvalues i = 10/49 {
	preserve
		keep if stp=="E540000`i'"
		export delimited using "./output/input_controls_contemporary_stp`i'.csv", replace
	restore
}


log close


