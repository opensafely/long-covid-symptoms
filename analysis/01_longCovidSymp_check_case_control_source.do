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
log using ./logs/01_longCovidSymp_check_case_control_source.log, replace t

import delimited ./output/input_covid_community.csv, clear
*check is only one stp
safetab stp
*check what variables
codebook


import delimited ./output/input_potential_controls_contemporary.csv, clear
*check is only one stp
safetab stp 

log close



