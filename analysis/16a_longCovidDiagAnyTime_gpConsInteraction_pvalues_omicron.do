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
*local dataset `1' 

*checking tabulations
capture log close
log using ./logs/16a_longCovidDiagAnyTime_gpConsInt_pvalscontemporary_omicron.log, replace t

use ./output/longCovidSymp_analysis_dataset_contemporary_omicron.dta, clear
rename case expStatus



foreach outcome in $diag {
	capture quietly clogit tEver_`outcome' i.expStatus##i.gpCountPrevYearCat i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	est store A
	capture quietly clogit tEver_`outcome' i.expStatus i.gpCountPrevYearCat i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	est store B
	lrtest A B, force
	display "LRtest p-value for tEver_`outcome':"
	display r(p)
}

*do infect parasite diagnosis - test for trend by increasing for infectious diseases
capture quietly clogit infect_parasite i.expStatus##i.gpCountPrevYearCat i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
est store A
capture quietly clogit infect_parasite i.expStatus##c.gpCountPrevYearCat i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
est store B
lrtest A B, force
display "LRtest p-value for infectious diseases outcome (test for trend):"
display r(p)




*repeat for sensitivity analysis
foreach outcome in $diag {
	capture quietly clogit tEver_`outcome' i.expStatus##i.gpCountPrevYearSENS i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	est store A
	capture quietly clogit tEver_`outcome' i.expStatus i.gpCountPrevYearSENS i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	est store B
	lrtest A B, force
	display "LRtest p-value for tEver_`outcome' (sensitivity analysis):"
	display r(p)
}

*just for pregnancy
keep if age>=15 & age<=45
capture quietly clogit tEver_pregnancy_compl i.expStatus##i.gpCountPrevYearSENS i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
est store A
capture quietly clogit tEver_pregnancy_compl i.expStatus i.gpCountPrevYearSENS i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
est store B
lrtest A B, force
display "LRtest p-value for tEver_pregnancy_compl (sensitivity analysis):"
display r(p)



cap file close tablecontents 
cap log close



	



