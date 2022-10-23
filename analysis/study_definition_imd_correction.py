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

CASESANDCONTROLS = "output/longCovidSymp_analysis_dataset_contemporary.csv"

# Import Variables 


## covariates not yet added i.e.: rural/urban, ethnicity, comorbidities
## all above relative to index date
from covariates_selection import generate_covariates_selection
covariates_selection= generate_covariates_selection(index_date_variable="case_index_date")


# Specify study definition

study = StudyDefinition(
    # configure the expectations framework
    default_expectations={
        "date": {"earliest": "1900-01-01", "latest": "today"},
        "rate": "uniform",
        "incidence" : 0.2
    },

     # select the study population
    population=patients.which_exist_in_file(CASESANDCONTROLS), 

    # start of observation period (note, needs to be called index date)
    index_date="2020-02-01", # note should be ignored when using case_index_date 


    # extract the NEW VARIABLES ONLY.
    # all other variables (that have already been extracted in the first extraction step) I will get by MERGING IN STATA
    # doing it this way as am uncomfortable about "reextracting" any variables that I have already extracted ((and performed checks)
    # for example, when I re-extracted, there there were some missing STPs and some sex categories other than M or F, despite these
    # being defined as required (for STP) or only M or F (for sex)

    

    # want to extract as there was a mistake in coding of IMD which needs fixed
    # COVARIATES  
    **covariates_selection, 
 

) 
