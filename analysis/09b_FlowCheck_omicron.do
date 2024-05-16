/*==============================================================================
DO FILE NAME:			09_longCovidSymp_cr_analysis_dataset.do
PROJECT:				Long covid symptoms
DATE: 					29th Aug 2022
AUTHOR:					Kevin Wing 										
DESCRIPTION OF FILE:	Creates a file containing the matched cases and comparators ready for analysis, and a file of the cases that could not be matched for descr analysis
DATASETS USED:			.csv
DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir

tgg


sysdir set PLUS "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 
sysdir set PERSONAL "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 


*NEEDS REDONE THIS WEEK SO THAT THE COUNTS AT THE BEGINNING OF EACH FUP HAVE BEEN INCLUDED TO DROP THOSE THAT WERE NO LONGER ELIGIBLE FOR THAT FUP PERIOD (AND ALSO DROPPED ANY
NO LONGER MATCHED AFTER DOING SO). THINK I NEED TO DROP COMPARATORS WHO BECAME CASES IN THE PREVIOUS FUP PERIOD, BUT LIKELY DO A SENSITIVITY ANALYSIS WHERE THESE PEOPLE ARE NOT DROPPED(?). 

OTHER OPTION WOULD BE THAT THESE PEOPLE SHOULD BECOME CASES, MATCHED TO NEW COMPARATORS AND THEN INCLUDED IN THE ANALYIS FOR THE NEXT FUP?

I THINK THE FIRST WAY OF DOING IT SHOULD BE OK THOUGH, CAN REPORT NUMBERS*

							
==============================================================================*/
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
*globals of lists of diagnoses and symptoms etc
do ./analysis/masterLists.do
pwd

*setup so that the code in this file can be used to output analyses for both contemporary and historical comparators (and is called twice by separate .yaml actions)
*local dataset `1'

* Open a log file
cap log close
*log using ./logs/09b_FlowCheck_`dataset'_omicron.log, replace t
log using ./logs/09b_FlowCheck_contemporary_omicron.log, replace t

*load main analysis file
*use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
use ./output/longCovidSymp_analysis_dataset_contemporary_omicron.dta, clear
rename case expStatus
bysort expStatus: sum death_date
bysort expStatus: sum dereg_date

****BUGHUNTING MAIN ANALYSIS FILE******
/*
keep if death_date!=.
set seed 478298
generate random = runiform()
sort random
keep if _n<1000
sort death_date
list death_date
*/


/*
****BUGHUNTING OTHER FILES******
capture noisily import delimited ./output/input_controls_`dataset'CorrectedDeathDate.csv, clear
keep if death_date!=""
set seed 478298
generate random = runiform()
sort random
keep if _n<1000
sort death_date
list death_date


capture noisily import delimited ./output/input_covid_matched_matches_`dataset'_allSTPs.csv, clear
keep if death_date!=""
set seed 478298
generate random = runiform()
sort random
keep if _n<1000
sort death_date
list death_date
*/



