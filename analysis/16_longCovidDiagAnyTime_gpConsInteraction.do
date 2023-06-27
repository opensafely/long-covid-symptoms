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
log using ./logs/16_longCovidDiagAnyTime_gpConsInteraction`dataset'.log, replace t

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
file open tablecontents using ./output/Figure5_gpConsInteraction_`dataset'.txt, t w replace
file write tablecontents "Fig 5: Analysis of diagnoses (at any time) including interaction with prev consultations for `dataset' comparator population (full adjusted)" _n _n
file write tablecontents ("Diagnosis") _tab ("Prev GP consults") _tab ("OR (95% CI)") _n


*loop through each outcome
/*
foreach outcome in $diag {
	cap noisily outputORsforOutcome, outcome(tEver_`outcome')
	file write tablecontents _n
}
*/


*************SENSITIVITY ANALYSIS WHERE PEOPLE WITH NO CONSULTATIONS ARE DROPPED**************
prog define outputORsforOutcomeSENS
	syntax, outcome(string)
	*above will need edited when also have the historical population to compare to
	
	*NEED TO FIX THIS SO THAT LINCOM LOOPS THROUGH EACH EXPOSURE CATEGORY (0 to 1) AND FOR EACH EXPOSURE CATEGORY LOOPS THROUGH EACH GPCONS CATEGORY (0 to 2)

	*Fully adjusted but including an interaction with previous consultations
	capture noisily clogit `outcome' i.expStatus##i.gpCountPrevYearSENS i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs, strata(set_id) or
	capture noisily estimates store fullAdj
	*get and diplay variable name
	local varLab: variable label `outcome'
	display "`varLab'"
	file write tablecontents  ("`varLab'")

	*loop through categories of gp count in previous year (0-2)
	forvalues i=0/2 {
		*get gpCountPrevYearCat category name
		local category: label gpCountPrevYearSENS `i'
		display "Category label: `category'"
		file write tablecontents _tab "`category'"
		*loop through categories of exposure (0-1)
		forvalues n=0/1 {
			capture noisily estimates restore fullAdj
			capture noisily lincom `n'.expStatus + `n'.expStatus#`i'.gpCountPrevYearSENS, or
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



file write tablecontents "****Fig 4 sensitivity: Same as above but with people with no consultations dropped, and lowest consultation group has 1 consultation****" _n _n
use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
rename case expStatus
*drop all people wtih no consultations in previous year
drop if gp_count_prevyear==0

*call programs using alternative prev GP variable where lowest category is 1 in previous year (rather than 0)
*loop through each outcome
/*
foreach outcome in $diag {
	cap noisily outputORsforOutcomeSENS, outcome(tEver_`outcome')
	file write tablecontents _n
}
*/

keep if age>=15 & age<=45
cap noisily outputORsforOutcomeSENS, outcome(pregnancy_compl)
file write tablecontents _n


cap file close tablecontents 
cap log close
	



