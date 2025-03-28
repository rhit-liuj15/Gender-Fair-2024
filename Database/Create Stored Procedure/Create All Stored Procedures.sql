USE PublicFacingData;

DROP PROCEDURE IF EXISTS GetAverages;
DROP PROCEDURE IF EXISTS GetMetadata;
DROP PROCEDURE IF EXISTS GetSchoolScores;
DROP PROCEDURE IF EXISTS GetSchoolData;

delimiter $$

CREATE PROCEDURE GetAverages ()
BEGIN
-- 	SELECT "AveragePayMen" as "Name", sum(SAOUTLM)/sum(SAINSTM) as "Value" FROM merged_ipeds_css_irs.ipeds_css_irs
--     UNION ALL
-- 	SELECT "AveragePayWomen" as "Name", sum(SAOUTLW)/sum(SAINSTW) as "Value" FROM merged_ipeds_css_irs.ipeds_css_irs
--     UNION ALL
-- 	SELECT "AverageHateCrime" as "Name", avg(3.141592653589793) as "Value" FROM merged_ipeds_css_irs.ipeds_css_irs
--     UNION ALL
-- 	SELECT "AverageVAWA" as "Name", avg(1.14514) as "Value" FROM merged_ipeds_css_irs.ipeds_css_irs;
END$$



CREATE PROCEDURE GetMetadata ()
BEGIN
	SELECT `GROUP`, `ABBR`, `DESC`
	FROM Metadata;
END$$



CREATE PROCEDURE GetSchoolScores ()
BEGIN
	SELECT UNITID, INSTNM, LEADERSHIP, POLICIES, SAFETY, DIVERSITY
	FROM PublicFacingData.SchoolScores;
END$$



-- The implementation of GetSchoolData uses a varchar for the string of school UNITIDs to allow querying a variable number of schools.
-- Note that in current implementation school data is only fetched one at a time.
CREATE PROCEDURE GetSchoolData (IN UnitIDs VARCHAR(10000))
BEGIN
    IF TRIM(UnitIDs) = '' THEN
        SELECT 'No UNITIDs provided. Returning no results.' AS Message;
	ELSE
		If UnitIDs REGEXP '^[0-9, ]*$' THEN
			SET @query = CONCAT('select UNITID, INSTNM, DEGREETOT, ENROLTOT, SALARYTOTM, SALARYTOTF, SALARYPPM, SALARYPPF, NASBLACKPCT, NASHISPANICPCT, NASASIAPCT,  PROFWOMENPCT, ASSOCPROFWOMEN, TENUREWOMENPCT, YEARLYHATECRIME, YEARLYHATECRIME1K, YEARLYVAWA, YEARLYVAWA1K
			from PublicFacingData.SchoolData WHERE UNITID IN (', UnitIDs, ');');
			PREPARE stmt FROM @query;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
		ELSE 
			SELECT 'String validation by \'^[0-9, ]*$\' failed. Returning no results.' AS Message;
		END IF;
	END IF;
END$$

delimiter ;

CALL GetAverages();
CALL GetMetadata();
CALL GetSchoolScores();
CALL GetSchoolData("");
CALL GetSchoolData("   1, 2,3   , -576   , 681,    66984133,-768913,-100706,3578");
CALL GetSchoolData("100654, 100706, 100751, 101301); Malicious query capable of injection");
CALL GetSchoolData("100654    ,     100706   ,   100751,     101301   ");
CALL GetSchoolData("100654, 100706, 100751, 101301");