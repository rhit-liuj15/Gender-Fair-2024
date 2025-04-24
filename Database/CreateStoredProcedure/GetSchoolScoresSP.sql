USE PublicFacingData;

DROP PROCEDURE IF EXISTS GetSchoolScore;

delimiter $$

CREATE PROCEDURE GetSchoolScore ()
BEGIN
	SELECT UNITID, INSTNM, LEADERSHIP, POLICIES, SAFETY, DIVERSITY
	FROM PublicFacingData.SchoolCategoryScore;
END$$

delimiter ;

CALL GetSchoolScore();