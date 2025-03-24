#
# ECE356 - Lab 4
# Fall 2024

#
# DROP tables
 
DROP TABLE IF EXISTS Schools;
DROP TABLE IF EXISTS Salaries;
DROP TABLE IF EXISTS CollegePlaying;
DROP TABLE IF EXISTS HallOfFame;
DROP TABLE IF EXISTS AwardsSharePlayers;
DROP TABLE IF EXISTS AwardsShareManagers;
DROP TABLE IF EXISTS AwardsPlayers;
DROP TABLE IF EXISTS AwardsManagers;
DROP TABLE IF EXISTS TeamsHalf;
DROP TABLE IF EXISTS ManagersHalf;
DROP TABLE IF EXISTS HomeGames;
DROP TABLE IF EXISTS SeriesPost;
DROP TABLE IF EXISTS FieldingPost;
DROP TABLE IF EXISTS PitchingPost;
DROP TABLE IF EXISTS BattingPost;
DROP TABLE IF EXISTS AllStarFull;
DROP TABLE IF EXISTS Managers;
DROP TABLE IF EXISTS Appearances;
DROP TABLE IF EXISTS FieldingOfSplit;
DROP TABLE IF EXISTS FieldingOf;
DROP TABLE IF EXISTS Fielding;
DROP TABLE IF EXISTS Pitching;
DROP TABLE IF EXISTS Batting;
DROP TABLE IF EXISTS Parks;
DROP TABLE IF EXISTS TeamsFranchises;
DROP TABLE IF EXISTS Teams;
DROP TABLE IF EXISTS People;


#
# CREATE tables


CREATE TABLE People (
    playerID VARCHAR(50) DEFAULT NULL,                         -- Unique code assigned to each player
    birthYear INT DEFAULT NULL,                                -- Year player was born
    birthMonth INT DEFAULT NULL,                               -- Month player was born
    birthDay INT DEFAULT NULL,                                 -- Day player was born
    birthCountry VARCHAR(100) DEFAULT NULL,                    -- Country where player was born
    birthState VARCHAR(100) DEFAULT NULL,                      -- State where player was born
    birthCity VARCHAR(100) DEFAULT NULL,                       -- City where player was born
    deathYear INT DEFAULT NULL,                                -- Year player died
    deathMonth INT DEFAULT NULL,                               -- Month player died
    deathDay INT DEFAULT NULL,                                 -- Day player died
    deathCountry VARCHAR(100) DEFAULT NULL,                    -- Country where player died
    deathState VARCHAR(100) DEFAULT NULL,                      -- State where player died
    deathCity VARCHAR(100) DEFAULT NULL,                       -- City where player died
    nameFirst VARCHAR(100) DEFAULT NULL,                       -- Player's first name
    nameLast VARCHAR(100) DEFAULT NULL,                        -- Player's last name
    nameGiven VARCHAR(100) DEFAULT NULL,                       -- Player's given name (first and middle)
    weight INT DEFAULT NULL,                                   -- Player's weight in pounds
    height INT DEFAULT NULL,                                   -- Player's height in inches
    bats VARCHAR(10) DEFAULT NULL,                             -- Player's batting hand (left, right, or both)
    throws VARCHAR(10) DEFAULT NULL,                           -- Player's throwing hand (left or right)
    debut DATE DEFAULT NULL,                                   -- Date player made first major league appearance
    finalGame DATE DEFAULT NULL,                               -- Date player made first major league appearance (includes date of last played game even if still active)
    retroID VARCHAR(50) DEFAULT NULL,                          -- ID used by Retrosheet
    bbrefID VARCHAR(50) DEFAULT NULL                           -- ID used by Baseball Reference website
);

