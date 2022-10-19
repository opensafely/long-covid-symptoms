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

CONTROLS = "output/input_covid_matched_matches_allSTPs.csv"

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
    population=patients.which_exist_in_file(CONTROLS), 

    # start of observation period (note, needs to be called index date)
    index_date="2020-02-01", # note should be ignored when using case_index_date 

    # import the variables I need that already exist in the matched list of cases
    # doing it this way as am uncomfortable about "reextracting" any variables that I have already extracted ((and performed checks)
    # for example, when I re-extracted, there there were some missing STPs and some sex categories other than M or F, despite these
    # being defined as required (for STP) or only M or F (for sex)

    # age
    age=patients.with_value_from_file(
        CONTROLS, 
        returning="age", 
        returning_type="int"), 
    # case
    case=patients.with_value_from_file(
        CONTROLS, 
        returning="case", 
        returning_type="int"), 
    # case index date
    case_index_date=patients.with_value_from_file(
        CONTROLS, 
        returning="case_index_date", 
        returning_type="date"), 
    # covid_hosp
    covid_hosp=patients.with_value_from_file(
        CONTROLS, 
        returning="covid_hosp", 
        returning_type="str"), 
    # covid_tpp_prob
    covid_tpp_prob=patients.with_value_from_file(
        CONTROLS, 
        returning="covid_tpp_prob", 
        returning_type="str"),
    # covid_tpp_probw2
    covid_tpp_probw2=patients.with_value_from_file(
        CONTROLS, 
        returning="covid_tpp_probw2", 
        returning_type="str"),
    # first_known_covid19
    first_known_covid19=patients.with_value_from_file(
        CONTROLS, 
        returning="first_known_covid19", 
        returning_type="str"),
    # first_pos_test
    first_pos_test=patients.with_value_from_file(
        CONTROLS, 
        returning="first_pos_test", 
        returning_type="str"),
    # first_pos_testw2
    first_pos_testw2=patients.with_value_from_file(
        CONTROLS, 
        returning="first_pos_testw2", 
        returning_type="str"),
    # imd
    imd=patients.with_value_from_file(
        CONTROLS, 
        returning="imd", 
        returning_type="int"),
    # pos_covid_test_ever
    pos_covid_test_ever=patients.with_value_from_file(
        CONTROLS, 
        returning="pos_covid_test_ever", 
        returning_type="str"),
    # set_id
    set_id=patients.with_value_from_file(
        CONTROLS, 
        returning="set_id", 
        returning_type="float"), 
    # sex
    sex=patients.with_value_from_file(
        CONTROLS, 
        returning="sex", 
        returning_type="str"), 
    # stp
    stp=patients.with_value_from_file(
        CONTROLS, 
        returning="stp", 
        returning_type="str"),
    

    # extract the new variables i.e. (1) covariates: ethnicity, rural_urban and comorbidities and (2) outcomes
    # COVARIATES  
    **covariates_complete, 

    # OUTCOME VARIABLES  
    **outcome_variables,  



    # TIME-VARYING SELECTION VARIABLES
    ## These variables are EITHER 1) defined within a specific time frame relative to the patient case date 
    ## OR 2) defined as before/after/on the patient case date, but they return something other than a date 
    ## For controls, they need to be extracted and applied after matching as controls are assigned the patient case date 
    ## It is most efficient to extract these separately for exposed and controls, as they are not needed for the controls yet,
    ## and we don't want to spend time matching ineligble exposed people  

    ### has 3 months of of baseline time
    ## Note that CASE_INDEX_DATE is defined in the covid19_variables files and is the earliest of first positive test or first probable diagnosis in W2
    ## These next two are variables that I need to check when sorting the variables out i.e. has follow-up in the controls, as can't see how to to handle it in the 
    ## matching script (and has died needs checked against the case index date)
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
