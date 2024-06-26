/*==============================================================================
DO FILE NAME:			09a_longCovidSymp_cr_imputed_datasets
PROJECT:				Symptoms, Diagnoses, Prescriptions after long covid
AUTHOR:					K Wing (adapted from hhclassifcation study)
DATE: 					9th May 2024					
DESCRIPTION OF FILE:	creates an analysis file with imputed ethnicity in it
DATASETS USED:			data in memory ($tempdir/analysis_dataset_STSET_outcome)
DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir
						table2_eth5_mi, printed to analysis/$outdir
						
https://stats.idre.ucla.edu/stata/seminars/mi_in_stata_pt1_new/						
							
==============================================================================*/
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
do ./analysis/masterLists.do


*log file
cap log close
log using "./logs/09a_hhClassif_imputed_datasets_contemporary", text replace

*test code for longCovid symptoms, loking just at anySymptomEver as the outcome, trying one imputation first (eventually will be 10)
*going to include anySymptomsEver and all component outcome symptoms but if problems with this will remove anySymptoms ever initially and if still problems will remove all of the component symptoms and only include anySymptomsEver (this article by Sterne et al includes why outcome is needed in MI: https://www.bmj.com/content/338/bmj.b2393)
*decided to change this to do MI for a selection of outcomes, creating separate datasets for analysis: At least one symptom, cognitive impairment, mobility impairment, hairloss, visual disturbance. Therefore impute separate datasets for each of these.
*update: will run the imputation on AnySymptomsEver demographic variables, then perform the analysis for all symptoms. Will then try using ONE of the above symptoms instead of AnySymptomsEver when prepping the MI, and see if this gives a differnt MI result when analysing that symptom only.
*Update: running on all together doesn't work, going to run a loop to output MI files for cognitive impairment, mobility impairment, hairloss, visual disturbance

*this is if I want to run a loop here
*foreach outcome in $imputedSymptoms {

* Open Stata dataset
use ./output/longCovidSymp_analysis_dataset_contemporary.dta, clear
rename case expStatus
*keep just the variables I need
*if outcome is anysymptom ever, keep all symptoms as may use this imputed file when analysing each of the symptoms, else just keep the outcome and demographic variables
*if `outcome'==anySymptomsEver {
	keep anySymptomsEver tEver_symp_breathless tEver_symp_cough tEver_symp_chesttight tEver_symp_chestpain tEver_symp_palp tEver_symp_fatigue tEver_symp_fever tEver_symp_cogimpair tEver_symp_headache tEver_symp_sleepdisturb tEver_symp_periphneuro tEver_symp_dizzy tEver_symp_mobilityimpair tEver_symp_visualdisturbance tEver_symp_abdominalpain tEver_symp_nauseavomiting tEver_symp_diarrhoea tEver_symp_weightloss tEver_symp_pain tEver_symp_depression tEver_symp_anxiety tEver_symp_ptsd tEver_symp_tinnitus tEver_symp_earache tEver_symp_sorethroat tEver_symp_taste_smell tEver_symp_nasal_congestion tEver_symp_rashes tEver_symp_hairloss patient_id ethnicity expStatus imd rural_urban numPreExistingComorbs ageCat gpCountPrevYearCat sex numPrescTypesPrevYearCat set_id
*} 
*else {
*	keep `outcome' patient_id ethnicity expStatus imd rural_urban numPreExistingComorbs ageCat gpCountPrevYearCat sex numPrescTypesPrevYearCat
*}

*mi set the data
mi set mlong

*mi register 
tab ethnicity
tab ethnicity, miss
mi register imputed ethnicity

display "`outcome'"

*test
*noisily mi impute mlogit eth5 i.anySymptomsEver, add(1) rseed(86542) augment force

*one loop with demographic data too
*noisily mi impute mlogit ethnicity i.anySymptomsEver i.expStatus i.imd i.rural_urban i.numPreExistingComorbs i.ageCat i.gpCountPrevYearCat i.sex i.numPrescTypesPrevYearCat, add(10) rseed(86542) augment force 

*impute ethnicity including the specific outcome
capture noisily mi impute mlogit ethnicity i.anySymptomsEver i.expStatus i.imd i.rural_urban i.numPreExistingComorbs i.ageCat i.gpCountPrevYearCat i.sex i.numPrescTypesPrevYearCat, add(10) rseed(86542) augment force 

*save imputed raw data
save ./output/longCovidSymp_analysis_dataset_contemporary_eth5_mianySymptomsEver.dta, replace	
*}

			

log close





