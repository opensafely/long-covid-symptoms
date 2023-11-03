from cohortextractor import filter_codes_by_category, patients, combine_codelists
from codelists import *
from datetime import datetime, timedelta


def generate_outcome_variables_medicines_contemporary_omicron(index_date_variable):
    outcome_variables_medicines_contemporary_omicron = dict(



# EACH OUTCOME REPEATED FOUR TIMES, AS FOLLOWS:
# "EVER AFTER INDEX" (HAVE GOT THE ACTUAL DATE HERE IN CASE ASKED TO DO TIME TO EVENT BY REVIEWER, ALL THE REMAINDER ARE BINARY FLAG)
# TIME PERIOD ONE (T1): 4-12 WEEKS (28 - 84 days)
# TIME PERIOD TWO (T2): 12 WEEKS TO 6 MONTHS (85 days - 180 days)
# TIME PERIOD THREE (T3): 6 MONTHS - 12 MONTHS



    bnf_gastro_broad=patients.with_these_medications(
        gastro_broad_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_gastro_broad=patients.with_these_medications(
        gastro_broad_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_gastro_broad=patients.with_these_medications(
        gastro_broad_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_gastro_broad=patients.with_these_medications(
        gastro_broad_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"], #up to latest follow-up date post-omicron
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 


    bnf_cardio_broad=patients.with_these_medications(
        cardio_broad_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_cardio_broad=patients.with_these_medications(
        cardio_broad_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_cardio_broad=patients.with_these_medications(
        cardio_broad_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_cardio_broad=patients.with_these_medications(
        cardio_broad_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 
    

    bnf_respiratory_broad=patients.with_these_medications(
        respiratory_broad_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_respiratory_broad=patients.with_these_medications(
        respiratory_broad_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_respiratory_broad=patients.with_these_medications(
        respiratory_broad_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_respiratory_broad=patients.with_these_medications(
        respiratory_broad_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 


    bnf_cns_broad=patients.with_these_medications(
        cns_broad_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_cns_broad=patients.with_these_medications(
        cns_broad_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_cns_broad=patients.with_these_medications(
        cns_broad_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_cns_broad=patients.with_these_medications(
        cns_broad_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 


    bnf_infect_broad=patients.with_these_medications(
        infections_broad_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_infect_broad=patients.with_these_medications(
        infections_broad_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_infect_broad=patients.with_these_medications(
        infections_broad_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_infect_broad=patients.with_these_medications(
        infections_broad_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 


    bnf_endo_broad=patients.with_these_medications(
        endocrine_broad_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_endo_broad=patients.with_these_medications(
        endocrine_broad_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_endo_broad=patients.with_these_medications(
        endocrine_broad_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_endo_broad=patients.with_these_medications(
        endocrine_broad_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 


    bnf_obstet_broad=patients.with_these_medications(
        obstetrics_broad_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_obstet_broad=patients.with_these_medications(
        obstetrics_broad_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_obstet_broad=patients.with_these_medications(
        obstetrics_broad_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_obstet_broad=patients.with_these_medications(
        obstetrics_broad_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 


    bnf_malign_broad=patients.with_these_medications(
        malignancies_broad_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_malign_broad=patients.with_these_medications(
        malignancies_broad_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_malign_broad=patients.with_these_medications(
        malignancies_broad_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_malign_broad=patients.with_these_medications(
        malignancies_broad_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_nutr_broad=patients.with_these_medications(
        nutrition_blood_broad_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_nutr_broad=patients.with_these_medications(
        nutrition_blood_broad_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_nutr_broad=patients.with_these_medications(
        nutrition_blood_broad_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_nutr_broad=patients.with_these_medications(
        nutrition_blood_broad_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_musculo_broad=patients.with_these_medications(
        musculo_broad_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_musculo_broad=patients.with_these_medications(
        musculo_broad_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_musculo_broad=patients.with_these_medications(
        musculo_broad_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_musculo_broad=patients.with_these_medications(
        musculo_broad_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_eye_broad=patients.with_these_medications(
        eye_broad_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_eye_broad=patients.with_these_medications(
        eye_broad_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_eye_broad=patients.with_these_medications(
        eye_broad_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_eye_broad=patients.with_these_medications(
        eye_broad_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_ear_broad=patients.with_these_medications(
        ear_broad_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_ear_broad=patients.with_these_medications(
        ear_broad_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_ear_broad=patients.with_these_medications(
        ear_broad_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_ear_broad=patients.with_these_medications(
        ear_broad_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_skin_broad=patients.with_these_medications(
        skin_broad_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_skin_broad=patients.with_these_medications(
        skin_broad_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_skin_broad=patients.with_these_medications(
        skin_broad_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_skin_broad=patients.with_these_medications(
        skin_broad_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_broncho_spec=patients.with_these_medications(
        bronchodil_spec_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_broncho_spec=patients.with_these_medications(
        bronchodil_spec_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_broncho_spec=patients.with_these_medications(
        bronchodil_spec_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_broncho_spec=patients.with_these_medications(
        bronchodil_spec_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_cough_spec=patients.with_these_medications(
        cough_spec_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_cough_spec=patients.with_these_medications(
        cough_spec_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_cough_spec=patients.with_these_medications(
        cough_spec_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_cough_spec=patients.with_these_medications(
        cough_spec_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_antiarrhth_spec=patients.with_these_medications(
        antiarrhth_spec_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_antiarrhth_spec=patients.with_these_medications(
        antiarrhth_spec_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_antiarrhth_spec=patients.with_these_medications(
        antiarrhth_spec_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_antiarrhth_spec=patients.with_these_medications(
        antiarrhth_spec_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_analgesics_spec=patients.with_these_medications(
        analgesics_spec_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_analgesics_spec=patients.with_these_medications(
        analgesics_spec_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_analgesics_spec=patients.with_these_medications(
        analgesics_spec_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_analgesics_spec=patients.with_these_medications(
        analgesics_spec_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_hypnotics_spec=patients.with_these_medications(
        hypnotics_spec_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_hypnotics_spec=patients.with_these_medications(
        hypnotics_spec_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_hypnotics_spec=patients.with_these_medications(
        hypnotics_spec_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_hypnotics_spec=patients.with_these_medications(
        hypnotics_spec_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_nausea_spec=patients.with_these_medications(
        nausea_spec_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_nausea_spec=patients.with_these_medications(
        nausea_spec_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_nausea_spec=patients.with_these_medications(
        nausea_spec_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_nausea_spec=patients.with_these_medications(
        nausea_spec_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_diarrhoea_spec=patients.with_these_medications(
        diarrhoea_spec_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_diarrhoea_spec=patients.with_these_medications(
        diarrhoea_spec_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_diarrhoea_spec=patients.with_these_medications(
        diarrhoea_spec_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_diarrhoea_spec=patients.with_these_medications(
        diarrhoea_spec_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_nsaids_spec=patients.with_these_medications(
        nsaids_spec_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_nsaids_spec=patients.with_these_medications(
        nsaids_spec_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_nsaids_spec=patients.with_these_medications(
        nsaids_spec_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_nsaids_spec=patients.with_these_medications(
        nsaids_spec_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_topicalpain_spec=patients.with_these_medications(
        topicalpain_spec_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_topicalpain_spec=patients.with_these_medications(
        topicalpain_spec_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_topicalpain_spec=patients.with_these_medications(
        topicalpain_spec_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_topicalpain_spec=patients.with_these_medications(
        topicalpain_spec_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_antidepr_spec=patients.with_these_medications(
        antidepr_spec_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_antidepr_spec=patients.with_these_medications(
        antidepr_spec_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_antidepr_spec=patients.with_these_medications(
        antidepr_spec_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_antidepr_spec=patients.with_these_medications(
        antidepr_spec_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),


    bnf_anxiolytic_spec=patients.with_these_medications(
        anxiolytic_spec_bnf_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_bnf_anxiolytic_spec=patients.with_these_medications(
        anxiolytic_spec_bnf_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_bnf_anxiolytic_spec=patients.with_these_medications(
        anxiolytic_spec_bnf_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_bnf_anxiolytic_spec=patients.with_these_medications(
        anxiolytic_spec_bnf_codes,
        between=[f"{index_date_variable} + 181 days", "2023-03-31"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),

    )
    return outcome_variables_medicines_contemporary_omicron