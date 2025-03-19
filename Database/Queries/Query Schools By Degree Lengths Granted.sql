select distinct UNITID
from C2022_A
join (select CodeValue, valueLabel from valuesets22 where varNumber = 35005) as subquery
on (C2022_A.AWLEVEL = subquery.CodeValue)
WHERE subquery.CodeValue IN ('3', '5', '7', '8', '12', '17', '18', '19')
order by UNITID;


select DRVEF2022.UNITID as "School ID", INSTNM as "School Name", DEGGRANT, STABBR as "State", ENRTOT as "Total Students"
from DRVEF2022
join (
	select distinct UNITID
	from C2022_A
	join (select CodeValue, valueLabel from valuesets22 where varNumber = 35005) as subquery
	on (C2022_A.AWLEVEL = subquery.CodeValue)
	WHERE subquery.CodeValue IN ('3', '5', '7', '8', '12', '17', '18', '19')
) as subquery using (UNITID)
join HD2022 using (UNITID)
order by ENRTOT asc;