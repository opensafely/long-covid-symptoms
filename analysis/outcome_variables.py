from cohortextractor import filter_codes_by_category, patients, combine_codelists
from codelists import *
from datetime import datetime, timedelta


def generate_outcome_variables(index_date_variable):
    outcome_variables = dict(


    infection_or_parasite=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),    
    
    neoplasms=patients.with_these_clinical_events(
        neoplastic_disease_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ), 

    blood_diseases=patients.with_these_clinical_events(
        combine_codelists(
            blood_cellular_disease_codes,
            disorder_haematopoietic_codes,
            disorder_immune_codes,
        ),
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    endocrine_nutr_metab_diseases=patients.with_these_clinical_events(
        combine_codelists(
            disorder_endocrine_codes,
            metabolic_disease_codes,
            nutritional_disorder_codes,
        ),
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    mental_behav_disorder=patients.with_these_clinical_events(
        mental_disorder_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    nervous_system_diseases=patients.with_these_clinical_events(
        combine_codelists(
            disorder_neurological_codes,
            cns_codes,
        ),
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    ear_mastoid_disease=patients.with_these_clinical_events(
        auditory_disorder_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    circulatory_system_disease=patients.with_these_clinical_events(
        cardiovascular_disease_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    respiratory_system_disease=patients.with_these_clinical_events(
        disorder_respiratory_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    digestive_system_disease=patients.with_these_clinical_events(
        disorder_digestive_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    skin_disease=patients.with_these_clinical_events(
        disorder_skin_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    muscuoloskeletal_connective_diseases=patients.with_these_clinical_events(
        combine_codelists(
            disorder_musculoskeletal_codes,
            disorder_connective_codes,
        ),
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    genitourinary_disease=patients.with_these_clinical_events(
        disorder_genitourinary_codes,
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

    perinatal_disease=patients.with_these_clinical_events(
        disorder_fetus_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    congenital_disease=patients.with_these_clinical_events(
        congential_disease_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    injury_poisoning=patients.with_these_clinical_events(
        combine_codelists(
            poisoning_codes,
            injury_codes,
        ),
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),




    

    )
    return outcome_variables