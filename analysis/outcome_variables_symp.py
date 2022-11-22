from cohortextractor import filter_codes_by_category, patients, combine_codelists
from codelists import *
from datetime import datetime, timedelta


def generate_outcome_variables_symp(index_date_variable):
    outcome_variables_symp = dict(



# EACH OUTCOME REPEATED FOUR TIMES, AS FOLLOWS:
# "EVER AFTER INDEX" (HAVE GOT THE ACTUAL DATE HERE IN CASE ASKED TO DO TIME TO EVENT BY REVIEWER, ALL THE REMAINDER ARE BINARY FLAG)
# TIME PERIOD ONE (T1): 4-12 WEEKS (28 - 84 days)
# TIME PERIOD TWO (T2): 12 WEEKS TO 6 MONTHS (85 days - 180 days)
# TIME PERIOD THREE (T3): 6 MONTHS ONWARDS (181 days+)

    symp_breathless=patients.with_these_clinical_events(
        breathlessness_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_breathless=patients.with_these_clinical_events(
        breathlessness_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_breathless=patients.with_these_clinical_events(
        breathlessness_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_breathless=patients.with_these_clinical_events(
        breathlessness_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 




    symp_chestpain=patients.with_these_clinical_events(
        chestpain_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_chestpain=patients.with_these_clinical_events(
        chestpain_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_chestpain=patients.with_these_clinical_events(
        chestpain_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_chestpain=patients.with_these_clinical_events(
        chestpain_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 



    symp_chesttight=patients.with_these_clinical_events(
        chesttightness_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_chesttight=patients.with_these_clinical_events(
        chesttightness_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_chesttight=patients.with_these_clinical_events(
        chesttightness_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_chesttight=patients.with_these_clinical_events(
        chesttightness_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 



    symp_cough=patients.with_these_clinical_events(
        cough_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_cough=patients.with_these_clinical_events(
        cough_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_cough=patients.with_these_clinical_events(
        cough_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_cough=patients.with_these_clinical_events(
        cough_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 
    


    symp_dizzy=patients.with_these_clinical_events(
        dizzy_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_dizzy=patients.with_these_clinical_events(
        dizzy_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_dizzy=patients.with_these_clinical_events(
        dizzy_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_dizzy=patients.with_these_clinical_events(
        dizzy_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 



    symp_fatigue=patients.with_these_clinical_events(
        fatigue_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_fatigue=patients.with_these_clinical_events(
        fatigue_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_fatigue=patients.with_these_clinical_events(
        fatigue_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_fatigue=patients.with_these_clinical_events(
        fatigue_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 



    symp_fever=patients.with_these_clinical_events(
        fever_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_fever=patients.with_these_clinical_events(
        fever_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_fever=patients.with_these_clinical_events(
        fever_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_fever=patients.with_these_clinical_events(
        fever_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 



    symp_mobilityimpair=patients.with_these_clinical_events(
        mobilityimpairment_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_mobilityimpair=patients.with_these_clinical_events(
        mobilityimpairment_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_mobilityimpair=patients.with_these_clinical_events(
        mobilityimpairment_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_mobilityimpair=patients.with_these_clinical_events(
        mobilityimpairment_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 



    symp_palp=patients.with_these_clinical_events(
        palpitations_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_palp=patients.with_these_clinical_events(
        palpitations_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_palp=patients.with_these_clinical_events(
        palpitations_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_palp=patients.with_these_clinical_events(
        palpitations_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 



    symp_periphneuro=patients.with_these_clinical_events(
        peripheralneuropathy_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_periphneuro=patients.with_these_clinical_events(
        peripheralneuropathy_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_periphneuro=patients.with_these_clinical_events(
        peripheralneuropathy_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_periphneuro=patients.with_these_clinical_events(
        peripheralneuropathy_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 



    symp_sleepdisturb=patients.with_these_clinical_events(
        sleepdisturbance_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_sleepdisturb=patients.with_these_clinical_events(
        sleepdisturbance_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_sleepdisturb=patients.with_these_clinical_events(
        sleepdisturbance_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_sleepdisturb=patients.with_these_clinical_events(
        sleepdisturbance_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 



    symp_delirium=patients.with_these_clinical_events(
        delirium_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_delirium=patients.with_these_clinical_events(
        delirium_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_delirium=patients.with_these_clinical_events(
        delirium_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_delirium=patients.with_these_clinical_events(
        delirium_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 



    symp_hairloss=patients.with_these_clinical_events(
        hairloss_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_hairloss=patients.with_these_clinical_events(
        hairloss_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_hairloss=patients.with_these_clinical_events(
        hairloss_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_hairloss=patients.with_these_clinical_events(
        hairloss_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 



    symp_headache=patients.with_these_clinical_events(
        headache_symptom_codes,
        on_or_after=f"{index_date_variable}",
        find_first_match_in_period=True,
        returning="date", 
        date_format="YYYY-MM-DD",
        return_expectations={"date": {"earliest": "index_date"}},
    ),  

    t1_symp_headache=patients.with_these_clinical_events(
        headache_symptom_codes,
        between=[f"{index_date_variable} + 28 days", f"{index_date_variable} + 84 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t2_symp_headache=patients.with_these_clinical_events(
        headache_symptom_codes,
        between=[f"{index_date_variable} + 85 days", f"{index_date_variable} + 180 days"],
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ),  

    t3_symp_headache=patients.with_these_clinical_events(
        headache_symptom_codes,
        on_or_after=f"{index_date_variable} + 181 days",
        returning="binary_flag", 
        return_expectations={"incidence": 0.15},
    ), 



    )
    return outcome_variables_symp