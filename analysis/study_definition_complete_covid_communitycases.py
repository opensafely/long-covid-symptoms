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
from outcome_variables import generate_outcome_variables
outcome_variables = generate_outcome_variables(index_date_variable="case_index_date")


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

    # import the variables I need that already exist in the matched list of cases
    # doing it this way as am uncomfortable about "reextracting" any variables that I have already extracted ((and performed checks)
    # for example, when I re-extracted, there there were some missing STPs and some sex categories other than M or F, despite these
    # being defined as required (for STP) or only M or F (for sex)

    # age
    age=patients.with_value_from_file(
        CASES, 
        returning="age", 
        returning_type="int"), 
    # case
    case=patients.with_value_from_file(
        CASES, 
        returning="case", 
        returning_type="int"), 
    # case index date
    case_index_date=patients.with_value_from_file(
        CASES, 
        returning="case_index_date", 
        returning_type="date"), 
    # covid_hosp
    covid_hosp=patients.with_value_from_file(
        CASES, 
        returning="covid_hosp", 
        returning_type="str"), 
    # covid_tpp_prob
    covid_tpp_prob=patients.with_value_from_file(
        CASES, 
        returning="covid_tpp_prob", 
        returning_type="str"),
    # covid_tpp_probw2
    covid_tpp_probw2=patients.with_value_from_file(
        CASES, 
        returning="covid_tpp_probw2", 
        returning_type="str"),
    # death_date
    death_date=patients.with_value_from_file(
        CASES, 
        returning="death_date", 
        returning_type="str"),
    # dereg_date
    dereg_date=patients.with_value_from_file(
        CASES, 
        returning="dereg_date", 
        returning_type="str"),
    # first_known_covid19
    first_known_covid19=patients.with_value_from_file(
        CASES, 
        returning="first_known_covid19", 
        returning_type="str"),
    # first_pos_test
    first_pos_test=patients.with_value_from_file(
        CASES, 
        returning="first_pos_test", 
        returning_type="str"),
    # first_pos_testw2
    first_pos_testw2=patients.with_value_from_file(
        CASES, 
        returning="first_pos_testw2", 
        returning_type="str"),
    # had_covid_hosp
    had_covid_hosp=patients.with_value_from_file(
        CASES, 
        returning="had_covid_hosp", 
        returning_type="int"),
    # has_died
    has_died=patients.with_value_from_file(
        CASES, 
        returning="has_died", 
        returning_type="int"),
    # has_follow_up
    has_follow_up=patients.with_value_from_file(
        CASES, 
        returning="has_follow_up", 
        returning_type="int"),
    # imd
    imd=patients.with_value_from_file(
        CASES, 
        returning="imd", 
        returning_type="int"),
    # match_counts
    match_counts=patients.with_value_from_file(
        CASES, 
        returning="match_counts", 
        returning_type="int"),
    # pos_covid_test_ever
    pos_covid_test_ever=patients.with_value_from_file(
        CASES, 
        returning="pos_covid_test_ever", 
        returning_type="str"),
    # set_id
    set_id=patients.with_value_from_file(
        CASES, 
        returning="set_id", 
        returning_type="float"), 
    # sex
    sex=patients.with_value_from_file(
        CASES, 
        returning="sex", 
        returning_type="str"), 
    # stp
    stp=patients.with_value_from_file(
        CASES, 
        returning="stp", 
        returning_type="str"),
    

    # extract the new variables i.e. (1) covariates: ethnicity, rural_urban and comorbidities and (2) outcomes
    # COVARIATES  
    **covariates_complete, 

    # OUTCOME VARIABLES  
    **outcome_variables,  


) 
