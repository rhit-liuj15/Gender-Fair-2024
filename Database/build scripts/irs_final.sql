-- Deduplicating IRS table --

CREATE TABLE `irs990`.`irs_final` AS
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY `EIN` 
               ORDER BY `YEAR` DESC, `IRS_MONTH` DESC
           ) AS rn
    FROM `irs990`.`Organizations`
) AS ranked
WHERE rn = 1;

ALTER TABLE `irs990`.`irs_final`
ADD PRIMARY KEY (`EIN`);
