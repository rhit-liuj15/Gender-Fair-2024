USE ipeds_2024_db;

SELECT distinct Codevalue, varName, valueLabel FROM valuesets22
where varName = "STABBR"
order by Codevalue;