from cohortextractor import (
    codelist,
    codelist_from_csv,
)
# COVID VARIABLES
covid_codelist = codelist_from_csv(
    "codelists/opensafely-covid-identification.csv",
    system="icd10",
    column="icd10_code",
 )

covid_identification_in_primary_care_case_codes_clinical = codelist_from_csv(
    "codelists/opensafely-covid-identification-in-primary-care-probable-covid-clinical-code.csv",
    system="ctv3",
    column="CTV3ID",
)

covid_identification_in_primary_care_case_codes_test = codelist_from_csv(
    "codelists/opensafely-covid-identification-in-primary-care-probable-covid-positive-test.csv",
    system="ctv3",
    column="CTV3ID",
)

covid_identification_in_primary_care_case_codes_seq = codelist_from_csv(
    "codelists/opensafely-covid-identification-in-primary-care-probable-covid-sequelae.csv",
    system="ctv3",
    column="CTV3ID",
)




# DIAGNOSES OUTCOME VARIABLES
cns_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-central-nervous-system-finding-all-descendants.csv",
    system="snomed",
    column="code",
)

compl_pregnancy_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-complication-of-pregnancy-childbirth-andor-the-puerperium-all-descendants.csv",
    system="snomed",
    column="code",
)

congential_disease_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-congenital-disease-all-descendants.csv",
    system="snomed",
    column="code",
)

auditory_disorder_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-auditory-system-all-descendants.csv",
    system="snomed",
    column="code",
)

cardiovascular_disease_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-cardiovascular-system-all-descendants.csv",
    system="snomed",
    column="code",
)

blood_cellular_disease_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-cellular-component-of-blood-all-descendants.csv",
    system="snomed",
    column="code",
)

disorder_connective_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-connective-tissue-all-descendants.csv",
    system="snomed",
    column="code",
)

disorder_digestive_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-digestive-system-all-descendants.csv",
    system="snomed",
    column="code",
)

disorder_endocrine_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-endocrine-system-all-descendants.csv",
    system="snomed",
    column="code",
)

disorder_fetus_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-fetus-or-newborn-all-descendants.csv",
    system="snomed",
    column="code",
)

disorder_haematopoietic_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-hematopoietic-structure-all-descendants.csv",
    system="snomed",
    column="code",
)

disorder_immune_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-immune-function-all-descendants.csv",
    system="snomed",
    column="code",
)

disorder_labor_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-labor-delivery-all-descendants.csv",
    system="snomed",
    column="code",
)

disorder_musculoskeletal_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-musculoskeletal-system-all-descendants.csv",
    system="snomed",
    column="code",
)

disorder_neurological_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-nervous-system-all-descendants.csv",
    system="snomed",
    column="code",
)

disorder_peurperium_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-puerperium-all-descendants.csv",
    system="snomed",
    column="code",
)

disorder_respiratory_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-respiratory-system-all-descendants.csv",
    system="snomed",
    column="code",
)

disorder_skin_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-skin-andor-subcutaneous-tissue-all-descendants.csv",
    system="snomed",
    column="code",
)

disorder_genitourinary_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-the-genitourinary-system-all-descendants.csv",
    system="snomed",
    column="code",
)

infectious_disease_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-infectious-disease-all-descendants.csv",
    system="snomed",
    column="code",
)

mental_disorder_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-mental-disorder-all-descendants.csv",
    system="snomed",
    column="code",
)

metabolic_disease_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-metabolic-disease-all-descendants.csv",
    system="snomed",
    column="code",
)

neoplastic_disease_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-neoplastic-disease-all-descendants.csv",
    system="snomed",
    column="code",
)

nutritional_disorder_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-nutritional-disorder-all-descendants.csv",
    system="snomed",
    column="code",
)

poisoning_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-poisoning-all-descendants.csv",
    system="snomed",
    column="code",
)

injury_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-traumatic-andor-non-traumatic-injury-all-descendants.csv",
    system="snomed",
    column="code",
)

visual_disorder_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-visual-system-disorder-all-descendants.csv",
    system="snomed",
    column="code",
)

hypertension_from_hhclassifAndAnna = codelist_from_csv(
    "codelists/opensafely-hypertension.csv",
    system="ctv3",
    column="CTV3ID",
)





# SYMPTOM OUTCOME VARIABLES

breathless_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-breathlessness-new.csv",
    system="snomed",
    column="code",
)

cough_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-cough.csv",
    system="snomed",
    column="code",
)

chesttightness_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-chest-tightness.csv",
    system="snomed",
    column="code",
)

chestpain_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-chest-pain-unexplained.csv",
    system="snomed",
    column="code",
)

palpitations_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-palpitations.csv",
    system="snomed",
    column="code",
)

fatigue_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-fatigue.csv",
    system="snomed",
    column="code",
)

fever_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-fever.csv",
    system="snomed",
    column="code",
)

cogimpairment_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-cognitive-impairment.csv",
    system="snomed",
    column="code",
)

headache_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-headache.csv",
    system="snomed",
    column="code",
)

sleepdisturbance_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-sleep-disturbance.csv",
    system="snomed",
    column="code",
)

peripheralneuropathy_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-peripheral-neuropathy.csv",
    system="snomed",
    column="code",
)

