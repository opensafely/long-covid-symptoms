from cohortextractor import filter_codes_by_category, patients, combine_codelists
from codelists import *
from datetime import datetime, timedelta


def generate_matching_variables(index_date_variable):
    matching_variables = dict(

    ## age 
    age=patients.age_as_of(
        f"{index_date_variable}",
        return_expectations={
            "rate": "universal",
            "int": {"distribution": "population_ages"},
        },
    ),
    ## geographical region - set this to be one STP for now (originally was 10) as this is what I have (hopefully) defined the populations to be
    stp=patients.registered_practice_as_of(
        f"{index_date_variable}",
        returning="stp_code",
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                     "STP1": 1.0,
                }
            },
        },
    ), 

    )
    return matching_variables
