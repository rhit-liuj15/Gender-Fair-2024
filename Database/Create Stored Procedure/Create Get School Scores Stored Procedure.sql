USE PublicFacingData;

DROP PROCEDURE IF EXISTS GetSchoolScoreTest;
DROP PROCEDURE IF EXISTS GetSchoolScore;

delimiter $$

CREATE PROCEDURE GetSchoolScoreTest ()
BEGIN
	SELECT UNITID, INSTNM, LEADERSHIP, POLICIES, SAFETY, DIVERSITY
	FROM PublicFacingData.SchoolCategoryScoreTest;
END$$

CREATE PROCEDURE GetSchoolScore ()
BEGIN
	SELECT UNITID, INSTNM, LEADERSHIP, POLICIES, SAFETY, DIVERSITY
	FROM PublicFacingData.SchoolCategoryScore;
END$$

delimiter ;

CALL GetSchoolScoreTest();

CALL GetSchoolScore();