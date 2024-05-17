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

/*
*test code
use ./output/longCovidSymp_analysis_dataset_contemporary_eth5_mianySymptomsEver.dta, clear

*check there are 10 imputations!
tab _mi_m

*test code - works!
mi estimate, noisily eform: clogit tEver_symp_weightloss i.expStatus i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs i.gpCountPrevYearCat, strata(set_id) or
*/

sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
*run globals of lists of diagnoses and symptoms, then make loc
do ./analysis/masterLists.do


*setup so that the code in this file can be used to output analyses for both contemporary and historical comparators (and is called twice by separate .yaml actions)
*local dataset `1' 

*checking tabulations
capture log close
log using ./logs/12a_longCovidSympAnyTime_figure1PanelAcontemporary_MI.log, replace t

	
prog drop _all


prog define outputORsforOutcome
	syntax, outcome(string)
	*Full adjusted with ethnicity MI
	display "`outcome' fully adjusted with multiple imputation to take account of ethnicity"
	mi estimate, saving ("./output/MI_RESULTS", replace) dots eform: clogit `outcome' i.expStatus i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs i.gpCountPrevYearCat, strata(set_id) or
	estimates use "./output/MI_RESULTS"
	capture noisily lincom 1.expStatus, or
	local hr_fullwgpCountCat_adj = r(estimate)
	local lb_fullwgpCountCat_adj = r(lb)
	local ub_fullwgpCountCat_adj = r(ub)
	*erase "./output/MI_RESULTS"
					
	*get variable name'
	local varLab: variable label `outcome'
	display "`varLab'"
	*get category name
	*local category: label `catLabel' `i'
	*display "Category label: `category'"
	
	*write each row
	*fully adjusted with missing ethnicity multiple imputed
	file write tablecontents ("`varLab'") _tab %4.2f (`hr_fullwgpCountCat_adj')  " (" %4.2f (`lb_fullwgpCountCat_adj') "-" %4.2f (`ub_fullwgpCountCat_adj ') ")"  _n

end

*call program and output tables
use ./output/longCovidSymp_analysis_dataset_contemporary_eth5_mianySymptomsEver.dta, clear
file open tablecontents using ./output/figure1PanelA_longCovidSympAnyTime_contemporaryMI.csv, t w replace
file write tablecontents "Fig 1A (symptoms anytime) with MI for missing ethnicity" _n _n
file write tablecontents ("Symptom") _tab ("OR (95% CI)") _tab _n




*JUST FOR any symptom ever
cap noisily outputORsforOutcome, outcome(anySymptomsEver)
file write tablecontents _n


*anySymptomEver is only one value in dummy data so need to test with a different symptoms
*cap noisily outputORsforOutcome, outcome(tEver_symp_weightloss)
*file write tablecontents _n

/*
*loop through each outcome
foreach outcome in $symp {
	cap noisily outputORsforOutcome, outcome(tEver_`outcome')
	file write tablecontents _n
}
*/

*JUST FOR DELIRIUM
/*
keep if age>=67
cap noisily outputORsforOutcome, outcome(tEver_symp_delirium)
file write tablecontents _n
*/

cap file close tablecontents 
cap log close



	



