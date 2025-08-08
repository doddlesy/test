DECLARE @DaysList VARCHAR(MAX) = '7,30,60';
DECLARE @RangeBack INT = 3;

-- Table to store target dates and corresponding DayValue
DECLARE @DateRanges TABLE (
    TargetDate DATE,
    DayValue INT
);

-- Step 1: Build list of date ranges
;WITH SplitDays AS (
    SELECT TRY_CAST(value AS INT) AS DaysFromNow
    FROM STRING_SPLIT(@DaysList, ',')
    WHERE ISNUMERIC(value) = 1
),
NumberSeries AS (
    SELECT number
    FROM master.dbo.spt_values
    WHERE type = 'P' AND number < @RangeBack
)
INSERT INTO @DateRanges (TargetDate, DayValue)
SELECT 
    DATEADD(DAY, DaysFromNow - NumberSeries.number, CAST(GETDATE() AS DATE)) AS TargetDate,
    DaysFromNow
FROM SplitDays
JOIN NumberSeries ON 1 = 1;

-- Step 2: Print the generated date ranges
PRINT 'Generated Date Ranges:';
SELECT * FROM @DateRanges ORDER BY TargetDate;

-- Step 3: Find matches in MyTable
-- Assumes MyTable has Email and DateColumn
WITH Matched AS (
    SELECT 
        m.Email,
        m.DateColumn,
        d.DayValue
    FROM MyTable m
    JOIN @DateRanges d ON CAST(m.DateColumn AS DATE) = d.TargetDate
),
RankedMatches AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY Email ORDER BY DayValue ASC) AS rn
    FROM Matched
)
-- Step 4: Return only best (lowest) match per email
SELECT 
    Email,
    DateColumn,
    DayValue AS MatchDay
FROM RankedMatches
WHERE rn = 1
ORDER BY MatchDay;

