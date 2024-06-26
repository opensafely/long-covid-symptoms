/*==============================================================================
DO FILE NAME:			09_longCovidSymp_cr_analysis_dataset.do
PROJECT:				Long covid symptoms
DATE: 					29th Aug 2022
AUTHOR:					Kevin Wing 										
DESCRIPTION OF FILE:	Creates a file containing the matched cases and comparators ready for analysis, and a file of the cases that could not be matched for descr analysis
DATASETS USED:			.csv
DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir

tg


sysdir set PLUS "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 
sysdir set PERSONAL "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 

							
==============================================================================*/
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
*globals of lists of diagnoses and symptoms etc
do ./analysis/masterLists.do
pwd

*setup so that the code in this file can be used to output analyses for both contemporary and historical comparators (and is called twice by separate .yaml actions)
local dataset `1'



* Open a log file
cap log close
log using ./logs/09_longCovidSymp_cr_`dataset'_analysis_dataset_omicron.log, replace t




*(0)=========Get total cases and potential matches figure for flowchart - extra bit of work in this file is to drop comparators without the necessary follow-up or who died before case index date============
/*Has follow-up needs checked as there is nowhere previously where it is checked against the matched cases case index date, plus the death_date variable for controls so far is only related to the
*index date, not the case_index_date*/
*case
capture noisily import delimited ./output/input_covid_communitycases_correctedCaseIndex_omicron.csv, clear
di "***********************FLOWCHART 1. NUMBER OF POTENTIAL CASES AND CONTROLS (WAVE 2)********************:"
di "**Potential cases:**"
count
*macro for flowhart output
local flow_1_cases=round(r(N),5) 

*comparator
capture noisily import delimited ./output/input_controls_`dataset'CorrectedDeathDate_omicron.csv, clear
di "**Potential comparators:**"
count
*macro for flowchart output
local flow_1_comparators=round(r(N),5) 

*Code to fix bug due to de_reg date error (eventually needs fixed by re-extraction)
*replace dereg_date=dereg_date + "-01" if dereg_date!=""

*see if I can select those who were (1) alive and (2) hadn't deregistered at the start of wave 2

foreach var of varlist dereg_date death_date {
	capture noisily confirm string variable `var'
	capture noisily rename `var' `var'_dstr
	capture noisily gen `var' = date(`var'_dstr, "YMD")
	capture noisily drop `var'_dstr
	capture noisily format `var' %td 
}


drop if dereg_date<date("15dec2021","DMY")
drop if death_date<date("15dec2021","DMY")

di "**Potential comparators who were alive and hadn't deregistered at the start of WAVE 4:**"
count
*macro for flowchart output
local flow_1_compReg=round(r(N),5)



*(1)=========Get all the (case and comparator related) variables from the matched cases and matched controls files============
*case
/*for cases the variables I want are: age, case, covid_hosp, covid_tpp_prob, covid_tpp_probw4, death_date, dereg_date, first_known_covid19, first_pos_test, first_pos_testw4, had_covid_hosp, has_died, has_follow_up, imd, match_counts, pos_covid_test_ever, set_id, sex, stp*/
capture noisily import delimited ./output/input_covid_matched_cases_`dataset'_allSTPs_omicron.csv, clear
keep patient_id age case covid_hosp covid_tpp_prob covid_tpp_probw4 death_date dereg_date first_known_covid19 first_pos_test first_pos_testw4 had_covid_hosp has_died has_follow_up imd match_counts pos_covid_test_ever set_id sex stp
tempfile cases_match_info_omicron
*for dummy data, should do nothing in the real data
duplicates drop patient_id, force
save `cases_match_info_omicron', replace
*NUMBER OF MATCHED CASES
safecount


*comparator
/*for comparator the variables I want are: age, case, covid_hosp, covid_tpp_prob, covid_tpp_probw4, first_known_covid19, first_pos_test, first_pos_testw4, imd, pos_covid_test_ever, set_id, sex, stp*/

/*
*DON'T NEED has_follow_up, has_died, death_date or dereg_date from the original file - these are all created new based on case_index_date in the new file
*/
capture noisily import delimited ./output/input_covid_matched_matches_`dataset'_allSTPs_omicron.csv, clear
keep patient_id age case covid_hosp covid_tpp_prob covid_tpp_probw4 first_known_covid19 first_pos_test first_pos_testw4 imd pos_covid_test_ever set_id sex stp
tempfile comp_match_info_omicron
*for dummy data, should do nothing in the real data
duplicates drop patient_id, force
save `comp_match_info_omicron', replace
*NUMBER OF MATCHED CONTROLS BEFORE DROPPING THOSE DUE TO FOLLOW-UP ISSUES RELATED TO CASE_INDEX_DATE (SEE BELOW)
safecount

