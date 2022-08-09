from cohortextractor import filter_codes_by_category, patients, combine_codelists
from codelists import *
from datetime import datetime, timedelta


def generate_outcome_variables(index_date_variable):
    outcome_variables = dict(

    auditory_disorder=patients.with_these_clinical_events(
        auditory_disorder_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),


    pregnancy_complications=patients.with_these_clinical_events(
        combine_codelists(
            compl_pregnancy_codes,
            disorder_peurperium_codes,
            disorder_labor_codes,
        ),
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    )
    return outcome_variables