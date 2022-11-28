/*==============================================================================
DO FILE NAME:			10_longCovidSymp_data_checks.do
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
log using ./logs/6a_longCovidSymp_checkHistoricalCombinedFiles.log, replace t




*(0)=========Cases============
import delimited ./output/input_covid_matched_cases_historical_allSTPs.csv, clear

*eyeball all variables
safecount
codebook


*(0)=========Controls============
import delimited ./output/input_covid_matched_matches_historical_allSTPs.csv, clear

*eyeball all variables
safecount
codebook




log close









