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
*globals of lists of diagnoses and symptoms etc
do ./analysis/masterLists.do

*setup so that the code in this file can be used to output analyses for both contemporary and historical comparators (and is called twice by separate .yaml actions)
local dataset `1' 

*checking tabulations
capture log close
log using ./logs/12b_longCovidDiagAnyTime_figure1PanelB`dataset'.log, replace t


	
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
	capture noisily clogit `outcome' i.expStatus, strata(set_id) or
	*this lincom ensures OR and CI can be stored in the r values, doesn't work straight from clogit
	capture noisily lincom 1.expStatus, or
	local hr_crude = r(estimate)
	local lb_crude = r(lb)
	local ub_crude = r(ub)
	*depr, ethnicity and rural/urban adjusted
	display "`outcome' additionally adjusted for deprivation, ethnicity and rural/urban"
	capture noisily clogit `outcome' i.expStatus i.imd i.ethnicity i.rural_urban, strata(set_id) or
	capture noisily lincom 1.expStatus, or
	local hr_deprEth_adj = r(estimate)
	local lb_deprEth_adj = r(lb)
	local ub_deprEth_adj = r(ub)
	*Adding comorbs
	display "`outcome' additionally adjusted for comorbidities"
	capture noisily clogit `outcome' i.expStatus i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	capture noisily lincom 1.expStatus, or
	local hr_full_adj = r(estimate)
	local lb_full_adj = r(lb)
	local ub_full_adj = r(ub)
	*Adding consultation rate
	display "`outcome' additionally adjusted for number of consultations in previous year"
	capture noisily clogit `outcome' i.expStatus i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs i.gpCountPrevYearCat, strata(set_id) or
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
	file write tablecontents  ("`varLab'") _tab ("vs 'dataset' population") _tab ("Crude") _tab %4.2f (`hr_crude')  " (" %4.2f (`lb_crude') "-" %4.2f (`ub_crude') ")" _tab (`events') _tab %3.1f (`percWEvent') ("%")  _n
	*depr and ethnicity adjusted
	file write tablecontents  _tab _tab ("Adjusted for deprivation, ethnicity &rural/urban") _tab %4.2f (`hr_deprEth_adj')  " (" %4.2f (`lb_deprEth_adj') "-" %4.2f (`ub_deprEth_adj') ")"  _n
	*fully adjusted
	file write tablecontents  _tab _tab ("Additionally adjusted for comorbidities") _tab %4.2f (`hr_full_adj')  " (" %4.2f (`lb_full_adj') "-" %4.2f (`ub_full_adj') ")"  _n
	*with gp conslutations
	file write tablecontents  _tab _tab ("Additionally adjusted for gp consultations in previous year") _tab %4.2f (`hr_fullwgpCountCat_adj')  " (" %4.2f (`lb_fullwgpCountCat_adj') "-" %4.2f (`ub_fullwgpCountCat_adj ') ")"  _n

end

*call program and output tables

use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
rename case expStatus
file open tablecontents using ./output/figure1PanelB_longCovidDiagAnyTime_`dataset'.txt, t w replace
file write tablecontents "Fig 1: Panel B. Community COVID-19: Odds ratios comparing odds of post-COVID diagnoses at any time during follow up in community COVID-19 compared to `dataset' comparator population." _n _n
file write tablecontents ("Diagnoses") _tab ("Comparator") _tab _tab ("OR (95% CI)") _tab ("Number of events") _tab ("Proportion of population with events") _n

*loop through each outcome

/*
foreach outcome in $diag {
	cap noisily outputORsforOutcome, outcome(tEver_`outcome')
	file write tablecontents _n
}
*/

*eye disease (left out originally)
/*
cap noisily outputORsforOutcome, outcome(tEver_eye_adnexa_dis)
file write tablecontents _n
*/

*pregnancy complications with age range that is just for women of childbearing age
keep if age>=15 & age<=45
cap noisily outputORsforOutcome, outcome(tEver_pregnancy_compl)
file write tablecontents _n

cap file close tablecontents 
cap log close



	