CREATE TABLE Teams (
    yearID INT DEFAULT NULL,                          -- Year of the season
    lgID VARCHAR(2) DEFAULT NULL,                     -- League ID
    teamID VARCHAR(3) DEFAULT NULL,                   -- Team ID
    franchID VARCHAR(50) DEFAULT NULL,                -- Franchise ID (links to TeamsFranchise table)
    divID VARCHAR(1) DEFAULT NULL,                    -- Team's division
    `rank` INT DEFAULT NULL,                            -- Position in final standings
    G INT DEFAULT NULL,                               -- Games played
    GHome INT DEFAULT NULL,                           -- Games played at home
    W INT DEFAULT NULL,                               -- Wins
    L INT DEFAULT NULL,                               -- Losses
    DivWin CHAR(1) DEFAULT NULL,                      -- Division Winner (Y or N)
    WCWin CHAR(1) DEFAULT NULL,                       -- Wild Card Winner (Y or N)
    LgWin CHAR(1) DEFAULT NULL,                       -- League Champion (Y or N)
    WSWin CHAR(1) DEFAULT NULL,                       -- World Series Winner (Y or N)
    R INT DEFAULT NULL,                               -- Runs scored
    AB INT DEFAULT NULL,                              -- At bats
    H INT DEFAULT NULL,                               -- Hits by batters
    `2B` INT DEFAULT NULL,                            -- Doubles
    `3B` INT DEFAULT NULL,                            -- Triples
    HR INT DEFAULT NULL,                              -- Homeruns by batters
    BB INT DEFAULT NULL,                              -- Walks by batters
    SO INT DEFAULT NULL,                              -- Strikeouts by batters
    SB INT DEFAULT NULL,                              -- Stolen bases
    CS INT DEFAULT NULL,                              -- Caught stealing
    HBP INT DEFAULT NULL,                             -- Batters hit by pitch
    SF INT DEFAULT NULL,                              -- Sacrifice flies
    RA INT DEFAULT NULL,                              -- Opponents' runs scored
    ER INT DEFAULT NULL,                              -- Earned runs allowed
    ERA DECIMAL(5,2) DEFAULT NULL,                    -- Earned run average
    CG INT DEFAULT NULL,                              -- Complete games
    SHO INT DEFAULT NULL,                             -- Shutouts
    SV INT DEFAULT NULL,                              -- Saves
    IPOuts INT DEFAULT NULL,                          -- Outs Pitched (innings pitched x 3)
    HA INT DEFAULT NULL,                              -- Hits allowed
    HRA INT DEFAULT NULL,                             -- Homeruns allowed
    BBA INT DEFAULT NULL,                             -- Walks allowed
    SOA INT DEFAULT NULL,                             -- Strikeouts by pitchers
    E INT DEFAULT NULL,                               -- Errors
    DP INT DEFAULT NULL,                              -- Double Plays
    FP DECIMAL(5,3) DEFAULT NULL,                     -- Fielding percentage
    name VARCHAR(255) DEFAULT NULL,                   -- Team's full name
    park VARCHAR(255) DEFAULT NULL,                   -- Name of team's home ballpark
    attendance INT DEFAULT NULL,                      -- Home attendance total
    BPF INT DEFAULT NULL,                             -- Three-year park factor for batters
    PPF INT DEFAULT NULL,                             -- Three-year park factor for pitchers
    teamIDBR VARCHAR(50) DEFAULT NULL,                -- Team ID used by Baseball Reference website
    teamIDlahman45 VARCHAR(50) DEFAULT NULL,          -- Team ID used in Lahman database version 4.5
    teamIDretro VARCHAR(50) DEFAULT NULL              -- Team ID used by Retrosheet
);

CREATE TABLE TeamsFranchises (
    franchID VARCHAR(50) DEFAULT NULL,         -- Franchise ID
    franchName VARCHAR(255) DEFAULT NULL,      -- Franchise name
    active CHAR(2) DEFAULT NULL,               -- Whether team is currently active or not (Y or N)
    NAassoc VARCHAR(50) DEFAULT NULL          -- ID of National Association team franchise played as
);

CREATE TABLE Parks (
    parkkey VARCHAR(50) DEFAULT NULL,          -- Ballpark ID code
    parkname VARCHAR(255) DEFAULT NULL,        -- Name of ballpark
    parkalias VARCHAR(255) DEFAULT NULL,                -- Alternate names of ballpark, separated by semicolon
    city VARCHAR(100) DEFAULT NULL,            -- City where the ballpark is located
    state VARCHAR(100) DEFAULT NULL,                    -- State where the ballpark is located
    country VARCHAR(100) DEFAULT NULL         -- Country where the ballpark is located
);

