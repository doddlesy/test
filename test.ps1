DECLARE @DaysList VARCHAR(MAX) = '7,30,60';  -- Comma-separated list of future days
DECLARE @RangeBack INT = 3;                  -- How many days back to check (inclusive)

-- CTE: Split the comma-separated string into individual integers
;WITH SplitDays AS (
    SELECT TRY_CAST(value AS INT) AS DaysFromNow
    FROM STRING_SPLIT(@DaysList, ',')
    WHERE ISNUMERIC(value) = 1
),
-- CTE: Generate the range of dates for each future day (e.g. 7,6,5 for 7)
DateRanges AS (
    SELECT 
        DATEADD(DAY, DaysFromNow - v.number, CAST(GETDATE() AS DATE)) AS TargetDate
    FROM SplitDays
    JOIN master.dbo.spt_values v ON v.type = 'P'
    WHERE v.number < @RangeBack
)
-- Final query: match table records with any date in the generated range
SELECT *
FROM MyTable
WHERE CAST(DateColumn AS DATE) IN (SELECT TargetDate FROM DateRanges);
