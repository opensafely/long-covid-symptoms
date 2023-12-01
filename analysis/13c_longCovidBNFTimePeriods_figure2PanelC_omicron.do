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
*local dataset `1' 



*checking tabulations
capture log close
log using ./logs/13c_longCovidPrescrTimePeriods_figure2PanelCcontemporary_omicron.log, replace t

        

	
prog drop _all

*2300 Thursday - I need to use lincom after the estimates in order to make my estimates retrievable

prog define outputORsforOutcome
	*`1'=outcome, `2'=dataset
	
	*tabulate values for checking output table against log files
	forvalues i=1/3{
		*drop people who became ineligible during the previous period and those with prescriptions in BNF category in the year before
		if `i'==1{
			*FUP1 don't need to do anything
			use ./output/longCovidSymp_analysis_dataset_`2'.dta, clear
			rename case expStatus
			drop if prev_`1'==1
			*get denominator for reporting proportion of exposed with events			
			count if expStatus==1
			local denom=r(N)
		} 
		else if `i'==2 {
			*FUP2 need to drop those who became ineligible during FUP1
			use ./output/longCovidSymp_analysis_dataset_`2'.dta, clear
			rename case expStatus
			drop if prev_`1'==1
			drop if becameIneligFUP1==1
			*get denominator for reporting proportion of exposed with events			
			count if expStatus==1
			local denom=r(N)
		} 
		else if `i'==3 {
			*FUP3 need to drop those who became ineligible during FUP1 and FUP2
			use ./output/longCovidSymp_analysis_dataset_`2'.dta, clear
			rename case expStatus
			drop if prev_`1'==1
			drop if becameIneligFUP1==1|becameIneligFUP2==1
			*get denominator for reporting proportion of exposed with events			
			count if expStatus==1
			local denom=r(N)
		}
		
		*get number of people with specific outcome (events column)
		cou if expStatus==1 & t`i'_`1' == 1
		local events=round(r(N),5)
		*calculate proportion of people with events
		local percWEvent=100*(`events'/`denom')
		*get ORs for each regression analysis
		*crude 
		display "t`i'_`1' regression results"
		safetab expStatus t`i'_`1', row
		*conditional logistic regressions for each time period
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
		file write tablecontents  ("`varLab'") _tab ("Time period `i' ") _tab %4.2f (`hr')  " (" %4.2f (`lb') "-" %4.2f (`ub') ")" _tab (`denom') _tab (`events') _tab %3.1f (`percWEvent') ("%")  _n
	}
					
end

*call program and output tables

*use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
file open tablecontents using ./output/figure2PanelC_longCovidPrescrTimePeriods_contemporary_omicron.txt, t w replace
file write tablecontents "Fig 2: Panel A. Community COVID-19: Odds ratios comparing odds of post-COVID SYMPTOMS OVER THREE TIME PERIODS during follow up in community COVID-19 compared to contemporary_omicron comparator populations." _n _n
file write tablecontents ("Symptom") _tab ("Comparator") _tab ("OR (95% CI)") _tab ("Number exposed to COVID") _tab ("Number of events") _tab ("Proportion of population with events") _n

*loop through each outcome
*foreach outcome in $diagnosisOutcomes {	

use ./output/longCovidSymp_analysis_dataset_contemporary_omicron.dta, clear
rename case expStatus
foreach outcome in $medicines {
	cap noisily outputORsforOutcome `outcome' contemporary_omicron
	file write tablecontents _n
}

cap file close tablecontents 
cap log close



	



