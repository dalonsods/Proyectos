WITH players_inducted AS (
    SELECT DISTINCT playerID
    FROM HallOfFame
    WHERE category='Player' AND inducted='Y'
),
players_not_inducted AS (
    SELECT DISTINCT playerID
    FROM HallOfFame
    WHERE category='Player' AND inducted='N'
),
all_players AS (
    SELECT DISTINCT playerID
    FROM Appearances
),
class AS (
    SELECT playerID,
    CASE
        WHEN playerID IN (SELECT * FROM players_inducted) OR playerID IN (SELECT * FROM players_not_inducted) THEN 'Y'
        ELSE 'N'
    END AS class
    FROM all_players
),
player_anual_salary AS (
    SELECT
        playerID,
        yearID,
        SUM(salary) AS player_salary
    FROM Salaries
    GROUP BY playerID, yearID
),
yearly_salary_averages AS (
    SELECT
        yearID,
        AVG(salary) AS avg_year_salary
    FROM Salaries
    GROUP BY yearID
),
-- average salary of a player divided by average salary of the rest of the players in those years
salary_compared AS (
    SELECT
        p.playerID,
        ROUND(SUM(p.player_salary) / SUM(y.avg_year_salary), 2) AS salary_ratio
    FROM player_anual_salary p
    JOIN yearly_salary_averages y
    ON p.yearID = y.yearID
    GROUP BY p.playerID
),
awards_statistics AS (
    SELECT
        playerID,
        ROUND(SUM(pointsWon) / SUM(pointsMax), 4) AS points_ratio,
        SUM(votesFirst) AS total_first_place_votes
    FROM AwardsSharePlayers
    GROUP BY playerID
),
total_awards AS (
    SELECT
        playerID,
        COUNT(*) AS total_awards
    FROM AwardsPlayers
    GROUP BY playerID
),
all_star_stats AS (
    SELECT
        playerID,
        SUM(GP) AS total_GP,
        SUM(CASE WHEN startingPos != '' THEN 1 ELSE 0 END) / SUM(GP) AS perc_starting
    FROM AllStarFull
    GROUP BY playerID
),
batting_stats AS (
    SELECT
        playerID,
        SUM(G) AS TotalBatGames,
        SUM(H) / SUM(AB) AS BattingAverage,
        SUM(R) / SUM(G) AS AvgRunsPerGame,
        SUM(HR) / SUM(G) AS AvgHomeRunsPerGame,
        SUM(RBI) / SUM(G) AS AvgRBIsPerGame,
        (SUM(G) - SUM(SO)) / SUM(G) AS AvgNoStrikeoutsPerGame
    FROM Batting
    GROUP BY playerID
),
pitching_stats AS (
    SELECT
        playerID,
        SUM(G) AS TotalPitGames,
        SUM(W) AS W,
        SUM(W) / SUM(L) AS WinLossRatio,
        SUM(ERA) / SUM(G) AS AvgERA,
        SUM(SO) / SUM(G) AS AvgSO,
        SUM(CG) / SUM(G) AS AvgCG,
        SUM(SHO) / SUM(G) AS AvgSHO
    FROM Pitching
    GROUP BY playerID
),
fielding_stats AS (
    SELECT
        playerID,
        SUM(G) AS TotalFieGames,
        SUM(PO) / SUM(G) AS avg_PO,
        SUM(A) / SUM(G) AS avg_A,
        SUM(E) / SUM(G) AS avg_E,
        SUM(DP) / SUM(G) AS avg_DP,
        AVG(ZR) AS avg_ZR
    FROM Fielding
    GROUP BY playerID
),
bating_post AS (
    SELECT playerID, SUM(G) AS total_bat_games_post
    FROM BattingPost
    GROUP BY playerID
),
pitching_post AS (
    SELECT playerID, SUM(G) AS total_pit_games_post
    FROM PitchingPost
    GROUP BY playerID
),
fielding_post AS (
    SELECT playerID, SUM(G) AS total_fie_games_post
    FROM FieldingPost
    GROUP BY playerID
)
SELECT
    -- Adding header
    'playerID',
    'salary_ratio',
    'points_ratio',
    'total_first_place_votes',
    'total_awards',
    'total_GP',
    'perc_starting',
    'TotalBatGames',
    'total_bat_games_post',
    'BattingAverage',
    'AvgRunsPerGame',
    'AvgHomeRunsPerGame',
    'AvgRBIsPerGame',
    'AvgNoStrikeoutsPerGame',
    'TotalPitGames',
    'total_pit_games_post',
    'WinLossRatio',
    'AvgERA',
    'AvgSO',
    'AvgCG',
    'AvgSHO',
    'TotalFieGames',
    'total_fie_games_post',
    'avg_PO',
    'avg_A',
    'avg_E',
    'avg_DP',
    'avg_ZR',
    'class'

