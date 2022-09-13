/*==============================================================================
DO FILE NAME:			09_longCovidSymp_cr_analysis_dataset.do
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
log using ./logs/09_longCovidSymp_cr_analysis_dataset.log, replace t




*(0)=========Get total cases and potential matches figure for flowchart============
*case
capture noisily import delimited ./output/input_covid_communitycases.csv, clear
di "***********************FLOWCHART 1. NUMBER OF POTENTIAL CASES AND CONTROLS (WAVE 2)********************:"
di "**Potential cases:**"
safecount

*comparator
capture noisily import delimited ./output/input_controls_contemporary.csv, clear
di "**Potential comparators:**"
safecount



*(1)=========Get case and comparator information from the "matched" files============
*case
capture noisily import delimited ./output/input_covid_matched_cases_allSTPs.csv, clear
keep patient_id case match_counts sex set_id stp
tempfile cases_match_info
*for dummy data, should do nothing in the real data
duplicates drop patient_id, force
save `cases_match_info', replace

*comparator
capture noisily import delimited ./output/input_covid_matched_matches_allSTPs.csv, clear
keep patient_id case set_id stp
tempfile comp_match_info
*for dummy data, should do nothing in the real data
duplicates drop patient_id, force
save `comp_match_info', replace





*(2)=========Add case and comparator information to the separate draft analysis files============
*import (matched) cases with variables and merge with match variables
capture noisily import delimited ./output/input_complete_covid_communitycases.csv, clear
drop stp /*this is needed to make sure dummy data still ends up with sensible STP data!*/
merge 1:1 patient_id using `cases_match_info'
keep if _merge==3
drop _merge
tempfile cases_with_vars_and_match_info
save `cases_with_vars_and_match_info', replace
di "***********************FLOWCHART 2. NUMBER OF MATCHED CASES AND MATCHED COMPARATORS********************:"
di "**Matched cases:**"
safecount


capture noisily import delimited ./output/input_complete_controls_contemporary.csv, clear
drop stp /*this is needed to make sure dummy data still ends up with sensible STP data!*/
merge 1:1 patient_id using `comp_match_info'
keep if _merge==3
drop _merge
tempfile comp_with_vars_and_match_info
save `comp_with_vars_and_match_info', replace
di "**Matched comparators:**"
safecount





*(3)=========Append case and comparator files together and tidy up, then check number as expected============
append using `cases_with_vars_and_match_info', force
tab case
*count then drop cases with no matches
count if match_counts==0
drop if match_counts==0
tab case
tab match_counts
di "***********************FLOWCHART 3. NUMBER OF MATCHED CASES AND MATCHED COMPARATORS (COMBINED FILE, AFTER DROPPING THOSE WITH MATCH_COUNTS==0********************:"
safecount
tab case




*(4)=========Create a file of unmatched cases for descriptive analysis============
*import list of all cases (pre-matching)
preserve
	capture noisily import delimited ./output/input_covid_communitycases.csv, clear
	tempfile allCases
	*for dummy data, should do nothing in the real data
	duplicates drop patient_id, force
	save `allCases', replace
	use `cases_match_info', clear
	keep patient_id
	merge 1:1 patient_id using `allCases'
	*want to keep the ones not matched as they were in the original extract file but not in the list of matches
	keep if _merge==2
	count
	*save file for descriptive analysis
	save output/longCovidSymp_UnmatchedCases_analysis_dataset.dta, replace
	di "***********************FLOWCHART 4. NUMBER OF UMATCHED CASES FROM UNMATCHED CASES FILE (TO CONFIRM IT ALIGNS WITH THE ABOVE FLOWCHART POINTS)********************:"
	safecount
restore





*(5)=========VARIABLE CLEANING============

*(a)===Ethnicity (5 category)====
* Ethnicity (5 category)
replace ethnicity = . if ethnicity==.
label define ethnicity 	1 "White"  					///
						2 "Mixed" 					///
						3 "Asian or Asian British"	///
						4 "Black"  					///
						5 "Other"					
						
label values ethnicity ethnicity
safetab ethnicity

 *re-order ethnicity
 gen eth5=1 if ethnicity==1
 replace eth5=2 if ethnicity==3
 replace eth5=3 if ethnicity==4
 replace eth5=4 if ethnicity==2
 replace eth5=5 if ethnicity==5
 replace eth5=. if ethnicity==.

 label define eth5 			1 "White"  					///
							2 "South Asian"				///						
							3 "Black"  					///
							4 "Mixed"					///
							5 "Other"					
					
label values eth5 eth5
safetab eth5, m

