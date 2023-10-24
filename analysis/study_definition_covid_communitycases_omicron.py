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
from covid19_variables_omicron import generate_covid19_variables_omicron
covid19_variables_omicron = generate_covid19_variables_omicron(index_date_variable="index_date")

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

    # start of observation period i.e. start of wave 1 (note, needs to be called index date)
    # this has to be start of wave 1 as it is used to estimate first known covid (a matching exclusion parameter) and this has to include wave 1 covid
    index_date="2020-02-01",
    # start of observation period i.e. start of wave 2 (note, needs to be called index date)
    #index_date="2020-09-01", 

     # select the study population
     # after trying to run matching for all regions and it taking 5 days without finishing, here are trying just 1 region on its own
     # for all development work going to use just one region - E54000043, which has 10,941 records in it
    

    population=patients.satisfying(
        """
        (age <=110) 
        AND (sex = "M" OR sex = "F") 
        AND imd > 0 
        AND has_follow_up
        AND NOT had_covid_hosp
        AND NOT has_died 
        AND NOT has_diedPrimaryCare
        AND NOT stp = ""
        """,
    ),   

    
    # COVID19 VARIABLES
    **covid19_variables_omicron, 

    # define the case index date - first of positive test or primary care diagnosis after wave 2
    # to keep this manageable re: matching, I'd like cases to only be selected from within wave 2 (INITIALLY)
    ## Note that TEMP_CASE_INDEX_DATE is defined in the covid19_variables files and is the earliest of first positive test or first probable diagnosis in W2
    ## But I want THE ACTUAL CASE INDEX DATE to be 28 days after the temp case index date that is defined here. Only way that I can see how to do this 
    ## is to make the change in STATA after this study_definition_covid_communitycases.py action has been run, then save the output. Then AFTER THIS HELPER STATA
    ## FILE HAS BEEN RUN, the case index date will be 28 days later and it is the case_index_date (=temp_case_index_date + 28 days) that will be passed to the other
    ## actions in the pipeline. One caveat is that in this file I need to make sure the time-dependent checks related to the temp_case_index_date variable
    ## check the data for exclusions up to 28 days after the temp_case_index_date (which is why the commands are + 28 days below)
    case_index_date=patients.minimum_of("first_pos_testW4", "covid_tpp_probW4"),

    # MATCHING VARIABLES  
    **matching_variables, 

    # DEMOG COVARIATES  
    **covariates_selection, 

    # Uncomment when have updated our own outcome variables
    # OUTCOME VARIABLES  
    # **outcome_variables, 


    # TIME-VARYING SELECTION VARIABLES
    ## These variables are EITHER 1) defined within a specific time frame relative to the patient case date 
    ## OR 2) defined as before/after/on the patient case date, but they return something other than a date 
    ## For controls, they need to be extracted and applied after matching as controls are assigned the patient case date 
    ## It is most efficient to extract these separately for exposed and controls, as they are not needed for the controls yet,
    ## and we don't want to spend time matching ineligble exposed people  

    ### See note above related to "temp_case_index_date"
    has_follow_up=patients.registered_with_one_practice_between(
        start_date="case_index_date - 3 months",
        end_date="case_index_date",
        return_expectations={"incidence": 0.95},
        ),

    ### See note above related to "temp_case_index_date"
    has_follow_up_28dys=patients.registered_with_one_practice_between(
        start_date="case_index_date - 3 months",
        end_date="case_index_date + 28 days",
        return_expectations={"incidence": 0.95},
        ),

    ### died before (temp) case_index_date
    has_died=patients.died_from_any_cause(
      on_or_before="case_index_date",
      returning="binary_flag",
    ),

    has_diedPrimaryCare=patients.with_death_recorded_in_primary_care(
         on_or_before="index_date",
         returning="binary_flag",
         date_format="YYYY-MM-DD",
    ),

    ### died between (temp) case_index_date and real case index date
    has_died_28dys=patients.died_from_any_cause(
      on_or_before="case_index_date + 28 days",
      returning="binary_flag",
    ),

    ### was hospitalised before case index date - this one can be 28 days as only applies to cases
    had_covid_hosp=patients.admitted_to_hospital(
        returning="binary_flag",  # defaults to "binary_flag"
        with_these_diagnoses=covid_codelist,  # optional
        on_or_before="case_index_date + 28 days",
    ),

    ### died after temp case index date (extracted as used as a matching variable, so needs to exist) between start of wave 1 and end of wave 4
    death_date=patients.died_from_any_cause(
        on_or_after="case_index_date",
        returning="date_of_death",
        date_format="YYYY-MM-DD", 
        return_expectations={
            "date": {
                "earliest": "2020-02-01",  # wave 1 start and wave 4 end (wave 4 end was actually 29 April 2022 but mass testing finished 1 April 2022)
                "latest": "2022-03-31", }, 
                "incidence": 0.01 },
    ),

    ### deregistered after case index date (extracted as used as a matching variable, so needs to exist)
    dereg_date=patients.date_deregistered_from_all_supported_practices(
        on_or_after="case_index_date", date_format="YYYY-MM-DD",
    ),


   ###THIS FILE SETS UP AN INDEX DATE THAT IS THE EARLIEST DATE OF (COMMUNITY COVID) IN WAVE 2
   ###THE FOLLOWING STATA FILE THEN TAKES THIS DATE AND ADDS 28 DAYS TO IT
   ###THE STATA FILE ALSO UPDATES THE has_follow_up, covid_hosp AND has_died VARIABLES SO THEY REFLECT THE 28 DAY PERIOD
   ###THE STATA FILE ALSO UPDATES THE death_date AND dereg_date VARIABLE SO THEY REFLECT THE 28 DAY PERIOD
   ###THE STATA FILE ALSO UPDATES THE first_known_covid DATE (FOR CASES) SO THAT IT IS SET TO "" (AND NOT CHECKED BY MATCHING PROGRAM AS OTHERWISE ALL RECORDS DROPPED)
   ###NOTE I CAN'T JUST CHANGE THE CASE_INDEX_DATE TO BE 28 DAYS LATER, AS IT DOESN'T NEED TO BE 28 DAYS LATER FOR NON-CASES (IT NEEDS TO BE THE DATE OF THE MATCHED CASE)
) 












