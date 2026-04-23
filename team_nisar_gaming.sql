-- ============================================================
--  Game Player Performance & Training Database
--  Team: team_nisar
--  Department: Multimedia and Gaming (MMG)
--  Instructor: Engr. Arifa
--  Date: April 2026
-- ============================================================

-- ────────────────────────────────────────────────────────────
--  STEP 1 — Create & Select Database
-- ────────────────────────────────────────────────────────────

CREATE DATABASE IF NOT EXISTS team_nisar_gaming;
USE team_nisar_gaming;

-- ────────────────────────────────────────────────────────────
--  STEP 2 — Create Tables (DDL)
-- ────────────────────────────────────────────────────────────

-- Table 1: players
CREATE TABLE players (
    player_id    INT PRIMARY KEY AUTO_INCREMENT,
    player_name  VARCHAR(100) NOT NULL,
    email        VARCHAR(100) UNIQUE,
    skill_level  VARCHAR(20),
    join_date    DATE
);

-- Table 2: game_levels
CREATE TABLE game_levels (
    level_id    INT PRIMARY KEY AUTO_INCREMENT,
    level_name  VARCHAR(100) NOT NULL,
    difficulty  INT CHECK (difficulty BETWEEN 1 AND 5),
    max_score   INT,
    topic       VARCHAR(100)
);

-- Table 3: player_scores
CREATE TABLE player_scores (
    score_id     INT PRIMARY KEY AUTO_INCREMENT,
    player_id    INT,
    level_id     INT,
    score        INT,
    played_date  DATE,
    FOREIGN KEY (player_id) REFERENCES players(player_id)    ON DELETE CASCADE,
    FOREIGN KEY (level_id)  REFERENCES game_levels(level_id) ON DELETE CASCADE
);

