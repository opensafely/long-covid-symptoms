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

## vaccine variables (Anna's code, can delete eventually)
# from vaccine_variables import generate_vaccine_variables
# vaccine_variables = generate_vaccine_variables(index_date_variable="index_date")

## matching variables 
from matching_variables import generate_matching_variables
matching_variables = generate_matching_variables(index_date_variable="index_date")

## Anna's code, will uncomment when we've added our own confounding variables
## confounding variables (note, relative to community COVID19 case (index) date)
## from confounding_variables import generate_confounding_variables
## confounding_variables = generate_confounding_variables(index_date_variable="case_index_date")

## Anna's code, will uncomment when we've added our own outcome variables
## outcome variables (note, relative to community COVID19 case (index) date)
## from outcome_variables import generate_outcome_variables
## outcome_variables = generate_outcome_variables(index_date_variable="case_index_date")

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
     # after trying to run matching for all regions in wave 2 and it taking 5 days without finishing, here are trying just 1 region on its own

    population=patients.satisfying(
        """
        (age <=110) 
        AND (sex = "M" OR sex = "F") 
        AND known_care_home 
        AND imd > 0 
        AND has_follow_up
        AND NOT covid_hospital
        AND NOT has_died 
        AND NOT stp = ""
        AND stp = "STP1"
        """,
    ),   

    
    # COVID19 VARIABLES  
    **covid19_variables, 

    
    # VACCINATION VARIABLES  (from Anna's old code)
    #  **vaccine_variables, 


    # MATCHING VARIABLES  
    **matching_variables, 

    # Uncomment when have updated our own confounding variables
    # CONFOUNDING VARIABLES  
    #**confounding_variables, 

    # Uncomment when have updated our own confounding variables
    # OUTCOME VARIABLES  
    #**outcome_variables, 

    # SELECTION VARIABLES 
    ### sex 
    sex=patients.sex(
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"M": 0.49, "F": 0.51}},
        }
    ),

    # TIME-VARYING SELECTION VARIABLES 
    ## These variables are EITHER 1) defined within a specific time frame relative to the patient vaccination date 
    ## OR 2) defined as before/after/on the patient vaccination date, but they return something other than a date 
    ## For controls, they need to be extracted and applied after matching as controls are assigned the patient vaccination date 
    ## It is most efficient to extract these separately for exposed and controls, as they are not needed for the controls yet,
    ## and we don't want to spend time matching ineligble exposed people  

    ### pregnancy 
    # pregnancy=patients.with_these_clinical_events(
    # preg,
    # returning="binary_flag",
    # find_last_match_in_period=True,
    # between=["first_known_vaccine_date - 274 days", "first_known_vaccine_date"],
    # return_expectations={"incidence": 0.01}
    # ),

    ### has one year of baseline time
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

    ## RESIDENTIAL STATUS 
    ### known care home 
    #### type of care home
    care_home_type=patients.care_home_status_as_of(
        "case_index_date",
        categorised_as={
            "CareHome": """
              IsPotentialCareHome
              AND LocationDoesNotRequireNursing='Y'
              AND LocationRequiresNursing='N'
            """,
            "NursingHome": """
              IsPotentialCareHome
              AND LocationDoesNotRequireNursing='N'
              AND LocationRequiresNursing='Y'
            """,
            "CareOrNursingHome": "IsPotentialCareHome",
            "PrivateHome": "NOT IsPotentialCareHome",
            "": "DEFAULT",
        },
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"CareHome": 0.30, "NursingHome": 0.10, "CareOrNursingHome": 0.10, "PrivateHome":0.45, "":0.05},},
        },
    ),
    #### has any value for the above 
    known_care_home=patients.satisfying(
        """care_home_type""",
        return_expectations={"incidence": 0.99},
    ),

    ## index of multiple deprivation, estimate of SES based on patient post code 
    imd=patients.categorised_as(
        {
            "0": "DEFAULT",
            "1": """index_of_multiple_deprivation >=1 AND index_of_multiple_deprivation < 32844*1/5""",
            "2": """index_of_multiple_deprivation >= 32844*1/5 AND index_of_multiple_deprivation < 32844*2/5""",
            "3": """index_of_multiple_deprivation >= 32844*2/5 AND index_of_multiple_deprivation < 32844*3/5""",
            "4": """index_of_multiple_deprivation >= 32844*3/5 AND index_of_multiple_deprivation < 32844*4/5""",
            "5": """index_of_multiple_deprivation >= 32844*4/5 AND index_of_multiple_deprivation < 32844""",
        },
        index_of_multiple_deprivation=patients.address_as_of(
            "case_index_date",
            returning="index_of_multiple_deprivation",
            round_to_nearest=100,
        ),
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "0": 0.05,
                    "1": 0.19,
                    "2": 0.19,
                    "3": 0.19,
                    "4": 0.19,
                    "5": 0.19,
                }
            },
        },
    ),

) 












