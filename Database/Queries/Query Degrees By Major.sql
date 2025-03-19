use ipeds_2024_db;

select CodeValue, valueLabel from valuesets22 where varNumber = 35000 and CHAR_LENGTH(CodeValue) = 2 order by CodeValue;

select CodeValue, valueLabel from valuesets22 where varNumber = 35000;

select CodeValue, valueLabel from valuesets22 where varNumber = 35005;

/*
1	Certificates of less than 1 year
2	Certificates of at least 1 but less than 2 years
3	Associate's degree
4	Certificates of at least 2 but less than 4 years
5	Bachelor's degree
6	Postbaccalaureate certificate
7	Master's degree
8	Post-master's certificate
12	Degrees total
13	Certificates below the baccalaureate total
14	Certificates above the baccalaureate total
15	Degrees/certificates total
17	Doctor's degree - research/scholarship 
18	Doctor's degree - professional practice 
19	Doctor's degree - other 
20	Certificates of less than 12 weeks
21	Certificates of at least 12 weeks but less than 1 year
*/

select * from HD2022 where UNITID = 135717;

SELECT DRVEF2022.UNITID AS "School ID", 
       INSTNM AS "School Name", 
       STABBR AS "State Abbreviation", 
       -- valueLabel AS "State Name", 
       ENRTOT AS "Total Students" 
FROM ipeds_2024_db.DRVEF2022 
JOIN ipeds_2024_db.HD2022 USING (UNITID)
where INSTNM = "Rose-Hulman Institute of Technology"
ORDER BY ENRTOT desc;

select * from C2022_A join (select CodeValue, valueLabel from valuesets22 where varNumber = 35000) as subquery on (C2022_A.CIPCODE = subquery.CodeValue) where UNITID = 152318;

select CIPCODE, valueLabel as "Major Category", CTOTALM as "Total Men", CTOTALW as "Total Women" from C2022_A join (select CodeValue, valueLabel from valuesets22 where varNumber = 35000) as subquery on (C2022_A.CIPCODE = subquery.CodeValue) where UNITID = 152318 AND MAJORNUM = 1 and CTOTALT > 0;

select CIPCODE, valueLabel as "Major Category", CTOTALM as "Total Men", CTOTALW as "Total Women" from C2022_A join (select CodeValue, valueLabel from valuesets22 where varNumber = 35000) as subquery on (C2022_A.CIPCODE = subquery.CodeValue) where UNITID = 152318 AND MAJORNUM = 1 and CTOTALT > 0 and LENGTH(CodeValue) = 5;

select * from C2022_A join (select CodeValue, valueLabel from valuesets22 where varNumber = 35000) as subquery on (C2022_A.CIPCODE = subquery.CodeValue) where UNITID = 152318 AND MAJORNUM = 1 and CTOTALT > 0 and LENGTH(CodeValue) = 5;

select CIPCODE, subquery1.valueLabel as "Major Category", subquery2.valueLabel as "Major Level", CTOTALM as "Total Men", CTOTALW as "Total Women", 100*CTOTALW/(CTOTALM+CTOTALW) as "Female Ratio In Percentage"
from C2022_A
join (select CodeValue, valueLabel from valuesets22 where varNumber = 35000) as subquery1
on (C2022_A.CIPCODE = subquery1.CodeValue)
join (select CodeValue, valueLabel from valuesets22 where varNumber = 35005) as subquery2
on (C2022_A.AWLEVEL = subquery2.CodeValue)
where UNITID = 152318 and MAJORNUM = 1 and CTOTALT > 0 and LENGTH(subquery1.CodeValue) = 5 and AWLEVEL = 5
order by subquery2.valueLabel, 100*CTOTALW/(CTOTALM+CTOTALW) desc, CIPCODE, AWLEVEL;

select CIPCODE, subquery1.valueLabel as "Major Category", count(UNITID) as "Number of Institutions Offering Bachelors Degrees", sum(CTOTALM+CTOTALW) as "Number of Students Receiving Bachelors Degrees In 2022",
	CONCAT(LPAD(FLOOR(((100*sum(CTOTALW)/sum(CTOTALM+CTOTALW)))),3,'0'),REPEAT('=', FLOOR((100*sum(CTOTALW)/sum(CTOTALM+CTOTALW)) / 5))) AS "Percentage of Female Students"
from C2022_A
join (select CodeValue, valueLabel from valuesets22 where varNumber = 35000) as subquery1
on (C2022_A.CIPCODE = subquery1.CodeValue)
where MAJORNUM = 1 and CTOTALT > 0 and LENGTH(subquery1.CodeValue) = 7 and AWLEVEL = 5
group by CIPCODE, subquery1.valueLabel
having sum(CTOTALM+CTOTALW) > 1000
order by CIPCODE;

select CIPCODE, subquery1.valueLabel as "Major Category", sum(CTOTALM) as "Total Men", sum(CTOTALW) as "Total Women"
from C2022_A
join (select CodeValue, valueLabel from valuesets22 where varNumber = 35000) as subquery1
on (C2022_A.CIPCODE = subquery1.CodeValue)
where MAJORNUM = 1 and CTOTALT > 0 and LENGTH(subquery1.CodeValue) = 5 and AWLEVEL = 5
group by CIPCODE, subquery1.valueLabel
order by sum(CTOTALM+CTOTALW) desc;

select UNITID, INSTNM as "School Name", sum(CTOTALM+CTOTALW) as "Total Degrees Issued", ENRTOT AS "Total Students", ENRTOT/sum(CTOTALM+CTOTALW)
from C2022_A
join HD2022 using (UNITID)
JOIN DRVEF2022 USING (UNITID)
where AWLEVEL in (12) and CIPCODE = 99
group by UNITID
having sum(CTOTALM+CTOTALW) >= 50
order by sum(CTOTALM+CTOTALW);


