-- Joining IPEDS filter tables --
CREATE TABLE `ipeds_tables`.`ipeds_filter` AS
SELECT 
    a.UNITID,
    a.CSTOTLT,
    b.EFLEVEL,
    b.EFTOTAL,
    c.CNTLAFFI,
    c.STUSRV8
FROM `ipeds_2024_db`.`C2022_B` a
INNER JOIN `ipeds_tables`.`EF2022_sorted` b ON a.UNITID = b.UNITID
INNER JOIN `ipeds_tables`.`IC2022_sorted` c ON a.UNITID = c.UNITID
WHERE a.CSTOTLT >= 50 AND b.EFTOTAL >= 200;

ALTER TABLE `ipeds_tables`.`ipeds_filter`
ADD PRIMARY KEY (`UNITID`);

-- Joining IPEDS tables --
CREATE TABLE `ipeds_tables`.`ipeds_final` AS
SELECT
	a.UNITID,
    b.INSTNM,
    b.STABBR,
    b.EIN,
    b.OPEID,
    a.CSTOTLT,
    a.EFTOTAL,
    a.CNTLAFFI,
    a.STUSRV8,
    c.SAINSTM,
    c.SAINSTW,
    c.SAOUTLM,
    c.SAOUTLW,
    c.AVGSALM,
    c.AVGSALW,
    d.HRBKAAT,
    d.HRHISPT,
    d.HRASIAT,
    e.HRTOTLW_101,
    e.HRTOTLW_102,
    e.HRTOTLW_200,
    e.HRBKAAW_101,
    e.HRBKAAW_102,
    e.HRBKAAW_200,
    e.HRHISPW_101,
    e.HRHISPW_102,
    e.HRHISPW_200,
    e.HRASIAW_101,
    e.HRASIAW_102,
    e.HRASIAW_200
FROM `ipeds_tables`.`ipeds_filter` a
INNER JOIN `ipeds_2024_db`.`HD2022` b ON a.UNITID = b.UNITID
INNER JOIN `ipeds_tables`.`SAL2022_IS_sorted` c ON a.UNITID = c.UNITID
INNER JOIN `ipeds_tables`.`S2022_OC_sorted` d ON a.UNITID = d.UNITID
INNER JOIN `ipeds_tables`.`S2022_IS_sorted` e ON a.UNITID = e.UNITID
ORDER BY a.`UNITID` ASC;

ALTER TABLE `ipeds_tables`.`ipeds_final`
ADD PRIMARY KEY (`UNITID`);

