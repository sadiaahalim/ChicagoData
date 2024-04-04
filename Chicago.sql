SELECT
    socio.COMMUNITY_AREA_NUMBER,
    socio.PERCENT_OF_HOUSING_CROWDED,
    socio.PERCENT_HOUSEHOLDS_BELOW_POVERTY,
    socio.PERCENT_AGED_16__UNEMPLOYED,
    socio.PERCENT_AGED_25__WITHOUT_HIGH_SCHOOL_DIPLOMA,
    socio.PERCENT_AGED_UNDER_18_OR_OVER_64,
    socio.PER_CAPITA_INCOME,
    schools.SAFETY_SCORE,
    schools.Environment_Score,
    schools.Instruction_Score,
	crimes.PRIMARY_TYPE,
    socio.HARDSHIP_INDEX 
    
INTO dbo.FactTable
FROM
    dbo.chicago_socioeconomic_data AS socio
JOIN
    dbo.chicago_public_schools AS schools
ON
    socio.COMMUNITY_AREA_NUMBER = schools.COMMUNITY_AREA_NUMBER
JOIN dbo.chicago_crime AS crimes ON crimes.COMMUNITY_AREA_NUMBER = socio.COMMUNITY_AREA_NUMBER;


-- Indexing the fact table
CREATE INDEX idx_CommunityAreaNumber ON dbo.FactTable(COMMUNITY_AREA_NUMBER);


ALTER TABLE dbo.FactTable
ADD INCOME_PER_CAPITA DECIMAL(18, 2)

UPDATE dbo.FactTable
SET INCOME_PER_CAPITA = PER_CAPITA_INCOME / PERCENT_HOUSEHOLDS_BELOW_POVERTY;


ALTER TABLE dbo.FactTable
ADD AVG_SCORE DECIMAL(18, 2);


UPDATE dbo.FactTable
SET AVG_SCORE = (SAFETY_SCORE + Environment_Score + Instruction_Score) / 3;

ALTER TABLE dbo.FactTable
DROP COLUMN Environment_Score;

ALTER TABLE dbo.FactTable
DROP COLUMN SAFETY_SCORE;

ALTER TABLE dbo.FactTable    
DROP COLUMN Instruction_Score;

SELECT * FROM dbo.FactTable