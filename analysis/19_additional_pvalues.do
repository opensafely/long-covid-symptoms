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
*run globals of lists of diagnoses and symptoms, then make loc
do ./analysis/masterLists.do

*setup so that the code in this file can be used to output analyses for both contemporary and historical comparators (and is called twice by separate .yaml actions)
local dataset `1' 

*checking tabulations
capture log close
log using ./logs/19_additional_pvalues`dataset'.log, replace t

use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
rename case expStatus


*******SYMPTOMS********

*do test for trend for any symptoms ever (SENS analysis)
capture quietly clogit anySymptomsEver i.expStatus##i.gpCountPrevYearSENS i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
capture quietly est store A
capture quietly clogit anySymptomsEver i.expStatus i.gpCountPrevYearSENS i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
capture quietly est store B
capture quietly lrtest A B, force
display "LRTtest test for trend p-value for anySymptomsEver (SENS):"
capture quietly display r(p)


*do test for trend for selected other symptoms (SENS analysis)
foreach outcome of varlist symp_fatigue symp_cogimpair symp_mobilityimpair {
	capture quietly clogit tEver_`outcome' i.expStatus##i.gpCountPrevYearSENS i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	est store A
	capture quietly clogit tEver_`outcome' i.expStatus i.gpCountPrevYearSENS i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	est store B
	lrtest A B, force
	display "LRTtest test for trend p-value for `outcome' (SENS):"
	display r(p)
}



*******DIAGNOSES********
*do test for trend for selected diagnoses (SENS analysis)
foreach outcome of varlist infect_parasite neoplasms resp_system_dis musculo_dis congenital_dis injury_poison {
	capture quietly clogit tEver_`outcome' i.expStatus##i.gpCountPrevYearSENS i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	est store A
	capture quietly clogit tEver_`outcome' i.expStatus i.gpCountPrevYearSENS i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	est store B
	lrtest A B, force
	display "LRTtest test for trend p-value for `outcome' (SENS):"
	display r(p)
}



*******BNF********
*do test for trend for selected BNF outcomes (SENS analysis)
foreach outcome of varlist bnf_nsaids_spec bnf_infect_broad bnf_musculo_broad bnf_malign_broad {
	capture quietly clogit tEver_`outcome' i.expStatus##i.gpCountPrevYearSENS i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	est store A
	capture quietly clogit tEver_`outcome' i.expStatus i.gpCountPrevYearSENS i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	est store B
	lrtest A B, force
	display "LRTtest test for trend p-value for `outcome' (SENS):"
	display r(p)
}

cap file close tablecontents 
cap log close



	