*===============legacy code (from hhclassif file) that I don't need=============
/*

local dataset `1' 

*log file
cap log close
log using "./logs/01b_hhClassif_imputed_datasets_`dataset'", text replace
* Open Stata dataset
use ./output/hhClassif_analysis_dataset_with_missing_ethnicity_ageband_3`dataset'.dta, clear
encode utla_group, generate(utla_group2)


*mi set the data
mi set mlong

*mi register 
tab eth5
replace eth5=. if eth5==6 //set unknown to missing - need to check if this will work as I dropped all records with missing ethnicity!
tab eth5, miss
mi register imputed eth5

*test code - works!
*noisily mi impute mlogit eth5, add(10) rseed(70548) augment force by(male coMorbCat) nolog 

*capture noisily stcox i.hhRiskCat67PLUS_5cats##i.eth5 i.imd##i.eth5 i.ageCatfor67Plus##i.eth5 i.obese4cat##i.eth5 i.rural_urbanFive i.smoke i.male i.coMorbCat, strata(utla_group) vce(cluster hh_id)	

*mi impute the dataset - need to edit this list based upon variables, testing 3 iterations for now, want to increase this to 5 once I know it works on the server
noisily mi impute mlogit eth5 i.covidHospOrDeathCase i.rural_urbanFive i.smoke i.male i.coMorbCat, add(10) rseed(70548) augment force by(hhRiskCat67PLUS_5cats imd obese2cat ageCatfor67PlusTWOCATS)
		
*save imputed raw data
save ./output/hhClassif_analysis_dataset_eth5_mi_ageband_3_`dataset'.dta, replace		
		
*mi stset - need to check this code is the same as my source file
*for reference from source file: stset stime_covidHospOrDeathCase, fail(covidHospOrDeathCase) id(patient_id) enter(enter_date) origin(enter_date)
mi stset stime_covidHospOrDeathCase, fail(covidHospOrDeathCase) id(patient_id) enter(enter_date) origin(enter_date)
save ./output/hhClassif_analysis_dataset_eth5_mi_ageband_3_STSET_covidHospOrDeathCase_`dataset'.dta, replace
tab _mi_m	


*i.imd##i.eth5 i.smoke##i.eth5 i.obese4cat##i.eth5 i.rural_urbanFive##i.eth5 i.ageCatfor67Plus##i.eth5 i.male##i.eth5 i.coMorbCat##i.eth


/*
*create a two category obesity category to see if imputation works with this
tab obese4cat
tab obese4cat, nolabel
generate obese2cat=obese4cat
recode obese2cat 3=2 4=2
tab obese4cat obese2cat
la var obese2cat "obesity in 2 categories"
label define obese2cat 	1 "Non-obese" 2 "Obese"
label values obese2cat obese2cat
tab obese2cat,m

*create a binary age group as convergence failed when age was in four groups
tab ageCatfor67Plus
tab ageCatfor67Plus, nolabel
generate ageCatfor67PlusTWOCATS=ageCatfor67Plus
recode ageCatfor67PlusTWOCATS 0=1 3=2 4=2
label define ageCatfor67PlusTWOCATS 1 "67-74" 2 "75+"
label values ageCatfor67PlusTWOCATS ageCatfor67PlusTWOCATS
tab ageCatfor67PlusTWOCATS ageCatfor67Plus


*SOURCE CODE FROM ROHINI:

/*
* Open a log file
cap log close
macro drop hr
estimates clear
log using $logdir\08b_eth_cr_imputed_mi_eth5, replace text


foreach i of global outcomes {
* Open Stata dataset
use "$Tempdir/analysis_dataset_STSET_`i'.dta", clear

*mi set the data
mi set mlong

*mi register 
replace eth5=. if eth5==6 //set unknown to missing
mi register imputed eth5

*mi impute the dataset - remove variables with missing values - bmi	hba1c_pct bp_map 
noisily mi impute mlogit eth5 `i' i.stp i.male age1 age2 age3 	i.imd						///
										i.bmicat_sa	i.hba1ccat			///
										gp_consult_count			///
										i.smoke_nomiss				///
										i.hypertension i.bp_cat	 	///	
										i.asthma					///
										i.chronic_respiratory_disease ///
										i.chronic_cardiac_disease	///
										i.dm_type 					///	
										i.cancer                    ///
										i.chronic_liver_disease		///
										i.stroke					///
										i.dementia					///
										i.other_neuro				///
										i.egfr60					///
										i.esrf						///
										i.immunosuppressed	 		///
										i.ra_sle_psoriasis			///
										i.hh_total_cat, ///
										add(10) rseed(70548) augment force // can maybe remove the force option in the server
										

*mi stset
mi	stset stime_`i', fail(`i') 	id(patient_id) enter(indexdate) origin(indexdate)
save "$Tempdir/analysis_dataset_STSET_`i'_eth5_mi.dta", replace
}
 

log close
*/

