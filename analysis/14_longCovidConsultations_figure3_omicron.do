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

program drop _all


*setup so that the code in this file can be used to output analyses for both contemporary and historical comparators (and is called twice by separate .yaml actions)
*local dataset `1' 

*checking tabulations
capture log close
log using ./logs/14_longCovidConsultationRate_figure3contemporary_omicron.log, replace t

*get data and setup file
use ./output/longCovidSymp_analysis_dataset_contemporary_omicron.dta, clear
*helper variables for this analysis file
rename case expStatus
generate logTotal_gp_count=log(total_gp_count)
forvalues i=1/3{
	generate logt`i'_gp_count=log(t`i'_gp_count)
}	
file open tablecontents using ./output/figure3_longCovidConsultations_contemporary_omicron.txt, t w replace
file write tablecontents "Fig 3: Median consultations overall and over time for contemporary_omicron comparator population (overall and by prev consultation rate strata)" _n _n
file write tablecontents _tab ("lower quartile (25%)") _tab ("median") _tab ("upper quartile (75%)") _tab ("p-value (unexp vs exposed, wilcoxon rank sum)") _n


*load dataset
*program for time ever analysis
program overallMedianCons
	*get median, 25% and 75% for consultations for unexposed and exposed
	*(A) At any time
	*overall
	sum total_gp_count, detail
	local total_25=r(p25)
	local total_50=r(p50)
	local total_75=r(p75)
	*by exposure status
	*unexp
	sum total_gp_count if expStatus==0, detail
	local totalUnexp_25=r(p25)
	local totalUnexp_50=r(p50)
	local totalUnexp_75=r(p75)
	*exp
	sum total_gp_count if expStatus==1, detail
	local totalExp_25=r(p25)
	local totalExp_50=r(p50)
	local totalExp_75=r(p75)
	*comparison of average - going to compare the means following log transformation (see Kirkwood and Sterne 13.2)
	hist total_gp_count if expStatus==0
	hist total_gp_count if expStatus==1
	ttest logTotal_gp_count, by(expStatus)
	local totalPvalue=r(p)
	*write results
	file write tablecontents  ("Combined") _tab %4.2f (`total_25') _tab %4.2f (`total_50') _tab %4.2f (`total_75') _tab ("-") _n
	file write tablecontents  ("Unexposed") _tab %4.2f (`totalUnexp_25') _tab %4.2f (`totalUnexp_50') _tab %4.2f (`totalUnexp_75') _tab ("-") _n
	file write tablecontents  ("Exposed") _tab %4.2f (`totalExp_25') _tab %4.2f (`totalExp_50') _tab %4.2f (`totalExp_75') _tab %4.2f (`totalPvalue') _n _n
end 

*program for time periods analysis
program timePeriodMedianCons
	forvalues i=1/3{
		*overall
		sum t`i'_gp_count, detail
		local t`i'total_25=r(p25)
		local t`i'total_50=r(p50)
		local t`i'total_75=r(p75)
		*by exposure status
		*unexp
		sum t`i'_gp_count if expStatus==0, detail
		local t`i'totalUnexp_25=r(p25)
		local t`i'totalUnexp_50=r(p50)
		local t`i'totalUnexp_75=r(p75)
		*exp
		sum t`i'_gp_count if expStatus==1, detail
		local t`i'totalExp_25=r(p25)
		local t`i'totalExp_50=r(p50)
		local t`i'totalExp_75=r(p75)
		*comparison of average - going to compare the means following log transformation (see Kirkwood and Sterne 13.2)
		ttest logt`i'_gp_count, by(expStatus)
		local t`i'Pvalue=r(p)
		*write output
		file write tablecontents  ("Time period `i'") _n 
		file write tablecontents  ("Combined") _tab %4.2f (`t`i'total_25') _tab %4.2f (`t`i'total_50') _tab %4.2f (`t`i'total_75') _tab ("-") _n
		file write tablecontents  ("Unexposed") _tab %4.2f (`t`i'totalUnexp_25') _tab %4.2f (`t`i'totalUnexp_50') _tab %4.2f (`t`i'totalUnexp_75') _tab ("-") _n
		file write tablecontents  ("Exposed") _tab %4.2f (`t`i'totalExp_25') _tab %4.2f (`t`i'totalExp_50') _tab %4.2f (`t`i'totalExp_75') _tab %4.2f (`t`i'Pvalue') _n _n
}
end

*(A) OVERALL TIME PERIOD
*(1) overall median cons, for all previous consultation rates strata
file write tablecontents  ("**OVERALL ACROSS ALL TIME PERIODS**") _n 
file write tablecontents  ("(1) All prev consultation rate strata combined") _n 
overallMedianCons
file write tablecontents  ("(2) By previous consultations strata") _n 
forvalues c=0/2 {
	preserve
		keep if gpCountPrevYearCat==`c'
		file write tablecontents  ("(a) Prev consultations category `c'") _n 
		overallMedianCons
	restore
}

*(B) SEPARATE TIME PERIODS
file write tablecontents  ("**SEPARATE TIME PERIODS**") _n 
file write tablecontents  ("(1) All prev consultation rate strata combined") _n 
timePeriodMedianCons
file write tablecontents  ("(2) By previous consultations strata") _n 
forvalues c=0/2 {
	preserve
		keep if gpCountPrevYearCat==`c'
		file write tablecontents  ("(a) Prev consultations category `c'") _n 
		timePeriodMedianCons
	restore
}

cap file close tablecontents 
cap log close



	



