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

## covid19 variables 
from covid19_variables import generate_covid19_variables
covid19_variables = generate_covid19_variables(index_date_variable="index_date")

## matching variables 
from matching_variables import generate_matching_variables
matching_variables = generate_matching_variables(index_date_variable="index_date")

## covariates: age, sex, region we already have a matching variables, need IMD, ethnicity, rural/urban, pre-existing comorbidity (although this comes from outcome vars)
## (note, all above relative to community COVID19 case (index) date)
from covariates import generate_covariates
covariates = generate_covariates(index_date_variable="index_date")

## outcome variables (note, relative to community COVID19 case (index) date)
from outcome_variables import generate_outcome_variables
outcome_variables = generate_outcome_variables(index_date_variable="index_date")

# Specify study definition

study = StudyDefinition(
    # configure the expectations framework
    default_expectations={
        "date": {"earliest": "1980-01-01", "latest": "today"},
        "rate": "uniform",
        "incidence" : 0.2
    },

    # start of observation period i.e. start of wave 1 (note, needs to be called index date)
    index_date="2020-02-01", 

     # select the study population
     # after trying to run matching for all regions and it taking 5 days without finishing, here are trying just 1 region on its own
     # for all development work going to use just one region - E54000043, which has 10,941 records in it
    

    population=patients.satisfying(
        """
        (age <=110) 
        AND (sex = "M" OR sex = "F") 
        AND imd > 0 
        AND has_follow_up
        AND NOT covid_hospital
        AND NOT has_died 
        AND NOT stp = ""
        AND stp ="E54000043"
        """,
    ),   

    
    # COVID19 VARIABLES
    **covid19_variables, 

    # define the case index date - first of positive test or primary care diagnosis after wave 1
    # to keep this manageable re: matching, I'd like cases to only be selected from within wave 1
    case_index_date=patients.minimum_of("first_positive_test_dateW2", "covid_tpp_probableW2"),

    # MATCHING VARIABLES  
    **matching_variables, 

    # COVARIATES  
    **covariates, 

    # Uncomment when have updated our own outcome variables
    # OUTCOME VARIABLES  
    **outcome_variables, 

    # SELECTION VARIABLES 
    ### sex 
    sex=patients.sex(
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"M": 0.49, "F": 0.51}},
        }
    ),


    # TIME-VARYING SELECTION VARIABLES
    ## These variables are EITHER 1) defined within a specific time frame relative to the patient case date 
    ## OR 2) defined as before/after/on the patient case date, but they return something other than a date 
    ## For controls, they need to be extracted and applied after matching as controls are assigned the patient case date 
    ## It is most efficient to extract these separately for exposed and controls, as they are not needed for the controls yet,
    ## and we don't want to spend time matching ineligble exposed people  

    ### has 3 months of of baseline time
    ## Note that CASE_INDEX_DATE is defined in the covid19_variables files and is the earliest of first positive test or first probable diagnosis in W2
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

    ### died after case index date (extracted as used as a matching variable, so needs to exist)
    death_date=patients.died_from_any_cause(
        on_or_after="case_index_date",
        returning="date_of_death",
        date_format="YYYY-MM-DD", 
        return_expectations={
            "date": {
                "earliest": "2020-02-01",  
                "latest": "2021-01-31", }, 
                "incidence": 0.01 },
    ),

    ### deregistered after case index date (extracted as used as a matching variable, so needs to exist)
    dereg_date=patients.date_deregistered_from_all_supported_practices(
        on_or_after="case_index_date", date_format="YYYY-MM",
    ),

) 











