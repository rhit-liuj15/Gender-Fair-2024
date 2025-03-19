SELECT HD2022.UNITID AS "School ID", 
       INSTNM AS "School Name", 
       STABBR AS "State",
       SUBQUERY.valueLabel as "Major",
       EF2022CP.*
FROM ipeds_2024_db.HD2022 
JOIN ipeds_2024_db.EF2022CP USING (UNITID)
JOIN
(
	SELECT * FROM valuesets22
    where varName = "EFCIPLEV"
) as SUBQUERY
on SUBQUERY.Codevalue = EF2022CP.EFCIPLEV
where UNITID = 183026