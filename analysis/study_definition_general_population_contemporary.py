from cohortextractor import (
    StudyDefinition, 
    patients, 
    codelist, 
    codelist_from_csv,
    filter_codes_by_category
    combine_codelists,
)
from common_variables_short import generate_common_variables_short

from codelists import *

common_variables_short = generate_common_variables_short(index_date_variable="patient_index_date")

# study definiton: used to define study pop and variables
study = StudyDefinition(
    default_expectations={
        "date": {"earliest": "1980-01-01", "latest": "today"},
        "rate": "uniform",
        "incidence": 0.2,
    },

    # define study population
    population=patients.satisfying(
        # should I be also excluding people with community covid here?
        """
            has_follow_up
        AND (age >=18 AND age <= 110)
        AND (sex = "M" OR sex = "F")
        AND imd > 0
        AND patient_index_date
        AND NOT covid_hospital
        AND NOT stp = ""
        """,
        has_follow_up=patients.registered_with_one_practice_between(
            "patient_index_date - 1 year", "patient_index_date"
        ),
    ),

    # don't think we can exclude person time from covid diagnosis here
    # so increase matching matching ratio, and explicitly drop people 
    # in stata code later from when they have a COVID diagnosis
    # define study index date
    index_date="2020-02-01",
   
    **common_variables
)
