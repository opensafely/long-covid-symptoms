*************************************************************************
*Do file: 08_hhClassif_an_mv_analysis_perEth5Group_HR_table.do
*
*Purpose: Create content that is ready to paste into a pre-formatted Word 
* shell table containing minimally and fully-adjusted HRs for risk factors
* of interest, across 2 outcomes 
*
*Requires: final analysis dataset (analysis_dataset.dta)
*k
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
log using ./logs/15_longCovidSympAnyTime_gpConsInteraction`dataset'.log, replace t

prog drop _all

prog define outputORsforOutcome
	syntax, outcome(string)
	*above will need edited when also have the historical population to compare to
	
	*NEED TO FIX THIS SO THAT LINCOM LOOPS THROUGH EACH EXPOSURE CATEGORY (0 to 1) AND FOR EACH EXPOSURE CATEGORY LOOPS THROUGH EACH GPCONS CATEGORY (0 to 2)

	*Fully adjusted but including an interaction with previous consultations
	capture noisily clogit `outcome' i.expStatus##i.gpCountPrevYearCat i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	capture noisily estimates store fullAdj
	*get and diplay variable name
	local varLab: variable label `outcome'
	display "`varLab'"
	file write tablecontents  ("`varLab'")

	*loop through categories of gp count in previous year (0-2)
	forvalues i=0/2 {
		*get gpCountPrevYearCat category name
		local category: label gpCountPrevYearCat `i'
		display "Category label: `category'"
		file write tablecontents _tab "`category'"
		*loop through categories of exposure (0-1)
		forvalues n=0/1 {
			capture noisily estimates restore fullAdj
			capture noisily lincom `n'.expStatus + `n'.expStatus#`i'.gpCountPrevYearCat, or
			capture noisily local hr_fulladj = r(estimate)
			capture noisily local lb_fulladj = r(lb)
			capture noisily local ub_fulladj = r(ub)
			if `n'==0 {
				file write tablecontents  _tab %4.2f (`hr_fulladj')  " (" %4.2f (`lb_fulladj') "-" %4.2f (`ub_fulladj') ")"  _n
			} 
			else {
				file write tablecontents  _tab _tab %4.2f (`hr_fulladj')  " (" %4.2f (`lb_fulladj') "-" %4.2f (`ub_fulladj') ")"  _n
			}
		}	
	}
end

*call program and output tables

use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
rename case expStatus
file open tablecontents using ./output/Figure4_gpConsInteraction_`dataset'.txt, t w replace
file write tablecontents "Fig 4: Analysis of symptoms (at any time) including interaction with age for `dataset' comparator population (full adjusted)" _n _n
file write tablecontents ("Symptom") _tab ("Prev GP consults") _tab ("OR (95% CI)") _n

*JUST FOR any symptom ever
cap noisily outputORsforOutcome, outcome(anySymptomsEver)
file write tablecontents _n

*loop through each outcome
foreach outcome in $symp {
	cap noisily outputORsforOutcome, outcome(tEver_`outcome')
	file write tablecontents _n
}


*JUST FOR DELIRIUM
keep if age>=67
cap noisily outputORsforOutcome, outcome(tEver_symp_delirium)
file write tablecontents _n


cap file close tablecontents 
cap log close



	



