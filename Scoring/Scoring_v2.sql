USE merged_ipeds_css_irs;



SET @numEntries = (SELECT COUNT(*) FROM GenderFair2024);



DROP FUNCTION IF EXISTS percentileToScore;

DELIMITER $$
CREATE FUNCTION percentileToScore(`rank` INT, entries INT, max INT)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    RETURN ROUND(max*(0.5-0.5*COS(PI()*`rank`/entries)));
END$$
DELIMITER ;



select
	avg(NONACDBLAK/(NONACDMEN+NONACDWOMEN)),
	avg(NONACDASIA/(NONACDMEN+NONACDWOMEN)),
	avg(NONACDHISP/(NONACDMEN+NONACDWOMEN)),
	avg(NONACDNHPI/(NONACDMEN+NONACDWOMEN)),
	avg(NONACDNAMC/(NONACDMEN+NONACDWOMEN)),
	avg(NONACDNRES/(NONACDMEN+NONACDWOMEN)),
	avg(NONACDTWOP/(NONACDMEN+NONACDWOMEN)),
	avg(NONACDUNKN/(NONACDMEN+NONACDWOMEN)),
	avg(ACDTOTBLAK/(ACDTOTMEN+ACDTOTWOMEN)),
	avg(ACDTOTASIA/(ACDTOTMEN+ACDTOTWOMEN)),
	avg(ACDTOTHISP/(ACDTOTMEN+ACDTOTWOMEN)),
	avg(ACDTOTNHPI/(ACDTOTMEN+ACDTOTWOMEN)),
	avg(ACDTOTNAMC/(ACDTOTMEN+ACDTOTWOMEN)),
	avg(ACDTOTNRES/(ACDTOTMEN+ACDTOTWOMEN)),
	avg(ACDTOTTWOP/(ACDTOTMEN+ACDTOTWOMEN)),
	avg(ACDTOTUNKN/(ACDTOTMEN+ACDTOTWOMEN))
    INTO
	@NONACDBLAKRATIO,
	@NONACDASIARATIO,
	@NONACDHISPRATIO,
	@NONACDNHPIRATIO,
	@NONACDNAMCRATIO,
	@NONACDNRESRATIO,
	@NONACDTWOPRATIO,
	@NONACDUNKNRATIO,
	@ACDTOTBLAKRATIO,
	@ACDTOTASIARATIO,
	@ACDTOTHISPRATIO,
	@ACDTOTNHPIRATIO,
	@ACDTOTNAMCRATIO,
	@ACDTOTNRESRATIO,
	@ACDTOTTWOPRATIO,
	@ACDTOTUNKNRATIO
from GenderFair2024;



-- All academic staff gender ratio (30 pts)

select UNITID, ACDPOPM, ACDPOPF, ACDPOPF/(ACDPOPF+ACDPOPM) as ratio,
	rank() OVER (order by ACDPOPF/(ACDPOPF+ACDPOPM)) as `rank`,
    percentileToScore(
		rank() OVER (order by ACDPOPF/(ACDPOPF+ACDPOPM)),
        @numEntries,
        30
	) as AcdStaffGenderScore
from GenderFair2024;

-- Academmic staff average pay by gender (15 pts)
-- To capture both overall pay and pay ratio advantages, the scored value is constructed by men's average pay
-- added with 3 times of women's average pay.
-- Note: some schools have no men workers or no women workers. Theoretically a school can have both, but it is not observed here.
-- There also exists a school (Maine Maritime Academy) which did not report any income figures for both men and women.
select UNITID,
	SALARYTOTACDM/ACDTOTMEN as MenAvgPay,
	SALARYTOTACDF/ACDTOTWOMEN as WomenAvgPay,
	(SALARYTOTACDF*ACDTOTMEN)/(ACDTOTWOMEN*SALARYTOTACDM) as ratio,
	SALARYTOTACDM/ACDTOTMEN+3*SALARYTOTACDF/ACDTOTWOMEN as metric,
	rank() OVER (order by SALARYTOTACDM/ACDTOTMEN+3*SALARYTOTACDF/ACDTOTWOMEN) as `rank`,
    percentileToScore(
		rank() OVER (order by SALARYTOTACDM/ACDTOTMEN+3*SALARYTOTACDF/ACDTOTWOMEN),
		@numEntries,
        15
	) as AcdStaffPayScore
