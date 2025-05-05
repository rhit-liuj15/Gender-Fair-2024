USE PublicFacingData;

DROP PROCEDURE IF EXISTS GetAverages;

delimiter $$

-- The implementation uses a varchar for the string of school UNITIDs, since the number of schools queried is variable.
-- 
CREATE PROCEDURE GetAverages ()
BEGIN
    SELECT Name, Value FROM Averages;
END$$

delimiter ;

CALL GetAverages();