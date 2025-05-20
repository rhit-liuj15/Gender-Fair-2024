DROP TABLE IF EXISTS `PublicFacingData`.`Offerings`;

CREATE TABLE `PublicFacingData`.`Offerings` (
	`UNITID` INT NOT NULL,
	`CIPCODE` VARCHAR(5) NOT NULL,
	`AWLEVEL` INT NOT NULL,
	PRIMARY KEY (`UNITID`, `CIPCODE`, `AWLEVEL`)
);

-- Only record offerings where at least 1 student is enrolled
INSERT INTO `PublicFacingData`.`Offerings` (`UNITID`, `CIPCODE`, `AWLEVEL`)
select UNITID, CIPCODE, AWLEVEL from `ipeds_2024_db`.`C2022_A`
where AWLEVEL in (3, 5, 7, 8, 17, 18, 19) and LENGTH(CIPCODE) = 5 and UNITID in (select UNITID from `PublicFacingData`.`SchoolData`)
group by UNITID, CIPCODE, AWLEVEL having sum(CTOTALT) >= 1;

SELECT * FROM `PublicFacingData`.`Offerings`;