* Ethnicity (16 category)
replace ethnicity_16 = . if ethnicity==.
label define ethnicity_16 									///
						1 "British or Mixed British" 		///
						2 "Irish" 							///
						3 "Other White" 					///
						4 "White + Black Caribbean" 		///
						5 "White + Black African"			///
						6 "White + Asian" 					///
 						7 "Other mixed" 					///
						8 "Indian or British Indian" 		///
						9 "Pakistani or British Pakistani" 	///
						10 "Bangladeshi or British Bangladeshi" ///
						11 "Other Asian" 					///
						12 "Caribbean" 						///
						13 "African" 						///
						14 "Other Black" 					///
						15 "Chinese" 						///
						16 "Other" 							
						
label values ethnicity_16 ethnicity_16
safetab ethnicity_16,m

* Ethnicity (16 category grouped further)
* Generate a version of the full breakdown with mixed in one group
gen eth16 = ethnicity_16
recode eth16 4/7 = 99
recode eth16 11 = 16
recode eth16 14 = 16
recode eth16 8 = 4
recode eth16 9 = 5
recode eth16 10 = 6
recode eth16 12 = 7
recode eth16 13 = 8
recode eth16 15 = 9
recode eth16 99 = 10
recode eth16 16 = 11

label define eth16 	///
						1 "British" ///
						2 "Irish" ///
						3 "Other White" ///
						4 "Indian" ///
						5 "Pakistani" ///
						6 "Bangladeshi" ///					
						7 "Caribbean" ///
						8 "African" ///
						9 "Chinese" ///
						10 "All mixed" ///
						11 "All Other" 
label values eth16 eth16
safetab eth16,m



*(b)===STP====
*For ease of future analysis(?) am going to recode these as numerical ordered at this stage
rename stp stp_old
bysort stp_old: gen stp = 1 if _n==1
replace stp = sum(stp)
drop stp_old



*(c)===IMD===
* Group into 5 groups
rename imd imd_o
egen imd = cut(imd_o), group(5) icodes

* add one to create groups 1 - 5 
replace imd = imd + 1

* - 1 is missing, should be excluded from population 
replace imd = .u if imd_o == -1
drop imd_o

* Reverse the order (so high is more deprived)
recode imd 5 = 1 4 = 2 3 = 3 2 = 4 1 = 5 .u = .u

label define imd 1 "1 least deprived" 2 "2" 3 "3" 4 "4" 5 "5 most deprived" .u "Unknown"
label values imd imd



*(d)===Categorical age===
egen ageCat=cut(age), at (0, 5, 18, 40, 50, 60, 70, 80, 200)
recode ageCat 0=0 5=1 18=2 40=3 50=4 60=5 70=6 80=7
label define ageCat 0 "0-4" 1 "5-17" 2 "18-39" 3 "40-49" 4 "50-59" 5 "60-79" 6 "70-79" 7 "80+"
label values ageCat ageCat
safetab ageCat, miss
la var ageCat "Age categorised"



*(e)===Pre-existing clinical comorbidities===
*number of broad diagnostic categories containing records in the one year before COVID-19
egen numPreExistingComorbs=rowtotal(comorb_infection_or_parasite-comorb_injury_poisoning)
*have a look at this
sum numPreExistingComorbs, detail
la var numPreExistingComorbs "Number of comorbidities diagnosed in prev yr"
*for now create a category with 0, 1, 2+
egen preExistComorbCat=cut(numPreExistingComorbs), at (0, 1, 2, 200) 
label define preExistComorbCat 0 "0" 1 "1" 2 "2+"
label values preExistComorbCat preExistComorbCat
safetab preExistComorbCat, miss
la var preExistComorbCat "Number of comorbidities diagnosed in prev yr"



*(f) Recode all dates from the strings 
*order variables to make for loop quicker
order patient_id case_index_date first_test_covid first_pos_test first_pos_testw2 covid_tpp_prob covid_tpp_probw2 covid_tpp_probclindiag covid_tpp_probtest covid_tpp_probseq covid_hosp pos_covid_test_ever infect_parasite neoplasms blood_diseases endocr_nutr_dis mental_disorder nervous_sys_dis ear_mastoid_dis circ_sys_dis resp_system_dis digest_syst_dis skin_disease musculo_dis genitourin_dis pregnancy_compl perinatal_dis congenital_dis injury_poison death_date dereg_date first_known_covid19
*have to rename some variables here as too long
foreach var of varlist case_index_date - first_known_covid19 {
	capture noisily confirm string variable `var'
	capture noisily rename `var' `var'_dstr
	capture noisily gen `var' = date(`var'_dstr, "YMD")
	capture noisily drop `var'_dstr
	capture noisily format `var' %td 

}


*(g) Sex
rename sex sexOrig
gen sex = 1 if sexOrig == "M"
replace sex = 0 if sexOrig == "F"
replace sex =. if sexOrig=="I"
replace sex =. if sexOrig=="U"
label define sex 0"Female" 1"Male"
label values sex sex
safetab sex
safecount
drop sexOrig

*save final file
save ./output/longCovidSymp_analysis_dataset_contemporary.dta, replace



log close