*(1a)========Get the gp consultation count variables for cases and controls============
capture noisily import delimited ./output/input_gpconsultations_cases_omicron.csv, clear
safecount
keep patient_id gp_count_prevyear total_gp_count t1_gp_count t2_gp_count t3_gp_count
tempfile case_gp_count_omicron
save `case_gp_count_omicron'

capture noisily import delimited ./output/input_gpconsultations_controls_`dataset'_omicron.csv, clear
count
keep patient_id gp_count gp_count_prevyear total_gp_count t1_gp_count t2_gp_count t3_gp_count
tempfile control_gp_count_omicron
save `control_gp_count_omicron'



*(1b)========Get the symptom information for cases and controls============
capture noisily import delimited ./output/input_symptoms_cases_omicron.csv, clear
count
drop case_index_date
tempfile case_symptoms_omicron
save `case_symptoms_omicron'
capture noisily import delimited ./output/input_symptoms_controls_`dataset'_omicron.csv, clear
count
drop case_index_date
tempfile control_symptoms_omicron
save `control_symptoms_omicron'


*(1c)========Get the medicines information for cases and controls============
capture noisily import delimited ./output/input_medicines_cases_omicron.csv, clear
count
drop case_index_date
tempfile case_medicines_omicron
save `case_medicines_omicron'
capture noisily import delimited ./output/input_medicines_controls_`dataset'_omicron.csv, clear
count
drop case_index_date
tempfile control_medicines_omicron
save `control_medicines_omicron'


*(2)=========Add the case and comparator information from above to the files with the rest of the information============
*import matched cases with variables and merge with match variables - note that the "complete" cases file is applicable to both current- and historical- matched cases
capture noisily import delimited ./output/input_complete_covid_communitycases_omicron.csv, clear
 
*add match info
merge 1:1 patient_id using `cases_match_info_omicron'
keep if _merge==3
drop _merge
*add gp_count
merge 1:1 patient_id using `case_gp_count_omicron'
keep if _merge==3
drop _merge
*add symptoms
merge 1:1 patient_id using `case_symptoms_omicron'
keep if _merge==3
drop _merge
*add medicines
merge 1:1 patient_id using `case_medicines_omicron'
keep if _merge==3
drop _merge

tempfile cases_wVars_omicron
save `cases_wVars_omicron', replace
di "***********************FLOWCHART 2. NUMBER OF MATCHED CASES AND MATCHED COMPARATORS BEFORE DROPPING CONTROLS INELIGIBLE DUE TO HAS_FOLLOW_UP AND DEATH_DATE VARS********************:"
di "**Matched cases:**"
count
*macro for flowchart
local flow_2_matchedCases=round(r(N),5) 

