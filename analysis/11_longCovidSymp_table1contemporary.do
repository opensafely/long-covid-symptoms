/*==============================================================================
DO FILE NAME:			11_longCovidSymp_table1contemporary
PROJECT:				Covid symptoms analysis 
DATE: 					12 Oct  
AUTHOR:					K Wing
						(adapted from hh classification table 1 file)
DESCRIPTION OF FILE:	Produce a table of baseline characteristics by case and comparator
						Output to a textfile for further formatting
DATASETS USED:			$Tempdir\analysis_dataset.dta
DATASETS CREATED: 		None
OTHER OUTPUT: 			Results in txt: $Tabfigdir\table1.txt 
						Log file: $Logdir\05_eth_table1_descriptives
USER-INSTALLED ADO: 	 
  (place .ado file(s) in analysis folder)	
  
 
sysdir set PLUS "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 
sysdir set PERSONAL "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 

cd ${outputData}
clear all


*first test run, am going to see if I can output tables by ethnicity category - worked, now make edits for hh_size and age
*probably going to make a 5 category variable for age

 ==============================================================================*/
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles

local dataset `1'



capture log close
log using ./logs/10_longCovidSymp_data_checks.log, replace t


* Open Stata dataset
use ./output/longCovidSymp_analysis_dataset_contemporary.dta, clear
*update variable with missing so that . is shown as unknown (just for this table)
*(1) ethnicity
replace eth5=6 if eth5==.
label drop eth5
label define eth5 			1 "White"  					///
							2 "South Asian"				///						
							3 "Black"  					///
							4 "Mixed"					///
							5 "Other"					///
							6 "Unknown"
					

label values eth5 eth5
safetab eth5, m


 /* PROGRAMS TO AUTOMATE TABULATIONS===========================================*/ 

********************************************************************************
* All below code from K Baskharan 
* Generic code to output one row of table

cap prog drop generaterow
program define generaterow
syntax, variable(varname) condition(string) 
	
	cou
	local overalldenom=r(N)
	
	sum `variable' if `variable' `condition'
	**K Wing additional code to aoutput variable category labels**
	local level=substr("`condition'",3,.)
	local lab: label `variable' `level'
	file write tablecontent (" `lab'") _tab
	
	*local lab: label hhRiskCatExp_5catsLabel 4

	
	/*this is the overall column*/
	cou if `variable' `condition'
	local rowdenom = r(N)
	local colpct = 100*(r(N)/`overalldenom')
	*file write tablecontent %9.0gc (`rowdenom')  (" (") %3.1f (`colpct') (")") _tab
	file write tablecontent %9.0f (`rowdenom')  (" (") %3.1f (`colpct') (")") _tab

	/*this loops through groups*/
	forvalues i=0/1{
		cou if case == `i'
		local rowdenom = r(N)
		cou if case == `i' & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom') 
		*file write tablecontent %9.0gc (r(N)) (" (") %3.1f (`pct') (")") _tab
		file write tablecontent %9.0f (r(N)) (" (") %3.1f (`pct') (")") _tab
	}
	
	file write tablecontent _n
end


* Output one row of table for co-morbidities and meds

cap prog drop generaterow2 /*this puts it all on the same row, is rohini's edit*/
program define generaterow2
syntax, variable(varname) condition(string) 
	
	cou
	local overalldenom=r(N)5
	
	cou if `variable' `condition'
	local rowdenom = r(N)
	local colpct = 100*(r(N)/`overalldenom')
	file write tablecontent %9.0gc (`rowdenom')  (" (") %3.1f (`colpct') (")") _tab

	forvalues i=0/1{
		cou if case == `i'
		local rowdenom = r(N)
		cou if case == `i' & `variable' `condition'
		local pct = 100*(r(N)/`rowdenom') 
		file write tablecontent %9.0gc (r(N)) (" (") %3.1f (`pct') (")") _tab
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

********************************************************************************
* Generic code to qui summarize a continous variable 

cap prog drop summarizevariable 
prog define summarizevariable
syntax, variable(varname) 

	local lab: variable label `variable'
	file write tablecontent ("`lab'") _n 


	qui summarize `variable', d
	file write tablecontent ("Mean (SD)") _tab 
	file write tablecontent  %3.1f (r(mean)) (" (") %3.1f (r(sd)) (")") _tab
	
	forvalues i=0/1{							
		qui summarize `variable' if case == `i', d
		file write tablecontent  %3.1f (r(mean)) (" (") %3.1f (r(sd)) (")") _tab
	}

file write tablecontent _n

	
	qui summarize `variable', d
	file write tablecontent ("Median (IQR)") _tab 
	file write tablecontent %3.1f (r(p50)) (" (") %3.1f (r(p25)) ("-") %3.1f (r(p75)) (")") _tab
	
	forvalues i=0/1{
		qui summarize `variable' if case == `i', d
		file write tablecontent %3.1f (r(p50)) (" (") %3.1f (r(p25)) ("-") %3.1f (r(p75)) (")") _tab
	}
	
file write tablecontent _n
	
end

/* INVOKE PROGRAMS FOR TABLE 1================================================*/ 

*Set up output file
cap file close tablecontent
file open tablecontent using ./output/table1_hhClassif`dataset'.txt, write text replace

file write tablecontent ("Table 1: Demographic and clinical characteristics for cases and contemporary matched comparators") _n

* eth5 labelled columns *THESE WOULD BE HOUSEHOLD LABELS, eth5 is the equivalent of the hh size variable

local lab0: label case 0
local lab1: label case 1

file write tablecontent _tab ("Total")				  			  _tab ///
							 ("`lab0'")  						  _tab ///
							 ("`lab1'")  						  _n							 
							 


**DEMOGRAPHICS AND PREVIOUS COMRBIDITIES (more than one level, potentially missing)**
*Age
tabulatevariable, variable(ageCat) min(0) max(9) 
file write tablecontent _n 
*continous
qui summarizevariable, variable(age) 
file write tablecontent _n

*Sex
tabulatevariable, variable(sex) min(0) max(1) 
file write tablecontent _n 

*IMD
tabulatevariable, variable(imd) min(1) max(5) 
file write tablecontent _n 

*Ethnicity
tabulatevariable, variable(eth5Table1) min(1) max(6) 
file write tablecontent _n 

*Rural urban (binary)
tabulatevariable, variable(rural_urbanBroad) min(0) max(1) 
file write tablecontent _n 

*Comorbidities (3 categories)
tabulatevariable, variable(preExistComorbCat) min(0) max(2) 
file write tablecontent _n 


file write tablecontent _n _n


file close tablecontent


* Close log file 
log close

