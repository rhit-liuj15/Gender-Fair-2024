/*
This creates the metadata table. We specify that in group 0, each entry's "ABBR" should be a string that represents a 1- or 2-digit number with no signs, no spaces and no leading zeroes. The corresponding "DESC" is the description for the group with that number.

Other positive group numbers can be used for any purpose.

The following is an example usage:

INSERT INTO `PublicFacingData`.`Metadata` (`GROUP`, `ABBR`, `DESC`) VALUES
	(0, '1', 'State names & abbreviations'),
	(0, '67', 'Companies with 2-letter abbreviations'),
	(1, 'CA', 'California'),
	(1, 'NY', 'New York'),
	(1, 'IN', 'Indiana'),
	(67, 'GE', 'General Electric'),
	(67, 'GM', 'General Motors'),
	(67, '3M', 'Minnesota Mining and Manufacturing Company'),
	(67, 'HP', 'Hewlett-Packard');
  
*/

DROP TABLE IF EXISTS `PublicFacingData`.`Metadata`;

CREATE TABLE `PublicFacingData`.`Metadata` (
	`GROUP` INT NOT NULL,
	`ABBR` VARCHAR(7) NOT NULL,
	`DESC` VARCHAR(200) NOT NULL,
	PRIMARY KEY (`GROUP`, `ABBR`)
);

INSERT INTO `PublicFacingData`.`Metadata` (`GROUP`, `ABBR`, `DESC`) VALUES
	(0, '1', 'State names & abbreviations'),
	(0, '2', 'Institution ownership and financial structure'),
	(0, '3', 'CIPCODE to major name'),
	(0, '4', 'Education level number mapping');

INSERT INTO `PublicFacingData`.`Metadata` (`GROUP`, `ABBR`, `DESC`)
SELECT 1, Codevalue, LEFT(valueLabel, 100) FROM ipeds_2024_db.valuesets22
	where varName = "STABBR";
    
INSERT INTO `PublicFacingData`.`Metadata` (`GROUP`, `ABBR`, `DESC`) 
SELECT 2, Codevalue, LEFT(valueLabel, 100) FROM ipeds_2024_db.valuesets22
	where varName = "CNTLAFFI" and CodeValue in ("1","3","4");

-- INSERT INTO `PublicFacingData`.`Metadata` (`GROUP`, `ABBR`, `DESC`) 
-- select 3, Codevalue, valueLabel from ipeds_2024_db.valuesets22 where varNumber in (35000) and Codevalue in (
-- 	select CIPCODE from C2022_A where AWLEVEL in (3, 5, 7, 8, 17, 18, 19) and LENGTH(CIPCODE) = 5 group by CIPCODE, AWLEVEL having sum(CTOTALT) >= 1
-- ) order by varNumber, Codevalue;


-- INSERT INTO `PublicFacingData`.`Metadata` (`GROUP`, `ABBR`, `DESC`) 
-- select 4, Codevalue, valueLabel from ipeds_2024_db.valuesets22 where varNumber in (35005) and Codevalue in (3, 5, 7, 8, 17, 18, 19);

SELECT * FROM `PublicFacingData`.`Metadata`;