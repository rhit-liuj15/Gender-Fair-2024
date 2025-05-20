
# Gender Fair College Ratings

This website ranks over 2000 institutions using a wide variety of gender
equality-focused metrics using reputable data sources.

# Tech Stack

| Segment         | Technology    |
| --------------- | ------------- |
| Front End       | Flutter       |
| API             | JavaScript    |
| Data processing | Python & MySQL|
| Database        | MySQL         |

# Installation/Setup

This is a branch created specifically to allow for web builds to statically store all data. Please refer to other releases that include both code and setup instructions.

Our website is written in dart/flutter. To build into a HTML/CSS/JS release, navigate into the `/Flutter` directory (Note the capitalization), and run `flutter build web`. By default, the web build will be placed in `/Flutter/build/web`.

# Scoring

| Category       | Weight | Distribution                                                         |
| -------------- | ------ | -------------------------------------------------------------------- |
| Leadership     | 30%    | Academic Staff Gender Composition (30%)                              |
| Policies & Pay | 25%    | Average pay for gender (15%), campus daycare (10%, not shown)        |
| Safety         | 20%    | Violence Against Women Act (VAWA) incidents (10%), hate crimes (10%) |
| Diversity      | 25%    | Racial diversity of academic (20%) and non-academic staff (5%)       |

# Data Sources

IPEDS: <https://nces.ed.gov/ipeds/use-the-data/download-access-database>

IRS: <https://www.irs.gov/charities-non-profits/form-990-series-downloads>

Campus Safety and Security (CSS): <https://ope.ed.gov/campussafety/#/datafile/list>
