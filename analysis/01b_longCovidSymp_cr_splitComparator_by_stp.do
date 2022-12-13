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

*setup so that the code in this file can be used to output analyses for any types of comparators (and is called twice by separate .yaml actions)
local dataset `1'


* Open a log file
cap log close
log using ./logs/01b_longCovidSymp_split`1'_by_stp.log, replace t



*(1)=========Split historical or 2019 comparators into separate stp files============
import delimited ./output/input_controls_`1'.csv, clear
safetab stp

*stp is always set to 1 in dummy data so manually splitting up here (just for dummy data)
*COMMENT OUT THE FOLLOWING WHEN NOT RUNNING ON DUMMY DATA
	*replace stp="STP2" if _n>300
	**END OF COMMENT OUT

	*stps are coded E54000005-9, 10, 12-17, 20-27, 29, 33, 35-37, 40-44, 49
foreach i of numlist 5/9  {
	preserve
		capture noisily keep if stp=="E5400000`i'"
		capture noisily export delimited using "./output/input_controls_`1'_stp`i'.csv", replace
		count
		capture noisily safetab stp
	restore
}

foreach i of numlist 10 12/17 20/27 29 33 35/37 40/44 49 {
	preserve
		capture noisily keep if stp=="E540000`i'"
		capture noisily export delimited using "./output/input_controls_`1'_stp`i'.csv", replace
		count
		capture noisily safetab stp
	restore
}


log close



