USE PublicFacingData;

DROP PROCEDURE IF EXISTS GetMetadata;

delimiter $$
CREATE PROCEDURE GetMetadata ()
BEGIN
	SELECT `GROUP`, `ABBR`, `DESC`
	FROM Metadata;
END$$

delimiter ;

CALL GetMetadata();