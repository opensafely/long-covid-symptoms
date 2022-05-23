from cohortextractor import filter_codes_by_category, patients, combine_codelists
from codelists import *
from datetime import datetime, timedelta


def generate_vaccine_variables(index_date_variable):
    vaccine_variables = dict(
    # COVID VACCINATION VARIABLES  
    # any COVID vaccination (first dose)
    first_any_vaccine_date=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-12-08",  # first vaccine administered on the 8/12
                "latest": "2021-05-11",
            }, 
            "incidence": 0.95
        },
    ),
    # pfizer (first dose) 
    first_pfizer_date=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        product_name_matches="COVID-19 mRNA Vaccine Comirnaty 30micrograms/0.3ml dose conc for susp for inj MDV (Pfizer)",
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-12-08",  # first vaccine administered on the 8/12
                "latest": "2021-05-11",
            }, 
            "incidence": 0.95
        },
    ),
    # az (first dose)
    first_az_date=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-12-08",  # first vaccine administered on the 8/12
                "latest": "2021-05-11",
            }, 
            "incidence": 0.95
        },
    ),

    # moderna (first dose)
    first_moderna_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA Vaccine Spikevax (nucleoside modified) 0.1mg/0.5mL dose disp for inj MDV (Moderna)",
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-12-08",  
                "latest": "2021-05-11",
            },
            "incidence": 0.95
        },
    ),

    # first ever vaccine date 
    first_known_vaccine_date=patients.minimum_of("first_moderna_date", "first_az_date", "first_pfizer_date"), 

    # ever vaccinated yes or no
    has_first_known_vaccine=patients.satisfying(
        """first_known_vaccine_date""",
        return_expectations={"incidence": 0.99},
    ),

    # any COVID vaccination (second dose)
    second_any_vaccine_date=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        on_or_after="first_any_vaccine_date + 21 days",  
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2021-03-01",  # first vaccine administered on the 8/12
                "latest": "2021-07-11",
            }, 
            "incidence": 0.95
        },
    ),
    # pfizer (second dose) 
    second_pfizer_date=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        product_name_matches="COVID-19 mRNA Vaccine Comirnaty 30micrograms/0.3ml dose conc for susp for inj MDV (Pfizer)",
        on_or_after="first_any_vaccine_date + 21 days",  
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2021-03-01",  # first vaccine administered on the 8/12
                "latest": "2021-07-11",
            }, 
            "incidence": 0.95
        },
    ),
    # az (second dose)
    second_az_date=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
        on_or_after="first_any_vaccine_date + 21 days",  
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2021-03-01",  # first vaccine administered on the 8/12
                "latest": "2021-07-11",
            }, 
            "incidence": 0.95
        },
    ),
    second_moderna_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA Vaccine Spikevax (nucleoside modified) 0.1mg/0.5mL dose disp for inj MDV (Moderna)",
        on_or_after="first_any_vaccine_date + 21 days",  
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2021-03-01",  
                "latest": "2021-07-11",
            },
            "incidence": 0.95
        },
    ),

    second_known_vaccine_date = patients.minimum_of("second_moderna_date", "second_az_date", "second_pfizer_date"), 

    # overlapping first doses 
    overlap_az_moderna=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
        between=["first_moderna_date", "first_moderna_date"], 
        find_first_match_in_period=True,
        returning="binary_flag",
        return_expectations={"incidence": 0.01}, 
    ),
     
    )
    return vaccine_variables
