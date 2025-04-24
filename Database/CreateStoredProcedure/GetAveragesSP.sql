USE PublicFacingData;

DROP PROCEDURE IF EXISTS GetAverages;

delimiter $$

-- The implementation uses a varchar for the string of school UNITIDs, since the number of schools queried is variable.
-- 
CREATE PROCEDURE GetAverages ()
BEGIN
	SELECT "AveragePayMen" as "Name", sum(SALARYTOTACDM)/sum(ACDPOPM) as "Value" FROM merged_ipeds_css_irs.GenderFair2024
    UNION ALL
	SELECT "AveragePayWomen" as "Name", sum(SALARYTOTACDF)/sum(ACDPOPF) as "Value" FROM merged_ipeds_css_irs.GenderFair2024
    UNION ALL
	SELECT "AverageHateCrime" as "Name", avg(3.141592653589793) as "Value" FROM merged_ipeds_css_irs.GenderFair2024
    UNION ALL
	SELECT "AverageVAWA" as "Name", avg(1.14514) as "Value" FROM merged_ipeds_css_irs.GenderFair2024;
END$$

delimiter ;

CALL GetAverages();
