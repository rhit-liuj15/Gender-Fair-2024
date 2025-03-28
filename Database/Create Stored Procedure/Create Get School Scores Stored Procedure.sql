USE PublicFacingData;

DROP PROCEDURE IF EXISTS GetSchoolScores;

delimiter $$


CREATE PROCEDURE GetSchoolScores ()
BEGIN
	SELECT UNITID, INSTNM, LEADERSHIP, POLICIES, SAFETY, DIVERSITY
	FROM PublicFacingData.SchoolScores;
END$$

delimiter ;

CALL GetSchoolScores();