*************************************************************************
*Do file: 08_hhClassif_an_mv_analysis_perEth5Group_HR_table.do
*
*Purpose: Create content that is ready to paste into a pre-formatted Word 
* shell table containing minimally and fully-adjusted HRs for risk factors
* of interest, across 2 outcomes 
*
*Requires: final analysis dataset (analysis_dataset.dta)
*

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
log using ./logs/13bb_longCovidDiagTimePeriods_countsPerGroup`dataset'.log, replace t

	
prog drop _all


prog define outputCountsforOutcome
	syntax, outcome(string)
	*above will need edited when also have the historical population to compare to

	*get overall denominator			
	count
	local denom=r(N)
	
	forvalues i=1/3{
		*get number of people with specific outcome (events column)
		cou if t`i'_`outcome' == 1
		local events=round(r(N),5)
		*calculate proportion of people with events
		local percWEvent=100*(`events'/`denom')
		*get exposed vs unexposed denominators			
		count if expStatus==0
		local unexpDenom=round(r(N),5)
		count if expStatus==1
		local expDenom=round(r(N),5)
		*get number of people (and %) with events by exposure status 
		cou if t`i'_`outcome'== 1 & expStatus==0
		local unexpEvents=round(r(N),5)
		local unexpPercWEvent=100*(`unexpEvents'/`unexpDenom')
		cou if t`i'_`outcome' == 1 & expStatus==1
		local expEvents=round(r(N),5)
		local expPercWEvent=100*(`expEvents'/`expDenom')	
						
		*get variable name
		local varLab: variable label t`i'_`outcome'
		display "`varLab'"
		*get category name
		*local category: label `catLabel' `i'
		*display "Category label: `category'"
		
		*write each row
		*crude 
		file write tablecontents  ("`varLab'") _tab (`denom') _tab (`events')  _tab %3.1f (`percWEvent') ("%") _tab (`unexpDenom') _tab (`unexpEvents')  _tab %3.1f (`unexpPercWEvent') ("%") _tab (`expDenom') _tab (`expEvents')  _tab %3.1f (`expPercWEvent') ("%")  _n
	}
end

*call program and output tables

use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
rename case expStatus
*counts for table header of overall number exposed and unexposed
count if expStatus==0
local totUnexp=r(N)
count if expStatus==1
local totExp=r(N)
file open tablecontents using ./output/figure2PanelB_countsPerGroup_`dataset'.txt, t w replace
file write tablecontents "Fig 1: Panel A supporting figures. Number with events by exposure satus AT ANY TIME during follow up (`dataset' comparator)" _n _n
file write tablecontents ("Unexposed to COVID N=`totUnexp'") _tab ("Exposed to COVID N=`totExp'") _n _n
file write tablecontents _tab ("Total N") _tab ("n with event") _tab ("% of total with events") _tab ("Unexposed N") _tab ("n unexposed with event") _tab ("% of unexposed with events") _tab ("Exposed to COVID N") _tab ("n exposed to COVID with event") _tab ("% of exposed to COVID with events") _n


*loop through each outcome
foreach outcome in $diag {
	cap noisily outputCountsforOutcome, outcome(`outcome')
	file write tablecontents _n
}



cap file close tablecontents 
cap log close



	