*historical needed death dates fixed as some of the deaths post-follow-up could be before 01Feb2019, comtemporary didn't need this fixed again here as no deathdates were before this date
if "`1'"=="historical" {
	capture noisily import delimited ./output/input_complete_controls_`dataset'CorrectedDeathDate_omicron.csv, clear
}
else if "`1'"=="contemporary" {
	capture noisily import delimited ./output/input_complete_controls_`dataset'_omicron.csv, clear
}
*add match info
merge 1:1 patient_id using `comp_match_info_omicron'
keep if _merge==3
drop _merge
*add gp_count info
merge 1:1 patient_id using `control_gp_count_omicron'
keep if _merge==3
drop _merge
*add symptoms
merge 1:1 patient_id using `control_symptoms_omicron'
keep if _merge==3
drop _merge
tempfile comp_withVars_omicron
save `comp_withVars_omicron', replace
*add medicines
merge 1:1 patient_id using `control_medicines_omicron'
keep if _merge==3
drop _merge
tempfile comp_withVars_omicron
save `comp_withVars_omicron', replace
di "**Matched comparators:**"
count
*macro for flowchart
local flow_2_matchedComparators=round(r(N),5)


*NOTE: Flowchart re: who was dropped here due date exclusions can be obtained from the STP matching logs (if needed)


*(3)=========Append case and comparator files together, drop controls with required has follow up and tidy up, then check number as expected============
append using `cases_wVars_omicron', force
order patient_id set_id match_count case
gsort set_id -case
*drop any comparators that don't have sufficient follow up
count if case==0 & has_follow_up==0
drop if case==0 & has_follow_up==0
*drop any comparators who have has_died as 1
count if case==0 & has_died==1
drop if case==0 & has_died==1

*redo match_count variable after having done this
generate match_countsNew=.
order patient_id set_id match_counts match_countsNew case
by set_id: replace match_countsNew=_N-1
replace match_countsNew=. if case==0
drop match_counts
rename match_countsNew match_counts

*count then drop cases with no matches
count if match_counts==0
drop if match_counts==0
tab case
tab match_counts
di "***********************FLOWCHART 3. NUMBER OF MATCHED CASES AND MATCHED COMPARATORS: COMBINED FILE, AFTER DROPPING INELGIIBLE CONTROLS (AS ABOVE) AND CASES WITH MATCH_COUNTS==0********************:"
count
*macros for flowchart
local flow_3_totMatch=round(r(N),5)
count if case==1
local flow_3_totMatchCase=round(r(N),5)
count if case==0
local flow_3_totMatchComp=round(r(N),5)

*save a list of final cases for analysis unmatched cases in next bit
preserve
	keep if case==1
	keep patient_id
	tempfile final_matchedCases_list_omicron
	save `final_matchedCases_list_omicron', replace
restore



*(4)=========Create a file of unmatched cases for descriptive analysis============
*import list of all cases (pre-matching)
preserve
	capture noisily import delimited ./output/input_covid_communitycases_correctedCaseIndex_omicron.csv, clear
	*for dummy data, should do nothing in the real data
	duplicates drop patient_id, force
	tempfile origCaseList_omicron
	save `origCaseList_omicron', replace
	use `final_matchedCases_list_omicron', clear
	merge 1:1 patient_id using `origCaseList_omicron'
	*want to keep the ones not matched as they were in the original extract file but not in the list of matches
	keep if _merge==2
	safecount
	*save file for descriptive analysis
	save output/longCovidSymp_UnmatchedCases_`dataset'_analysis_dataset_omicron.dta, replace
	di "***********************FLOWCHART 4. NUMBER OF UMATCHED CASES FROM UNMATCHED CASES FILE (TO CONFIRM IT ALIGNS WITH THE ABOVE FLOWCHART POINTS)********************:"
	count
	*for flowchart macro
	local flow_4_unMatchedCases=round(r(N),5)
restore

*output flowchart table

cap file close tablecontent
file open tablecontent using ./output/flowchart_longCovidSymp_contemporary_omicron.txt, write text replace

file write tablecontent ("FLOWCHART `1'") _n _n
file write tablecontent ("Number of potential cases:") _tab ("`flow_1_cases'") _n
file write tablecontent ("Number of potential comparators:") _tab ("`flow_1_comparators'") _n
file write tablecontent ("Number of potential comparators who were alive and hadn't deregistered at start of wave 4:") _tab ("`flow_1_compReg'") _n
file write tablecontent ("Number of matched cases before dropping comparators ineligible due to has_follow_up and death_date_vars:") _tab ("`flow_2_matchedCases'") _n
file write tablecontent ("Number of matched comparators before dropping comparators ineligible due to has_follow_up and death_date_vars:") _tab ("`flow_2_matchedComparators'") _n
file write tablecontent ("Number of people after dropping ineligible comparators (as above) and cases with no matches:") _tab ("`flow_3_totMatch'") _n
file write tablecontent ("Number of cases after dropping ineligible comparators (as above) and cases with no matches:") _tab ("`flow_3_totMatchCase'") _n
file write tablecontent ("Number of comparators after dropping ineligible comparators (as above) and cases with no matches:") _tab ("`flow_3_totMatchComp'") _n
file write tablecontent ("Number of unmatched cases from unmatched cases file (to check with above):") _tab ("`flow_4_unMatchedCases'") _n

file close tablecontent



*(5)=========VARIABLE CLEANING============

*label case variables
label define case 0 "Comparator (contemporary)" ///
				  1 "Case"
label values case case
safetab case 

*(a)===Ethnicity (5 category)====
* Ethnicity (5 category)
replace ethnicity = . if ethnicity==.
label define ethnicity 	1 "White"  					///
						2 "Mixed" 					///
						3 "Asian or Asian British"	///
						4 "Black"  					///
						5 "Other"					
						
label values ethnicity ethnicity
safetab ethnicity

 *re-order ethnicity
 gen eth5=1 if ethnicity==1
 replace eth5=2 if ethnicity==3
 replace eth5=3 if ethnicity==4
 replace eth5=4 if ethnicity==2
 replace eth5=5 if ethnicity==5
 replace eth5=. if ethnicity==.

 label define eth5 			1 "White"  					///
							2 "South Asian"				///						
							3 "Black"  					///
							4 "Mixed"					///
							5 "Other"					
					
label values eth5 eth5
safetab eth5, m

*create an ethnicity for table 1 (includes unknown)
*ETHNICITY
*create an ethnicity variable with missing shown as "Unknown" just for this analysis
generate eth5Table1=eth5
replace eth5Table1=6 if eth5Table1==.
label define eth5Table1 			1 "White"  					///
									2 "South Asian"				///						
									3 "Black"  					///
									4 "Mixed"					///
									5 "Other"					///
									6 "Unknown"
					
label values eth5Table1 eth5Table1
safetab eth5Table1, m


* Ethnicity (16 category)
replace ethnicity_16 = . if ethnicity==.
label define ethnicity_16 									///
						1 "British or Mixed British" 		///
						2 "Irish" 							///
						3 "Other White" 					///
						4 "White + Black Caribbean" 		///
						5 "White + Black African"			///
						6 "White + Asian" 					///
 						7 "Other mixed" 					///
						8 "Indian or British Indian" 		///
						9 "Pakistani or British Pakistani" 	///
						10 "Bangladeshi or British Bangladeshi" ///
						11 "Other Asian" 					///
						12 "Caribbean" 						///
						13 "African" 						///
						14 "Other Black" 					///
						15 "Chinese" 						///
						16 "Other" 							
						
label values ethnicity_16 ethnicity_16
safetab ethnicity_16,m

* Ethnicity (16 category grouped further)
* Generate a version of the full breakdown with mixed in one group
gen eth16 = ethnicity_16
recode eth16 4/7 = 99
recode eth16 11 = 16
recode eth16 14 = 16
recode eth16 8 = 4
recode eth16 9 = 5
recode eth16 10 = 6
recode eth16 12 = 7
recode eth16 13 = 8
recode eth16 15 = 9
recode eth16 99 = 10
recode eth16 16 = 11

label define eth16 	///
						1 "British" ///
						2 "Irish" ///
						3 "Other White" ///
						4 "Indian" ///
						5 "Pakistani" ///
						6 "Bangladeshi" ///					
						7 "Caribbean" ///
						8 "African" ///
						9 "Chinese" ///
						10 "All mixed" ///
						11 "All Other" 
label values eth16 eth16
safetab eth16,m


*(a2)GP consultation covariates
*previous gp_count categorised as 0, 1-5, 6+
egen gpCountPrevYearCat=cut(gp_count_prevyear), at (0, 1, 6, 100000)
recode gpCountPrevYearCat 0=0 1=1 6=2
label define gpCountPrevYearCat 0 "0" 1 "1-5" 2 "6+"
label values gpCountPrevYearCat gpCountPrevYearCat
safetab gpCountPrevYearCat, miss
la var gpCountPrevYearCat "Categorised number of GP appts in year prior to COVID-19 diagnosis"
*create alternative previous consultations variable where the lowest category is 1
egen gpCountPrevYearSENS=cut(gp_count_prevyear), at (1, 2, 6, 100000)
la var gpCountPrevYearSENS "Sens analysis: num of GP appts in yr prior to COVID-19 diagnosis"
recode gpCountPrevYearSENS 1=0 2=1 6=2
label define gpCountPrevYearSENS 0 "1" 1 "2-5" 2 "6+"
label values gpCountPrevYearSENS gpCountPrevYearSENS
safetab gpCountPrevYearSENS, miss
safetab gpCountPrevYearSENS gpCountPrevYearCat, miss
*label gp count outcome variables
la var total_gp_count "Num of gp conslts during all post-COVID follow-up"
la var t1_gp_count "Num of gp conslts during 4-12 wk post-COVID"
la var t2_gp_count "Num of gp conslts during 12 wk - 6 mo post-COVID"
la var t3_gp_count "Num of gp conslts during 6 mo - 1 yr post-COVID"
*create gp count outcome categorical variables
*overall
egen total_gp_countCat=cut(total_gp_count), at (0, 1, 6, 100000)
recode total_gp_countCat 0=0 1=1 6=2
label define total_gp_countCat 0 "0" 1 "1-5" 2 "6+"
label values total_gp_countCat total_gp_countCat
safetab total_gp_countCat, miss
la var total_gp_countCat "Num of gp conslts during all post-COVID follow-up"
*time period 1
egen t1_gp_countCat=cut(t1_gp_count), at (0, 1, 3, 100000)
recode t1_gp_countCat 0=0 1=1 3=2
label define t1_gp_countCat 0 "0" 1 "1-2" 2 "3+"
label values t1_gp_countCat t1_gp_countCat
safetab t1_gp_countCat, miss
la var t1_gp_countCat "Num of gp conslts during 4 wk - 12 wk post-COVID"
*time period 2
egen t2_gp_countCat=cut(t2_gp_count), at (0, 1, 3, 100000)
recode t2_gp_countCat 0=0 1=1 3=2
label define t2_gp_countCat 0 "0" 1 "1-2" 2 "3+"
label values t2_gp_countCat t2_gp_countCat
safetab t2_gp_countCat, miss
la var t2_gp_countCat "Num of gp conslts during 6 mo - 1 yr post-COVID"
*time period 2
egen t3_gp_countCat=cut(t3_gp_count), at (0, 1, 3, 100000)
recode t3_gp_countCat 0=0 1=1 3=2
label define t3_gp_countCat 0 "0" 1 "1-2" 2 "3+"
label values t3_gp_countCat t3_gp_countCat
safetab t3_gp_countCat, miss
la var t3_gp_countCat "Num of gp conslts during 6 mo - 1 yr post-COVID"





*(b)===STP====
*For ease of future analysis(?) am going to recode these as numerical ordered at this stage, also drop if STP is missing
rename stp stp_old
bysort stp_old: gen stp = 1 if _n==1
replace stp = sum(stp)
drop stp_old



*(c)===IMD===
* Reverse the order (so high is more deprived)
tab imd
recode imd 5 = 1 4 = 2 3 = 3 2 = 4 1 = 5 .u = .u

label define imd 1 "1 least deprived" 2 "2" 3 "3" 4 "4" 5 "5 most deprived" .u "Unknown"
label values imd imd
*check after reordering
tab imd




*(d)===Categorical age - 2 versions===
*age categorised with children split up
egen ageCat=cut(age), at (0, 3, 6, 12, 18, 40, 50, 60, 70, 80, 200)
recode ageCat 0=0 3=1 6=2 12=3 18=4 40=5 50=6 60=7 70=8 80=9
label define ageCat 0 "0-2" 1 "3-5" 2 "6-11" 3 "12-17" 4 "18-39" 5 "40-49" 6 "50-59" 7 "60-69" 8 "70-79" 9 "80+"
label values ageCat ageCat
safetab ageCat, miss
la var ageCat "Age categorised"

*age categorised with children combined
egen ageCatChildCombined=cut(age), at (0, 18, 40, 50, 60, 70, 80, 200)
recode ageCatChildCombined 0=0 18=1 40=2 50=3 60=4 70=5 80=6
label define ageCatChildCombined 0 "<18" 1 "18-39" 2 "40-49" 3 "50-59" 4 "60-69" 5 "70-79" 6 "80+"
label values ageCatChildCombined ageCatChildCombined
safetab ageCatChildCombined, miss
la var ageCatChildCombined "Age categorised (children combined)"


*(e)===Rural-urban===
*label the urban rural categories
replace rural_urban=. if rural_urban<1|rural_urban>8
label define rural_urban 1 "urban major conurbation" ///
							  2 "urban minor conurbation" ///
							  3 "urban city and town" ///
							  4 "urban city and town in a sparse setting" ///
							  5 "rural town and fringe" ///
							  6 "rural town and fringe in a sparse setting" ///
							  7 "rural village and dispersed" ///
							  8 "rural village and dispersed in a sparse setting"
label values rural_urban rural_urban
safetab rural_urban, miss

*create a 4 category rural urban variable based upon meeting with Roz 21st October
generate rural_urbanFive=.
la var rural_urbanFive "Rural Urban in five categories"
replace rural_urbanFive=1 if rural_urban==1
replace rural_urbanFive=2 if rural_urban==2
replace rural_urbanFive=3 if rural_urban==3|rural_urban==4
replace rural_urbanFive=4 if rural_urban==5|rural_urban==6
replace rural_urbanFive=5 if rural_urban==7|rural_urban==8
label define rural_urbanFive 1 "Urban major conurbation" 2 "Urban minor conurbation" 3 "Urban city and town" 4 "Rural town and fringe" 5 "Rural village and dispersed"
label values rural_urbanFive rural_urbanFive
safetab rural_urbanFive, miss

*generate a binary rural urban (with missing assigned to urban)
generate rural_urbanBroad=.
replace rural_urbanBroad=1 if rural_urban<=4|rural_urban==.
replace rural_urbanBroad=0 if rural_urban>4 & rural_urban!=.
label define rural_urbanBroad 0 "Rural" 1 "Urban"
label values rural_urbanBroad rural_urbanBroad
safetab rural_urbanBroad rural_urban, miss
label var rural_urbanBroad "Rural-Urban"




*(e)===Pre-existing clinical comorbidities and precribing in the previous year===
*number of broad diagnostic categories containing records in the one year before COVID-19 (or matched date)
order patient_id case_index_date $comorbs
egen numPreExistingComorbs=rowtotal(comorb_infection_or_parasite-comorb_injury_poisoning)
*have a look at this
sum numPreExistingComorbs, detail
la var numPreExistingComorbs "Number of comorbidities diagnosed in prev yr"
*for now create a category with 0, 1, 2+
egen preExistComorbCat=cut(numPreExistingComorbs), at (0, 1, 2, 200) 
label define preExistComorbCat 0 "0" 1 "1" 2 "2+"
label values preExistComorbCat preExistComorbCat
safetab preExistComorbCat, miss
la var preExistComorbCat "Number of comorbidities diagnosed in prev yr"

*number of distinct bnf group prescriptions in the one year before COVID-19 (or matched date)
order patient_id case_index_date $prevMedicines
egen numPrescTypesPrevYear=rowtotal(prev_bnf_gastro_broad-prev_bnf_anxiolytic_spec)
*have a look at this
sum numPrescTypesPrevYear, detail
la var numPrescTypesPrevYear "Number of types of distinct BNF groups of drugs prescribed in prev year"
*for now create a category with 0, 1, 2+
egen numPrescTypesPrevYearCat=cut(numPrescTypesPrevYear), at (0, 1, 3, 200) 
recode numPrescTypesPrevYearCat 3=2
label define numPrescTypesPrevYearCat 0 "0" 1 "1-2" 2 "3+"
label values numPrescTypesPrevYearCat numPrescTypesPrevYearCat
safetab numPrescTypesPrevYearCat, miss
la var numPrescTypesPrevYearCat "Number of types of distinct BNF groups of drugs prescribed in prev year"


*Code to fix bug due to de_reg date error (eventually needs fixed by re-extraction)
*replace dereg_date=dereg_date + "-01" if dereg_date!="" & case==0


*(f) Recode all dates from the strings 
*order variables to make for loop quicker (remember the plain diag and symp named variables contain dates)
order patient_id case_index_date first_pos_test first_pos_testw4 covid_tpp_prob covid_tpp_probw4 covid_hosp pos_covid_test_ever death_date dereg_date first_known_covid19 $diag $symp
*have to rename some variables here as too long
foreach var of varlist case_index_date - first_known_covid19 $diag $symp $medicines {
	capture noisily confirm string variable `var'
	capture noisily rename `var' `var'_dstr
	capture noisily gen `var' = date(`var'_dstr, "YMD")
	capture noisily drop `var'_dstr
	capture noisily format `var' %td 
}

*(f2)Create variables for each outcome that are "EVER HAD"
/*incorrect, as this is date until end of follow-up!
foreach var of varlist $diag $symp {
	generate tEver_`var'=0
	replace tEver_`var'=1 if `var'!=.
} 
*/

foreach var of varlist $diag $symp $medicines {
	generate tEver_`var'=0
	replace tEver_`var'=1 if t1_`var'==1 | t2_`var'==1 |  t3_`var'==1
} 

*delirium!!!!
generate tEver_symp_delirium=0
replace tEver_symp_delirium=1 if t1_symp_delirium==1 | t2_symp_delirium==1 |  t3_symp_delirium==1
label variable tEver_symp_delirium "tEver_symp_delirium"
label variable t1_symp_delirium "t1_symp_delirium"
label variable t2_symp_delirium "t2_symp_delirium"
label variable t3_symp_delirium "t3_symp_delirium"


*create a variable that defines whether a person had ANY symptoms ever over followup
generate sympCounter=0
foreach var of varlist $symp {
	replace sympCounter=sympCounter+tEver_`var'
} 
generate anySymptomsEver=0
replace anySymptomsEver=1 if sympCounter>0
*repeat by each time period
forvalues i=1/3 {
	generate t`i'SympCounter=0
	foreach var of varlist $symp {
		replace t`i'SympCounter=t`i'SympCounter+t`i'_`var'
	} 
	generate t`i'_anySymptomsEver=0
	replace t`i'_anySymptomsEver=1 if t`i'SympCounter>0
	la var t`i'_anySymptomsEver "t`i'_anySymptomsEver"
	drop t`i'SympCounter
}





*create variable names
foreach var of varlist $diag $symp $medicines {
	label variable tEver_`var' "tEver_`var'"
	label variable t1_`var' "t1_`var'"
	label variable t2_`var' "t2_`var'"
	label variable t3_`var' "t3_`var'"
} 
la var sympCounter "Total number of types of symptoms"
label variable anySymptomsEver "Had at least one symptom during entire follow-up"


*****CREATE THE SUNBURST PLOT VARIABLES*****
*(A) THREE TIME PERIODS
*first, create variables that select people who had NO symptoms for each of the three time periods
forvalues i=1/3 {
	generate t`i'_sympCounter=0
	foreach var of varlist $symp {
		replace t`i'_sympCounter=t`i'_sympCounter+t`i'_`var'
	}
	generate t`i'_noSymptoms=1
	la var t`i'_noSymptoms "t`i'_noSymptoms"
	replace t`i'_noSymptoms=0 if t`i'_sympCounter>0
	drop t`i'_sympCounter
}

*then, setup broad symptom categories and mark who had any of these for each timeperiod
*first loop loops through each of the high level categories
foreach a of global highLevelSymp  {
	display "`a'"
	*second loop loops through time periods
	forvalues i=1/3 {
		generate t`i'_`a'Counter=0
		*final loop loops through each symptom of the high level category and adds one to counter if the symptom was present during that time period
		foreach var of varlist $`a' {
			replace t`i'_`a'Counter=t`i'_`a'Counter+t`i'_`var'
		}
		generate t`i'_`a'=0
		replace t`i'_`a'=1 if t`i'_`a'Counter>0
		la var t`i'_`a' "t`i'_`a'"
	}
}



*(B) TWO TIME PERIODS (FIRST TWO TIME PERIODS COMBINED)
*create a combined t1-t2 for each symptom
foreach var of varlist $symp {
	generate t1t2_`var'=0
	replace t1t2_`var'=1 if t1_`var'|t1_`var'==1
}

*then, create variables that select people who had NO symptoms for the combined t1t2 group
generate t1t2_sympCounter=0
foreach var of varlist $symp {
	replace t1t2_sympCounter=t1t2_sympCounter+t1t2_`var'
}
generate t1t2_noSymptoms=1
la var t1t2_noSymptoms "t1t2_noSymptoms"
replace t1t2_noSymptoms=0 if t1t2_sympCounter>0
drop t1t2_sympCounter

*then, setup broad symptom categories and mark who had any of these for each timeperiod
*first loop loops through each of the high level categories
foreach a of global highLevelSymp  {
	display "`a'"
	generate t1t2_`a'Counter=0
	*final loop loops through each symptom of the high level category and adds one to counter if the symptom was present during that time period
	foreach var of varlist $`a' {
		replace t1t2_`a'Counter=t1t2_`a'Counter+t1t2_`var'
	}
	generate t1t2_`a'=0
	replace t1t2_`a'=1 if t1t2_`a'Counter>0
	la var t1t2_`a' "t1t2_`a'"
}






