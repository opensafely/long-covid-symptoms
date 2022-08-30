/*==============================================================================
DO FILE NAME:			05_check_vars_after_matching.do
PROJECT:				Long covid symptoms
DATE: 					26th Aug 2022
AUTHOR:					Kevin Wing 										
DESCRIPTION OF FILE:	Checks vars in matched files
DATASETS USED:			matched output files
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
log using ./logs/05_check_vars_after_matching.log, replace t


*(1)=========Import case and control file and perform a codebook for each============
*cases
capture noisily import delimited ./output/matched_cases_stp5.csv, clear
codebook

*matched comparators
capture noisily import delimited ./output/matched_matches_stp5.csv, clear
codebook

log close



