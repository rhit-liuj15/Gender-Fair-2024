USE PublicFacingData;

DROP PROCEDURE IF EXISTS GetAverages;

delimiter $$

CREATE PROCEDURE GetAverages ()
BEGIN
    SELECT Name, Value FROM Averages;
END$$

delimiter ;

CALL GetAverages();