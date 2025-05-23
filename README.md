
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

The installation/setup instructions can be found in each componnet's respective section.

Setting up the website and API on the same host sharing port 443 for HTTPS is not tested.

## Database

The installation and hosting manual of the MySQL server can be found on MySQL's official wesite:
https://dev.mysql.com/doc/refman/9.3/en/installing.html

### Importing Data

IPEDS: <https://github.com/rhit-shirakrk/ipeds-data-import>
CSS: Refer to `/Database/CSS/readme.txt`
IRS: <https://github.com/rhit-shirakrk/irs-990-parser>

### Processing Data
Before running the import scripts, make sure the db is up and running and has the following schemas:
- css
- irs990
- ipeds_2024_db
- PublicFacingData

If not, run the `/Database/create_all_schemas.sql` to create them.

First, run `/Database/CreateTable/SchoolDataTable.sql` to create the table for general school data.

Then, run `/Database/merge_script.sql` to merge the data from IPEDS, CSS and IRS and insert to school data table.

Only then, run the other scripts found in `/Database/CreateTable`.

Next, run `/Database/Scoring/Scoring_v2.sql`.

Finally, run the scripts found in `/Database/CreateStoredProcedure`.

By now every table and stored procedure needed for the project should be created and ready to go.

## Website

Our website is written in dart/flutter. To build into a HTML/CSS/JS release, cd into the `/Flutter` directory (Note the capitalization), and run `flutter build web`. By default, the web build will be placed in `/Flutter/build/web`. It has been tested and runs properly on a Windows 11 environment.

## API

The API can be found at `/API/express_query_database_https.js`

Make sure you have Node.js installed on your device: https://nodejs.org/en/download

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

To host the API, simply run command `node express_query_database_https.js`

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
