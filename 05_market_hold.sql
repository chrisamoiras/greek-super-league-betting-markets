-- 05_market_hold.sql
-- Question (business view): How much does each market earn for the bookmaker, in theory and in practice?
-- Theoretical hold = overround / (1 + overround): the share of stakes the bookmaker keeps
--   if money is spread across outcomes in line with the odds.
-- Actual hold = 1 - (money paid back / money staked) if 1 unit was staked on every outcome.
-- GGR (Gross Gaming Revenue) = stakes - winnings paid. Hold = GGR / stakes.
-- Only seasons 2019/20 onwards, because Over/Under odds start then (fair comparison of markets).

WITH m AS (
    SELECT * FROM matches WHERE Season >= '2019/20'
),
markets AS (
    SELECT 'Bet365 1X2' AS market,
           B365_Overround_1X2 AS overround,
           3.0 AS stakes,
           CASE FTR WHEN 'H' THEN B365H WHEN 'D' THEN B365D ELSE B365A END AS paid_back
    FROM m WHERE B365_Overround_1X2 IS NOT NULL
    UNION ALL
    SELECT 'Pinnacle 1X2', PS_Overround_1X2, 3.0,
           CASE FTR WHEN 'H' THEN PSH WHEN 'D' THEN PSD ELSE PSA END
    FROM m WHERE PS_Overround_1X2 IS NOT NULL
    UNION ALL
    SELECT 'Bet365 Over/Under 2.5', B365_Overround_OU25, 2.0,
           CASE WHEN Over25 = 1 THEN B365_Over25 ELSE B365_Under25 END
    FROM m WHERE B365_Overround_OU25 IS NOT NULL
    UNION ALL
    SELECT 'Pinnacle Over/Under 2.5', PS_Overround_OU25, 2.0,
           CASE WHEN Over25 = 1 THEN PS_Over25 ELSE PS_Under25 END
    FROM m WHERE PS_Overround_OU25 IS NOT NULL
)
SELECT
    market,
    COUNT(*)                                                   AS matches,
    ROUND(100.0 * AVG(overround), 2)                           AS avg_margin_pct,
    ROUND(100.0 * AVG(overround / (1 + overround)), 2)         AS theoretical_hold_pct,
    ROUND(100.0 * (1 - SUM(paid_back) / SUM(stakes)), 2)       AS actual_hold_pct
FROM markets
GROUP BY market
ORDER BY market;
