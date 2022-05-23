# variables needed:
#   outcomes: symptoms, diagnostic cats, prescriptions, some measure of healthcare use
#   exposure: date of covid?? (this comes in index date? so probably not needed)
#   covariates: age, sex, region, deprivation, region,
#       ethnicity, rural/urban, some measure of comorbidities prior to start of follow up
#   ?variables needed to ensure eligibility: covid hosp admission, deregistration, death, ? community covid?
#   secondary analyses: vaccination status, 
#       source of community COVID-19 diagnosis (i.e., primary care or SGSS)
#   sensitivity analyses: coded long-COVID


from cohortextractor import filter_codes_by_category, patients, combine_codelists
from codelists import *
from datetime import datetime, timedelta


def generate_common_variables(index_date_variable):
    common_variables = dict(
        #########################
        # 1. eligibility
        deregistered=patients.date_deregistered_from_all_supported_practices(
            date_format="YYYY-MM-DD"
        ),
        
        died_date_ons=patients.died_from_any_cause(
            returning="date_of_death",
            date_format="YYYY-MM-DD",
            return_expectations={
                "date": {"earliest": "index_date"},
                "incidence": 0.1,
            },
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

        # ?? do I need something in here re: community COVID, so that I can exclude comparators 
        # with subsequent COVID?
        # I do want to look within cases at GP vs SGSS source of first COVID diagnosis
        # pull back a date for SGSS / primary care COVID to double check that
        # these people are dropped from comparator pool appropriately
        # ? consider increasing ratio of covid:comparator if necessary


        #########################
        # 2. characteristics/used as covariates/stratifiers
        age=patients.age_as_of(
            f"{index_date_variable}",
            return_expectations={
                "rate": "universal",
                "int": {"distribution": "population_ages"},
            },
        ),
        sex=patients.sex(
            return_expectations={
                "rate": "universal",
                "category": {"ratios": {"M": 0.49, "F": 0.51}},
            }
        ),
        ethnicity=patients.with_these_clinical_events(
            ethnicity_codes,
            returning="category",
            find_last_match_in_period=True,
            on_or_before=f"{index_date_variable}",
            return_expectations={
                "category": {"ratios": {"1": 0.8, "5": 0.1, "3": 0.1}},
                "incidence": 0.75,
            },
        ),

        imd=patients.address_as_of(
            "index_date",
            returning="index_of_multiple_deprivation",
            round_to_nearest=100,
            return_expectations={
                "rate": "universal",
                "category": {
                    "ratios": {
                        "100": 0.1,
                        "200": 0.1,
                        "300": 0.1,
                        "400": 0.1,
                        "500": 0.1,
                        "600": 0.1,
                        "700": 0.1,
                        "800": 0.1,
                        "900": 0.1,
                        "1000": 0.1,
                    }
                },
            },
        ),

        region=patients.registered_practice_as_of(
            "index_date",
            returning="nuts1_region_name",
            return_expectations={
                "rate": "universal",
                "category": {
                    "ratios": {
                        "North East": 0.1,
                        "North West": 0.1,
                        "Yorkshire and The Humber": 0.1,
                        "East Midlands": 0.1,
                        "West Midlands": 0.1,
                        "East": 0.1,
                        "London": 0.2,
                        "South East": 0.1,
                        "South West": 0.1,
                    },
                },
            },
        ),

        ### rural/urban
        # add code

        stp=patients.registered_practice_as_of(
            "index_date",
            returning="stp_code",
            return_expectations={
                "rate": "universal",
                "category": {
                    "ratios": {
                        "STP1": 0.1,
                        "STP2": 0.1,
                        "STP3": 0.1,
                        "STP4": 0.1,
                        "STP5": 0.1,
                        "STP6": 0.1,
                        "STP7": 0.1,
                        "STP8": 0.1,
                        "STP9": 0.1,
                        "STP10": 0.1,
                    }
                },
            },
        ),

        
        #########################
        # 3. Outcomes

        # 3.1 symptoms
        # 3.2 diagnostic cats
        # 3.3 prescriptions
        # 3.4 healthcare use
        # events need to be able to happen multiple times
        # so var for each event in each time window, (index, index + 8 weeks)

        #########################
        # 4. Sensitivity/Secondary analyses

        # 4.1 Vaccination status
        # 4.2 coded long-COVID        



        
    )
    return common_variables
