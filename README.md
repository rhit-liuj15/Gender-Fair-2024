
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

Three separate components need to be set up for the project: database, website, and API.

This project is a standard Flutter web application and can be run using flutter run -d chrome or deployed to any web server. It has been tested and runs properly on a Windows 11 environmen

Setting up the website and API on the same host sharing port 443 for HTTPS is not tested.

## Database

### Importing Data

IPEDS: <https://github.com/rhit-shirakrk/ipeds-data-import>
CSS: Refer to `/Database/CSS/readme.txt`
IRS: <https://github.com/rhit-shirakrk/irs-990-parser>

### Processing Data

First, run `/Database/merge_script.sql` to merge the data from IPEDS, CSS and IRS.

Then, run the scripts found in `/Database/CreateTable`.

Then, run `/Database/Scoring/Scoring_v2.sql`.

Then, run the scripts found in `/Database/CreateStoredProcedure`.

## Website

Our website is written in dart/flutter. To build into a HTML/CSS/JS release, cd into the `/Flutter` directory (Note the capitalization), and run `flutter build web`. By default, the web build will be placed in `/Flutter/build/web`.

## API

The API can be found at `/API/express_query_database_https.js`

At the time of deciding tech stack, dart did not have a good way of connecting with a MySQL server, and the purpose of the API is to take a request for data, run a stored procedure in the database, and return the data in JSON format.

The API expects:

1. credentials to the account which can be used to run stored procedures.
2. The key and certificate (cert) which the API server will use

The expected format for the config file is:

```
{
 "host": "",
 "user": "",
 "password": "",
 "database": "",
 "key": "",
 "cert": ""
}
```

Once the API is hosted, remember update the `hostname` found in `/Flutter/lib/models/data_loader.dart`.

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
