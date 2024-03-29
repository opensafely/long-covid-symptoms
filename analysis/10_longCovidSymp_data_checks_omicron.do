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
g


sysdir set PLUS "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 
sysdir set PERSONAL "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 

							
==============================================================================*/
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
*globals of lists of diagnoses and symptoms etc
do ./analysis/masterLists.do
pwd


* Open a log file
cap log close
log using ./logs/10_longCovidSymp_data_checks_contemporary_omicron.log, replace t


*setup so that the code in this file can be used to output analyses for both contemporary and historical comparators (and is called twice by separate .yaml actions)
*local dataset `1'





*(0)=========Load file and check total numbers and cases and controls============
use ./output/longCovidSymp_analysis_dataset_contemporary_omicron.dta, clear

*eyeball all variables
codebook


*total number in cohort
safecount
*total cases and controls
safetab case, miss
*number of matches per case
safetab match_counts case, miss

*Duplicate patient check
*cases shouldn't be duplicated
duplicates report patient_id if case==1
*comparators might be duplicated, check here
duplicates report patient_id if case==0
*then check how many cases are also in the comparator group
preserve 
	keep patient_id case
	keep if case==0
	tempfile comparators
	save `comparators'
restore
preserve
	keep patient_id case
	keep if case==1
	*_merge==3 are those who are both cases and comparators
	merge 1:m patient_id using `comparators'
restore




*(1)=========CHECK TIME RULES THAT I CHECKED IN 05============
capture noisily assert covid_hosp>=case_index_date
capture noisily assert death_date>=case_index_date
capture noisily assert dereg_date>=case_index_date
capture noisily assert first_known_covid19>=case_index_date




*(2)=========CHECK TIME RULES FROM PROTOCOL i.e. when index date is in relation to COVID etc============
*cases
*(a)case_index_date should be minimum of first positive test or covid diangosis in primary care + 28 days
capture noisily assert case_index_date==min(first_pos_testw4, covid_tpp_probw4) + 28 if case==1
*list these variables for the individuals where this didn't hold
list case_index_date first_pos_testw4 covid_tpp_probw4 if case_index_date!=min(first_pos_testw4, covid_tpp_probw4) + 28 & case==1


*(b)check how many cases were hospitalised after the start of follow-up, and when this happened
tab caseHospForCOVIDDurFUP1
tab caseHospForCOVIDDurFUP2
tab caseHospForCOVIDDurFUP3


*comparators
*(a)first_known_covid19 must not be before case_index_date
capture noisily assert first_known_covid19>=case_index_date if case==0
*(b)check how many became cases after their start of follow-up and at which section of follow-up
tab compBecameCaseDurFUP1
tab compBecameCaseDurFUP2
tab compBecameCaseDurFUP3





/*(2)======================CHECK INCLUSION AND EXCLUSION CRITERIA=====================================*/ 

* INCLUSION 1: age <=110 at 1 March 2020 
capture noisly assert age < .
capture noisly assert age <= 110
 
* INCLUSION 2: M or F gender at 1 March 2020 
capture noisily assert inlist(sex, 0, 1)

* EXCLUDE 1:  MISSING IMD
capture noisily assert inlist(imd, 1, 2, 3, 4, 5, .u)

*EXCLUDE 2: STP IS PRESENT
capture noisily assert stp!=.





/*(2a)======================CHECK GP_COUNT=====================================*/ 
*prev gp consultations
sum gp_count_prevyear, detail
safetab gpCountPrevYearCat
*time period 1 gp consultations
sum t1_gp_count
safetab t1_gp_countCat
*time period 2 gp consultations
sum t2_gp_count
safetab t2_gp_countCat
*time period 3 gp consultations
sum t3_gp_count
safetab t3_gp_countCat





/*(3)===============CHECK EXPECTED VALUES============================================================*/ 

* Age (2 versions)
datacheck age<., nol
*1*
datacheck inlist(ageCat, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9), nol
safetab ageCat, miss
*2*
datacheck inlist(ageCatChildCombined, 0, 1, 2, 3, 4, 5, 6), nol
safetab ageCatChildCombined, miss

* Sex
datacheck inlist(sex, 0, 1), nol
safetab sex, miss

* IMD
datacheck inlist(imd, 1, 2, 3, 4, 5, .u), nol

* Ethnicity
*eth5
datacheck inlist(eth5, 1, 2, 3, 4, 5, .), nol
*eth16
datacheck inlist(eth5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, .), nol

*comorb
foreach var of varlist $comorbs{ 
	safetab `var', m
}

*prev medicines
sum numPrescTypesPrevYear, detail
safetab numPrescTypesPrevYearCat


*all outcomes 
foreach var of varlist $diag $symp $medicines { 
	safetab t1_`var' case, m
	safetab t2_`var' case, m
	safetab t3_`var' case, m
	safetab tEver_`var' case, m
}

*any symptoms ever
safetab anySymptomsEver




/*(4) TESTING LOGICAL RELATIONSHIPS======================================================*/ 

* Age
bysort ageCat: summ age
bysort ageCatChildCombined: summ age

*comorbidities
sum numPreExistingComorbs, detail
safetab preExistComorbCat

*prev medications
sum numPrescTypesPrevYear, detail
safetab numPrescTypesPrevYearCat

*prev consultations
sum gp_count_prevyear, detail
safetab gpCountPrevYearCat




/* EXPECTED RELATIONSHIPS=====================================================*/ 

/*  Relationships between demographic/lifestyle variables  */
*Age and ethnicity
safetab ageCat ethnicity, row 
*Age and IMD
safetab ageCat imd, row 
*Age and distinct bnf category prescriptions
safetab ageCat numPrescTypesPrevYearCat, row
*Age and consultations
safetab ageCat gpCountPrevYearCat
*Age and pre-existing comorbidities
safetab ageCat preExistComorbCat, row
*Sex and pre-existing comorbidities
safetab sex preExistComorbCat, row
*Ethnicity and pre-existing comorbidities
safetab ethnicity preExistComorbCat, row

/*                          
* Relationships of outcomes with age
foreach var of varlist t1_infect_parasite - t3_injury_poison {
 	safetab ageCat `var', row 
}


*Relationship of outcomes with sex
foreach var of varlist t1_infect_parasite - t3_injury_poison {	
 	safetab sex `var', row 
}


*Relationship of outcomes with ethnicity
foreach var of varlist t1_infect_parasite - t3_injury_poison {	
 	safetab ethnicity `var', row 
}



*Relationship of outcomes with imd
foreach var of varlist t1_infect_parasite - t3_injury_poison {	
 	safetab imd `var', row 
}
*/


* Close log file 
log close