UNION

SELECT
    a.playerID,
    s.salary_ratio,
    COALESCE(w.points_ratio, 0) AS points_ratio,
    COALESCE(w.total_first_place_votes, 0) AS total_first_place_votes,
    COALESCE(t.total_awards, 0) AS total_awards,
    COALESCE(al.total_GP, 0) AS total_GP,
    COALESCE(al.perc_starting, 0) AS perc_starting,
    COALESCE(b.TotalBatGames, 0) AS TotalBatGames,
    COALESCE(bp.total_bat_games_post, 0) AS total_bat_games_post,
    COALESCE(b.BattingAverage, 0) AS BattingAverage,
    COALESCE(b.AvgRunsPerGame, 0) AS AvgRunsPerGame,
    COALESCE(b.AvgHomeRunsPerGame, 0) AS AvgHomeRunsPerGame,
    COALESCE(b.AvgRBIsPerGame, 0) AS AvgRBIsPerGame,
    COALESCE(b.AvgNoStrikeoutsPerGame, 0) AS AvgNoStrikeoutsPerGame,
    COALESCE(p.TotalPitGames, 0) AS TotalPitGames,
    COALESCE(pp.total_pit_games_post, 0) AS total_pit_games_post,
    CASE
        WHEN p.W > 0 THEN COALESCE(p.WinLossRatio, (SELECT MAX(WinLossRatio) FROM pitching_stats))
        ELSE 0
    END AS WinLossRatio,
    COALESCE(p.AvgERA, 0) AS AvgERA,
    COALESCE(p.AvgSO, 0) AS AvgSO,
    COALESCE(p.AvgCG, 0) AS AvgCG,
    COALESCE(p.AvgSHO, 0) AS AvgSHO,
    COALESCE(f.TotalFieGames, 0) AS TotalFieGames,
    COALESCE(fp.total_fie_games_post, 0) AS total_fie_games_post,
    COALESCE(f.avg_PO, 0) AS avg_PO,
    COALESCE(f.avg_A, 0) AS avg_A,
    COALESCE(f.avg_E, 0) AS avg_E,
    COALESCE(f.avg_DP, 0) AS avg_DP,
    COALESCE(f.avg_ZR, 0) AS avg_ZR,
    a.class
FROM class a
JOIN salary_compared s ON a.playerID = s.playerID
LEFT JOIN awards_statistics w ON a.playerID = w.playerID
LEFT JOIN total_awards t ON a.playerID = t.playerID
LEFT JOIN all_star_stats al ON a.playerID = al.playerID
LEFT JOIN batting_stats b ON a.playerID = b.playerID
LEFT JOIN pitching_stats p ON a.playerID = p.playerID
LEFT JOIN fielding_stats f ON a.playerID = f.playerID
LEFT JOIN bating_post bp ON a.playerID = bp.playerID
LEFT JOIN pitching_post pp ON a.playerID = pp.playerID
LEFT JOIN fielding_post fp ON a.playerID = fp.playerID
INTO OUTFILE '/var/lib/mysql-files/taskA.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';
