USE PublicFacingData;

DROP PROCEDURE IF EXISTS GetSchoolData;

delimiter $$

-- The implementation uses a varchar for the string of school UNITIDs, since the number of schools queried is variable.

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
		END IF;
	END IF;
END$$

delimiter ;

CALL GetSchoolData("");
CALL GetSchoolData("   1, 2,3   , -576   , 681,    66984133,-768913,-100706,3578");
CALL GetSchoolData("100654, 100706, 100751, 101301); Malicious query capable of injection");
CALL GetSchoolData("100654, 100706, 100751, 101301");

