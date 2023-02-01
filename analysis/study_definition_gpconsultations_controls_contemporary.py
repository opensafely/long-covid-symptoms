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

CONTROLS = "output/input_covid_matched_matches_contemporary_allSTPs.csv"



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

    # get case index date from original file
    case_index_date=patients.with_value_from_file(
        CONTROLS, 
        returning="case_index_date", 
        returning_type="date"), 



    #NUMBER OF GP CONSULTATIONS IN THE PREVIOUS YEAR
    gp_count_prevYear=patients.with_gp_consultations(
        between=["case_index_date - 1 year", "case_index_date"],
        returning="number_of_matches_in_period",
        return_expectations={"int": {"distribution": "normal", "mean": 6, "stddev": 3},"incidence": 0.6,},
    ),

    #NUMBER OF GP CONSULTATIONS (AS AN OUTCOME)
    total_gp_count=patients.with_gp_consultations(
        between=["case_index_date", "2022-01-31"],
        returning="number_of_matches_in_period",
        return_expectations={"int": {"distribution": "normal", "mean": 6, "stddev": 3},"incidence": 0.6,},
    ),  

    t1_gp_count=patients.with_gp_consultations(
        between=["case_index_date + 28 days", "case_index_date + 84 days"],
        returning="number_of_matches_in_period",
        return_expectations={"int": {"distribution": "normal", "mean": 6, "stddev": 3},"incidence": 0.6,},
    ), 

    t2_gp_count=patients.with_gp_consultations(
        between=["case_index_date + 85 days", "case_index_date + 180 days"],
        returning="number_of_matches_in_period",
        return_expectations={"int": {"distribution": "normal", "mean": 6, "stddev": 3},"incidence": 0.6,},
    ),      

    t3_gp_count=patients.with_gp_consultations(
        between=["case_index_date + 181 days", "2022-01-31"],
        returning="number_of_matches_in_period",
        return_expectations={"int": {"distribution": "normal", "mean": 6, "stddev": 3},"incidence": 0.6,},
    ), 


) 
