/*==============================================================================
DO FILE NAME:			09_longCovidSymp_cr_analysis_dataset.do
PROJECT:				Long covid symptoms
DATE: 					29th Aug 2022
AUTHOR:					Kevin Wing 										
DESCRIPTION OF FILE:	Creates a file containing the matched cases and comparators ready for analysis, and a file of the cases that could not be matched for descr analysis
DATASETS USED:			.csv
DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir

tg


sysdir set PLUS "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 
sysdir set PERSONAL "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 

							
==============================================================================*/
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
*globals of lists of diagnoses and symptoms etc
do ./analysis/masterLists.do
pwd

*setup so that the code in this file can be used to output analyses for both contemporary and historical comparators (and is called twice by separate .yaml actions)
local dataset `1'



* Open a log file
cap log close
log using ./logs/000_controlsFlowCheck.log, replace t




*(0)=========Get total cases and potential matches figure for flowchart - extra bit of work in this file is to drop comparators without the necessary follow-up or who died before case index date============
/*Has follow-up needs checked as there is nowhere previously where it is checked against the matched cases case index date, plus the death_date variable for controls so far is only related to the
*index date, not the case_index_date*/
*case
capture noisily import delimited ./output/input_covid_communitycases_correctedCaseIndex.csv, clear
di "***********************FLOWCHART 1. NUMBER OF POTENTIAL CONTROLS (WAVE 2) - CHECKING AT START OF WAVE 2********************:"


*comparator
capture noisily import delimited ./output/input_controls_contemporaryFlowCheck.csv, clear
di "**Potential comparators:**"
safecount


log close



