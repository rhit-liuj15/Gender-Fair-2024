SET SQL_SAFE_UPDATES = 0;

ALTER TABLE `css`.`css_hate_merged_records`
ADD COLUMN YEARLYHATECRIME DOUBLE;

UPDATE `css`.`css_hate_merged_records`
SET YEARLYHATECRIME = (
    MURD20 +
    RAPE20 +
    FOND20 +
    INCE20 +
    STAT20 +
    ROBBE20 +
    AGG_A20 +
    BURGLA20 +
    VEHIC20 +
    ARSON20 +
    SIM_A20 +
    LAR_T20 +
    INTIM20 +
    VANDAL20 +
    MURD21 +
    RAPE21 +
    FOND21 +
    INCE21 +
    STAT21 +
    ROBBE21 +
    AGG_A21 +
    BURGLA21 +
    VEHIC21 +
    ARSON21 +
    SIM_A21 +
    LAR_T21 +
    INTIM21 +
    VANDAL21 +
    MURD22 +
    RAPE22 +
    FOND22 +
    INCE22 +
    STAT22 +
    ROBBE22 +
    AGG_A22 +
    BURGLA22 +
    VEHIC22 +
    ARSON22 +
    SIM_A22 +
    LAR_T22 +
    INTIM22 +
    VANDAL22
) / 3;

ALTER TABLE `css`.`css_hate_merged_records`
ADD COLUMN YEARLYHATECRIME1K DOUBLE;

UPDATE `css`.`css_hate_merged_records`
SET YEARLYHATECRIME1K = YEARLYHATECRIME * 1000 / NULLIF(Total, 0);

RENAME TABLE `css`.`css_hate_merged_records` TO `css`.`css_hate_final`;

SET SQL_SAFE_UPDATES = 1;