from GenderFair2024 order by `rank` desc;

-- Has campus daycare (10 pts)
select UNITID, HASDAYCARE, HASDAYCARE*10 as DaycareScore
from GenderFair2024;

-- Hate crime (10 pts)
select UNITID, YEARLYHATECRIME1K, 
	@numEntries - rank() OVER (order by YEARLYHATECRIME1K) as `rank`,
    percentileToScore(
		@numEntries - rank() OVER (order by YEARLYHATECRIME1K),
		@numEntries,
        10
	) as HateCrimeScore
from GenderFair2024 order by `rank` desc;

-- VAWA (10 pts)
select UNITID, YEARLYVAWA1K, 
	@numEntries - rank() OVER (order by YEARLYVAWA1K) as `rank`,
    percentileToScore(
		@numEntries - rank() OVER (order by YEARLYVAWA1K),
		@numEntries,
        10
	) as VAWAScore
from GenderFair2024 order by `rank` desc;

-- Academic staff racial composition (20 pts)

-- Non-academic staff racial composition (5 pts)

WITH NONACDRATIO AS (
	select
		UNITID,
		(RANK() OVER (ORDER BY NONACDBLAK/(NONACDMEN+NONACDWOMEN))) * @NONACDBLAKRATIO +
		(RANK() OVER (ORDER BY NONACDASIA/(NONACDMEN+NONACDWOMEN))) * @NONACDASIARATIO +
		(RANK() OVER (ORDER BY NONACDHISP/(NONACDMEN+NONACDWOMEN))) * @NONACDHISPRATIO +
		(RANK() OVER (ORDER BY NONACDNHPI/(NONACDMEN+NONACDWOMEN))) * @NONACDNHPIRATIO +
		(RANK() OVER (ORDER BY NONACDNAMC/(NONACDMEN+NONACDWOMEN))) * @NONACDNAMCRATIO +
		(RANK() OVER (ORDER BY NONACDNRES/(NONACDMEN+NONACDWOMEN))) * @NONACDNRESRATIO +
		(RANK() OVER (ORDER BY NONACDTWOP/(NONACDMEN+NONACDWOMEN))) * @NONACDTWOPRATIO +
		(RANK() OVER (ORDER BY NONACDUNKN/(NONACDMEN+NONACDWOMEN))) * @NONACDUNKNRATIO
		as NonAcademicRaceRatios
	from GenderFair2024
)
select
	UNITID,
	NonAcademicRaceRatios,
	RANK() OVER (ORDER BY NonAcademicRaceRatios) AS NonAcademicRaceRank,    
    percentileToScore(
		RANK() OVER (ORDER BY NonAcademicRaceRatios),
		@numEntries,
        10
	) as AcdStaffPayScore
from NONACDRATIO order by NonAcademicRaceRank desc;




-- Full Script

