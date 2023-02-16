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
log using ./logs/14_longCovidConsultationRate_figure3`dataset'.log, replace t


*load dataset
use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
rename case expStatus
file open tablecontents using ./output/figure3_longCovidConsultations_`dataset'.txt, t w replace
file write tablecontents "Fig 3: Median consultations overall and over time for `dataset' comparator population" _n _n
file write tablecontents _tab ("lower quartile (25%)") _tab ("median") _tab ("upper quartile (75%)") _tab ("p-value (unexp vs exposed, wilcoxon rank sum)") _n
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
generate logTotal_gp_count=log(total_gp_count)
ttest logTotal_gp_count, by(expStatus)
local totalPvalue=r(p)
*write output
file write tablecontents  ("-Overall across all time periods-'") _n 
file write tablecontents  ("Combined") _tab %4.2f (`total_25') _tab %4.2f (`total_50') _tab %4.2f (`total_75') _tab ("-") _n
file write tablecontents  ("Unexposed") _tab %4.2f (`totalUnexp_25') _tab %4.2f (`totalUnexp_50') _tab %4.2f (`totalUnexp_75') _tab ("-") _n
file write tablecontents  ("Exposed") _tab %4.2f (`totalExp_25') _tab %4.2f (`totalExp_50') _tab %4.2f (`totalExp_75') _tab %4.2f (`totalPvalue') _n _n


*(B) Time periods

*NEED TO PUT THIS IN A FOR LOOP TO HANDLE THREE TIME PERIODS
file write tablecontents  ("-Separate time periods-'") _n 
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
	generate logt`i'_gp_count=log(t`i'_gp_count)
	ttest logt`i'_gp_count, by(expStatus)
	local t`i'Pvalue=r(p)
	*write output
	file write tablecontents  ("Time period `i'") _n 
	file write tablecontents  ("Combined") _tab %4.2f (`t`i'total_25') _tab %4.2f (`t`i'total_50') _tab %4.2f (`t`i'total_75') _tab ("-") _n
	file write tablecontents  ("Unexposed") _tab %4.2f (`t`i'totalUnexp_25') _tab %4.2f (`t`i'totalUnexp_50') _tab %4.2f (`t`i'totalUnexp_75') _tab ("-") _n
	file write tablecontents  ("Exposed") _tab %4.2f (`t`i'totalExp_25') _tab %4.2f (`t`i'totalExp_50') _tab %4.2f (`t`i'totalExp_75') _tab %4.2f (`t`i'Pvalue') _n
}


cap file close tablecontents 
cap log close



	



