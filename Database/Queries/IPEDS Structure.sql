-- ============================================================ Overview ============================================================ --
/*
NOTE: These instructions are specific to the IPEDS 2024 PROVISIONAL RELEASE. Many table names contains the year number in them, therefore checking the specific database (as well as the changes file) is advised.

The 2024 provisional release of IPEDS contains three tables useful for navigation: Tables22, vartable22, valuesets22.

Tables22: Each row contains information about one table. Of particular interest are these variables:
	TableName: the name of the table which you enter for queries.
	Tablenumber: a number that is unique to the table. This number is used for filtering metadata from table vartable22.
	TableTitle: a long title for the table.
	Description: an extended description of the table and what datapoints it offers.

vartable22: Each row contains information about one variable in one table. Of particular interest are these variables:
	TableNumber: same as in Tables22.
	varNumber: a number unique to the variable. This number is used for filtering metadata from table valuesets22.
	varName: the variable's name. These are the variable names used to specify what to select from a table. Note that these are not necessarily unique across all tables.
		See this query for more details on name duplicates:
		select varName as `Name`, count(*) as `Occurrences` from vartable22 group by varName having `Occurrences` > 1 order by Occurrences desc;
	varTitle: long name for the variable.
	longDescription: self explanatory, it's a longer description about the variable.

valuesets22: Each row contains information about one value's occurrence statics for one variable in one table. Of particular interest are these variables:
	varNumber: same as in vartable22.
	Codevalue: A possible value for a variable.
		Note that for generality purposes, the valueLabel is encoded as a varchar(20). Conversions may be needed when making comparisons.
	valueLabel: A longer description for that variable.

Recommendations:
	The variable names of IPEDS are relatively hard to understand. It's recommended to convert them to something more readable.

Please note that the case sensitivity of names may matter depending on the system.
*/
-- ============================================================ Example Usage ============================================================ --

use ipeds_2024_db;

/*
Sets the database to assume IPEDS database as the default database.

In this demo, we will investigate the contents of S2022_IS (table 95)

If you instead want to find a specific table, you will instead browse examine the Tables22 table.
*/

select TableName, Tablenumber, TableTitle, `Description` from Tables22 where Tablenumber=95;

/*
Observe the title for the table:

Full-time instructional staff, by faculty and tenure status, academic rank, race/ethnicity, and gender (Degree-granting institutions): Fall 2022
*/

select varNumber, varName, varTitle, longDescription from vartable22 where Tablenumber = 95;

/*
This query shows all the columns/fields (other than UNITID which is included by default) that are in the table S2022_IS (table 95).

Note that the vartable22 does NOT contain specification for which variables constitute the primary key (if not the UNITID alone). However, the data is properly structured, therefore tools such as MySQL workbench will show the columns which constitute the UNITID.

The specification is instead found in the Tables22.Description field. In this case, for S2022_IS, the description says:
	"... Each record is uniquely defined by the variables IPEDS ID (UNITID), and the variable SISCAT which is the combination of faculty and tenure status FACSTAT (tenured, on tenure track, and not on-tenure track/no tenure system) and academic rank ARANK (professors, associate professors, etc.)."

This specification indicates that we should study the possible values for the fields FACSTAT and ARANK to better separate the categories. Note down their respective varNumber:
	FACSTAT: 53006
	ARANK: 53011
*/

select varNumber, Codevalue, valueLabel from valuesets22 where varNumber in (53006, 53011) order by varNumber, Codevalue;

/*
Observe that:

For FACSTAT, Codevalue 0 is the aggregate, with Codevalue 10 and 50 being subtotals for groups with or without faculty status. Codevalues 20,30,40,41,42,43,44,45 being specific tenure/contract statuses

For ARANK, Codevalue 0 is the aggregate, with Codevalue 1,2,3,4,5,6 being specific categories of professors
*/