-- Table 4: training_missions
CREATE TABLE training_missions (
    mission_id    INT PRIMARY KEY AUTO_INCREMENT,
    mission_name  VARCHAR(100) NOT NULL,
    level_id      INT,
    duration      INT,
    status        VARCHAR(20) DEFAULT 'pending',
    player_id     INT,
    FOREIGN KEY (level_id)  REFERENCES game_levels(level_id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES players(player_id)    ON DELETE CASCADE
);

-- ────────────────────────────────────────────────────────────
--  STEP 3 — ALTER TABLE (DDL)
-- ────────────────────────────────────────────────────────────

ALTER TABLE players ADD COLUMN phone VARCHAR(20);
ALTER TABLE players MODIFY COLUMN skill_level VARCHAR(50);
ALTER TABLE training_missions ADD COLUMN notes TEXT;

-- ────────────────────────────────────────────────────────────
--  STEP 4 — Insert Sample Data (DML)
-- ────────────────────────────────────────────────────────────

-- Players
INSERT INTO players (player_id, player_name, email, skill_level, join_date) VALUES
(1, 'Nisar Ahmed',     'nisar@game.com',    'Beginner',     '2024-01-10'),
(2, 'Saira Memon',     'saira@game.com',    'Intermediate', '2024-01-12'),
(3, 'Abdullah Rajput', 'abdullah@game.com', 'Beginner',     '2024-01-15'),
(4, 'Ali Hassan',      'ali@game.com',      'Advanced',     '2024-02-01'),
(5, 'Zara Khan',       'zara@game.com',     'Intermediate', '2024-02-10');

-- Game Levels
INSERT INTO game_levels (level_id, level_name, difficulty, max_score, topic) VALUES
(1, 'Basic Shooting', 1, 100, 'Aim Training'),
(2, 'Map Navigation', 2, 100, 'Spatial Awareness'),
(3, 'Team Strategy',  3, 100, 'Coordination'),
(4, 'Boss Battle',    4, 100, 'Combat Skills'),
(5, 'Speed Run',      5, 100, 'Reflexes');

-- Player Scores
INSERT INTO player_scores (score_id, player_id, level_id, score, played_date) VALUES
(1,  1, 1, 80, '2024-03-01'),
(2,  1, 2, 40, '2024-03-02'),
(3,  1, 3, 30, '2024-03-03'),
(4,  2, 1, 90, '2024-03-01'),
(5,  2, 2, 75, '2024-03-02'),
(6,  3, 1, 45, '2024-03-01'),
(7,  3, 3, 20, '2024-03-03'),
(8,  4, 4, 95, '2024-03-04'),
(9,  5, 2, 50, '2024-03-02'),
(10, 5, 5, 35, '2024-03-05');

-- Training Missions
INSERT INTO training_missions (mission_id, mission_name, level_id, duration, status, player_id) VALUES
(1, 'Aim Practice Drill',   1, 30, 'pending',     3),
(2, 'Map Reading Exercise', 2, 45, 'in_progress', 1),
(3, 'Strategy Workshop',    3, 60, 'pending',     1),
(4, 'Combat Basics',        4, 40, 'pending',     3),
(5, 'Reflex Training',      5, 35, 'pending',     5);

-- ────────────────────────────────────────────────────────────
--  STEP 5 — UPDATE & DELETE (DML)
-- ────────────────────────────────────────────────────────────

-- Update skill level
UPDATE players SET skill_level = 'Intermediate' WHERE player_id = 1;

-- Mark mission as done
UPDATE training_missions SET status = 'done' WHERE mission_id = 2;

-- Correct a score
UPDATE player_scores SET score = 55 WHERE score_id = 6;

-- Delete a player
DELETE FROM players WHERE player_id = 4;

-- Delete low scores
DELETE FROM player_scores WHERE score < 20;

-- ────────────────────────────────────────────────────────────
--  STEP 6 — SELECT Queries (DQL)
-- ────────────────────────────────────────────────────────────

-- Query 1: All players
SELECT * FROM players;

-- Query 2: Specific columns
SELECT player_name, skill_level FROM players;

-- Query 3: WHERE condition
SELECT * FROM players WHERE skill_level = 'Beginner';

-- Query 4: ORDER BY score descending
SELECT * FROM player_scores ORDER BY score DESC;

-- Query 5: LIMIT top 3 scores
SELECT * FROM player_scores ORDER BY score DESC LIMIT 3;

-- Query 6: LIKE pattern matching
SELECT * FROM players WHERE player_name LIKE 'N%';

-- Query 7: Aggregate functions
SELECT COUNT(*) AS total_players FROM players;
SELECT AVG(score) AS avg_score   FROM player_scores;
SELECT MAX(score) AS highest     FROM player_scores;
SELECT MIN(score) AS lowest      FROM player_scores;

-- Query 8: GROUP BY — average score per level
SELECT gl.level_name, AVG(ps.score) AS avg_score
FROM player_scores ps
JOIN game_levels gl ON ps.level_id = gl.level_id
GROUP BY gl.level_name;

-- Query 9: HAVING — levels where average score is above 60
SELECT gl.level_name, AVG(ps.score) AS avg_score
FROM player_scores ps
JOIN game_levels gl ON ps.level_id = gl.level_id
GROUP BY gl.level_name
HAVING avg_score > 60;

-- Query 10: INNER JOIN — weak players (score below 50)
SELECT p.player_name, gl.level_name, ps.score
FROM player_scores ps
JOIN players p      ON ps.player_id = p.player_id
JOIN game_levels gl ON ps.level_id  = gl.level_id
WHERE ps.score < 50
ORDER BY ps.score ASC;

-- Query 11: LEFT JOIN — all players with their missions
SELECT p.player_name, tm.mission_name, tm.status
FROM players p
LEFT JOIN training_missions tm ON p.player_id = tm.player_id;

-- Query 12: Subquery — players who scored below average
SELECT player_name FROM players
WHERE player_id IN (
    SELECT player_id FROM player_scores
    WHERE score < (SELECT AVG(score) FROM player_scores)
);

-- ────────────────────────────────────────────────────────────
--  STEP 7 — DESCRIBE Tables
-- ────────────────────────────────────────────────────────────

DESCRIBE players;
DESCRIBE game_levels;
DESCRIBE player_scores;
DESCRIBE training_missions;

-- ────────────────────────────────────────────────────────────
--  END OF FILE
-- ────────────────────────────────────────────────────────────
