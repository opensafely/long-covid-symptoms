from cohortextractor import filter_codes_by_category, patients, combine_codelists
from codelists import *
from datetime import datetime, timedelta


def generate_covariates_complete(index_date_variable):

    covariates_complete = dict(

    # DEMOGRAPHICS AND LIFESTYLE 

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

    #Took this out now handled in dedicated files for gpcount
    #NUMBER OF GP CONSULTATIONS IN THE PREVIOUS YEAR
    #gp_count=patients.with_gp_consultations(
    #    between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
    #    returning="number_of_matches_in_period",
    #    return_expectations={"int": {"distribution": "normal", "mean": 6, "stddev": 3},"incidence": 0.6,},
    #),



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




    # MEDICATIONS (PRESCRIPTIONS FOR ANY OF THE BROAD MEDICATION CATEGORIES IN THE PREVIOUS YEAR)
    prev_bnf_gastro_broad=patients.with_these_medications(
        gastro_broad_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_cardio_broad=patients.with_these_medications(
        cardio_broad_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_respiratory_broad=patients.with_these_medications(
        respiratory_broad_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_cns_broad=patients.with_these_medications(
        cns_broad_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_infect_broad=patients.with_these_medications(
        infections_broad_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_endo_broad=patients.with_these_medications(
        endocrine_broad_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_obstet_broad=patients.with_these_medications(
        obstetrics_broad_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_malign_broad=patients.with_these_medications(
        malignancies_broad_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_nutr_broad=patients.with_these_medications(
        nutrition_blood_broad_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_musculo_broad=patients.with_these_medications(
        musculo_broad_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_eye_broad=patients.with_these_medications(
        eye_broad_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_ear_broad=patients.with_these_medications(
        ear_broad_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_skin_broad=patients.with_these_medications(
        skin_broad_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_broncho_spec=patients.with_these_medications(
        bronchodil_spec_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_cough_spec=patients.with_these_medications(
        cough_spec_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_antiarrhth_spec=patients.with_these_medications(
        antiarrhth_spec_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_analgesics_spec=patients.with_these_medications(
        analgesics_spec_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_hypnotics_spec=patients.with_these_medications(
        hypnotics_spec_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_nausea_spec=patients.with_these_medications(
        nausea_spec_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_diarrhoea_spec=patients.with_these_medications(
        diarrhoea_spec_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_nsaids_spec=patients.with_these_medications(
        nsaids_spec_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_topicalpain_spec=patients.with_these_medications(
        topicalpain_spec_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_antidepr_spec=patients.with_these_medications(
        antidepr_spec_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    prev_bnf_anxiolytic_spec=patients.with_these_medications(
        anxiolytic_spec_bnf_codes,
        between=[f"{index_date_variable} - 1 year", f"{index_date_variable}"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    
    )
    return covariates_complete