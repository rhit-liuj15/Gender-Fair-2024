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
	SELECT "AverageHateCrime" as "Name", sum(YEARLYHATECRIME)/sum(ENROLLTOT)*1000 FROM merged_ipeds_css_irs.GenderFair2024
    UNION ALL
	SELECT "AverageHateCrime" as "Name", sum(YEARLYVAWA)/sum(ENROLLTOT)*1000 FROM merged_ipeds_css_irs.GenderFair2024;
END$$

delimiter ;

CALL GetAverages();