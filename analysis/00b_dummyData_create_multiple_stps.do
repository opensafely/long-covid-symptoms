/*==============================================================================
DO FILE NAME:			00b_dummyData_create_multiple_stps.do
PROJECT:				Long covid symptoms
DATE: 					6th September 2022
AUTHOR:					Kevin Wing									
DESCRIPTION OF FILE:	Changes stp from all "stp1" to the full range of stps
DATASETS USED:			.csv files from study definitioons
DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir

t

JUST FOR DUMMY DATA, NOT TO BE INCLUDED IN YAML. ASSUMES DUMMY DATA N IS 50 000.

sysdir set PLUS "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 
sysdir set PERSONAL "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 

							
==============================================================================*/
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
pwd


* Open a log file
cap log close
log using ./logs/00b_dummyData_create_multiple_stps.log, replace t

*program for replacing stps that is called below
program drop _all
program replaceSTPs
	local low=0
	*divide total dataset by number of stps (=31)
	local increase=int(_N/31)
	*replace stps 5-9
	foreach i of numlist 5/9 {
		local high=`low'+`increase'
		replace stp="E5400000`i'" if _n>`low'& _n<`high'
		local low=`low'+ `increase'
	}
	count
	*replace all other stps
	*reset lower limit to take account that 5/9 have been done already
	local low=`increase'*5 
	foreach i of numlist 10 12/17 20/27 29 33 35/37 40/44 49 {
		local high=`low'+`increase'
		replace stp="E540000`i'" if _n>`low'& _n<`high'
		local low=`low'+ `increase'
	}
	count
	*tidy up remainder
	replace stp="E54000005" if stp=="STP1"
end


*(1)=========Create separate stps for cases============
import delimited ./output/input_covid_communitycases_correctedCaseIndex.csv, clear
*tabulate before changes
tab stp
*call program
replaceSTPs
*tabulate after changes
tab stp, miss
*export output
export delimited using "./output/input_covid_communitycases_correctedCaseIndex.csv", replace




*(2)=========Create separate stps for comparators============
import delimited ./output/input_controls_contemporary.csv, clear
*tabulate before changes
tab stp
*call program
replaceSTPs
*tabulate after changes
tab stp
*export output
export delimited using "./output/input_controls_contemporary.csv", replace


log close



