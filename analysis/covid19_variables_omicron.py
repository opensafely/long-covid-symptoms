from cohortextractor import filter_codes_by_category, patients, combine_codelists
from codelists import *
from datetime import datetime, timedelta


def generate_covid19_variables_omicron(index_date_variable):
    covid19_variables = dict(
    # COVID19 STATUS VARIABLES  
    # sgss test results
    first_test_covid=patients.with_test_result_in_sgss(
        pathogen="SARS-CoV-2",
        test_result="any",
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={"date": {
                "earliest": "2020-02-01",  # wave 1 start and wave 3 end (wave 3 end was actually 29 April 2022 but mass testing finished 1 April 2022)
                "latest": "2022-03-31",
            }, 
            "rate": "exponential_increase"
        },
    ),
    first_pos_test=patients.with_test_result_in_sgss(
        pathogen="SARS-CoV-2",
        test_result="positive",
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={"date": {
                "earliest": "2020-02-01",  # wave 1 start and wave 3 end (wave 3 end was actually 29 April 2022 but mass testing finished 1 April 2022)
                "latest": "2022-03-31",
            }, 
            "rate": "exponential_increase"
        },
    ),
    # this one is specifically for selecting cases, which I only want to do between the beginning and end of my wave 3 dates 
    first_pos_testW4=patients.with_test_result_in_sgss(
        pathogen="SARS-CoV-2",
        test_result="positive",
        between=("2021-12-15", "2022-03-31"),
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={"date": {
                "earliest": "2021-12-15",  # wave 4 start and wave 4 end (or at least end of mass testing) i.e. Dec 10 2021 to March 31 2022
                "latest": "2022-03-31",
            }, 
            "rate": "exponential_increase"
        },
    ),


    # covid primary and secondary care cases
    covid_tpp_prob=patients.with_these_clinical_events(
        combine_codelists(
            covid_identification_in_primary_care_case_codes_clinical,
            covid_identification_in_primary_care_case_codes_test,
            covid_identification_in_primary_care_case_codes_seq,
        ),
        on_or_after=f"{index_date_variable}",
        return_first_date_in_period=True,
        include_day=True,
        return_expectations={"date": {
                "earliest": "2020-02-01",  # wave 1 start and wave 4 end (or at least end of mass testing) i.e. to March 31 2022
                "latest": "2022-03-31",
            }, 
            "rate": "exponential_increase"
        },
    ),
    # this one is specifically for selecting cases, which I only want to do between the beginning and end of my W3 dates - WAS A MISTAKE HERE!!!!
    covid_tpp_probW4=patients.with_these_clinical_events(
        combine_codelists(
            covid_identification_in_primary_care_case_codes_clinical,
            covid_identification_in_primary_care_case_codes_test,
            covid_identification_in_primary_care_case_codes_seq,
        ),
        between=("2021-12-15", "2022-03-31"),
        return_first_date_in_period=True,
        include_day=True,
        return_expectations={"date": {
                "earliest": "2021-12-15",  # wave 4 start and wave 4 end (wave 3 end was actually 29 April 2022 but mass testing finished 1 April 2022)
                "latest": "2022-03-31",
            }, 
            "rate": "exponential_increase"
        },
    ),
    covid_tpp_probCLINDIAG=patients.with_these_clinical_events(
        covid_identification_in_primary_care_case_codes_clinical,
        on_or_after=f"{index_date_variable}",
        return_first_date_in_period=True,
        include_day=True,
        return_expectations={"date": {
                "earliest": "2020-02-01",  # wave 1 start and wave 4 end (wave 4 end was actually 29 April 2022 but mass testing finished 1 April 2022)
                "latest": "2022-03-31",
            }, 
            "rate": "exponential_increase"},
    ),
    covid_tpp_probTEST=patients.with_these_clinical_events(
        covid_identification_in_primary_care_case_codes_test,
        on_or_after=f"{index_date_variable}",
        return_first_date_in_period=True,
        include_day=True,
        return_expectations={"date": {
                "earliest": "2020-02-01",  # wave 1 start and wave 4 end (wave 4 end was actually 29 April 2022 but mass testing finished 1 April 2022)
                "latest": "2022-03-31",
            }, 
            "rate": "exponential_increase"},
    ),
    covid_tpp_probSEQ=patients.with_these_clinical_events(
        covid_identification_in_primary_care_case_codes_seq,
        on_or_after=f"{index_date_variable}",
        return_first_date_in_period=True,
        include_day=True,
        return_expectations={"date": {
                "earliest": "2020-02-01",  # wave 1 start and wave 4 end (wave 4 end was actually 29 April 2022 but mass testing finished 1 April 2022)
                "latest": "2022-03-31",
            }, 
            "rate": "exponential_increase"},
    ),
    covid_hosp=patients.admitted_to_hospital(
        returning="date_admitted",  # defaults to "binary_flag"
        with_these_diagnoses=covid_codelist,  # optional
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        date_format="YYYY-MM-DD",
        return_expectations={"date": {
                "earliest": "2020-02-01",  # wave 1 start and wave 4 end (wave 4 end was actually 29 April 2022 but mass testing finished 1 April 2022)
                "latest": "2022-03-31",
            }, 
            "rate": "exponential_increase"},
    ),
    covid_hosp_primDiag=patients.admitted_to_hospital(
        returning="primary_diagnosis",
        with_these_diagnoses=covid_codelist,  # optional
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {"earliest": "2020-02-01",  # wave 1 start and wave 4 end (wave 4 end was actually 29 April 2022 but mass testing finished 1 April 2022)
                "latest": "2022-03-31"},
            "incidence": 0.95,
            "category": {"ratios": {"U071": 0.5, "U072": 0.5}},
        },
    ),
    pos_covid_test_ever=patients.with_test_result_in_sgss(
        pathogen="SARS-CoV-2",
        test_result="positive",
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {"earliest": "2020-02-01",  # wave 1 start and wave 4 end (wave 4 end was actually 29 April 2022 but mass testing finished 1 April 2022)
                "latest": "2022-03-31"},
            "rate": "exponential_increase",
        },
    ),

    # first known covid date - this one I want to look back to the start of the pandemic (i.e. beginning of wave 1)
    # this is because I need to know earliest covid-19 to make sure people included in study from beginning of fourth wave
    # onwards haven't already had covid in the first wave
    first_known_covid19=patients.minimum_of("first_pos_test", "covid_tpp_prob", "covid_hosp"), 
     
    )
    return covid19_variables



    # covid19 deaths  
    # died_ons_covid_flag_any=patients.with_these_codes_on_death_certificate(
    #    covid_codelist,
    #    on_or_after="2020-02-01",
    #    match_only_underlying_cause=False,
    #    return_expectations={"incidence": 0.33},
    #),
    #died_ons_covid_flag_underlying=patients.with_these_codes_on_death_certificate(
    #    covid_codelist,
    #   on_or_after="2020-02-01",
    #    match_only_underlying_cause=True,
    #    return_expectations={"incidence": 0.33},
    #),
    #died_date_ons=patients.died_from_any_cause(
    #    on_or_after="2020-02-01",
    #    returning="date_of_death",
    #    include_month=True,
    #    include_day=True,
    #    return_expectations={
    #        "date": {"earliest": "2020-02-01"},
    #        "rate": "exponential_increase",
    #    },
    #),
    # cpns
    #died_date_cpns=patients.with_death_recorded_in_cpns(
    #    on_or_after="2020-02-01",
    #    returning="date_of_death",
    #    include_month=True,
    #    include_day=True,
    #    return_expectations={
    #        "date": {"earliest": "2020-02-01"},
    #        "rate": "exponential_increase",
    #    },
    #),
