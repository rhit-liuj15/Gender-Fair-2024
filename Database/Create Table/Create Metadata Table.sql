/*
This creates the metadata table. We specify that in group 0, each entry's "ABBR" should be a string that represents a 1- or 2-digit number with no signs, no spaces and no leading zeroes. The corresponding "DESC" is the description for the group with that number.

Group numbers 1-99 can be used for any purpose.

The following is an example usage:

INSERT INTO `PublicFacingData`.`Metadata` (`GROUP`, `ABBR`, `DESC`) VALUES
  (0, '1', 'State names & abbreviations'),
  (0, '67', 'Companies with 2-letter abbreviations'),
  (1, 'CA', 'California'),
  (1, 'NY', 'New York'),
  (1, 'IN', 'Indiana'),
  (67, 'GE', 'General Electric'),
  (67, 'GM', 'General Motors'),
  (67, '3M', 'Minnesota Mining and Manufacturing Company'),
  (67, 'HP', 'Hewlett-Packard');
  
*/

-- DROP TABLE IF EXISTS `PublicFacingData`.`Metadata`;

CREATE TABLE `PublicFacingData`.`Metadata` (
  `GROUP` INT NOT NULL,
  `ABBR` VARCHAR(2) NOT NULL,
  `DESC` VARCHAR(100) NULL,
  PRIMARY KEY (`GROUP`, `ABBR`)
);

-- SELECT * FROM `PublicFacingData`.`Metadata`;