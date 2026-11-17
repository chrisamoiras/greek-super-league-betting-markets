-- 02_calibration.sql
-- Question: Are Bet365's odds accurate? When the odds say 40%, does that outcome happen about 40% of the time?
-- We use the fair (margin-free) probability: (1/odds) / sum of (1/odds) of the 3 outcomes.
-- Step 1 (CTE + UNION ALL): turn every match into 3 rows, one per outcome (Home, Draw, Away).
-- Step 2: put each row in a 10-percentage-point band and compare predicted vs actual.

WITH outcomes AS (
    SELECT Season, 'Home' AS outcome, B365_ProbH AS prob, HomeWin AS happened FROM matches WHERE B365_ProbH IS NOT NULL
    UNION ALL
    SELECT Season, 'Draw', B365_ProbD, Draw    FROM matches WHERE B365_ProbD IS NOT NULL
    UNION ALL
    SELECT Season, 'Away', B365_ProbA, AwayWin FROM matches WHERE B365_ProbA IS NOT NULL
),
banded AS (
    SELECT
        CAST(prob * 10 AS INTEGER) * 10 AS band_start,   -- 0.47 -> 40 (the 40-50% band)
        prob,
        happened
    FROM outcomes
)
SELECT
    band_start || '-' || (band_start + 10) || '%'           AS predicted_band,
    COUNT(*)                                                AS outcomes,
    ROUND(100.0 * AVG(prob), 1)                             AS avg_predicted_pct,
    ROUND(100.0 * AVG(happened), 1)                         AS actual_pct,
    ROUND(100.0 * (AVG(happened) - AVG(prob)), 1)           AS difference_pp
FROM banded
GROUP BY band_start
ORDER BY band_start;
