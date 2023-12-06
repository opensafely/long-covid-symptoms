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
*globals of lists of diagnoses and symptoms etc
do ./analysis/masterLists.do
pwd

*setup so that the code in this file can be used to output analyses for both contemporary, historical and 2019 comparators (and is called twice by separate .yaml actions)


* Open a log file
cap log close
log using ./logs/6f_longCovidSymp_contemporary_checkCombinedFiles.log, replace t




*(0)=========Cases============
import delimited ./output/input_covid_matched_cases_contemporary_allSTPs.csv, clear

*eyeball all variables
safecount
codebook


*(0)=========Controls============
import delimited ./output/input_covid_matched_matches_contemporary_allSTPs.csv, clear

*eyeball all variables
safecount
codebook




log close









