from cohortextractor import (
    StudyDefinition, 
    patients, 
    codelist, 
    codelist_from_csv,
    filter_codes_by_category
    combine_codelists,
)
from common_variables_short import generate_common_variables_short
from codelists import *

# need shortened version of common vars with just matching vars
# i.e., age +/- whatever I use for matching
common_variables_short = generate_common_variables_short(index_date_variable="index_date")

study = StudyDefinition(
    default_expectations={
        "date": {"earliest": "1980-01-01", "latest": "today"},
        "rate": "uniform",
        "incidence": 0.2,
    },
    population=patients.satisfying(
        """
            has_follow_up
        AND (age <= 110)
        AND (sex = "M" OR sex = "F")
        AND imd > 0
        AND NOT stp = ""
        """,
        # registered between march 2018 and march 2020
        # and in a later step confirm that comparators have 3 months of registration
        # before their index date (can't do this now, as we don't know index)
        # so will need to up matching ratio to account for people who stop being eligible
        # because they don't have continuous registration

        # drop the above suggestions instead edit in match.py use case index to set control eligibility
        # see under 'more examples' here: https://github.com/opensafely-core/matching#readme%5C


        has_follow_up=patients.registered_with_one_practice_between(
            "index_date - 3 months", "index_date"
        ),
    ),

    # I guess we do something different here due to the matching program
    # do I explictly need to exclude people with previous COVID here?
    # I guess not necessary as gen pop 2018-2019 by definition can't have covid
    # also as I want to match 2020 covid people to 2018 gen pop
    # and 2021 covid people to 2019 gen pop, do I need a separate study def file for 2018
    # and 2019?
    index_date="2019-02-01",
    **common_variables_short
)