*(g) Sex
rename sex sexOrig
gen sex = 1 if sexOrig == "M"
replace sex = 0 if sexOrig == "F"
replace sex =. if sexOrig=="I"
replace sex =. if sexOrig=="U"
label define sex 0"Female" 1"Male"
label values sex sex
safetab sex
safecount
drop sexOrig


*(h)Flag comparators who have a known covid date that is within the follow up period
generate compBecameCaseEver=0 if case==0
replace compBecameCaseEver=1 if first_known_covid19>(case_index_date) & first_known_covid19<=(date("31mar2023","DMY")) & case==0
la var compBecameCaseEver "comparator who had COVID anytime during follow-up"
generate compBecameCaseDurFUP1=0 if case==0
replace compBecameCaseDurFUP1=1 if first_known_covid19>(case_index_date) & first_known_covid19<=(case_index_date + 85) & case==0
la var compBecameCaseDurFUP1 "comparator who had COVID during FUP period 1"
generate compBecameCaseDurFUP2=0 if case==0
replace compBecameCaseDurFUP2=1 if first_known_covid19>(case_index_date + 85) & first_known_covid19<=(case_index_date + 180) & case==0
la var compBecameCaseDurFUP2 "comparator who had COVID during FUP period 2"
generate compBecameCaseDurFUP3=0 if case==0
replace  compBecameCaseDurFUP3=1 if first_known_covid19>(case_index_date + 180) & first_known_covid19<=(date("31mar2023","DMY")) & case==0 & first_known_covid19!=.
la var compBecameCaseDurFUP3 "comparator who had COVID during FUP period 3"


