*************************************************************************
*Do file: 08_hhClassif_an_mv_analysis_perEth5Group_HR_table.do
*
*Purpose: Create content that is ready to paste into a pre-formatted Word 
* shell table containing minimally and fully-adjusted HRs for risk factors
* of interest, across 2 outcomes g
*
*Requires: final analysis dataset (analysis_dataset.dta)
*g

*
*Coding: K Wing, base on file from HFORBES, based on file from Krishnan Bhaskaran
*
*Date drafted: 17th June 2021
*************************************************************************
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
*run globals of lists of diagnoses and symptoms, then make loc
do ./analysis/masterLists.do

capture log close
log using ./logs/17_longCovidSympTimePeriods_sunburstcontemporary.log, replace t

*test area for this file!
*this is the correct logic, just need it to output tables
use ./output/longCovidSymp_analysis_dataset_contemporary.dta, clear



******(A) THREE LEVEL SUNBURST PLOT******
file open tablecontents using ./output/sunburst_contemporary_3Periods.txt, t w replace
file write tablecontents "Table to support three level sunburst plot" _n _n
file write tablecontents ("Level 1") _tab ("n") _tab ("Level 2") _tab ("n") _tab ("Level 3") _tab ("n") _n

*helper macros for outputting to excel
local l1count=-1
local l2count=-1
local l3count=0

foreach a of global highLevelSympAndNone {
	*display "t1_`a':"
	count if t1_`a'==1	
	local level1_Count=round(r(N),5)
	*get label
	local level1_Lab: variable label t1_`a'
	local l1count=`l1count'+1
	foreach b of global highLevelSympAndNone {
		*display "t1_`a' and t2_`b':"
		count if t1_`a'==1 & t2_`b'==1
		local level2_Count=round(r(N),5)
		local level2_Lab: variable label t2_`b'
		local l2count=`l2count'+1
		foreach c of global highLevelSympAndNone {
			*display "t1_`a' and t2_`b' and t3_`c':"
			count if t1_`a'==1 & t2_`b'==1 & t3_`c'==1
			local level3_Count=round(r(N),5)
			local level3_Lab: variable label t3_`c'
			local l3count=`l3count'+1
			*file write tablecontents  ("`level1_Lab'") _tab (`level1_Count') _tab ("`level2_Lab'") _tab (`level2_Count') _tab ("`level3_Lab'") _tab (`level3_Count') _n
			display "l3count: `l3count'"
			display "l2count: `l2count'"
			if (`l3count'-1)/100==`l1count'  {
				file write tablecontents  ("`level1_Lab'") _tab (`level1_Count') _tab ("`level1_Lab' and `level2_Lab'") _tab (`level2_Count') _tab ("`level1_Lab' and `level2_Lab' and `level3_Lab'") _tab (`level3_Count') _n 
			}
			else if (`l3count'-1)/10==`l2count' & (`l3count'-1)/100!=`l1count'{
				file write tablecontents  _tab _tab ("`level1_Lab' and `level2_Lab'") _tab (`level2_Count') _tab ("`level1_Lab' and `level2_Lab' and `level3_Lab'") _tab (`level3_Count') _n 
			}
			else {
				file write tablecontents  _tab _tab _tab _tab ("`level1_Lab' and `level2_Lab' and `level3_Lab'") _tab (`level3_Count') _n
			}
		}
	}
}

cap file close tablecontents 



******(B) TWO LEVEL SUNBURST PLOT (TIME PERIODS ONE AND TWO COMBINED)*****
file open tablecontents using ./output/sunburst_contemporary_2Periods.txt, t w replace
file write tablecontents "Table to support 2 level sunburst plot" _n _n
file write tablecontents ("Level 1") _tab ("n") _tab ("Level 2") _tab ("n") _n

*helper macros for outputting to excel
local l1count=-1
local l2count=0

foreach a of global highLevelSympAndNone {
	count if t1t2_`a'==1	
	local level1_Count=round(r(N),5)
	*get label
	local level1_Lab: variable label t1t2_`a'
	local l1count=`l1count'+1
	foreach b of global highLevelSympAndNone {
		count if t1t2_`a'==1 & t3_`b'==1
		local level2_Count=round(r(N),5)
		local level2_Lab: variable label t3_`b'
		local l2count=`l2count'+1
		if (`l2count'-1)/10==`l1count' {
			file write tablecontents  ("`level1_Lab'") _tab (`level1_Count') _tab ("`level1_Lab' and `level2_Lab'") _tab (`level2_Count') _n 
		}
		else {
			file write tablecontents  _tab _tab ("`level1_Lab' and `level2_Lab'") _tab (`level2_Count') _n
		}
	}
}


cap file close tablecontents 

cap log close





	



