import pandas as pd
from osmatching import match

## MATCH SEPARATE STPS OF CASES AND CONTROLS
#stp5
match(
    case_csv="input_covid_communitycases_stp5",
    match_csv="input_controls_contemporary_stp5",
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
    output_suffix="_stp5",
    output_path="output",
)

#stp6
match(
    case_csv="input_covid_communitycases_stp6",
    match_csv="input_controls_contemporary_stp6",
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
    output_suffix="_stp6",
    output_path="output",
)

#stp7
match(
    case_csv="input_covid_communitycases_stp7",
    match_csv="input_controls_contemporary_stp7",
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
    output_suffix="_stp7",
    output_path="output",
)

#stp8
match(
    case_csv="input_covid_communitycases_stp8",
    match_csv="input_controls_contemporary_stp8",
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
    output_suffix="_stp8",
    output_path="output",
)

#stp9
match(
    case_csv="input_covid_communitycases_stp9",
    match_csv="input_controls_contemporary_stp9",
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
    output_suffix="_stp9",
    output_path="output",
)

#stp10
match(
    case_csv="input_covid_communitycases_stp10",
    match_csv="input_controls_contemporary_stp10",
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
    output_suffix="_stp10",
    output_path="output",
)

#stp12
match(
    case_csv="input_covid_communitycases_stp12",
    match_csv="input_controls_contemporary_stp12",
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
    output_suffix="_stp12",
    output_path="output",
)

#stp13
match(
    case_csv="input_covid_communitycases_stp13",
    match_csv="input_controls_contemporary_stp13",
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
    output_suffix="_stp13",
    output_path="output",
)

#stp14
match(
    case_csv="input_covid_communitycases_stp14",
    match_csv="input_controls_contemporary_stp14",
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
    output_suffix="_stp14",
    output_path="output",
)

#stp15
match(
    case_csv="input_covid_communitycases_stp15",
    match_csv="input_controls_contemporary_stp15",
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
    output_suffix="_stp15",
    output_path="output",
)

#stp16
match(
    case_csv="input_covid_communitycases_stp16",
    match_csv="input_controls_contemporary_stp16",
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
    output_suffix="_stp16",
    output_path="output",
)

#stp17
match(
    case_csv="input_covid_communitycases_stp17",
    match_csv="input_controls_contemporary_stp17",
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
    output_suffix="_stp17",
    output_path="output",
)

#stp20
match(
    case_csv="input_covid_communitycases_stp20",
    match_csv="input_controls_contemporary_stp20",
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
    output_suffix="_stp20",
    output_path="output",
)

#stp21
match(
    case_csv="input_covid_communitycases_stp21",
    match_csv="input_controls_contemporary_stp21",
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
    output_suffix="_stp21",
    output_path="output",
)

#stp22
match(
    case_csv="input_covid_communitycases_stp22",
    match_csv="input_controls_contemporary_stp22",
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
    output_suffix="_stp22",
    output_path="output",
)

#stp23
match(
    case_csv="input_covid_communitycases_stp23",
    match_csv="input_controls_contemporary_stp23",
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
    output_suffix="_stp23",
    output_path="output",
)

#stp24
match(
    case_csv="input_covid_communitycases_stp24",
    match_csv="input_controls_contemporary_stp24",
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
    output_suffix="_stp24",
    output_path="output",
)

#stp25
match(
    case_csv="input_covid_communitycases_stp25",
    match_csv="input_controls_contemporary_stp25",
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
    output_suffix="_stp25",
    output_path="output",
)

#stp26
match(
    case_csv="input_covid_communitycases_stp26",
    match_csv="input_controls_contemporary_stp26",
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
    output_suffix="_stp26",
    output_path="output",
)

#stp27
match(
    case_csv="input_covid_communitycases_stp27",
    match_csv="input_controls_contemporary_stp27",
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
    output_suffix="_stp27",
    output_path="output",
)

#stp29
match(
    case_csv="input_covid_communitycases_stp29",
    match_csv="input_controls_contemporary_stp29",
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
    output_suffix="_stp29",
    output_path="output",
)

#stp33
match(
    case_csv="input_covid_communitycases_stp33",
    match_csv="input_controls_contemporary_stp33",
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
    output_suffix="_stp33",
    output_path="output",
)

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

#stp36
match(
    case_csv="input_covid_communitycases_stp36",
    match_csv="input_controls_contemporary_stp36",
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
    output_suffix="_stp36",
    output_path="output",
)

#stp37
match(
    case_csv="input_covid_communitycases_stp37",
    match_csv="input_controls_contemporary_stp37",
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
    output_suffix="_stp37",
    output_path="output",
)

#stp40
match(
    case_csv="input_covid_communitycases_stp40",
    match_csv="input_controls_contemporary_stp40",
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
    output_suffix="_stp40",
    output_path="output",
)

#stp41
match(
    case_csv="input_covid_communitycases_stp41",
    match_csv="input_controls_contemporary_stp41",
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
    output_suffix="_stp41",
    output_path="output",
)

#stp42
match(
    case_csv="input_covid_communitycases_stp42",
    match_csv="input_controls_contemporary_stp42",
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
    output_suffix="_stp42",
    output_path="output",
)

#stp43
match(
    case_csv="input_covid_communitycases_stp43",
    match_csv="input_controls_contemporary_stp43",
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
    output_suffix="_stp43",
    output_path="output",
)

#stp44
match(
    case_csv="input_covid_communitycases_stp44",
    match_csv="input_controls_contemporary_stp44",
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
    output_suffix="_stp44",
    output_path="output",
)

#stp49
match(
    case_csv="input_covid_communitycases_stp49",
    match_csv="input_controls_contemporary_stp49",
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
    output_suffix="_stp49",
    output_path="output",
)
