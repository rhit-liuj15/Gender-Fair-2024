
# Gender Fair College Ratings

This website ranks over 2000 institutions using a wide variety of gender
equality-focused metrics using reputable data sources.

# Tech Stack

| Segment         | Technology    |
| --------------- | ------------- |
| Data processing | Python & MySQL|
| Database        | MySQL         |
| Front End       | Flutter       |
| API             | JavaScript    |

# Installation/Setup

## Database

## Website

Our website is written in dart/flutter

## API

The API can be found at `/API/express_query_database_https.js`

At the time of deciding tech stack, dart did not have a good way of connecting with a MySQL server, and the purpose of the API is to take a request for data, run a stored procedure in the database, and return the data in JSON format.

The API expects:
1. credentials to the account which can be used to run stored procedures.
2. The key, certificate (cert) and certificate authority (ca, optional if the certificate is issued by a publicly trusted certificate authority) which the API server will use

TODO: Write about using credentials and hosting

Once the API is hosted, remember update the `hostname` found in `/Flutter/lib/models/data_loader.dart`.

# Scoring


# Data Sources

IPEDS: <https://nces.ed.gov/ipeds/use-the-data/download-access-database>

IRS: <https://www.irs.gov/charities-non-profits/form-990-series-downloads>

Campus Safety and Security (CSS): <https://ope.ed.gov/campussafety/#/datafile/list>
