-- 01_season_overview.sql
-- Question: How did results, goals and bookmaker margins change season by season?
-- Margin (overround) = sum of implied probabilities (1/odds) of all outcomes - 1.
-- AVG() ignores NULLs, so matches without odds from a bookmaker are left out of that bookmaker's margin.

SELECT
    Season,
    COUNT(*)                                        AS matches,
    ROUND(100.0 * AVG(HomeWin), 1)                  AS home_win_pct,
    ROUND(100.0 * AVG(Draw), 1)                     AS draw_pct,
    ROUND(100.0 * AVG(AwayWin), 1)                  AS away_win_pct,
    ROUND(AVG(TotalGoals), 2)                       AS avg_goals,
    ROUND(100.0 * AVG(Over25), 1)                   AS over25_pct,
    ROUND(100.0 * AVG(B365_Overround_1X2), 2)       AS b365_margin_1x2_pct,
    ROUND(100.0 * AVG(PS_Overround_1X2), 2)         AS pinnacle_margin_1x2_pct,
    COUNT(PS_Overround_1X2)                         AS matches_with_pinnacle_odds,
    ROUND(100.0 * AVG(B365_Overround_OU25), 2)      AS b365_margin_ou25_pct,
    ROUND(100.0 * AVG(PS_Overround_OU25), 2)        AS pinnacle_margin_ou25_pct
FROM matches
GROUP BY Season
ORDER BY Season;
