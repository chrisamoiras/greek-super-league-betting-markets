-- 03_return_by_odds_band.sql
-- Question: Where does the bookmaker's margin come from? Favourites or outsiders (longshots)?
-- If someone staked 1 unit on EVERY outcome at Bet365 odds, what would they get back, per odds band?
--   win  -> profit = odds - 1
--   lose -> profit = -1
-- player_return_pct < 0 means the bookmaker keeps that share of the stakes (bookmaker hold).
-- A much more negative return for long odds = "favourite-longshot bias".

WITH bets AS (
    SELECT B365H AS odds, HomeWin AS won FROM matches WHERE B365H IS NOT NULL
    UNION ALL
    SELECT B365D, Draw    FROM matches WHERE B365D IS NOT NULL
    UNION ALL
    SELECT B365A, AwayWin FROM matches WHERE B365A IS NOT NULL
),
banded AS (
    SELECT
        CASE
            WHEN odds < 1.50 THEN '1) 1.01-1.49'
            WHEN odds < 2.00 THEN '2) 1.50-1.99'
            WHEN odds < 3.00 THEN '3) 2.00-2.99'
            WHEN odds < 5.00 THEN '4) 3.00-4.99'
            WHEN odds < 10.0 THEN '5) 5.00-9.99'
            ELSE                  '6) 10.00+'
        END AS odds_band,
        odds,
        won,
        CASE WHEN won = 1 THEN odds - 1 ELSE -1 END AS profit
    FROM bets
)
SELECT
    odds_band,
    COUNT(*)                                  AS bets,
    ROUND(AVG(odds), 2)                       AS avg_odds,
    ROUND(100.0 * AVG(won), 1)                AS win_pct,
    ROUND(100.0 / AVG(odds), 1)               AS approx_implied_pct,
    ROUND(100.0 * SUM(profit) / COUNT(*), 1)  AS player_return_pct
FROM banded
GROUP BY odds_band
ORDER BY odds_band;