CREATE TABLE Batting (
    playerID VARCHAR(50) DEFAULT NULL,         -- Player ID code
    yearID INT DEFAULT NULL,                   -- Year
    stint INT DEFAULT NULL,                    -- Player's stint (order of appearances within a season)
    teamID VARCHAR(50) DEFAULT NULL,           -- Team
    lgID VARCHAR(50) DEFAULT NULL,             -- League
    G INT DEFAULT NULL,                        -- Games
    AB INT DEFAULT NULL,                       -- At Bats
    R INT DEFAULT NULL,                        -- Runs
    H INT DEFAULT NULL,                        -- Hits
    2B INT DEFAULT NULL,                       -- Doubles
    3B INT DEFAULT NULL,                       -- Triples
    HR INT DEFAULT NULL,                       -- Homeruns
    RBI INT DEFAULT NULL,                      -- Runs Batted In
    SB INT DEFAULT NULL,                       -- Stolen Bases
    CS INT DEFAULT NULL,                       -- Caught Stealing
    BB INT DEFAULT NULL,                       -- Base on Balls
    SO INT DEFAULT NULL,                       -- Strikeouts
    IBB INT DEFAULT NULL,                      -- Intentional Walks
    HBP INT DEFAULT NULL,                      -- Hit by pitch
    SH INT DEFAULT NULL,                       -- Sacrifice Hits
    SF INT DEFAULT NULL,                       -- Sacrifice Flies
    GIDP INT DEFAULT NULL                     -- Grounded into Double Plays
);

CREATE TABLE Pitching (
    playerID VARCHAR(50) DEFAULT NULL,         -- Player ID code
    yearID INT DEFAULT NULL,                   -- Year
    stint INT DEFAULT NULL,                    -- Player's stint (order of appearances within a season)
    teamID VARCHAR(50) DEFAULT NULL,           -- Team
    lgID VARCHAR(50) DEFAULT NULL,             -- League
    W INT DEFAULT NULL,                        -- Wins
    L INT DEFAULT NULL,                        -- Losses
    G INT DEFAULT NULL,                        -- Games
    GS INT DEFAULT NULL,                       -- Games Started
    CG INT DEFAULT NULL,                       -- Complete Games
    SHO INT DEFAULT NULL,                      -- Shutouts
    SV INT DEFAULT NULL,                       -- Saves
    IPOuts INT DEFAULT NULL,                   -- Outs Pitched (innings pitched x 3)
    H INT DEFAULT NULL,                        -- Hits
    ER INT DEFAULT NULL,                       -- Earned Runs
    HR INT DEFAULT NULL,                       -- Homeruns
    BB INT DEFAULT NULL,                       -- Walks
    SO INT DEFAULT NULL,                       -- Strikeouts
    BAOpp DECIMAL(5,3) DEFAULT NULL,           -- Opponent's Batting Average
    ERA DECIMAL(5,2) DEFAULT NULL,             -- Earned Run Average
    IBB INT DEFAULT NULL,                      -- Intentional Walks
    WP INT DEFAULT NULL,                       -- Wild Pitches
    HBP INT DEFAULT NULL,                      -- Batters Hit By Pitch
    BK INT DEFAULT NULL,                       -- Balks
    BFP INT DEFAULT NULL,                      -- Batters faced by Pitcher
    GF INT DEFAULT NULL,                       -- Games Finished
    R INT DEFAULT NULL,                        -- Runs Allowed
    SH INT DEFAULT NULL,                       -- Sacrifices by opposing batters
    SF INT DEFAULT NULL,                       -- Sacrifice flies by opposing batters
    GIDP INT DEFAULT NULL                     -- Grounded into double plays by opposing batter
);

CREATE TABLE Fielding (
    playerID VARCHAR(50) DEFAULT NULL,        -- Player ID code
    yearID INT DEFAULT NULL,                  -- Year
    stint INT DEFAULT NULL,                   -- Player's stint (order of appearances within a season)
    teamID VARCHAR(50) DEFAULT NULL,          -- Team
    lgID VARCHAR(50) DEFAULT NULL,            -- League
    Pos VARCHAR(5) DEFAULT NULL,              -- Position
    G INT DEFAULT NULL,                       -- Games
    GS INT DEFAULT NULL,                      -- Games Started
    InnOuts INT DEFAULT NULL,                 -- Time played in the field expressed as outs
    PO INT DEFAULT NULL,                      -- Putouts
    A INT DEFAULT NULL,                       -- Assists
    E INT DEFAULT NULL,                       -- Errors
    DP INT DEFAULT NULL,                      -- Double Plays
    PB INT DEFAULT NULL,                      -- Passed Balls (by catchers)
    WP INT DEFAULT NULL,                      -- Wild Pitches (by catchers)
    SB INT DEFAULT NULL,                      -- Opponent Stolen Bases (by catchers)
    CS INT DEFAULT NULL,                      -- Opponents Caught Stealing (by catchers)
    ZR DECIMAL(5,2) DEFAULT NULL             -- Zone Rating
);

