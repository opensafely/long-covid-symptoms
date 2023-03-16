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
log using ./logs/13a_longCovidSympTimePeriods_figure2PanelA`dataset'.log, replace t

        

	
prog drop _all

*2300 Thursday - I need to use lincom after the estimates in order to make my estimates retrievable

prog define outputORsforOutcome
	syntax, outcome(string)
	*above will need edited when also have the historical population to compare to

	*get denominator			
	count
	local denom=r(N)
	
	*tabulate values for checking output table against log files
	forvalues i=1/3{
		*get number of people with specific outcome (events column)
		cou if t`i'_`outcome' == 1
		local events=round(r(N),5)
		*calculate proportion of people with events
		local percWEvent=100*(`events'/`denom')
		*get ORs for each regression analysis
		*crude 
		display "t`i'_`outcome' regression results"
		safetab expStatus t`i'_`outcome', row
		*conditional logistic regressions for each time period
		capture noisily clogit t`i'_`outcome' i.expStatus i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs i.gpCountPrevYearCat, strata(set_id) or
		*this lincom ensures OR and CI can be stored in the r values, doesn't work straight from clogit
		capture noisily lincom 1.expStatus, or
		local hr = r(estimate)
		local lb = r(lb)
		local ub = r(ub)
		
		*get variable name
		local varLab: variable label t`i'_`outcome'
		display "`varLab'"
		*get category name
		*local category: label `catLabel' `i'
		*display "Category label: `category'"
		
		*write each row
		*T1: 4-12 weeks
		file write tablecontents  ("`varLab'")  _tab ("Time period `i' ") _tab %4.2f (`hr')  " (" %4.2f (`lb') "-" %4.2f (`ub') ")" _tab (`events') _tab %3.1f (`percWEvent') ("%")  _n
	}
					
end

*call program and output tables

use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
rename case expStatus
file open tablecontents using ./output/figure2PanelA_longCovidSympTimePeriods_`dataset'.txt, t w replace
file write tablecontents "Fig 2: Panel A. Community COVID-19: Odds ratios comparing odds of post-COVID SYMPTOMS OVER THREE TIME PERIODS during follow up in community COVID-19 compared to `dataset' comparator populations." _n _n
file write tablecontents ("Symptom") _tab ("Comparator") _tab ("OR (95% CI)") _tab ("Number of events") _tab ("Proportion of population with events") _n

*loop through each outcome
/*
foreach outcome in $symp {
	cap noisily outputORsforOutcome, outcome(`outcome')
	file write tablecontents _n
}
*/

*stratified by previous year gpcount
file write tablecontents ("Symptom results stratified by consultations in prev year (0=0 consultations, 1=1-5 consultations, 2=6+ consultations)") _n
forvalues i=0/2 {
	preserve
		keep if gpCountPrevYearCat==`i'
		file write tablecontents ("Previous gp count category `i'") _n
		foreach outcome in $symp {
			cap noisily outputORsforOutcome, outcome(`outcome')
			file write tablecontents _n
		}
	restore
}

*this is when doing just the codelists added subsequently (pain etc)

*Entire list
/*
foreach outcome in $sympAddtl {
	cap noisily outputORsforOutcome, outcome(`outcome')
	file write tablecontents _n
}
*/

/*
*JUST FOR DELIRIUM
keep if age>=67
cap noisily outputORsforOutcome, outcome(symp_delirium)
file write tablecontents _n
*/

*this is when doing just the codelists added subsequently (pain etc)
foreach outcome in $sympAddtl {
	cap noisily outputORsforOutcome, outcome(tEver_`outcome')
	file write tablecontents _n
}


*JUST FOR any symptom ever
cap noisily outputORsforOutcome, outcome(anySymptomsEver)
file write tablecontents _n


*JUST FOR delirium
keep if age>=67
cap noisily outputORsforOutcome, outcome(tEver_symp_delirium)
file write tablecontents _n

cap file close tablecontents 
cap log close




