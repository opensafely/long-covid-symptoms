from cohortextractor import filter_codes_by_category, patients, combine_codelists
from codelists import *
from datetime import datetime, timedelta


def generate_outcome_variables(index_date_variable):
    outcome_variables = dict(



# EACH OUTCOME REPEATED FOUR TIMES, AS FOLLOWS:
# "EVER AFTER INDEX" (HAVE GOT THE ACTUAL DATE HERE IN CASE ASKED TO DO TIME TO EVENT BY REVIEWER, ALL THE REMAINDER ARE BINARY FLAG)
# TIME PERIOD ONE (T1): 4-12 WEEKS (28 - 84 days)
# TIME PERIOD TWO (T2): 12 WEEKS TO 6 MONTHS (85 days - 180 days)
# TIME PERIOD THREE (T3): 6 MONTHS ONWARDS (181 days+)

    infection_or_parasite=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_infection_or_parasite=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_infection_or_parasite=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_infection_or_parasite=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 


    
    neoplasms=patients.with_these_clinical_events(
        neoplastic_disease_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ), 

    t1_neoplasms=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_neoplasms=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_neoplasms=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
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

    t1_blood_diseases=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_blood_diseases=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_blood_diseases=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
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

    t1_endocrine_nutr_metab_diseases=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_endocrine_nutr_metab_diseases=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_endocrine_nutr_metab_diseases=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    

    mental_behav_disorder=patients.with_these_clinical_events(
        mental_disorder_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_mental_behav_disorder=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_mental_behav_disorder=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_mental_behav_disorder=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
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

    t1_nervous_system_diseases=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_nervous_system_diseases=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_nervous_system_diseases=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    ear_mastoid_disease=patients.with_these_clinical_events(
        auditory_disorder_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_ear_mastoid_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_ear_mastoid_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_ear_mastoid_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    circulatory_system_disease=patients.with_these_clinical_events(
        cardiovascular_disease_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_circulatory_system_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_circulatory_system_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_circulatory_system_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    respiratory_system_disease=patients.with_these_clinical_events(
        disorder_respiratory_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_respiratory_system_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_respiratory_system_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_respiratory_system_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    digestive_system_disease=patients.with_these_clinical_events(
        disorder_digestive_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_digestive_system_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_digestive_system_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_digestive_system_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    skin_disease=patients.with_these_clinical_events(
        disorder_skin_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_skin_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_skin_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_skin_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
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

    t1_muscuoloskeletal_connective_diseases=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_muscuoloskeletal_connective_diseases=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_muscuoloskeletal_connective_diseases=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    genitourinary_disease=patients.with_these_clinical_events(
        disorder_genitourinary_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_genitourinary_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_genitourinary_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_genitourinary_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
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

    t1_pregnancy_complications=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_pregnancy_complications=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_pregnancy_complications=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    perinatal_disease=patients.with_these_clinical_events(
        disorder_fetus_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_perinatal_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_perinatal_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_perinatal_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    congenital_disease=patients.with_these_clinical_events(
        congential_disease_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_congenital_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_congenital_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_congenital_disease=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
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

    t1_injury_poisoning=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_injury_poisoning=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_injury_poisoning=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    )
    return outcome_variables