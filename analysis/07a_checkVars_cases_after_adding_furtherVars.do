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
log using ./logs/07a_checkVars_cases_after_adding_furtherVars.log, replace t


*(1)=========Import case file, codebook and then look at dates============
*using stp 29 as this is one of the smaller stps but not too small (has 6,317 cases)
*cases
capture noisily import delimited ./output/input_complete_covid_communitycases.csv, clear



*convert string dates to dates
order first_test_covid first_pos_test first_pos_testw2 covid_tpp_prob covid_tpp_probw2 covid_tpp_probclindiag covid_tpp_probtest covid_tpp_probseq covid_hosp covid_hosp_primdiag pos_covid_test_ever first_known_covid19 death_date dereg_date case_index_date blood_diseases circ_sys_dis congenital_dis digest_syst_dis ear_mastoid_dis endocr_nutr_dis genitourin_dis infect_parasite injury_poison mental_disorder musculo_dis neoplasms nervous_sys_dis perinatal_dis pregnancy_compl resp_system_dis skin_disease t1_blood_diseases t1_circ_sys_dis t1_congenital_dis t1_digest_syst_dis t1_ear_mastoid_dis t1_endocr_nutr_dis t1_genitourin_dis t1_infect_parasite t1_injury_poison t1_mental_disorder t1_musculo_dis t1_neoplasms t1_nervous_sys_dis t1_perinatal_dis t1_pregnancy_compl t1_resp_system_dis t1_skin_disease t2_blood_diseases t2_circ_sys_dis t2_congenital_dis t2_digest_syst_dis t2_ear_mastoid_dis t2_endocr_nutr_dis t2_genitourin_dis t2_infect_parasite t2_injury_poison t2_mental_disorder t2_musculo_dis t2_neoplasms t2_nervous_sys_dis t2_perinatal_dis t2_pregnancy_compl t2_resp_system_dis t2_skin_disease t3_blood_diseases t3_circ_sys_dis t3_congenital_dis t3_digest_syst_dis t3_ear_mastoid_dis t3_endocr_nutr_dis t3_genitourin_dis t3_infect_parasite t3_injury_poison t3_mental_disorder t3_musculo_dis t3_neoplasms t3_nervous_sys_dis t3_perinatal_dis t3_pregnancy_compl t3_resp_system_dis t3_skin_disease
foreach var of varlist first_test_covid - t3_skin_disease {
	capture noisily confirm string variable `var'
	capture noisily rename `var' `var'_dstr
	capture noisily gen `var' = date(`var'_dstr, "YMD")
	capture noisily drop `var'_dstr
	capture noisily format `var' %td 
}


*REPEATING CHECKS DONE POST MATCHING IN ONE FILE JUST TO CHECK ADDING VARS HASN'T MESSED ANYTHING UP
*check that there were no hospitalisations, deregistrations or deaths prior to the case index dates
capture noisily assert covid_hosp>=case_index_date
capture noisily assert death_date>=case_index_date
capture noisily assert dereg_date>=case_index_date

*now checking all variables for cases
codebook



log close






