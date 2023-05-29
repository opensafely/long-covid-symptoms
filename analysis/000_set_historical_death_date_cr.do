/*==============================================================================
DO FILE NAME:			000_set_historical_death_date_an.do
PROJECT:				Long covid symptoms
DATE: 					22nd Sep 2022
AUTHOR:					Kevin Wing									
DESCRIPTION OF FILE:	Corrects the death date for the historical cohort becuase ONS death date is only available from Feb 2019 onwards - uses the primary care death date if it is
populated prior to 1st Feb 2019.


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
log using ./logs/000_set_historical_death_date_cr.log, replace t



*(0)=========import historical controls============
*controls
import delimited ./output/input_controls_historical.csv, clear



*(1)=========check both death date variables are there============
*controls
codebook death_date death_dateprimarycare




*(2)=========Destring variables============
*death_date
confirm string variable death_date
rename death_date death_date_str
gen death_date = date(death_date_str, "YMD")
format death_date %td 
**death_date primary care
confirm string variable death_dateprimarycare
rename death_dateprimarycare death_dateprimarycare_str
gen death_dateprimarycare = date(death_dateprimarycare_str, "YMD")
format death_dateprimarycare %td 



*(2)=============For all invididuals who have a primary care death date prior to 1st Feb 2019, populate the ONS date with this============================== 
/*Condition for replacement:
	1. death_datePrimaryCare needs to be populated
	2. death_date needs to not be populated
	3. death_datePrimaryCare needs to be before 1st feburary 2019

*/
generate pCareDDateUsed=0
la var pCareDDateUsed "primary care death date as death was prior to 01feb2019"
replace pCareDDateUsed=1 if death_dateprimarycare!=. & death_date==. & death_dateprimarycare<date("2019-02-01", "YMD")
replace death_date=death_dateprimarycare if death_dateprimarycare!=. & death_date==. & death_dateprimarycare<date("2019-02-01", "YMD")
*code for checking dummy data
*order death_date death_date_str death_dateprimarycare death_dateprimarycare_str pCareDDateUsed


*(3)=============Restring the dates============================== 
*restring the new case_index_date variable and delete/rename those I don't need
generate death_dateNEW = string(death_date, "%tdCCYY-NN-DD")
*order death_dateNEW death_date death_date_str death_dateprimarycare death_dateprimarycare_str pCareDDateUsed
drop death_date
rename death_dateNEW death_date
replace death_date="" if death_date=="."
*order death_date death_date_str death_dateprimarycare death_dateprimarycare_str pCareDDateUsed
drop death_date_str death_dateprimarycare death_dateprimarycare_str
*confusingly, all of the death dates in the dummy data are prior to feb 2019!



*save file
capture noisily export delimited using "./output/input_controls_historicalCorrectedDeathDate.csv", replace

log close



