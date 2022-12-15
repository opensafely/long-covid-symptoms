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

CONTROLS = "output/input_covid_matched_matches_2019_allSTPs.csv"

# Import Variables 

## covariates not yet added i.e.: rural/urban, ethnicity, comorbidities
## all above relative to index date
from covariates_complete import generate_covariates_complete
covariates_complete= generate_covariates_complete(index_date_variable="case_index_date")

## outcome variables (note, relative to community COVID19 case (index) date)
from outcome_variables_diag import generate_outcome_variables_diag
outcome_variables_diag = generate_outcome_variables_diag(index_date_variable="case_index_date")


# Specify study definition

study = StudyDefinition(
    # configure the expectations framework
    default_expectations={
        "date": {"earliest": "1900-01-01", "latest": "today"},
        "rate": "uniform",
        "incidence" : 0.2
    },

     # select the study population
    population=patients.which_exist_in_file(CONTROLS), 

    # start of observation period (note, needs to be called index date)
    index_date="2019-02-01", # note should be ignored when using case_index_date 

    # get case index date from controls file
    case_index_date=patients.with_value_from_file(
        CONTROLS, 
        returning="case_index_date", 
        returning_type="date"), 

    # extract the NEW VARIABLES ONLY.
    # all other variables (that have already been extracted in the first extraction step) I will get by MERGING IN STATA
    # doing it this way as am uncomfortable about "reextracting" any variables that I have already extracted ((and performed checks)
    # for example, when I re-extracted, there there were some missing STPs and some sex categories other than M or F, despite these
    # being defined as required (for STP) or only M or F (for sex)

    

    # extract the new variables i.e. (1) covariates: ethnicity, rural_urban and comorbidities and (2) diagnoses (3) prev GP consultations
    # (symptoms are added by the next study definition)
    # COVARIATES  
    **covariates_complete, 

    # DIAGNOSES VARIABLES  
    **outcome_variables_diag, 


    # TIME-VARYING SELECTION VARIABLES
    ## Need to redo these as previously they were just assessed based upon index date 
    has_follow_up=patients.registered_with_one_practice_between(
        start_date="case_index_date - 3 months",
        end_date="case_index_date",
        return_expectations={"incidence": 0.95},
        ),

    ### died before case index date
    has_died=patients.died_from_any_cause(
      on_or_before="case_index_date",
      returning="binary_flag",
    ),

    ### died after case index date
    death_date=patients.died_from_any_cause(
        on_or_after="case_index_date",
        returning="date_of_death",
        date_format="YYYY-MM-DD", 
        return_expectations={
            "date": {
                "earliest": "2019-02-01",  
                "latest": "2021-05-11", }, 
                "incidence": 0.01 },
    ),

    ### deregistered after case index date
    dereg_date=patients.date_deregistered_from_all_supported_practices(
        on_or_after="case_index_date", date_format="YYYY-MM",
    ),
) 