CREATE TABLE FieldingOf (
    playerID VARCHAR(50) DEFAULT NULL,        -- Player ID code
    yearID INT DEFAULT NULL,                  -- Year
    stint INT DEFAULT NULL,                   -- Player's stint (order of appearances within a season)
    Glf INT DEFAULT NULL,                     -- Games played in left field
    Gcf INT DEFAULT NULL,                     -- Games played in center field
    Grf INT DEFAULT NULL                     -- Games played in right field
);

CREATE TABLE FieldingOfSplit (
    playerID VARCHAR(50) DEFAULT NULL,        -- Player ID code
    yearID INT DEFAULT NULL,                  -- Year
    stint INT DEFAULT NULL,                   -- Player's stint (order of appearances within a season)
    teamID VARCHAR(50) DEFAULT NULL,          -- Team
    lgID VARCHAR(10) DEFAULT NULL,            -- League
    Pos VARCHAR(5) DEFAULT NULL,              -- Position
    G INT DEFAULT NULL,                       -- Games
    GS INT DEFAULT NULL,                      -- Games Started
    InnOuts INT DEFAULT NULL,                 -- Time played in the field expressed as outs
    PO INT DEFAULT NULL,                      -- Putouts
    A INT DEFAULT NULL,                       -- Assists
    E INT DEFAULT NULL,                       -- Errors
    DP INT DEFAULT NULL                      -- Double Plays
);

CREATE TABLE Appearances (
    yearID INT DEFAULT NULL,                  -- Year
    teamID VARCHAR(50) DEFAULT NULL,          -- Team
    lgID VARCHAR(10) DEFAULT NULL,            -- League
    playerID VARCHAR(50) DEFAULT NULL,        -- Player ID code
    G_all INT DEFAULT NULL,                   -- Total games played
    GS INT DEFAULT NULL,                      -- Games started
    G_batting INT DEFAULT NULL,               -- Games in which player batted
    G_defense INT DEFAULT NULL,               -- Games in which player appeared on defense
    G_p INT DEFAULT NULL,                     -- Games as pitcher
    G_c INT DEFAULT NULL,                     -- Games as catcher
    G_1b INT DEFAULT NULL,                    -- Games as first baseman
    G_2b INT DEFAULT NULL,                    -- Games as second baseman
    G_3b INT DEFAULT NULL,                    -- Games as third baseman
    G_ss INT DEFAULT NULL,                    -- Games as shortstop
    G_lf INT DEFAULT NULL,                    -- Games as left fielder
    G_cf INT DEFAULT NULL,                    -- Games as center fielder
    G_rf INT DEFAULT NULL,                    -- Games as right fielder
    G_of INT DEFAULT NULL,                    -- Games as outfielder
    G_dh INT DEFAULT NULL,                    -- Games as designated hitter
    G_ph INT DEFAULT NULL,                    -- Games as pinch hitter
    G_pr INT DEFAULT NULL                    -- Games as pinch runner
);

CREATE TABLE Managers (
    playerID VARCHAR(50) DEFAULT NULL,        -- Player ID Number
    yearID INT DEFAULT NULL,                  -- Year
    teamID VARCHAR(50) DEFAULT NULL,          -- Team
    lgID VARCHAR(10) DEFAULT NULL,            -- League
    inseason INT DEFAULT NULL,                -- Managerial order (One if managed the team entire year)
    G INT DEFAULT NULL,                       -- Games managed
    W INT DEFAULT NULL,                       -- Wins
    L INT DEFAULT NULL,                       -- Losses
    `rank` INT DEFAULT NULL,                             -- Team's final position in standings
    plyrMgr CHAR(1) DEFAULT NULL                      -- Player Manager (denoted by 'Y')
);

CREATE TABLE AllStarFull (
    playerID VARCHAR(50) DEFAULT NULL,              -- Player ID code
    yearID INT DEFAULT NULL,                        -- Year
    gameNum INT DEFAULT NULL,                       -- Game number (zero if only one All-Star game played that season)
    gameID VARCHAR(50) DEFAULT NULL,                -- Retrosheet ID for the game
    teamID VARCHAR(50) DEFAULT NULL,                -- Team
    lgID VARCHAR(10) DEFAULT NULL,                  -- League
    GP INT DEFAULT NULL,                            -- 1 if Played in the game
    startingPos VARCHAR(50) DEFAULT NULL                    -- Position played if player was a starter
);

