from cohortextractor import filter_codes_by_category, patients, combine_codelists
from codelists import *
from datetime import datetime, timedelta


def generate_outcome_variables_diag_contemporary(index_date_variable):
    outcome_variables_diag_contemporary = dict(



# EACH OUTCOME REPEATED FOUR TIMES, AS FOLLOWS:
# "EVER AFTER INDEX" (HAVE GOT THE ACTUAL DATE HERE IN CASE ASKED TO DO TIME TO EVENT BY REVIEWER, ALL THE REMAINDER ARE BINARY FLAG)
# TIME PERIOD ONE (T1): 4-12 WEEKS (28 - 84 days)
# TIME PERIOD TWO (T2): 12 WEEKS TO 6 MONTHS (85 days - 180 days)
# TIME PERIOD THREE (T3): 6 MONTHS ONWARDS (181 days+)

    infect_parasite=patients.with_these_clinical_events(
        infectious_disease_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_infect_parasite=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_infect_parasite=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_infect_parasite=patients.with_these_clinical_events(
        infectious_disease_codes,
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
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
        neoplastic_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_neoplasms=patients.with_these_clinical_events(
        neoplastic_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_neoplasms=patients.with_these_clinical_events(
        neoplastic_disease_codes,
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
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
        combine_codelists(
            blood_cellular_disease_codes,
            disorder_haematopoietic_codes,
            disorder_immune_codes,
        ),
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_blood_diseases=patients.with_these_clinical_events(
        combine_codelists(
            blood_cellular_disease_codes,
            disorder_haematopoietic_codes,
            disorder_immune_codes,
        ),
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_blood_diseases=patients.with_these_clinical_events(
        combine_codelists(
            blood_cellular_disease_codes,
            disorder_haematopoietic_codes,
            disorder_immune_codes,
        ),
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    endocr_nutr_dis=patients.with_these_clinical_events(
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

    t1_endocr_nutr_dis=patients.with_these_clinical_events(
        combine_codelists(
            disorder_endocrine_codes,
            metabolic_disease_codes,
            nutritional_disorder_codes,
        ),
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_endocr_nutr_dis=patients.with_these_clinical_events(
        combine_codelists(
            disorder_endocrine_codes,
            metabolic_disease_codes,
            nutritional_disorder_codes,
        ),
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_endocr_nutr_dis=patients.with_these_clinical_events(
        combine_codelists(
            disorder_endocrine_codes,
            metabolic_disease_codes,
            nutritional_disorder_codes,
        ),
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    

    mental_disorder=patients.with_these_clinical_events(
        mental_disorder_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_mental_disorder=patients.with_these_clinical_events(
        mental_disorder_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_mental_disorder=patients.with_these_clinical_events(
        mental_disorder_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_mental_disorder=patients.with_these_clinical_events(
        mental_disorder_codes,
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    nervous_sys_dis=patients.with_these_clinical_events(
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

    t1_nervous_sys_dis=patients.with_these_clinical_events(
        combine_codelists(
            disorder_neurological_codes,
            cns_codes,
        ),
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_nervous_sys_dis=patients.with_these_clinical_events(
        combine_codelists(
            disorder_neurological_codes,
            cns_codes,
        ),
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_nervous_sys_dis=patients.with_these_clinical_events(
        combine_codelists(
            disorder_neurological_codes,
            cns_codes,
        ),
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    eye_adnexa_dis=patients.with_these_clinical_events(
        visual_disorder_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_eye_adnexa_dis=patients.with_these_clinical_events(
        visual_disorder_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_eye_adnexa_dis=patients.with_these_clinical_events(
        visual_disorder_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_eye_adnexa_dis=patients.with_these_clinical_events(
        visual_disorder_codes,
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    ear_mastoid_dis=patients.with_these_clinical_events(
        auditory_disorder_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_ear_mastoid_dis=patients.with_these_clinical_events(
        auditory_disorder_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_ear_mastoid_dis=patients.with_these_clinical_events(
        auditory_disorder_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_ear_mastoid_dis=patients.with_these_clinical_events(
        auditory_disorder_codes,
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    circ_sys_dis=patients.with_these_clinical_events(
        cardiovascular_disease_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_circ_sys_dis=patients.with_these_clinical_events(
        cardiovascular_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_circ_sys_dis=patients.with_these_clinical_events(
        cardiovascular_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_circ_sys_dis=patients.with_these_clinical_events(
        cardiovascular_disease_codes,
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    resp_system_dis=patients.with_these_clinical_events(
        disorder_respiratory_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_resp_system_dis=patients.with_these_clinical_events(
        disorder_respiratory_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_resp_system_dis=patients.with_these_clinical_events(
        disorder_respiratory_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_resp_system_dis=patients.with_these_clinical_events(
        disorder_respiratory_codes,
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    digest_syst_dis=patients.with_these_clinical_events(
        disorder_digestive_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_digest_syst_dis=patients.with_these_clinical_events(
        disorder_digestive_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_digest_syst_dis=patients.with_these_clinical_events(
        disorder_digestive_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_digest_syst_dis=patients.with_these_clinical_events(
        disorder_digestive_codes,
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
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
        disorder_skin_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_skin_disease=patients.with_these_clinical_events(
        disorder_skin_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_skin_disease=patients.with_these_clinical_events(
        disorder_skin_codes,
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    musculo_dis=patients.with_these_clinical_events(
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

    t1_musculo_dis=patients.with_these_clinical_events(
        combine_codelists(
            disorder_musculoskeletal_codes,
            disorder_connective_codes,
        ),
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_musculo_dis=patients.with_these_clinical_events(
        combine_codelists(
            disorder_musculoskeletal_codes,
            disorder_connective_codes,
        ),
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_musculo_dis=patients.with_these_clinical_events(
        combine_codelists(
            disorder_musculoskeletal_codes,
            disorder_connective_codes,
        ),
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    genitourin_dis=patients.with_these_clinical_events(
        disorder_genitourinary_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_genitourin_dis=patients.with_these_clinical_events(
        disorder_genitourinary_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_genitourin_dis=patients.with_these_clinical_events(
        disorder_genitourinary_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_genitourin_dis=patients.with_these_clinical_events(
        disorder_genitourinary_codes,
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    pregnancy_compl=patients.with_these_clinical_events(
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

    t1_pregnancy_compl=patients.with_these_clinical_events(
        combine_codelists(
            compl_pregnancy_codes,
            disorder_peurperium_codes,
            disorder_labor_codes,
        ),
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_pregnancy_compl=patients.with_these_clinical_events(
        combine_codelists(
            compl_pregnancy_codes,
            disorder_peurperium_codes,
            disorder_labor_codes,
        ),
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_pregnancy_compl=patients.with_these_clinical_events(
        combine_codelists(
            compl_pregnancy_codes,
            disorder_peurperium_codes,
            disorder_labor_codes,
        ),
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    perinatal_dis=patients.with_these_clinical_events(
        disorder_fetus_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_perinatal_dis=patients.with_these_clinical_events(
        disorder_fetus_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_perinatal_dis=patients.with_these_clinical_events(
        disorder_fetus_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_perinatal_dis=patients.with_these_clinical_events(
        disorder_fetus_codes,
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    congenital_dis=patients.with_these_clinical_events(
        congential_disease_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_congenital_dis=patients.with_these_clinical_events(
        congential_disease_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_congenital_dis=patients.with_these_clinical_events(
        congential_disease_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_congenital_dis=patients.with_these_clinical_events(
        congential_disease_codes,
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    injury_poison=patients.with_these_clinical_events(
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

    t1_injury_poison=patients.with_these_clinical_events(
        combine_codelists(
            poisoning_codes,
            injury_codes,
        ),
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_injury_poison=patients.with_these_clinical_events(
        combine_codelists(
            poisoning_codes,
            injury_codes,
        ),
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_injury_poison=patients.with_these_clinical_events(
        combine_codelists(
            poisoning_codes,
            injury_codes,
        ),
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),



    hypertension_bugTest=patients.with_these_clinical_events(
        hypertension_from_hhclassifAndAnna,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),

    t1_hypertension_bugTest=patients.with_these_clinical_events(
        hypertension_from_hhclassifAndAnna,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_hypertension_bugTest=patients.with_these_clinical_events(
        hypertension_from_hhclassifAndAnna,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_hypertension_bugTest=patients.with_these_clinical_events(
        hypertension_from_hhclassifAndAnna,
        between=[f"{index_date_variable} + 181 days", "2022-01-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),






    )
    return outcome_variables_diag_contemporary