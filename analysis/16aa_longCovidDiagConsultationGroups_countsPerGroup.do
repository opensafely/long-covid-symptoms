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
log using ./logs/16aa_longCovidDiagConsultationGroups_countsPerGroup`dataset'.log, replace t

	
prog drop _all


prog define outputCountsforOutcome
	syntax, outcome(string)
	
	/*Note about this code - the denominator here has to be within strata of previous consultations as you can only be in one strata (whereas for the time period analysis 
	all people are in all strata - apart from those who died prior to t2 or t3, which we haven't take account of but would be very unlikely to change the % result)*/
	
	forvalues i=0/2{
		*get overall denominator for the specific strata of previous consultation			
		count if gpCountPrevYearCat==`i'
		local denom=r(N)
		
		*get number of people with specific outcome (events column)
		cou if gpCountPrevYearCat==`i' & `outcome'==1
		local events=round(r(N),5)
		*calculate proportion of people with events within the specific previous consultation strata
		local percWEvent=100*(`events'/`denom')
		*get exposed vs unexposed denominators			
		count if gpCountPrevYearCat==`i' & expStatus==0
		local unexpDenom=round(r(N),5)
		count if gpCountPrevYearCat==`i' & expStatus==1
		local expDenom=round(r(N),5)
		*get number of people (and %) with events by exposure status 
		cou if gpCountPrevYearCat==`i' & `outcome'==1 & expStatus==0
		local unexpEvents=round(r(N),5)
		local unexpPercWEvent=100*(`unexpEvents'/`unexpDenom')
		cou if gpCountPrevYearCat==`i' & `outcome'==1 & expStatus==1
		local expEvents=round(r(N),5)
		local expPercWEvent=100*(`expEvents'/`expDenom')	
						
		*get variable name
		local varLab: variable label `outcome'
		display "`varLab'"
		
		*get prevconsname
		local catLab: label (gpCountPrevYearCat) `i'
		display "Category label: `catLab'"
		
		*write each row
		*crude 
		file write tablecontents  ("`varLab'") _tab ("`catLab'")  _tab (`denom') _tab (`events')  _tab %3.1f (`percWEvent') ("%") _tab (`unexpDenom') _tab (`unexpEvents')  _tab %3.1f (`unexpPercWEvent') ("%") _tab (`expDenom') _tab (`expEvents')  _tab %3.1f (`expPercWEvent') ("%")  _n
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
file open tablecontents using ./output/Figure5_gpConsInteractionCounts_`dataset'.txt, t w replace
file write tablecontents "Fig 5: Supporting figures. Number with events by exposure satus at any time BY PREVIOUS CONSULTATIONS during follow up (`dataset' comparator)" _n _n
file write tablecontents ("Unexposed to COVID N=`totUnexp'") _tab ("Exposed to COVID N=`totExp'") _n _n
file write tablecontents _tab _tab ("Total N") _tab ("n with event") _tab ("% of total with events") _tab ("Unexposed N") _tab ("n unexposed with event") _tab ("% of unexposed with events") _tab ("Exposed to COVID N") _tab ("n exposed to COVID with event") _tab ("% of exposed to COVID with events") _n

/*
*loop through SYMPTOMS
file write tablecontents "SYMPTOMS" _n _n
foreach outcome in $symp {
	cap noisily outputCountsforOutcome, outcome(tEver_`outcome')
	file write tablecontents _n
}

*loop through DIAGNOSES
file write tablecontents "DIAGNOSES" _n _n
foreach outcome in $diag {
	cap noisily outputCountsforOutcome, outcome(tEver_`outcome')
	file write tablecontents _n
}

*loop through PRESCRIPTIONS
file write tablecontents "PRESCRIPTIONS" _n _n
foreach outcome in $medicines {
	cap noisily outputCountsforOutcome, outcome(tEver_`outcome')
	file write tablecontents _n
}
*/

*JUST FOR ANY SYMPTOM EVER
cap noisily outputCountsforOutcome, outcome(anySymptomsEver)
file write tablecontents _n

*JUST FOR DELIRIUM
keep if age>=67
cap noisily outputCountsforOutcome, outcome(tEver_symp_delirium)
file write tablecontents _n


cap file close tablecontents 
cap log close



	



