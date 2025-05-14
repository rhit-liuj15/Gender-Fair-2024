USE PublicFacingData;

DROP PROCEDURE IF EXISTS GetOfferings;

delimiter $$
CREATE PROCEDURE GetOfferings ()
BEGIN
	SELECT `UNITID`, `CIPCODE`, `AWLEVEL`
	FROM Offerings;
END$$

delimiter ;

CALL GetOfferings();