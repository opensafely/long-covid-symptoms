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
CONTROLS = "output/input_covid_matched_matches_contemporary_allSTPs_omicron.csv"

# Import Variables 
## medicine variables (note, relative to community COVID19 case (index) date)
from outcome_variables_medicines_contemporary_omicron import generate_outcome_variables_medicines_contemporary_omicron
outcome_variables_medicines_contemporary_omicron = generate_outcome_variables_medicines_contemporary_omicron(index_date_variable="case_index_date")


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

    # OUTCOME VARIABLES FOR SYMPTOMS
    **outcome_variables_medicines_contemporary_omicron,  

) 
