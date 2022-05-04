# in this file we can specify matching ratio
# and also check eligibility against index date
# notes under 'more examples' here: https://github.com/opensafely-core/matching#readme%5C
# matching on age (within one year), sex and stp

from osmatching import match

match(
    case_csv="input_covid_community.csv",
    match_csv="input_potential_controls_2018to2019",
    matches_per_case=5,
    match_variables={
        "sex": "category",
        "age": 1,
        "stp": "category",
    },
    closest_match_variables=["age"],
    replace_match_index_date_with_case="2_year_earlier",
    index_date_variable="indexdate",
    date_exclusion_variables={
        "died_date_ons": "before",
    },
    output_suffix="_control_2018to2019",
)

match(
    case_csv="input_covid_community.csv",
    match_csv="input_potential_controls_contemporary",
    matches_per_case=5,
    match_variables={
        "sex": "category",
        "age": 1,
        "stp": "category",
    },
    closest_match_variables=["age"],
    replace_match_index_date_with_case="no_offset",
    index_date_variable="indexdate",
    date_exclusion_variables={
        "died_date_ons": "before",
    },
    output_suffix="_control_contemporary",
)
