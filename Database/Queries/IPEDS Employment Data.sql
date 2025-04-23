USE ipeds_2024_db;

/*

EAP2022		90	Number of staff by occupational category, faculty and tenure status:  Fall 2022
SAL2022_IS	91	Number and salary outlays for full-time nonmedical instructional staff, by gender, and academic rank: Academic year 2022-23
SAL2022_NIS	92	Number and salary outlays for full-time nonmedical noninstructional staff by occupation: Academic year 2022-23
S2022_OC	93	Full- and part-time staff by occupational category, race/ethnicity, and gender:  Fall 2022
S2022_SIS	94	Full-time instructional staff, by academic rank, faculty and tenure status (Degree-granting institutions): Fall 2022
S2022_IS	95	Full-time instructional staff, by faculty and tenure status, academic rank, race/ethnicity, and gender (Degree-granting institutions): Fall 2022
S2022_NH	96	New hires by occupational category, race/ethnicity, and gender (Degree-granting institutions):  Fall 2022
DRVHR2022	97	Frequently used/derived variables Human resources (HR): Fall 2022

*/

select TableNumber, TableTitle, varName, varNumber, varTitle, longDescription from vartable22 where TableNumber = 91;
-- ARANK (40106): Academic rank
-- The primary key is composed of the school UID plus ARANK
-- Lots of variables covering different contact lengths

select TableNumber, TableTitle, varName, varNumber, varTitle, longDescription from vartable22 where TableNumber = 92;
-- The primary key is the school UID
-- The table contains variables separated by category, with two entries per category for 1) number of workers in that category and 2) total outlay

select TableNumber, TableTitle, varName, varNumber, varTitle, longDescription from vartable22 where TableNumber = 93;
-- STAFFCAT (53016): Occupation and full- and part-time status
-- FTPT (53021): Full-time or part-time status
-- OCCUPCAT (53026): Occupation category
-- The primary key is composed of the school UID plus STAFFCAT
-- The table contains variables separated by race and gender
-- Note that STAFFCAT is a "concatenation" of FTPT and OCCUPCAT
-- SABDTYPE (50131) is a legacy variable indicating whether this category was consistent with pre-2012 reports

select TableNumber, TableTitle, varName, varNumber, varTitle, longDescription from vartable22 where TableNumber = 94;
-- Information in table 94 is a subset of 95.

select TableNumber, TableTitle, varName, varNumber, varTitle, longDescription from vartable22 where TableNumber = 95;
-- SISCAT (53001): Instructional staff category
-- FACSTAT (53006): Faculty and tenure status
-- ARANK (53011): Academic rank
-- The primary key is composed of the school UID plus SISCAT
-- The table contains variables separated by race and gender
-- Note that SISCAT is a "concatenation" of FACSTAT and ARANK