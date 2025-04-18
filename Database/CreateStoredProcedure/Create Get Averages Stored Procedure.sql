USE PublicFacingData;

DROP PROCEDURE IF EXISTS GetAverages;

delimiter $$

-- The implementation uses a varchar for the string of school UNITIDs, since the number of schools queried is variable.
-- 
CREATE PROCEDURE GetAverages ()
BEGIN
	SELECT "AveragePayMen" as "Name", sum(SAOUTLM)/sum(SAINSTM) as "Value" FROM merged_ipeds_css_irs.ipeds_css_irs_final
    UNION ALL
	SELECT "AveragePayWomen" as "Name", sum(SAOUTLW)/sum(SAINSTW) as "Value" FROM merged_ipeds_css_irs.ipeds_css_irs_final
    UNION ALL
	SELECT "AverageHateCrime" as "Name", avg(3.141592653589793) as "Value" FROM merged_ipeds_css_irs.ipeds_css_irs_final
    UNION ALL
	SELECT "AverageVAWA" as "Name", avg(1.14514) as "Value" FROM merged_ipeds_css_irs.ipeds_css_irs_final;
END$$

delimiter ;

CALL GetAverages();
