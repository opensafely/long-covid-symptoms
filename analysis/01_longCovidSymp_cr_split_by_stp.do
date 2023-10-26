/*==============================================================================
DO FILE NAME:			01_longCovidSymp_check_case_control_source.do
PROJECT:				Long covid symptoms
DATE: 					28th May 2022
AUTHOR:					Kevin Wing									
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


*(1)=========Split cases into separate stp files== ==========
import delimited ./output/input_covid_communitycases_correctedCaseIndex.csv, clear
*tab just so I can see list of stps
safetab stp


*stps are coded E54000005-9, 10, 12-17, 20-27, 29, 33, 35-37, 40-44, 49
*files need to be .csv format as this is what the matching program needs as input
foreach i of numlist 5/9 {
	preserve
		capture noisily keep if stp=="E5400000`i'"
		capture noisily export delimited using "./output/input_covid_communitycases_stp`i'.csv", replace
		count
		capture noisily safetab stp
	restore
}

foreach i of numlist 10 12/17 20/27 29 33 35/37 40/44 49 {
	preserve
		capture noisily keep if stp=="E540000`i'"
		capture noisily export delimited using "./output/input_covid_communitycases_stp`i'.csv", replace
		count
		capture noisily safetab stp
	restore
}




*(2)=========Split controls into separate stp files============
import delimited ./output/input_controls_contemporaryCorrectedDeathDate.csv, clear
safetab stp


	*stps are coded E54000005-9, 10, 12-17, 20-27, 29, 33, 35-37, 40-44, 49
foreach i of numlist 5/9  {
	preserve
		capture noisily keep if stp=="E5400000`i'"
		capture noisily export delimited using "./output/input_controls_contemporary_stp`i'.csv", replace
		count
		capture noisily safetab stp
	restore
}

foreach i of numlist 10 12/17 20/27 29 33 35/37 40/44 49 {
	preserve
		capture noisily keep if stp=="E540000`i'"
		capture noisily export delimited using "./output/input_controls_contemporary_stp`i'.csv", replace
		count
		capture noisily safetab stp
	restore
}


log close



