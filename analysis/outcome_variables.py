from cohortextractor import filter_codes_by_category, patients, combine_codelists
from codelists import *
from datetime import datetime, timedelta


def generate_outcome_variables(index_date_variable):
    outcome_variables = dict(

    ## Bells Palsy
    bells_palsy_gp=patients.with_these_clinical_events(
        bells_palsy_primary_care_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),
    bells_palsy_hospital=patients.admitted_to_hospital(
        with_these_diagnoses=bells_palsy_secondary_care_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date_admitted",
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ), 
    bells_palsy_death=patients.with_these_codes_on_death_certificate(
        bells_palsy_secondary_care_codes,
        on_or_after=f"{index_date_variable}",
        match_only_underlying_cause=False,
        returning="date_of_death",
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ), 
    bells_palsy_emergency=patients.attended_emergency_care(
        with_these_diagnoses=bells_palsy_emergency_care_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date_arrived",
        date_format="YYYY-MM-DD",
        return_expectations={
        "date": {"earliest" : "index_date"}},
    ), 
    any_bells_palsy=patients.minimum_of("bells_palsy_gp", "bells_palsy_hospital", "bells_palsy_death", "bells_palsy_emergency"), 

    ## Transverse Myelitis 
    transverse_myelitis_gp=patients.with_these_clinical_events(
        transverse_myelitis_primary_care_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),
    transverse_myelitis_hospital=patients.admitted_to_hospital(
        with_these_diagnoses=transverse_myelitis_secondary_care_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date_admitted",
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ), 
    transverse_myelitis_death=patients.with_these_codes_on_death_certificate(
        transverse_myelitis_secondary_care_codes,
        on_or_after=f"{index_date_variable}",
        match_only_underlying_cause=False,
        returning="date_of_death",
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ), 
    any_transverse_myelitis=patients.minimum_of("transverse_myelitis_gp", "transverse_myelitis_hospital", "transverse_myelitis_death"), 

    ## Guillain Barre
    guillain_barre_gp=patients.with_these_clinical_events(
        guillain_barre_primary_care_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),
    guillain_barre_hospital=patients.admitted_to_hospital(
        with_these_diagnoses=guillain_barre_secondary_care_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date_admitted",
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ), 
    guillain_barre_death=patients.with_these_codes_on_death_certificate(
        guillain_barre_secondary_care_codes,
        on_or_after=f"{index_date_variable}",
        match_only_underlying_cause=False,
        returning="date_of_death",
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ), 
    any_guillain_barre=patients.minimum_of("guillain_barre_gp", "guillain_barre_hospital", "guillain_barre_death"), 
    )
    return outcome_variables