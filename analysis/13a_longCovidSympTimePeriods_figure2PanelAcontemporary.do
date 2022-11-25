*************************************************************************
*Do file: 08_hhClassif_an_mv_analysis_perEth5Group_HR_table.do
*
*Purpose: Create content that is ready to paste into a pre-formatted Word 
* shell table containing minimally and fully-adjusted HRs for risk factors
* of interest, across 2 outcomes 
*
*Requires: final analysis dataset (analysis_dataset.dta)

*
*Coding: K Wing, base on file from HFORBES, based on file from Krishnan Bhaskaran
*
*Date drafted: 17th June 2021
*************************************************************************
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles

*checking tabulations
capture log close
log using ./logs/13a_longCovidSympTimePeriods_figure2PanelAcontemporary.log, replace t

*list of symptoms (first release here)
global symptomOutcomes symp_cough symp_chesttight symp_palp symp_fatigue symp_fever symp_cogimpair symp_sleepdisturb symp_periphneuro t3_symp_periphneuro  t1_symp_dizzy t2_symp_dizzy t3_symp_dizzy t1_symp_mobilityimpair t2_symp_mobilityimpair t3_symp_mobilityimpair

global symptomOutcomesT2         

global symptomOutcomesT3          

	
prog drop _all

*2300 Thursday - I need to use lincom after the estimates in order to make my estimates retrievable

prog define outputORsforOutcome
	syntax, outcome(string)
	*above will need edited when also have the historical population to compare to

	*get denominator			
	count
	local denom=r(N)
	*get number of people with specific outcome (events column)
	cou if `outcome' == 1
	local events=round(r(N),5)
	*calculate proportion of people with events
	local percWEvent=100*(`events'/`denom')
	*get ORs for each regression analysis
	*crude 
	display "`outcome' adjusted only for matched"
	*tabulate values for checking output table against log files
	safetab expStatus `outcome', row
	*conditional logistic regressions
	*capture noisily clogit `outcome' i.expStatus, strata(set_id) or
	*this lincom ensures OR and CI can be stored in the r values, doesn't work straight from clogit
	*capture noisily lincom 1.expStatus, or
	*local hr_crude = r(estimate)
	*local lb_crude = r(lb)
	*local ub_crude = r(ub)
	*depr, ethnicity and rural/urban adjusted
	*display "`outcome' additionally adjusted for deprivation, ethnicity and rural/urban"
	*capture noisily clogit `outcome' i.expStatus i.imd i.ethnicity i._rural_urban, strata(set_id) or
	*capture noisily lincom 1.expStatus, or
	*local hr_deprEth_adj = r(estimate)
	*local lb_deprEth_adj = r(lb)
	*local ub_deprEth_adj = r(ub)
	*Adding comorbs
	*display "`outcome' additionally adjusted for comorbidities"
	*capture noisily clogit `outcome' i.expStatus i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	*capture noisily lincom 1.expStatus, or
	*local hr_full_adj = r(estimate)
	*local lb_full_adj = r(lb)
	*local ub_full_adj = r(ub)
	*Adding consultation rate
	display "Matched on age, STP and sex and adjusted for deprivation, ethnicity, rural/urban, comorbidities and number of consultations in previous year"
	capture noisily clogit `outcome' i.expStatus i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs i.gpCountCat, strata(set_id) or
	capture noisily lincom 1.expStatus, or
	local hr_fullwgpCountCat_adj = r(estimate)
	local lb_fullwgpCountCat_adj = r(lb)
	local ub_fullwgpCountCat_adj = r(ub)
					
	*get variable name
	local varLab: variable label `outcome'
	display "`varLab'"
	*get category name
	*local category: label `catLabel' `i'
	*display "Category label: `category'"
	
	*write each row
	*crude 
	file write tablecontents  ("`varLab'") _tab ("vs 2020 general population") _tab ("Fully adjusted") _tab %4.2f (`hr_fullwgpCountCat_adj')  " (" %4.2f (`lb_fullwgpCountCat_adj') "-" %4.2f (`ub_fullwgpCountCat_adj ') ")"  _n

end

*call program and output tables

use ./output/longCovidSymp_analysis_dataset_contemporary.dta, clear
rename case expStatus
file open tablecontents using ./output/figure2PanelA_longCovidSympTimePeriods_contemporary.txt, t w replace
file write tablecontents "Fig 2: Panel A. Community COVID-19: Odds ratios comparing odds of post-COVID SYMPTOMS OVER THREE TIME PERIODS during follow up in community COVID-19 compared to comparator populations." _n _n
file write tablecontents ("Diagnoses") _tab ("Comparator") _tab _tab ("OR (95% CI)") _tab ("Number of events") _tab ("Proportion of population with events") _n

*loop through each outcome
*foreach outcome in $diagnosisOutcomes {
file write tablecontents ("TIME PERIOD ONE: 4-12 WEEKS")	
foreach outcome in $symptomOutcomes {
	cap noisily outputORsforOutcome, outcome(`outcome')
	file write tablecontents _n
}

cap file close tablecontents 
cap log close



	



