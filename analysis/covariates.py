from cohortextractor import filter_codes_by_category, patients, combine_codelists
from codelists import *
from datetime import datetime, timedelta


def generate_covariates(index_date_variable):

    covariates = dict(

    # DEMOGRAPHICS AND LIFESTYLE 

    ### sex 
    sex=patients.sex(
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"M": 0.49, "F": 0.51}},
        }
    ),

    #ETHNICITY IN 5 CATEGORIES
    ethnicity=patients.with_these_clinical_events(
        ethnicity_codes,
        returning="category",
        find_last_match_in_period=True,
        include_date_of_match=True,
        return_expectations={
            "category": {"ratios": {"1": 0.25, "2": 0.25, "3": 0.25, "5": 0.25}},
            "incidence": 0.9,
        },
    ),

    #ETHNICITY IN 16 CATEGORIES
    ethnicity_16=patients.with_these_clinical_events(
        ethnicity_codes_16,
        returning="category",
        find_last_match_in_period=True,
        include_date_of_match=True,
        return_expectations={
            "category": {
                "ratios": {
                    "1": 0.0625,
                    "2": 0.0625,
                    "3": 0.0625,
                    "4": 0.0625,
                    "5": 0.0625,
                    "6": 0.0625,
                    "7": 0.0625,
                    "8": 0.0625,
                    "9": 0.0625,
                    "10": 0.0625,
                    "11": 0.0625,
                    "12": 0.0625,
                    "13": 0.0625,
                    "14": 0.0625,
                    "15": 0.0625,
                    "16": 0.0625,
                }
            },
            "incidence": 0.75,
        },
    ),


    imd=patients.categorised_as(
        {
            "0": "DEFAULT",
            "1": """index_of_multiple_deprivation >=1 AND index_of_multiple_deprivation < 32844*1/5""",
            "2": """index_of_multiple_deprivation >= 32844*1/5 AND index_of_multiple_deprivation < 32844*2/5""",
            "3": """index_of_multiple_deprivation >= 32844*2/5 AND index_of_multiple_deprivation < 32844*3/5""",
            "4": """index_of_multiple_deprivation >= 32844*3/5 AND index_of_multiple_deprivation < 32844*4/5""",
            "5": """index_of_multiple_deprivation >= 32844*4/5 AND index_of_multiple_deprivation < 32844""",
        },
        index_of_multiple_deprivation=patients.address_as_of(
            "index_date",
            returning="index_of_multiple_deprivation",
            round_to_nearest=100,
        ),
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "0": 0.05,
                    "1": 0.19,
                    "2": 0.19,
                    "3": 0.19,
                    "4": 0.19,
                    "5": 0.19,
                }
            },
        },

    ),


    # COMORBIDITIES (PRIOR DIAGNOSES OF BROAD DIAGNOSTIC CATEGORIES)
    comorb_infection_or_parasite=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),   

    comorb_neoplasms=patients.with_these_clinical_events(
        neoplastic_disease_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 

    comorb_blood_diseases=patients.with_these_clinical_events(
        combine_codelists(
            blood_cellular_disease_codes,
            disorder_haematopoietic_codes,
            disorder_immune_codes,
        ),
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_endocrine_nutr_metab_diseases=patients.with_these_clinical_events(
        combine_codelists(
            disorder_endocrine_codes,
            metabolic_disease_codes,
            nutritional_disorder_codes,
        ),
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_mental_behav_disorder=patients.with_these_clinical_events(
        mental_disorder_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_nervous_system_diseases=patients.with_these_clinical_events(
        combine_codelists(
            disorder_neurological_codes,
            cns_codes,
        ),
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_ear_mastoid_disease=patients.with_these_clinical_events(
        auditory_disorder_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_circulatory_system_disease=patients.with_these_clinical_events(
        cardiovascular_disease_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_respiratory_system_disease=patients.with_these_clinical_events(
        disorder_respiratory_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_digestive_system_disease=patients.with_these_clinical_events(
        disorder_digestive_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_skin_disease=patients.with_these_clinical_events(
        disorder_skin_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_muscuoloskeletal_connective_diseases=patients.with_these_clinical_events(
        combine_codelists(
            disorder_musculoskeletal_codes,
            disorder_connective_codes,
        ),
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_genitourinary_disease=patients.with_these_clinical_events(
        disorder_genitourinary_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_pregnancy_complications=patients.with_these_clinical_events(
        combine_codelists(
            compl_pregnancy_codes,
            disorder_peurperium_codes,
            disorder_labor_codes,
        ),
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_perinatal_disease=patients.with_these_clinical_events(
        disorder_fetus_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_congenital_disease=patients.with_these_clinical_events(
        congential_disease_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    comorb_injury_poisoning=patients.with_these_clinical_events(
        combine_codelists(
            poisoning_codes,
            injury_codes,
        ),
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 


    # RURAL OR URBAN LOCATION
    rural_urban=patients.address_as_of(
        "index_date",
        returning="rural_urban_classification",
        return_expectations={
            "rate": "universal",
            "category": 
                {"ratios": {
                    "1": 0.1,
                    "2": 0.1,
                    "3": 0.1,
                    "4": 0.1,
                    "5": 0.1,
                    "6": 0.1,
                    "7": 0.2,
                    "8": 0.2,
                }
            },
        },
    ),
    )
    return covariates