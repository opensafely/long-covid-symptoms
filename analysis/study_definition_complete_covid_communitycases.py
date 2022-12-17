# Import necessary functions
from cohortextractor import (
    StudyDefinition,
    patients,
    codelist_from_csv,
    codelist,
    filter_codes_by_category,
    combine_codelists
)

# Import all codelists
from codelists import *

# Import the required data 

CASES = "output/input_covid_matched_cases_allSTPs.csv"

# Import Variables 


## covariates not yet added i.e.: rural/urban, ethnicity, comorbidities
## all above relative to index date
from covariates_complete import generate_covariates_complete
covariates_complete= generate_covariates_complete(index_date_variable="case_index_date")

## outcome variables (note, relative to community COVID19 case (index) date)
from outcome_variables_diag_contemporary import generate_outcome_variables_diag_contemporary
outcome_variables_diag_contemporary = generate_outcome_variables_diag_contemporary(index_date_variable="case_index_date")


# Specify study definition

study = StudyDefinition(
    # configure the expectations framework
    default_expectations={
        "date": {"earliest": "1900-01-01", "latest": "today"},
        "rate": "uniform",
        "incidence" : 0.2
    },

     # select the study population
    population=patients.which_exist_in_file(CASES), 

    # start of observation period (note, needs to be called index date)
    index_date="2020-02-01", # note should be ignored when using case_index_date 

    # get case index date from original file
    case_index_date=patients.with_value_from_file(
        CASES, 
        returning="case_index_date", 
        returning_type="date"), 

    # extract the NEW VARIABLES ONLY.
    # all other variables (that have already been extracted in the first extraction step) I will get by MERGING IN STATA
    # doing it this way as am uncomfortable about "reextracting" any variables that I have already extracted ((and performed checks)
    # for example, when I re-extracted, there there were some missing STPs and some sex categories other than M or F, despite these
    # being defined as required (for STP) or only M or F (for sex)

    

    # extract the new variables i.e. (1) covariates: ethnicity, rural_urban and comorbidities and (2) outcomes based on case index date
    # COVARIATES  
    **covariates_complete, 

    # OUTCOME VARIABLES FOR DIAGNOSES 
    **outcome_variables_diag_contemporary,  


) 
