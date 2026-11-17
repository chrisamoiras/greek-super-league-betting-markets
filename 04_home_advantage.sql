-- 04_home_advantage.sql
-- Question: How strong is home advantage, and did it change when stadiums were empty (COVID, 2020/21)?
-- Note: 2020/21 was played almost entirely without fans in Greece. Part of 2019/20 too (after March 2020).
-- Comparing seasons shows a correlation, not proof that fans cause home advantage.

SELECT
    Season,
    CASE WHEN Season = '2020/21' THEN 'Empty stadiums' ELSE 'Fans allowed (mostly)' END AS crowd_status,
    COUNT(*)                                                AS matches,
    ROUND(100.0 * AVG(HomeWin), 1)                          AS home_win_pct,
    ROUND(100.0 * AVG(AwayWin), 1)                          AS away_win_pct,
    ROUND(100.0 * (AVG(HomeWin) - AVG(AwayWin)), 1)         AS home_minus_away_pp,
    ROUND(AVG(FTHG - FTAG), 2)                              AS avg_goal_difference_home,
    ROUND(100.0 * AVG(B365_ProbH), 1)                       AS b365_expected_home_win_pct
FROM matches
GROUP BY Season
ORDER BY Season;
