-- Create the table with OPEID as the primary key
CREATE TABLE `css`.`css_vawa_merged_records` (
    OPEID INT PRIMARY KEY,
    men_total INT,
    women_total INT,
    Total INT,
    DOMEST20 INT,
    DATING20 INT,
    STALK20 INT,
    DOMEST21 INT,
    DATING21 INT,
    STALK21 INT,
    DOMEST22 INT,
    DATING22 INT,
    STALK22 INT
);

-- Insert the aggregated records
INSERT INTO `css`.`css_vawa_merged_records`
SELECT 
    OPEID,
    -- First occurrence of 'men_total', 'women_total', 'Total'
    MIN(men_total) AS men_total,  
    MIN(women_total) AS women_total,  
    MIN(Total) AS Total,  
    -- Sum numeric columns except first_columns
    SUM(DOMEST20) AS DOMEST20,
    SUM(DATING20) AS DATING20,
    SUM(STALK20) AS STALK20,
    SUM(DOMEST21) AS DOMEST21,
    SUM(DATING21) AS DATING21,
    SUM(STALK21) AS STALK21,
    SUM(DOMEST22) AS DOMEST22,
    SUM(DATING22) AS DATING22,
    SUM(STALK22) AS STALK22
FROM `css`.`css_vawa`
GROUP BY OPEID;