CREATE TABLE BattingPost (
    yearID INT DEFAULT NULL,                         -- Year
    round VARCHAR(50) DEFAULT NULL,                  -- Level of playoffs
    playerID VARCHAR(50) DEFAULT NULL,               -- Player ID code
    teamID VARCHAR(50) DEFAULT NULL,                 -- Team
    lgID VARCHAR(10) DEFAULT NULL,                   -- League
    G INT DEFAULT NULL,                              -- Games
    AB INT DEFAULT NULL,                             -- At Bats
    R INT DEFAULT NULL,                              -- Runs
    H INT DEFAULT NULL,                              -- Hits
    `2B` INT DEFAULT NULL,                           -- Doubles
    `3B` INT DEFAULT NULL,                           -- Triples
    HR INT DEFAULT NULL,                             -- Homeruns
    RBI INT DEFAULT NULL,                            -- Runs Batted In
    SB INT DEFAULT NULL,                             -- Stolen Bases
    CS INT DEFAULT NULL,                             -- Caught stealing
    BB INT DEFAULT NULL,                             -- Base on Balls
    SO INT DEFAULT NULL,                             -- Strikeouts
    IBB INT DEFAULT NULL,                            -- Intentional walks
    HBP INT DEFAULT NULL,                            -- Hit by pitch
    SH INT DEFAULT NULL,                             -- Sacrifices
    SF INT DEFAULT NULL,                             -- Sacrifice flies
    GIDP INT DEFAULT NULL                           -- Grounded into double plays
);

CREATE TABLE PitchingPost (
    playerID VARCHAR(50) DEFAULT NULL,             -- Player ID code
    yearID INT DEFAULT NULL,                      -- Year
    round VARCHAR(50) DEFAULT NULL,               -- Level of playoffs
    teamID VARCHAR(50) DEFAULT NULL,              -- Team
    lgID VARCHAR(10) DEFAULT NULL,                -- League
    W INT DEFAULT NULL,                           -- Wins
    L INT DEFAULT NULL,                           -- Losses
    G INT DEFAULT NULL,                           -- Games
    GS INT DEFAULT NULL,                          -- Games Started
    CG INT DEFAULT NULL,                          -- Complete Games
    SHO INT DEFAULT NULL,                         -- Shutouts
    SV INT DEFAULT NULL,                          -- Saves
    IPOuts INT DEFAULT NULL,                      -- Outs Pitched (innings pitched x 3)
    H INT DEFAULT NULL,                           -- Hits
    ER INT DEFAULT NULL,                          -- Earned Runs
    HR INT DEFAULT NULL,                          -- Homeruns
    BB INT DEFAULT NULL,                          -- Walks
    SO INT DEFAULT NULL,                          -- Strikeouts
    BAOpp FLOAT DEFAULT NULL,                     -- Opponents' batting average
    ERA FLOAT DEFAULT NULL,                       -- Earned Run Average
    IBB INT DEFAULT NULL,                         -- Intentional Walks
    WP INT DEFAULT NULL,                          -- Wild Pitches
    HBP INT DEFAULT NULL,                         -- Batters Hit By Pitch
    BK INT DEFAULT NULL,                          -- Balks
    BFP INT DEFAULT NULL,                         -- Batters faced by Pitcher
    GF INT DEFAULT NULL,                          -- Games Finished
    R INT DEFAULT NULL,                           -- Runs Allowed
    SH INT DEFAULT NULL,                          -- Sacrifice Hits allowed
    SF INT DEFAULT NULL,                          -- Sacrifice Flies allowed
    GIDP INT DEFAULT NULL                        -- Grounded into Double Plays
);

