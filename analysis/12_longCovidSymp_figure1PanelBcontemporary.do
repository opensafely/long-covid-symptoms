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
log using ./logs/12_longCovidSymp_figure1PanelBcontemporary.log, replace t

*list of all outcomes
global diagnosisOutcomes tEver_infect_parasite tEver_neoplasms tEver_blood_diseases tEver_endocr_nutr_dis tEver_mental_disorder tEver_nervous_sys_dis tEver_ear_mastoid_dis tEver_circ_sys_dis tEver_resp_system_dis tEver_digest_syst_dis tEver_skin_disease tEver_musculo_dis tEver_genitourin_dis tEver_pregnancy_compl tEver_perinatal_dis tEver_congenital_dis tEver_injury_poison

	
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
	display "`outcome' additionally adjusted for deprivation and ethnicity"
	capture noisily clogit `outcome' i.expStatus i.imd i.ethnicity i._rural_urban, strata(set_id) or
	capture noisily lincom 1.expStatus, or
	local hr_deprEth_adj = r(estimate)
	local lb_deprEth_adj = r(lb)
	local ub_deprEth_adj = r(ub)
	*fully adjusted (adding comorbs)
	display "`outcome' additionally adjusted for rural/urban status"
	capture noisily clogit `outcome' i.expStatus i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	capture noisily lincom 1.expStatus, or
	local hr_full_adj = r(estimate)
	local lb_full_adj = r(lb)
	local ub_full_adj = r(ub)
					
	*get variable name
	local varLab: variable label `outcome'
	display "`varLab'"
	*get category name
	*local category: label `catLabel' `i'
	*display "Category label: `category'"
	
	*write each row
	*crude 
	file write tablecontents  ("`varLab'") _tab ("vs 2020 general population") _tab ("Crude") _tab %4.2f (`hr_crude')  " (" %4.2f (`lb_crude') "-" %4.2f (`ub_crude') ")" _tab (`events') _tab %3.1f (`percWEvent') ("%")  _n
	*depr and ethnicity adjusted
	file write tablecontents  _tab _tab ("Adjusted for deprivation & ethnicity") _tab %4.2f (`hr_deprEth_adj')  " (" %4.2f (`lb_deprEth_adj') "-" %4.2f (`ub_deprEth_adj ') ")"  _n
	*fully adjusted
	file write tablecontents  _tab _tab ("Additionally adjusted for rural/urban") _tab %4.2f (`hr_full_adj')  " (" %4.2f (`lb_full_adj') "-" %4.2f (`ub_full_adj ') ")"  _n

end

*call program and output tables

use ./output/longCovidSymp_analysis_dataset_contemporary.dta, clear
rename case expStatus
file open tablecontents using ./output/figure1PanelB_longCovidSymp_contemporary.txt, t w replace
file write tablecontents "Fig 1: Panel B. Community COVID-19: Odds ratios comparing odds of post-COVID diagnoses at any time during follow up in community COVID-19 compared to comparator populations." _n _n
file write tablecontents ("Diagnoses") _tab ("Comparator") _tab _tab ("OR (95% CI)") _tab ("Number of events") _tab ("Proportion of population with events") _n

*loop through each outcome
*foreach outcome in $diagnosisOutcomes {
foreach outcome in $diagnosisOutcomes {
	cap noisily outputORsforOutcome, outcome(`outcome')
	file write tablecontents _n
}

cap file close tablecontents 
cap log close



	



