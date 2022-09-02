/*==============================================================================
DO FILE NAME:			00_checkSTPs_in_original_extract_an.do
PROJECT:				Long covid symptoms
DATE: 					2nd Sep 2022
AUTHOR:					Kevin Wing									
DESCRIPTION OF FILE:	Checks numbers in each stp in original extracted files
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
log using ./logs/00_checkSTPs_in_original_extract_an.log, replace t


*(1)=========Cases============
import delimited ./output/input_covid_communitycases.csv, clear
safetab stp


*(2)=========Controls============
import delimited ./output/input_controls_contemporary.csv, clear
safetab stp


log close