CREATE TABLE FieldingPost (
    playerID VARCHAR(50) DEFAULT NULL,           -- Player ID code
    yearID INT DEFAULT NULL,                     -- Year
    teamID VARCHAR(50) DEFAULT NULL,             -- Team
    lgID VARCHAR(10) DEFAULT NULL,               -- League
    round VARCHAR(50) DEFAULT NULL,              -- Level of playoffs
    Pos VARCHAR(10) DEFAULT NULL,                -- Position
    G INT DEFAULT NULL,                          -- Games
    GS INT DEFAULT NULL,                         -- Games Started
    InnOuts INT DEFAULT NULL,                    -- Time played in the field expressed as outs
    PO INT DEFAULT NULL,                         -- Putouts
    A INT DEFAULT NULL,                          -- Assists
    E INT DEFAULT NULL,                          -- Errors
    DP INT DEFAULT NULL,                         -- Double Plays
    TP INT DEFAULT NULL,                         -- Triple Plays
    PB INT DEFAULT NULL,                         -- Passed Balls
    SB INT DEFAULT NULL,                         -- Stolen Bases allowed (by catcher)
    CS INT DEFAULT NULL                         -- Caught Stealing (by catcher)
);

CREATE TABLE SeriesPost (
    yearID INT DEFAULT NULL,                     -- Year
    round VARCHAR(50) DEFAULT NULL,              -- Level of playoffs
    teamIDwinner VARCHAR(50) DEFAULT NULL,       -- Team ID of the team that won the series
    lgIDwinner VARCHAR(10) DEFAULT NULL,         -- League ID of the team that won the series
    teamIDloser VARCHAR(50) DEFAULT NULL,        -- Team ID of the team that lost the series
    lgIDloser VARCHAR(10) DEFAULT NULL,          -- League ID of the team that lost the series
    wins INT DEFAULT NULL,                       -- Wins by team that won the series
    losses INT DEFAULT NULL,                     -- Losses by team that won the series
    ties INT DEFAULT NULL                       -- Tie games
);

CREATE TABLE HomeGames (
    yearkey INT DEFAULT NULL,                    -- Year
    leaguekey VARCHAR(10) DEFAULT NULL,          -- League
    teamkey VARCHAR(50) DEFAULT NULL,            -- Team ID
    parkkey VARCHAR(50) DEFAULT NULL,            -- Ballpark ID
    spanfirst DATE DEFAULT NULL,                 -- Date of first game played
    spanlast DATE DEFAULT NULL,                  -- Date of last game played
    games INT DEFAULT NULL,                      -- Total number of games
    openings INT DEFAULT NULL,                   -- Total number of paid dates played
    attendance INT DEFAULT NULL                 -- Total attendance
);

CREATE TABLE ManagersHalf (
    playerID VARCHAR(50) DEFAULT NULL,           -- Manager ID code
    yearID INT DEFAULT NULL,                     -- Year
    teamID VARCHAR(50) DEFAULT NULL,             -- Team
    lgID VARCHAR(10) DEFAULT NULL,               -- League
    inseason INT DEFAULT NULL,                   -- Managerial order
    half VARCHAR(10) DEFAULT NULL,               -- First or second half of season
    G INT DEFAULT NULL,                          -- Games managed
    W INT DEFAULT NULL,                          -- Wins
    L INT DEFAULT NULL,                          -- Losses
    `rank` INT DEFAULT NULL                       -- Team's position in standings for the half
);

CREATE TABLE TeamsHalf (
    yearID INT DEFAULT NULL,                     -- Year
    lgID VARCHAR(10) DEFAULT NULL,               -- League
    teamID VARCHAR(50) DEFAULT NULL,             -- Team
    half VARCHAR(10) DEFAULT NULL,               -- First or second half of season
    divID VARCHAR(10) DEFAULT NULL,              -- Division
    DivWin CHAR(1) DEFAULT NULL,                 -- Won Division (Y or N)
    `rank` INT DEFAULT NULL,                       -- Team's position in standings for the half
    G INT DEFAULT NULL,                          -- Games played
    W INT DEFAULT NULL,                          -- Wins
    L INT DEFAULT NULL                          -- Losses
);

CREATE TABLE AwardsManagers (
    playerID VARCHAR(50) DEFAULT NULL,           -- Manager ID code
    awardID VARCHAR(100) DEFAULT NULL,           -- Name of award won
    yearID INT DEFAULT NULL,                     -- Year
    lgID VARCHAR(10) DEFAULT NULL,               -- League
    tie CHAR(1) DEFAULT NULL,                    -- Award was a tie (Y or N)
    notes TEXT DEFAULT NULL                              -- Notes about the award
);

