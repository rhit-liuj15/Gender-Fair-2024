-- Disable SQL safe mode
SET SQL_SAFE_UPDATES = 0;

-- Add the new column YEARLYVAWA
ALTER TABLE `css`.`css_vawa_merged_records`
ADD COLUMN YEARLYVAWA DOUBLE;

-- Update YEARLYVAWA with the computed value
UPDATE `css`.`css_vawa_merged_records`
SET YEARLYVAWA = (DOMEST20 + DATING20 + STALK20
                 + DOMEST21 + DATING21 + STALK21
                 + DOMEST22 + DATING22 + STALK22) / 3;
                 
-- Add the new column YEARLYVAWA1K
ALTER TABLE `css`.`css_vawa_merged_records`
ADD COLUMN YEARLYVAWA1K DOUBLE;

-- Update YEARLYVAWA1K with the computed value
UPDATE `css`.`css_vawa_merged_records`
SET YEARLYVAWA1K = YEARLYVAWA * 1000 / NULLIF(Total, 0);

-- Rename 'css_vawa_merged_records' to 'css_vawa_final'
RENAME TABLE `css`.`css_vawa_merged_records` TO `css`.`css_vawa_final`;

-- Enable SQL safe mode
SET SQL_SAFE_UPDATES = 1;