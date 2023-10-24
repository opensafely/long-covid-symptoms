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

local dataset `1'



*(0)=========import files============
if "`1'"=="contemporary" {
	****CODE THAT UPDATES HAS DIED SO IT TAKES ACCOUNT OF PRIMARY CARE AS WELL AS ONS RECORDS******
	cap log close
	log using ./logs/000_set_correct_death_dates_contemporary_omicron_cr.log, replace t
	import delimited ./output/input_controls_`1'_omicron.csv, clear
	replace has_died=1 if has_diedprimarycare==1
	tab has_died, miss
	capture noisily export delimited using "./output/input_controls_contemporaryCorrectedDeathDate_omicron.csv", replace
	log close
}
else if "`1'"=="cases" {
	****CODE THAT UPDATES HAS DIED SO IT TAKES ACCOUNT OF PRIMARY CARE AS WELL AS ONS RECORDS******
	log using ./logs/000_set_correct_death_dates_cases_omicron_cr.log, replace t
	import delimited ./output/input_covid_communitycases_omicron.csv, clear
	replace has_died=1 if has_diedprimarycare==1
	tab has_died, miss
	capture noisily export delimited using "./output/input_covidcommunitycasesCorrectedDeathDate_omicron.csv", replace
	log close
}




