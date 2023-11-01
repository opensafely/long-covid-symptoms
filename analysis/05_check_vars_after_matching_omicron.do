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
*globals of lists of diagnoses and symptoms etc
do ./analysis/masterLists.do
pwd

*setup so that the code in this file can be used to output analyses for both contemporary, historical and 2019 comparators (and is called twice by separate .yaml actions)
local dataset `1'



* Open a log file
cap log close
log using ./logs/05_check_vars`1'_after_matching_omicron.log, replace t


*(1)=========Import case file, codebook and then look at dates============
*using stp 29 as this is one of the smaller stps but not too small (has 6,317 cases)
*cases
capture noisily import delimited ./output/matched_cases_stp29_omicron.csv, clear
codebook


*convert string dates to dates
order first_test_covid first_pos_test first_pos_testw4 covid_tpp_prob covid_tpp_probw4 covid_tpp_probclindiag covid_tpp_probtest covid_tpp_probseq covid_hosp covid_hosp_primdiag pos_covid_test_ever first_known_covid19 death_date dereg_date first_known_covid19original case_index_dateorig case_index_date
foreach var of varlist first_test_covid - case_index_date {
	capture noisily confirm string variable `var'
	capture noisily rename `var' `var'_dstr
	capture noisily gen `var' = date(`var'_dstr, "YMD")
	capture noisily drop `var'_dstr
	capture noisily format `var' %td 
}


*check that case indexdate is 28 days after original case index dates
capture noisily assert case_index_date==case_index_dateorig+28

*check that there were no hospitalisations, deregistrations or deaths prior to the case index dates
capture noisily assert covid_hosp>=case_index_date
capture noisily assert death_date>=case_index_date
capture noisily assert dereg_date>=case_index_date

*repeat for original case date in case the above didn't work
capture noisily assert covid_hosp>=case_index_dateorig
capture noisily assert death_date>=case_index_dateorig
capture noisily assert dereg_date>=case_index_dateorig

*matched comparators - just doing cases for now so I can check that everything is as expected re: dates
*capture noisily import delimited ./output/matched_matches_stp29.csv, clear
*codebook

/*
*keep one record to check case_index_date of matched historical comparator
keep if _n==1
keep patient_id set_id case_index_date
duplicates drop patient_id, force
rename case_index_date case_index_dateForCase
tempfile caseIndexChecker
save `caseIndexChecker'
*/




*(2)=========Import comparator file, codebook and then look at dates============
*using stp 29 as this is one of the smaller stps but not too small (has 6,317 cases)
*comparators
	capture noisily import delimited ./output/matched_matches_stp29_omicron.csv, clear
codebook


*convert string dates to dates
order first_test_covid first_pos_test first_pos_testw4 covid_tpp_prob covid_tpp_probw4 covid_tpp_probclindiag covid_tpp_probtest covid_tpp_probseq covid_hosp covid_hosp_primdiag pos_covid_test_ever first_known_covid19 death_date dereg_date case_index_date
foreach var of varlist first_test_covid - case_index_date {
	capture noisily confirm string variable `var'
	capture noisily rename `var' `var'_dstr
	capture noisily gen `var' = date(`var'_dstr, "YMD")
	capture noisily drop `var'_dstr
	capture noisily format `var' %td 
}


*check that there were deregistrations, deaths or first known covid prior to the case index dates
capture noisily assert first_known_covid>=case_index_date
capture noisily assert death_date>=case_index_date
capture noisily assert dereg_date>=case_index_date


*summarise case index date
codebook case_index_date
summ case_index_date, detail


*summarise death_date and dereg_date
codebook death_date
summ death_date, detail
codebook dereg_date
summ dereg_date, detail

/*
*for historical comparators, check for specific date that it is three years prior
keep patient_id set_id case_index_date
duplicates drop patient_id, force
merge m:1 set_id using `caseIndexChecker'
keep if _merge==3
if "`1'"=="historical" {
	capture noisily assert case_index_date==case_index_dateForCase-1096
}
*/



log close



