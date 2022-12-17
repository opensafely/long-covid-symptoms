import pandas as pd
from osmatching import match

## MATCH SEPARATE STPS OF CASES AND CONTROLS
#stp5
match(
    case_csv="input_covid_communitycases_stp26",
    match_csv="input_controls_historical_stp26",
    matches_per_case=5,
    match_variables={
        "age": 1,
        "sex": "category",
    },
    index_date_variable="case_index_date", 
    replace_match_index_date_with_case="3_years_earlier", 
    date_exclusion_variables={
        "death_date": "before",
        "dereg_date": "before",
        "first_known_covid19": "before",
        "covid_hosp": "before"
    },
    #  indicator_variable_name="indicatorVariableName", 
    output_suffix="_historical_stp26",
    output_path="output",
)


