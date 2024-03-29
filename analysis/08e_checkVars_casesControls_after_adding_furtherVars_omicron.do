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
log using ./logs/08e_checkVars_casesControls_after_adding_furtherVars_omicron.log, replace t

*(0)========Cases==============
*capture noisily import delimited ./output/input_complete_covid_communitycases_omicron.csv, clear
*codebook

*check distribution of gp consultations in previous year in order to plan for caregorical variable
capture noisily import delimited ./output/input_symptoms_cases_omicron.csv, clear
codebook

 
*(0)========Comparators==============
*capture noisily import delimited ./output/input_complete_controls_contemporary_omicron.csv, clear
*codebook


*check distribution of gp consultations in previous year in order to plan for caregorical variable
capture noisily import delimited ./output/input_symptoms_controls_contemporary_omicron.csv, clear
codebook



log close






