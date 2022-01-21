from cohortextractor import (
    StudyDefinition, 
    patients, 
    codelist, 
    codelist_from_csv,
    combine_codelists,
)
from common_variables import generate_common_variables
from codelists import *

common_variables = generate_common_variables(index_date_variable="patient_index_date")

study = StudyDefinition(
    default_expectations={
        # define default dummy data behaviour
        # expect event dates to be between 1/1/1980 and today
        # uniformly distributed
        # recorded for 20% of patients, and empty otherwise
        "date": {"earliest": "1980-01-01", "latest": "today"},
        "rate": "uniform",
        "incidence": 0.7,
    },
    population=patients.satisfying(
    # does the AND NOT covid_hospitalisation mean that we drop everyone
    # who EVER had a covid record?
    # or do we include them up until their covid record?
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
            "patient_index_date - 3 months", "patient_index_date"
        ),
    ),
    index_date="2020-02-01",

    has_community_covid=patients.satisfying(
        # need to edit here in order to return earliest of the dates from 
        # the two functions below
        "covid_test OR covid_codelist",
        covid_test=patients.with_test_result_in_sgss(
            pathogen="SARS-CoV-2",
            test_result="positive",
            find_first_match_in_period=True,
            returning="date",
            date_format="YYYY-MM-DD",
            return_expectations={"date": {"earliest": "patient_index_date"}},
        ),
        covid_primarycare=patients.with_these_clinical_events(
            # the var below is named in codelists.py file (so name appropriately!)
            snomed_covid,
            returning="date",
            date_format="YYYY-MM-DD",
            find_first_match_in_period=True,
            return_expectations={"incidence": 0.1, "date": {"earliest": "patient_index_date"}},
        ),   
    ),


    
    covid_hospital=patients.admitted_to_hospital(
        returning="date_admitted",
        # covid_codelist is a name from the codelists.py file
        with_these_diagnoses=icd_covid,
        on_or_after="index_date",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={"date": {"earliest": "index_date"}},
    ),
    **common_variables
)