dizzy_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-dizzy.csv",
    system="snomed",
    column="code",
)

delirium_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-delirium.csv",
    system="snomed",
    column="code",
)

mobilityimpairment_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-mobility-impairment.csv",
    system="snomed",
    column="code",
)

visualdisturbance_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-visual-disturbance.csv",
    system="snomed",
    column="code",
)

abdominalpain_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-abdominal-pain.csv",
    system="snomed",
    column="code",
)

nauseavomiting_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-nausea-and-vomiting.csv",
    system="snomed",
    column="code",
)

diarrhoea_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-diarrhoea.csv",
    system="snomed",
    column="code",
)

weightloss_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-weight-loss-and-reduced-appetite.csv",
    system="snomed",
    column="code",
)

pain_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-pain.csv",
    system="snomed",
    column="code",
)

depression_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-depression.csv",
    system="snomed",
    column="code",
)

anxiety_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-anxiety.csv",
    system="snomed",
    column="code",
)

ptsd_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-ptsd.csv",
    system="snomed",
    column="code",
)

tinnitus_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-tinnitus.csv",
    system="snomed",
    column="code",
)

earache_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-earache.csv",
    system="snomed",
    column="code",
)

sorethroat_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-sore-throat.csv",
    system="snomed",
    column="code",
)

taste_smell_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-loss-of-taste-or-smell.csv",
    system="snomed",
    column="code",
)

nasal_congestion_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-nasal-congestion.csv",
    system="snomed",
    column="code",
)

rashes_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-rashes.csv",
    system="snomed",
    column="code",
)

hairloss_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-hair-loss.csv",
    system="snomed",
    column="code",
)




# MEDICINES OUTCOME VARIABLES

gastro_broad_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-1-gastro-intestinal-system-dmd.csv",
    system="snomed",
    column="dmd_id",
)

cardio_broad_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-2-cardiovascular-system-dmd.csv",
    system="snomed",
    column="dmd_id",
)

respiratory_broad_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-3-respiratory-system-dmd.csv",
    system="snomed",
    column="dmd_id",
)

cns_broad_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-4-central-nervous-system-dmd.csv",
    system="snomed",
    column="dmd_id",
)

infections_broad_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-5-infections-dmd.csv",
    system="snomed",
    column="dmd_id",
)

endocrine_broad_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-6-endocrine-system-dmd.csv",
    system="snomed",
    column="dmd_id",
)

obstetrics_broad_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-7-obstetrics-gynaecology-and-urinary-tract-disorders-dmd.csv",
    system="snomed",
    column="dmd_id",
)

malignancies_broad_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-8-malignant-disease-and-immunosuppression-dmd.csv",
    system="snomed",
    column="dmd_id",
)

nutrition_blood_broad_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-9-nutrition-and-blood-dmd.csv",
    system="snomed",
    column="dmd_id",
)

musculo_broad_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-10-musculoskeletal-and-joint-diseases-dmd.csv",
    system="snomed",
    column="dmd_id",
)

eye_broad_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-11-eye-dmd.csv",
    system="snomed",
    column="dmd_id",
)

ear_broad_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-12-ear-nose-and-oropharynx-dmd.csv",
    system="snomed",
    column="dmd_id",
)

skin_broad_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-13-skin-dmd.csv",
    system="snomed",
    column="dmd_id",
)

bronchodil_spec_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-subcat-0301-bronchodilators-dmd.csv",
    system="snomed",
    column="dmd_id",
)

cough_spec_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-subcat-0309-cough-preparations-dmd.csv",
    system="snomed",
    column="dmd_id",
)

antiarrhth_spec_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-subcat-0203-anti-arrhythmic-drugs-dmd.csv",
    system="snomed",
    column="dmd_id",
)

analgesics_spec_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-subcat-0407-analgesics-dmd.csv",
    system="snomed",
    column="dmd_id",
)

hypnotics_spec_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-subcat-040101-hypnotics-dmd.csv",
    system="snomed",
    column="dmd_id",
)

nausea_spec_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-subcat-0406-drugs-used-in-nausea-and-vertigo-dmd.csv",
    system="snomed",
    column="dmd_id",
)

diarrhoea_spec_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-subcat-0104-acute-diarrhoea-dmd.csv",
    system="snomed",
    column="dmd_id",
)

nsaids_spec_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-subcat-100101-non-steroidal-anti-inflammatory-drugs-dmd.csv",
    system="snomed",
    column="dmd_id",
)

topicalpain_spec_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-subcat-100302-rubefacients-topical-nsaids-capsaicin-and-poultices-dmd.csv",
    system="snomed",
    column="dmd_id",
)

antidepr_spec_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-subcat-0403-antidepressant-drugs-dmd.csv",
    system="snomed",
    column="dmd_id",
)

anxiolytic_spec_bnf_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-bnf-subcat-040102-anxiolytics-dmd.csv",
    system="snomed",
    column="dmd_id",
)





# COVARIATES
ethnicity_codes = codelist_from_csv(
    "codelists/opensafely-ethnicity.csv",
    system="ctv3",
    column="Code",
    category_column="Grouping_6",
)

ethnicity_codes_16 = codelist_from_csv(
    "codelists/opensafely-ethnicity.csv",
    system="ctv3",
    column="Code",
    category_column="Grouping_16",
)