*use ./output/longCovidSymp_analysis_dataset_`dataset'.dta, clear
use ./output/longCovidSymp_analysis_dataset_contemporary_omicron.dta, clear
rename case expStatus

********************************TABULATION PROGRAMS****************************

cap prog drop generaterow
program define generaterow
syntax, variable(varname) condition(string) 
	
	cou
	local overalldenom=r(N)
	
	sum `variable' if `variable' `condition'
	**K Wing additional code to output variable category labels**
	local level=substr("`condition'",3,.)
	local lab: label `variable' `level'
	file write tablecontent (" `lab'") _tab
	
	*local lab: label hhRiskCatExp_5catsLabel 4

	
	/*this is the overall column - had to edit this so that the row totals are the SUM OF THE ROUNDED COUNTS FOR EXPOSED AND UNEXPOSED, not the rounded total (as these may not match)*/
	/*old code
	cou if `variable' `condition'
	local rowdenom = round(r(N),5)
	local colpct = 100*(r(N)/`overalldenom')
	*/
	*updated code where the row totals (i.e. the "Total" column) is the sum of the two rounded values for the exposed (COVID case) and unexposed (comparator) columns
	/*this is the overall column - had to edit this so that the row totals are the SUM OF THE ROUNDED COUNTS FOR EXPOSED AND UNEXPOSED, not the rounded total (as these may not match)*/
	forvalues i=0/1{
		cou if expStatus == `i' & `variable' `condition'
		local subTotal_`i'=round(r(N),5)
	}
	local rowdenom = `subTotal_0' + `subTotal_1'
	local colpct = 100*(`rowdenom'/`overalldenom')
	file write tablecontent %9.0f (`rowdenom')  (" (") %3.1f (`colpct') (")") _tab

	/*this loops through groups*/
	forvalues i=0/1{
		safecount if expStatus==`i'
		local coldenom=r(N)
		cou if expStatus == `i' & `variable' `condition'
		local pct = 100*(r(N)/`coldenom')
		*file write tablecontent %9.0gc (r(N)) (" (") %3.1f (`pct') (")") _tab
		file write tablecontent %9.0f (round(r(N),5)) (" (") %3.1f (`pct') (")") _tab
	}
	
	file write tablecontent _n
	
end



/* Explanatory Notes 

defines a program (SAS macro/R function equivalent), generate row
the syntax row specifies two inputs for the program: 

	a VARNAME which is your variable 
	a CONDITION which is a string of some condition you impose 
	
the program counts if variable and condition and returns the counts
column percentages are then automatically generated
this is then written to the text file 'tablecontent' 
the number followed by space, brackets, formatted pct, end bracket and then tab

the format %3.1f specifies length of 3, followed by 1 dp. 

*/ 

********************************************************************************
* Generic code to output one section (varible) within table (calls above)

cap prog drop tabulatevariable
prog define tabulatevariable
syntax, variable(varname) min(real) max(real) [missing]

	local lab: variable label `variable'
	file write tablecontent ("`lab'") _n 

	forvalues varlevel = `min'/`max'{ 
		generaterow, variable(`variable') condition("==`varlevel'")
	}
	
	if "`missing'"!="" generaterow, variable(`variable') condition("== 12")
	


end

********************************************************************************

/* Explanatory Notes 

defines program tabulate variable 
syntax is : 

	- a VARNAME which you stick in variable 
	- a numeric minimum 
	- a numeric maximum 
	- optional missing option, default value is . 

forvalues lowest to highest of the variable, manually set for each var
run the generate row program for the level of the variable 
if there is a missing specified, then run the generate row for missing vals

*/ 




********************************END OF TABULATION PROGRAMS*******************

*Set up output file
cap file close tablecontent
file open tablecontent using ./output/flowcheck_longCovidSymp_omicron.csv, write text replace

file write tablecontent ("Flowchart check figures for wave 2 `1'") _n

 
*for display n values
safecount if expStatus==0
local unexposed=r(N)
safecount if expStatus==1
local exposed=r(N)
safecount
local total=r(N)

file write tablecontent _tab ("Total")	_tab ///			 
							 ("Unexposed (`1')")	_tab ///
							 ("Exposed")  			_n 	

							 
file write tablecontent _tab ("n=`total'")				  		  _tab ///
							 ("n=`unexposed'")				  	_tab ///
							 ("n=`exposed'")  			  	  _n


*Numbers for flowchart check
*(0) Ever during follow-up
file write tablecontent _n ("Ever during follow-up") _n
*(a) any ineligibility ever
tab becameIneligEver expStatus, col
tabulatevariable, variable(becameIneligEver) min(0) max(1)

*(b) specific reasons ever
tab compBecameCaseEver expStatus, col
tabulatevariable, variable(compBecameCaseEver) min(0) max(1)

tab caseHospForCOVIDEver expStatus, col
tabulatevariable, variable(caseHospForCOVIDEver) min(0) max(1)

tab diedEver expStatus, col
tabulatevariable, variable(diedEver) min(0) max(1)

tab deregEver expStatus, col
tabulatevariable, variable(deregEver) min(0) max(1)





*(1) During FUP1
file write tablecontent _n ("During FUP1") _n
*(a) any ineligibility FUP1
tab becameIneligFUP1 expStatus, col
tabulatevariable, variable(becameIneligFUP1) min(0) max(1)

*(b) specific reasons FUP1
tab compBecameCaseDurFUP1 expStatus, col
tabulatevariable, variable(compBecameCaseDurFUP1) min(0) max(1)

tab caseHospForCOVIDDurFUP1 expStatus, col
tabulatevariable, variable(caseHospForCOVIDDurFUP1) min(0) max(1)
tab diedDuringFUP1 expStatus, col
tabulatevariable, variable(diedDuringFUP1) min(0) max(1)

tab deregDuringFUP1 expStatus, col
tabulatevariable, variable(deregDuringFUP1) min(0) max(1)





*(2) During FUP2
file write tablecontent _n ("During FUP2") _n
*(a) any ineligibility FUP2
tab becameIneligFUP2 expStatus, col
tabulatevariable, variable(becameIneligFUP2) min(0) max(1)

*(b) specific reasons FUP2
tab compBecameCaseDurFUP2 expStatus, col
tabulatevariable, variable(compBecameCaseDurFUP2) min(0) max(1)

tab caseHospForCOVIDDurFUP2 expStatus, col
tabulatevariable, variable(caseHospForCOVIDDurFUP2) min(0) max(1)

tab diedDuringFUP2 expStatus, col
tabulatevariable, variable(diedDuringFUP2) min(0) max(1)

tab deregDuringFUP2 expStatus, col
tabulatevariable, variable(deregDuringFUP2) min(0) max(1)





*(3) During FUP3
file write tablecontent _n ("During FUP2") _n
*(a) any ineligibility FUP3
tab becameIneligFUP3 expStatus, col
tabulatevariable, variable(becameIneligFUP3) min(0) max(1)


*(b) specific reasons FUP3
tab compBecameCaseDurFUP3 expStatus, col
tabulatevariable, variable(compBecameCaseDurFUP3) min(0) max(1)


tab caseHospForCOVIDDurFUP3 expStatus, col
tabulatevariable, variable(caseHospForCOVIDDurFUP3) min(0) max(1)


tab diedDuringFUP3 expStatus, col
tabulatevariable, variable(diedDuringFUP3) min(0) max(1)


tab deregDuringFUP3 expStatus, col
tabulatevariable, variable(deregDuringFUP3) min(0) max(1)


file write tablecontent _n

file close tablecontent


* Close log file 
cap log close