*(i)Flag cases who are hospitalised with COVID after the start of follow-up, and which period this was in
generate caseHospForCOVIDEver=0 if case==1
replace caseHospForCOVIDEver=1 if covid_hosp>(case_index_date) & covid_hosp<=(date("31mar2023","DMY")) & case==1
la var caseHospForCOVIDEver "case who was hospitalised for COVID anytime during follow-up"
generate caseHospForCOVIDDurFUP1=0 if case==1
replace caseHospForCOVIDDurFUP1=1 if covid_hosp>(case_index_date) & covid_hosp<=(case_index_date + 85) & case==1
la var caseHospForCOVIDDurFUP1 "case who was hospitalised for COVID during FUP period 1"
generate caseHospForCOVIDDurFUP2=0 if case==1
replace caseHospForCOVIDDurFUP2=1 if covid_hosp>(case_index_date + 85) & covid_hosp<=(case_index_date + 180) & case==1
la var caseHospForCOVIDDurFUP2 "case who was hospitalised for COVID during FUP period 2"
generate caseHospForCOVIDDurFUP3=0 if case==1
replace caseHospForCOVIDDurFUP3=1 if covid_hosp>(case_index_date + 180) & covid_hosp<=(date("31mar2023","DMY")) & case==1
la var caseHospForCOVIDDurFUP3 "case who was hospitalised for COVID during FUP period 3"


