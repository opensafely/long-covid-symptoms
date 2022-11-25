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
#First approved set (25 Nov) i.e.:
#opensafely/symptoms-cough/72d8934b
#opensafely/symptoms-chest-tightness/40b9ace1
#opensafely/symptoms-palpitations/27aa39ac
#opensafely/symptoms-fatigue/0e9ac677
#opensafely/symptoms-fever/758b5341
#opensafely/symptoms-cognitive-impairment/7af0d32d
#opensafely/symptoms-sleep-disturbance/59c92016
#opensafely/symptoms-peripheral-neuropathy/09fbfa1a
#opensafely/symptoms-dizzy/5c7be00c
#opensafely/symptoms-mobility-impairment/62a81387


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

mobilityimpairment_symptom_codes = codelist_from_csv(
    "codelists/opensafely-symptoms-mobility-impairment.csv",
    system="snomed",
    column="code",
)






