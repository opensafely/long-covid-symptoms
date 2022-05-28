import pandas as pd
from osmatching import match

# CONCURRENT CONTROLS - took out stp here while just trying one region at a time
match(
    case_csv="input_covid_community",
    match_csv="input_potential_controls_contemporary",
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
    output_suffix="_contemporary",
    output_path="output",
)
