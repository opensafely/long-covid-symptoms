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

# Import Variables 

## COVID19 variables 
from covid19_variables import generate_covid19_variables
covid19_variables = generate_covid19_variables(index_date_variable="index_date")

## matching variables 
from matching_variables import generate_matching_variables
matching_variables = generate_matching_variables(index_date_variable="index_date")

## covariates required for selection: age, imd, sex (and region but data management is stratified on this)
## all above relative to index date
from covariates_selection import generate_covariates_selection
covariates_selection= generate_covariates_selection(index_date_variable="index_date")

## outcome variables (note, relative to community COVID19 case (index) date)
#from outcome_variables import generate_outcome_variables
#outcome_variables = generate_outcome_variables(index_date_variable="index_date")

# Specify study definition

study = StudyDefinition(
    # configure the expectations framework
    default_expectations={
        "date": {"earliest": "1980-01-01", "latest": "today"},
        "rate": "uniform",
        "incidence" : 0.2
    },

    # start of observation period i.e. year before start of wave 1 (note, needs to be called index date)
    index_date="2018-02-01", 

     # select the study population
     # note that this is the POOL of potential unexposed concurrent controls 
     # criteria relevant to their index dates, is determined in the matching action 
     # after trying to run matching for all regions in wave 2 and it taking 5 days without finishing, here are trying just 1 region on its own

    population=patients.satisfying(
        """
        (age <=110) 
        AND (sex = "M" OR sex = "F") 
        AND imd > 0 
        AND NOT has_died
        AND NOT stp = ""
        """,
    ),
    
    # COVID19_variables 
    **covid19_variables, 

    # MATCHING VARIABLES  
    **matching_variables, 

    # DEMOG COVARIATES  
    **covariates_selection, 


    # TIME-VARYING SELECTION VARIABLES - THESE ARE JUST TO MAKE THE COHORT SMALLER AT THIS STAGE, BUT DEATH AND HOSP IS CHECKED AGAIN AT MATCHING
    ## These variables are EITHER 1) defined within a specific time frame relative to the patient vaccination date 
    ## OR 2) defined as before/after/on the patient vaccination date, but they return something other than a date 
    ## For controls, they need to be extracted and applied after matching as controls are assigned the patient vaccination date 
    ## It is most efficient to extract these separately for exposed and controls, as they are not needed for the controls yet,
    ## and we don't want to spend time matching ineligble exposed people  

    ## For the controls, the only criteria that can be applied before the assignment of the case index date is age, sex,  death and dereg criteria 

    has_died=patients.died_from_any_cause(
     on_or_before="index_date",
         returning="binary_flag",
         date_format="YYYY-MM-DD", 
     ),

    death_date=patients.died_from_any_cause(
        on_or_after="index_date",
        returning="date_of_death",
        date_format="YYYY-MM-DD", 
        return_expectations={
            "date": {
                "earliest": "2020-12-08",  
                "latest": "2021-05-11", }, 
                "incidence": 0.01 },
    ),

    dereg_date=patients.date_deregistered_from_all_supported_practices(
        on_or_after="index_date", date_format="YYYY-MM",
    ),

) 