*(j)Flag anyone who died during follow-up, and which period this was in
generate diedEver=0
replace diedEver=1 if death_date>(case_index_date) & death_date<=(date("31mar2023","DMY"))
la var diedEver "died anytime during follow-up"
generate diedDuringFUP1=0
replace diedDuringFUP1=1 if death_date>(case_index_date) & death_date<=(case_index_date + 85)
la var diedDuringFUP1 "died during FUP period 1"
generate diedDuringFUP2=0
replace diedDuringFUP2=1 if death_date>(case_index_date + 85) & death_date<=(case_index_date + 180)
la var diedDuringFUP2 "died during FUP period 2"
generate diedDuringFUP3=0
replace diedDuringFUP3=1 if death_date>(case_index_date + 180) & death_date<=(date("31mar2023","DMY"))
la var caseHospForCOVIDDurFUP3 "died during FUP period 3"


*(k)Flag anyone who deregistered during follow-up, and which period this was in
generate deregEver=0
replace deregEver=1 if dereg_date>(case_index_date) & dereg_date<=(date("31mar2023","DMY"))
la var deregEver "dereg anytime during follow-up"
generate deregDuringFUP1=0
replace deregDuringFUP1=1 if dereg_date>(case_index_date) & dereg_date<=(case_index_date + 85)
la var deregDuringFUP1 "dereg during FUP period 1"
generate deregDuringFUP2=0
replace deregDuringFUP2=1 if dereg_date>(case_index_date + 85) & dereg_date<=(case_index_date + 180)
la var deregDuringFUP2 "died during FUP period 2"
generate deregDuringFUP3=0
replace deregDuringFUP3=1 if dereg_date>(case_index_date + 180) & dereg_date<=(date("31mar2023","DMY"))
la var deregDuringFUP3 "died during FUP period 3"


