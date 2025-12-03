USE PublicFacingData;

DROP TABLE IF EXISTS `Averages`;

CREATE TABLE `Averages` (
	`Name` VARCHAR(100) NOT NULL,
	`Value` DOUBLE NOT NULL,
	PRIMARY KEY (`Name`)
);


INSERT INTO Averages
	SELECT "AveragePayMen" as "Name", sum(SALARYTOTACDM)/sum(ACDPOPM) as "Value" FROM SchoolData
	UNION ALL
	SELECT "AveragePayWomen" as "Name", sum(SALARYTOTACDF)/sum(ACDPOPF) as "Value" FROM SchoolData
	UNION ALL
	SELECT "AverageHateCrime" as "Name", 1000*sum(YEARLYHATECRIME)/sum(CSSPOPULATION) FROM SchoolData
	UNION ALL
	SELECT "AverageVAWA" as "Name", 1000*sum(YEARLYVAWA)/sum(CSSPOPULATION) FROM SchoolData;

select Name, Value from Averages;