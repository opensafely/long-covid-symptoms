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

# OUTCOME VARIABLES
auditory_disorder_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-auditory-system-all-descendants.csv",
    system="ctv3",
    column="code",
)

compl_pregnancy_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-complication-of-pregnancy-childbirth-andor-the-puerperium-all-descendants.csv",
    system="ctv3",
    column="code",
)

disorder_peurperium_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-puerperium-all-descendants.csv",
    system="ctv3",
    column="code",
)

disorder_labor_codes = codelist_from_csv(
    "codelists/user-kate-mansfield-disorder-of-labor-delivery-all-descendants.csv",
    system="ctv3",
    column="code",
)



####################################################################################################
##The following is Anna's code for her neurovaccine study, leaving in for the moment so code runs##
bells_palsy_primary_care_codes = codelist_from_csv(
    "codelists/opensafely-bells-palsy.csv",
    system="ctv3",
    column="code",
)
bells_palsy_secondary_care_codes = codelist_from_csv(
    "codelists/opensafely-bells-palsy-icd-10.csv",
    system="icd10",
    column="code",
)
bells_palsy_emergency_care_codes = codelist(["193093009"], system="snomed")
transverse_myelitis_primary_care_codes = codelist_from_csv(
    "codelists/opensafely-transverse-myelitis.csv",
    system="ctv3",
    column="CTV3Code",
)
transverse_myelitis_secondary_care_codes = codelist_from_csv(
    "codelists/opensafely-acute-transverse-myelitis-icd-10.csv",
    system="icd10",
    column="code",
)
guillain_barre_primary_care_codes = codelist_from_csv(
    "codelists/opensafely-guillain-barre.csv",
    system="ctv3",
    column="code",
)
guillain_barre_secondary_care_codes = codelist_from_csv(
    "codelists/opensafely-guillain-barre-syndrome-icd10.csv",
    system="icd10",
    column="code",
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

diabetes = codelist_from_csv(
    "codelists/opensafely-diabetes.csv",
    system="ctv3",
    column="CTV3ID",
)
hiv = codelist_from_csv(
    "codelists/opensafely-hiv.csv",
    system="ctv3",
    column="CTV3ID",
)
cancer_excluding_lung_and_haematological = codelist_from_csv(
    "codelists/opensafely-cancer-excluding-lung-and-haematological.csv",
    system="ctv3",
    column="CTV3ID",
)
lung_cancer = codelist_from_csv(
    "codelists/opensafely-lung-cancer.csv",
    system="ctv3",
    column="CTV3ID",
)
haematological_cancer = codelist_from_csv(
    "codelists/opensafely-haematological-cancer.csv",
    system="ctv3",
    column="CTV3ID",
)
hypertension = codelist_from_csv(
    "codelists/opensafely-hypertension.csv",
    system="ctv3",
    column="CTV3ID",
)
preg = codelist_from_csv(
    "codelists/primis-covid19-vacc-uptake-preg.csv",
    system="snomed",
    column="code",
)
ms_no_primary_care = codelist_from_csv(
    "codelists/opensafely-multiple-sclerosis-v2.csv",
    system="ctv3",
    column="code",
)
cidp_primary_care = codelist_from_csv(
    "codelists/opensafely-chronic-inflammatory-demyelinating-polyneuropathy-cidp.csv",
    system="ctv3",
    column="code",
)

# Systemic inflammatory or autoimmune disorders combining: 
## ankylosing spondylitis
## antiphospholipid syndrome
antiphospholipid = codelist_from_csv(
    "codelists/opensafely-antiphospholipid-syndrome.csv",
    system="ctv3",
    column="code",
)
## Behçet disease
## mixed connective tissue disease
## rheumatoid arthritis a
rheumatoid_arthritis = codelist_from_csv(
    "codelists/opensafely-rheumatoid-arthritis.csv",
    system="ctv3",
    column="CTV3ID",
)
## SLE 
lupus = codelist_from_csv(
    "codelists/opensafely-systemic-lupus-erythematosus-sle.csv",
    system="ctv3",
    column="CTV3ID",
)
## sarcoidosis
## scleroderma
## Sjögren syndrome