WITH SCORES AS (
	select
		UNITID,
		percentileToScore(
			rank() OVER (order by ACDPOPF/(ACDPOPF+ACDPOPM)),
			@numEntries,
			30
		) as AcdStaffGenderScore,
		percentileToScore(
			rank() OVER (order by SALARYTOTACDM/ACDTOTMEN+3*SALARYTOTACDF/ACDTOTWOMEN),
			@numEntries,
			15
		) as AcdStaffPayScore,
        HASDAYCARE*10 as DaycareScore,
		percentileToScore(
			@numEntries - rank() OVER (order by YEARLYHATECRIME1K),
			@numEntries,
			10
		) as HateCrimeScore,
		percentileToScore(
			@numEntries - rank() OVER (order by YEARLYVAWA1K),
			@numEntries,
			10
		) as VAWAScore
	from GenderFair2024
),
ACDRATIO AS (
	select
		UNITID,
		(RANK() OVER (ORDER BY ACDTOTBLAK/(ACDTOTMEN+ACDTOTWOMEN))) * @ACDTOTBLAKRATIO +
		(RANK() OVER (ORDER BY ACDTOTASIA/(ACDTOTMEN+ACDTOTWOMEN))) * @ACDTOTASIARATIO +
		(RANK() OVER (ORDER BY ACDTOTHISP/(ACDTOTMEN+ACDTOTWOMEN))) * @ACDTOTHISPRATIO +
		(RANK() OVER (ORDER BY ACDTOTNHPI/(ACDTOTMEN+ACDTOTWOMEN))) * @ACDTOTNHPIRATIO +
		(RANK() OVER (ORDER BY ACDTOTNAMC/(ACDTOTMEN+ACDTOTWOMEN))) * @ACDTOTNAMCRATIO +
		(RANK() OVER (ORDER BY ACDTOTNRES/(ACDTOTMEN+ACDTOTWOMEN))) * @ACDTOTNRESRATIO +
		(RANK() OVER (ORDER BY ACDTOTTWOP/(ACDTOTMEN+ACDTOTWOMEN))) * @ACDTOTTWOPRATIO +
		(RANK() OVER (ORDER BY ACDTOTUNKN/(ACDTOTMEN+ACDTOTWOMEN))) * @ACDTOTUNKNRATIO
		as AcademicRaceRatios
	from GenderFair2024
),
ACDSCORE AS (
	select
		UNITID,
		AcademicRaceRatios,
		RANK() OVER (ORDER BY AcademicRaceRatios) AS AcademicRaceRank,    
		percentileToScore(
			RANK() OVER (ORDER BY AcademicRaceRatios),
			@numEntries,
			20
		) as AcdDiversityScore
	from ACDRATIO
),
NONACDRATIO AS (
	select
		UNITID,
		(RANK() OVER (ORDER BY NONACDBLAK/(NONACDMEN+NONACDWOMEN))) * @NONACDBLAKRATIO +
		(RANK() OVER (ORDER BY NONACDASIA/(NONACDMEN+NONACDWOMEN))) * @NONACDASIARATIO +
		(RANK() OVER (ORDER BY NONACDHISP/(NONACDMEN+NONACDWOMEN))) * @NONACDHISPRATIO +
		(RANK() OVER (ORDER BY NONACDNHPI/(NONACDMEN+NONACDWOMEN))) * @NONACDNHPIRATIO +
		(RANK() OVER (ORDER BY NONACDNAMC/(NONACDMEN+NONACDWOMEN))) * @NONACDNAMCRATIO +
		(RANK() OVER (ORDER BY NONACDNRES/(NONACDMEN+NONACDWOMEN))) * @NONACDNRESRATIO +
		(RANK() OVER (ORDER BY NONACDTWOP/(NONACDMEN+NONACDWOMEN))) * @NONACDTWOPRATIO +
		(RANK() OVER (ORDER BY NONACDUNKN/(NONACDMEN+NONACDWOMEN))) * @NONACDUNKNRATIO
		as NonAcademicRaceRatios
	from GenderFair2024
),
NONACDSCORE AS (
	select
		UNITID,
		NonAcademicRaceRatios,
		RANK() OVER (ORDER BY NonAcademicRaceRatios) AS NonAcademicRaceRank,    
		percentileToScore(
			RANK() OVER (ORDER BY NonAcademicRaceRatios),
			@numEntries,
			5
		) as NonAcdDiversityScore
	from NONACDRATIO
),
AllScores as (
	select
		UNITID,
		INSTNM,
		STATE,
		INSTFUNDINGTYPE,
		AcdStaffGenderScore,
		AcdStaffPayScore,
		DaycareScore,
		HateCrimeScore,
		VAWAScore,
		AcdDiversityScore,
		NonAcdDiversityScore
	from SCORES JOIN NONACDSCORE USING (UNITID) JOIN ACDSCORE USING (UNITID) JOIN GenderFair2024 USING (UNITID)
)
select
	UNITID,
	INSTNM,
	STATE,
	INSTFUNDINGTYPE,
	AcdStaffGenderScore as LEADERSHIP,
	AcdStaffPayScore + DaycareScore as POLICIES,
	HateCrimeScore + VAWAScore as SAFETY,
	AcdDiversityScore + NonAcdDiversityScore as DIVERSITY
	AcdStaffGenderScore + AcdStaffPayScore + DaycareScore + HateCrimeScore + VAWAScore + AcdDiversityScore + NonAcdDiversityScore as Total,
from AllScores order by UNITID

