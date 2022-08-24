/*==============================================================================
DO FILE NAME:			1_longCovid_cr_combined_cases_contemporary_controls.do 
PROJECT:				Long COVID symptoms
DATE: 					23rd August 2022 
AUTHOR:					Kevin Wing adapted from R Mathur H Forbes, A Wong, A Schultze, C Rentsch,K Baskharan, E Williamson 										
DESCRIPTION OF FILE:	combines cases and matched comparator people and adds a variable that specifies whether case or not (and id of matched set)
						also performs a
DATASETS USED:			data in memory (from output/inputWithHHDependencies.csv)
DATASETS CREATED: 		none
OTHER OUTPUT: 			logfiles, printed to folder analysis/$logdir



sysdir set PLUS "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 
sysdir set PERSONAL "/Users/kw/Documents/GitHub/households-research/analysis/adofiles" 

							
==============================================================================*/
sysdir set PLUS ./analysis/adofiles
sysdir set PERSONAL ./analysis/adofiles
pwd


*first argument main W2 
/* code I don't need from hh analysis but might be useful at some point
local dataset `1' 
if "`dataset'"=="MAIN" local fileextension
else local fileextension "_`1'"
local inputfile "input`fileextension'.csv"

*Start dates
if "`dataset'"=="MAIN" global indexdate = "1/2/2020"
else if "`dataset'"=="W2" global indexdate = "1/9/2020"

*Censor dates
if "`dataset'"=="MAIN" global study_end_censor   	= "31/08/2020"
else if "`dataset'"=="W2" global study_end_censor   	= "31/01/2021"
*****have already performed a sensitivity/testing assumptions analysis up to 31/04/2021*******
***be ready to censor 2 weeks after vaccination also as a subsequent analysis*****
***also to consider: impact of wild-type vs alpha over time, is this an issue*****
*/

* Open a log file
cap log close
log using ./logs/01_longCovidSymp_cr_combined_cases_controls.log, replace t





/* ADD CASE STATUS AND MATCHED SET INFORMATION TO FILES===========================================================*/
import delimited ./output/input_complete_covid_communitycases.csv, clear

*just for dummy - need to make it so there are 2 STPS
replace stp="STP2" if _n>200


*import delimited ./output/input.csv, clear
import delimited ./output/`inputfile', clear

*merge with msoa data (copied from DGrint SGTF repo)
merge m:1 msoa using ./lookups/MSOA_lookup
drop if _merge==2
drop _merge





