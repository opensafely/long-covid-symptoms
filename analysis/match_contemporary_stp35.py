import pandas as pd
from osmatching import match

## MATCH SEPARATE STPS OF CASES AND CONTROLS

#stp35
match(
    case_csv="input_covid_communitycases_stp35",
    match_csv="input_controls_contemporary_stp35",
    matches_per_case=5,
    match_variables={
        "age": 1,
        "sex": "category",
    },
    index_date_variable="case_index_date", 
    replace_match_index_date_with_case="no_offset", 
    date_exclusion_variables={
        "death_date": "before",
        "dereg_date": "before",
        "first_known_covid19_date": "before",
    },
    #  indicator_variable_name="indicatorVariableName", 
    output_suffix="_stp35",
    output_path="output",
)