CREATE TABLE AwardsPlayers (
    playerID VARCHAR(50) DEFAULT NULL,           -- Player ID code
    awardID VARCHAR(100) DEFAULT NULL,           -- Name of award won
    yearID INT DEFAULT NULL,                     -- Year
    lgID VARCHAR(10) DEFAULT NULL,               -- League
    tie CHAR(1) DEFAULT NULL,                    -- Award was a tie (Y or N)
    notes TEXT DEFAULT NULL                              -- Notes about the award
);

CREATE TABLE AwardsShareManagers (
    awardID VARCHAR(100) DEFAULT NULL,           -- Name of award votes were received for
    yearID INT DEFAULT NULL,                     -- Year
    lgID VARCHAR(10) DEFAULT NULL,               -- League
    playerID VARCHAR(50) DEFAULT NULL,           -- Manager ID code
    pointsWon INT DEFAULT NULL,                  -- Number of points received
    pointsMax INT DEFAULT NULL,                  -- Maximum number of points possible
    votesFirst INT DEFAULT NULL                 -- Number of first place votes
);

CREATE TABLE AwardsSharePlayers (
    awardID VARCHAR(100) DEFAULT NULL,           -- Name of award votes were received for
    yearID INT DEFAULT NULL,                     -- Year
    lgID VARCHAR(10) DEFAULT NULL,               -- League
    playerID VARCHAR(50) DEFAULT NULL,           -- Player ID code
    pointsWon INT DEFAULT NULL,                  -- Number of points received
    pointsMax INT DEFAULT NULL,                  -- Maximum number of points possible
    votesFirst INT DEFAULT NULL                 -- Number of first place votes
);

CREATE TABLE HallOfFame (
    playerID VARCHAR(50) DEFAULT NULL,          -- Player ID code
    yearID INT DEFAULT NULL,                    -- Year of ballot
    votedBy VARCHAR(100) DEFAULT NULL,          -- Method by which player was voted upon
    ballots INT DEFAULT NULL,                   -- Total ballots cast in that year
    needed INT DEFAULT NULL,                    -- Number of votes needed for selection in that year
    votes INT DEFAULT NULL,                     -- Total votes received
    inducted CHAR(1) DEFAULT NULL,              -- Whether player was inducted by that vote or not (Y or N)
    category VARCHAR(100) DEFAULT NULL,                  -- Category in which candidate was honored
    needed_note TEXT DEFAULT NULL                       -- Explanation of qualifiers for special elections
);

CREATE TABLE CollegePlaying (
    playerID VARCHAR(50) DEFAULT NULL,          -- Player ID code
    schoolID VARCHAR(50) DEFAULT NULL,          -- School ID code
    yearID INT DEFAULT NULL                     -- Year
);

CREATE TABLE Salaries (
    yearID INT DEFAULT NULL,                    -- Year
    teamID VARCHAR(50) DEFAULT NULL,            -- Team
    lgID VARCHAR(10) DEFAULT NULL,              -- League
    playerID VARCHAR(50) DEFAULT NULL,          -- Player ID code
    salary DECIMAL(15, 2) DEFAULT NULL         -- Salary
);

CREATE TABLE Schools (
    schoolID VARCHAR(50) DEFAULT NULL,                  -- School ID code
    schoolName VARCHAR(255) DEFAULT NULL,       -- School name
    schoolCity VARCHAR(255) DEFAULT NULL,       -- City where school is located
    schoolState VARCHAR(255) DEFAULT NULL,      -- State where school's city is located
    schoolNick VARCHAR(255) DEFAULT NULL       -- Nickname for school's baseball team
);

SHOW TABLES;

#
# Insert

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/People.csv' INTO TABLE People
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@dummy,playerID,birthYear,birthMonth,birthDay,birthCity,birthCountry,birthState,deathYear,deathMonth,deathDay,deathCountry,deathState,deathCity,nameFirst,nameLast,nameGiven,weight,height,bats,throws,debut,bbrefID,finalGame,retroID);


LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/Teams.csv' INTO TABLE Teams
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(yearID,lgID,teamID,franchID,divID,`rank`,G,Ghome,W,L,DivWin,WCWin,LgWin,WSWin,R,AB,H,2B,3B,HR,BB,SO,SB,CS,HBP,SF,RA,ER,ERA,CG,SHO,SV,IPouts,HA,HRA,BBA,SOA,E,DP,FP,name,park,attendance,BPF,PPF,teamIDBR,teamIDlahman45,teamIDretro);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/TeamsFranchises.csv' INTO TABLE TeamsFranchises
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(franchID,franchName,active,NAassoc);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/Parks.csv' INTO TABLE Parks
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@dummy,parkalias,parkkey,parkname,city,state,country);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/Batting.csv' INTO TABLE Batting
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,yearID,stint,teamID,lgID,G,@dummy,AB,R,H,2B,3B,HR,RBI,SB,CS,BB,SO,IBB,HBP,SH,SF,GIDP,@dummy);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/Pitching.csv' INTO TABLE Pitching
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,yearID,stint,teamID,lgID,W,L,G,GS,CG,SHO,SV,IPouts,H,ER,HR,BB,SO,BAOpp,ERA,IBB,WP,HBP,BK,BFP,GF,R,SH,SF,GIDP);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/Fielding.csv' INTO TABLE Fielding
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,yearID,stint,teamID,lgID,POS,G,GS,InnOuts,PO,A,E,DP,PB,WP,SB,CS,ZR);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/FieldingOF.csv' INTO TABLE FieldingOf
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,yearID,stint,Glf,Gcf,Grf);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/FieldingOFsplit.csv' INTO TABLE FieldingOfSplit
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,yearID,stint,teamID,lgID,POS,G,GS,InnOuts,PO,A,E,DP,@dummy,@dummy,@dummy,@dummy,@dummy);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/Appearances.csv' INTO TABLE Appearances
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(yearID,teamID,lgID,playerID,G_all,GS,G_batting,G_defense,G_p,G_c,G_1b,G_2b,G_3b,G_ss,G_lf,G_cf,G_rf,G_of,G_dh,G_ph,G_pr);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/Managers.csv' INTO TABLE Managers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,yearID,teamID,lgID,inseason,G,W,L,`rank`,plyrMgr);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/AllstarFull.csv' INTO TABLE AllStarFull
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,yearID,gameNum,gameID,teamID,lgID,GP,startingPos);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/BattingPost.csv' INTO TABLE BattingPost
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(yearID,round,playerID,teamID,lgID,G,AB,R,H,2B,3B,HR,RBI,SB,CS,BB,SO,IBB,HBP,SH,SF,GIDP);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/PitchingPost.csv' INTO TABLE PitchingPost
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,yearID,round,teamID,lgID,W,L,G,GS,CG,SHO,SV,IPouts,H,ER,HR,BB,SO,BAOpp,ERA,IBB,WP,HBP,BK,BFP,GF,R,SH,SF,GIDP);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/FieldingPost.csv' INTO TABLE FieldingPost
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,yearID,teamID,lgID,round,POS,G,GS,InnOuts,PO,A,E,DP,TP,PB,SB,CS);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/SeriesPost.csv' INTO TABLE SeriesPost
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(yearID,round,teamIDwinner,lgIDwinner,teamIDloser,lgIDloser,wins,losses,ties);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/HomeGames.csv' INTO TABLE HomeGames
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(yearkey,leaguekey,teamkey,parkkey,spanfirst,spanlast,games,openings,attendance);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/ManagersHalf.csv' INTO TABLE ManagersHalf
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,yearID,teamID,lgID,inseason,half,G,W,L,`rank`);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/TeamsHalf.csv' INTO TABLE TeamsHalf
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(yearID,lgID,teamID,Half,divID,DivWin,`rank`,G,W,L);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/AwardsManagers.csv' INTO TABLE AwardsManagers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,awardID,yearID,lgID,tie,notes);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/AwardsPlayers.csv' INTO TABLE AwardsPlayers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,awardID,yearID,lgID,tie,notes);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/AwardsShareManagers.csv' INTO TABLE AwardsShareManagers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(awardID,yearID,lgID,playerID,pointsWon,pointsMax,votesFirst);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/AwardsSharePlayers.csv' INTO TABLE AwardsSharePlayers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(awardID,yearID,lgID,playerID,pointsWon,pointsMax,votesFirst);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/HallOfFame.csv' INTO TABLE HallOfFame
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,yearid,votedBy,ballots,needed,votes,inducted,category,needed_note);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/CollegePlaying.csv' INTO TABLE CollegePlaying
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(playerID,schoolID,yearID);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/Salaries.csv' INTO TABLE Salaries
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(yearID,teamID,lgID,playerID,salary);

LOAD DATA LOCAL INFILE 'lahman_1871-2023_csv/lahman_1871-2023_csv/Schools.csv' INTO TABLE Schools
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(schoolID,schoolName,schoolCity,schoolState,schoolNick);
