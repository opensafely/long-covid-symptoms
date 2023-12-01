*************************************************************************
*Do file: 08_hhClassif_an_mv_analysis_perEth5Group_HR_table.do
*
*Purpose: Create content that is ready to paste into a pre-formatted Word 
* shell table containing minimally and fully-adjusted HRs for risk factors
* of interest, across 2 outcomes 
*
*Requires: final analysis dataset (analysis_dataset.dta) g h

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
*local dataset `1' 



*checking tabulations
capture log close
log using ./logs/13a_longCovidSympTimePeriods_figure2PanelAcontemporary_omicron.log, replace t

        

	
prog drop _all

*FRI 9 JUNE: AT BEGINNING OF FUP1, NEED TO DROP THOSE WHO BECAME INELIGIBLE DURING FUP1. AT BEGINNING OF FUP2, NEED TO DROP THOSE WHO BECAME INELIGIBLE DURING FUP1 AND FUP2

prog define outputORsforOutcome
	*`1'=outcome, `2'=dataset
	
	*tabulate values for checking output table against log files
	forvalues i=1/3{
		*drop people who became ineligible during the previous period
		if `i'==1{
			*FUP1 don't need to do anything
			use ./output/longCovidSymp_analysis_dataset_`2'.dta, clear
			rename case expStatus
			*get denominator for reporting proportion of exposed with events			
			count if expStatus==1
			local denom=r(N)
		} 
		else if `i'==2 {
			*FUP2 need to drop those who became ineligible during FUP1
			use ./output/longCovidSymp_analysis_dataset_`2'.dta, clear
			rename case expStatus
			drop if becameIneligFUP1==1
			*get denominator for reporting proportion of exposed with events			
			count if expStatus==1
			local denom=r(N)
		} 
		else if `i'==3 {
			*FUP3 need to drop those who became ineligible during FUP1 and FUP2
			use ./output/longCovidSymp_analysis_dataset_`2'.dta, clear
			rename case expStatus
			drop if becameIneligFUP1==1|becameIneligFUP2==1
			*get denominator for reporting proportion of exposed with events			
			count if expStatus==1
			local denom=r(N)
		}
		
		*get number of people with specific outcome in the exposed to COVID group (events column)
		cou if expStatus==1 & t`i'_`1' == 1
		local events=round(r(N),5)
		*calculate proportion of people with events
		local percWEvent=100*(`events'/`denom')
		*get ORs for each regression analysis
		*crude 
		display "t`i'_`1' regression results"
		*safetab expStatus t`i'_`outcome', row
		*conditional logistic regressions for each time period
		if "`1'"=="symp_delirium"{
			keep if age>=67
		} 		
		capture noisily clogit t`i'_`1' i.expStatus i.imd i.ethnicity i.rural_urban i.numPreExistingComorbs i.gpCountPrevYearCat, strata(set_id) or
		*this lincom ensures OR and CI can be stored in the r values, doesn't work straight from clogit
		capture noisily lincom 1.expStatus, or
		local hr = r(estimate)
		local lb = r(lb)
		local ub = r(ub)
		
		*get variable name
		local varLab: variable label t`i'_`1'
		display "`varLab'"
		*get category name
		*local category: label `catLabel' `i'
		*display "Category label: `category'"
		
		*write each row
		*T1: 4-12 weeks
		file write tablecontents  ("`varLab'")  _tab ("Time period `i' ") _tab %4.2f (`hr')  " (" %4.2f (`lb') "-" %4.2f (`ub') ")" _tab (`denom') _tab (`events') _tab %3.1f (`percWEvent') ("%")  _n
	}
					
end

*call program and output tables


file open tablecontents using ./output/figure2PanelA_longCovidSympTimePeriods_contemporary_omicron.txt, t w replace
file write tablecontents "Fig 2: Panel A. Community COVID-19: Odds ratios comparing odds of post-COVID SYMPTOMS OVER THREE TIME PERIODS during follow up in community COVID-19 compared to contemporary_omicron comparator populations." _n _n
file write tablecontents ("Symptom") _tab ("Comparator") _tab ("OR (95% CI)") _tab ("Number exposed to COVID") _tab ("Number of events in exposed") _tab ("Proportion of exposed to COVID with events") _n

/*
*this is when doing just the codelists added subsequently (pain etc)
foreach outcome in $sympAddtl {
	cap noisily outputORsforOutcome, outcome(`outcome')
	file write tablecontents _n
}
*/


*JUST FOR any symptom ever
cap noisily outputORsforOutcome anySymptomsEver contemporary_omicron
file write tablecontents _n

*loop through each outcome
foreach outcome in $symp {
	cap noisily outputORsforOutcome `outcome' contemporary_omicron
	file write tablecontents _n
}


*JUST FOR delirium
cap noisily outputORsforOutcome symp_delirium contemporary_omicron
file write tablecontents _n

cap file close tablecontents 
cap log close



*stratified by previous year gpcount
/*
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
*/

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