*(l)Flag individuals who became ineligible in a specific time period due to any of the above being coded as 1
*(0)Became ineligible ever
generate becameIneligEver=0
replace becameIneligEver=1 if compBecameCaseEver==1 | caseHospForCOVIDEver==1 | diedEver==1 | deregEver==1
la var becameIneligEver "Became ineligible at any point during follow-up"
*(1)Became ineligible in FUP1
generate becameIneligFUP1=0
replace becameIneligFUP1=1 if compBecameCaseDurFUP1==1 | caseHospForCOVIDDurFUP1==1 | diedDuringFUP1==1 | deregDuringFUP1==1
la var becameIneligFUP1 "Became ineligible during FUP1"
*(2)Became ineligible in FUP2
generate becameIneligFUP2=0
replace becameIneligFUP2=1 if compBecameCaseDurFUP2==1 | caseHospForCOVIDDurFUP2==1 | diedDuringFUP2==1 | deregDuringFUP2==1
la var becameIneligFUP2 "Became ineligible during FUP2"
*(3)Became ineligible in FUP3
generate becameIneligFUP3=0
replace becameIneligFUP3=1 if compBecameCaseDurFUP3==1 | caseHospForCOVIDDurFUP3==1 | diedDuringFUP3==1 | deregDuringFUP3==1
la var becameIneligFUP3 "Became ineligible during FUP3"


	

*save final file
save ./output/longCovidSymp_analysis_dataset_`dataset'_omicron.dta, replace
*save a version that contains only the patient_ids and removes duplicates (for correcting imd and any other covariates assessed independent of case index date)
duplicates drop patient_id, force
keep patient_id
capture noisily export delimited using "./output/longCovidSymp_analysis_dataset_`dataset'_omicron.csv", replace



log close



