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


sysdir set PLUS "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 
sysdir set PERSONAL "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 

							
==============================================================================*/
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
pwd


* Open a log file
cap log close
log using ./logs/10_longCovidSymp_data_checks.log, replace t








*(0)=========Load file and check total numbers and cases and controls============
use ./output/longCovidSymp_analysis_dataset_contemporary.dta, clear

*draft initial checks for stuff that looks odd in lof of 09
codebook

/*
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





*(1)=========CHECK TIME RULES FROM PROTOCOL i.e. when index date is in relation to COVID etc============

*cases
*(a)case_index_date should be minimum of first positive test or covid diangosis in primary care
*THIS CODE WILL NEED UPDATED IF/WHEN THE 4 WEEK WINDOW IS ADDED TO THE CASE INDEX DATE
capture noisily assert case_index_date==min(first_pos_testw2, covid_tpp_probw2) if case==1
*(b)check how many cases were hospitalised after the start of follow-up, and when this happened
tab caseHospForCOVIDDurFUP1
tab caseHospForCOVIDDurFUP2
tab caseHospForCOVIDDurFUP3


*comparators
*(a)first_known_covid19 must be after case_index_date
capture noisily assert first_known_covid19>case_index_date if case==0
*(b)check how many became cases after their start of follow-up and at which section of follow-up
tab compBecameCaseDurFUP1
tab compBecameCaseDurFUP2
tab compBecameCaseDurFUP3





/*(2)======================CHECK INCLUSION AND EXCLUSION CRITERIA=====================================*/ 

* INCLUSION 1: >=18 and <=110 at 1 March 2020 
capture noisly assert age < .
*assert age >= 18
capture noisly assert age <= 110
 
* INCLUSION 2: M or F gender at 1 March 2020 
capture noisily assert inlist(male, 0, 1)

* EXCLUDE 1:  MISSING IMD
capture noisily assert inlist(imd, 1, 2, 3, 4, 5, .u)

*EXCLUDE 2: STP IS PRESENT
capture noisily assert stp!=.





/*(3)===============CHECK EXPECTED VALUES============================================================*/ 

* Age
datacheck age<., nol
datacheck inlist(ageCat, 0, 1, 2, 3, 4, 5, 6, 7), nol
safetab ageCat, miss

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

* Smoking
*datacheck inlist(smoke, 1, 2, 3, 4), nol
*datacheck inlist(smoke, 1, 2, 3), nol 

*comorb
foreach var of varlist comorb_infection_or_parasite - comorb_injury_poisoning{ 
	safetab `var', m
}


*all outcomes
foreach var of varlist t1_infect_parasite - t3_injury_poison{ 
	safetab `var', m
}




/*(4) TESTING LOGICAL RELATIONSHIPS======================================================*/ 

*HH variables
*safetab hhRiskCat hh_total_cat
*safetab hhRiskCatExp_5cats hh_total_cat


* BMI
*bysort bmicat: summ bmi
*safetab bmicat obese4cat, m

* Age
*bysort ageCatHHRisk: summ age
*safetab ageCatHHRisk age66, m

* Smoking
safetab smoke, m

* Diabetes
*safetab diabcat diabetes, m

* CKD
*safetab reduced egfr_cat, m
* CKD
*safetab reduced esrd, m

*comorbidities
safetab coMorbCat

/* EXPECTED RELATIONSHIPS=====================================================*/ 

/*  Relationships between demographic/lifestyle variables  */
safetab ageCatHHRisk bmicat, 	row 
safetab ageCatHHRisk smoke, 	row  
safetab ageCatHHRisk ethnicity, row 
safetab ageCatHHRisk imd, 		row 
*safetab ageCatHHRisk shield,    row 

safetab bmicat smoke, 		 row   
safetab bmicat ethnicity, 	 row 
safetab bmicat imd, 	 	 row 
safetab bmicat hypertension, row 
*safetab bmicat shield,    row 

                            
safetab smoke ethnicity, 	row 
safetab smoke imd, 			row 
safetab smoke hypertension, row 
*safetab smoke shield,    row 
                      
safetab ethnicity imd, 		row 
*safetab shield imd, 		row 

*safetab shield ethnicity, 		row 



* Relationships with age
foreach var of varlist 								///
					chronic_respiratory_disease 	///
					asthma_severe	///
					chronic_cardiac_disease  		///
					dm  			///
					cancer_nonhaemPrevYear ///
					cancer_haemPrev5Years				///
					chronic_liver_disease  ///
					stroke_dementia  ///
					egfr60  			/// 
					organ_transplant  			/// 
					asplenia			 	///
					other_immuno			 	///	 	
										{

		
 	safetab ageCatHHRisk `var', row 
 }


*Relationships with sex
foreach var of varlist 						///
					chronic_respiratory_disease 	///
					asthma_severe	///
					chronic_cardiac_disease  		///
					dm  			///
					cancer_nonhaemPrevYear ///
					cancer_haemPrev5Years				///
					chronic_liver_disease  ///
					stroke_dementia  ///
					egfr60  			/// 
					organ_transplant  			/// 
					asplenia			 	///
					other_immuno			 	///	
										{
						
 	safetab male `var', row 
}

*Relationships with smoking							
foreach var of varlist  							///
					chronic_respiratory_disease 	///
					asthma_severe	///
					chronic_cardiac_disease  		///
					dm  			///
					cancer_nonhaemPrevYear ///
					cancer_haemPrev5Years				///
					chronic_liver_disease  ///
					stroke_dementia  ///
					egfr60  			/// 
					organ_transplant  			/// 
					asplenia			 	///
					other_immuno			 	///
					{
	
 	safetab smoke `var', row 
}


/* SENSE CHECK OUTCOMES=======================================================*/
safetab covidDeathCase covidHospCase  , row col
safetab covidDeathCase nonCOVIDDeathCase  , row col
safetab nonCOVIDDeathCase covidHospCase  , row col

safecount if covidHospCase==1 & covidDeathCase==1
safecount if covidDeathCase==1 & nonCOVIDDeathCase==1
safecount if covidHospCase==1 & nonCOVIDDeathCase==1

*/
* Close log file 
log close








