CREATE DATABASE nigeria_conflict_database;
USE nigeria_conflict_database;

CREATE TABLE nigeria_conflict_events (
    id VARCHAR(50) NOT NULL PRIMARY KEY,
    relid VARCHAR(100),
    year SMALLINT,
    date_start DATE,
    date_end DATE,
    violence_type_code TINYINT,
    conflict_name VARCHAR(255),
    side_a VARCHAR(255),
    side_b VARCHAR(255),
    admin_level_1 VARCHAR(150),
    admin_level_2 VARCHAR(150),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    country VARCHAR(100),
    deaths_a INT,
    deaths_b INT,
    deaths_civilians INT,
    deaths_unknown INT,
    best_fatality_estimate INT,
    high_fatality_estimate INT,
    low_fatality_estimate INT
);

INSERT INTO nigeria_conflict_database.nigeria_conflict_events
SELECT *
FROM nigeria_conflict_database.nigeria_conflict_data_main;
SELECT *
FROM nigeria_conflict_events;
SHOW COLUMNS FROM nigeria_conflict_database.nigeria_conflict_events;
SELECT DISTINCT violence_type_code
FROM nigeria_conflict_database.nigeria_conflict_events
ORDER BY violence_type_code;

CREATE TABLE violence_types (
    violence_type_code TINYINT PRIMARY KEY,
    violence_type_name VARCHAR(50) NOT NULL
);

INSERT INTO nigeria_conflict_database.violence_types
    (violence_type_code, violence_type_name)
VALUES
    (1, 'State-based conflict'),
    (3, 'One-sided violence');
    
ALTER TABLE nigeria_conflict_events
ADD CONSTRAINT fk_events_violence_type
FOREIGN KEY (violence_type_code)
REFERENCES violence_types (violence_type_code);

CREATE TABLE conflicts (
    conflict_id INT AUTO_INCREMENT PRIMARY KEY,
    conflict_name VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO conflicts (conflict_name)
SELECT DISTINCT conflict_name
FROM nigeria_conflict_events
WHERE conflict_name IS NOT NULL;

ALTER TABLE nigeria_conflict_events
ADD COLUMN conflict_id INT NULL;

UPDATE nigeria_conflict_events AS e
JOIN conflicts AS c
    ON e.conflict_name = c.conflict_name
SET e.conflict_id = c.conflict_id
WHERE e.id IS NOT NULL;

ALTER TABLE nigeria_conflict_events
ADD CONSTRAINT fk_events_conflict
FOREIGN KEY (conflict_id)
REFERENCES conflicts (conflict_id);

CREATE TABLE participants (
    participant_id INT AUTO_INCREMENT PRIMARY KEY,
    participant_name VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO participants (participant_name)
SELECT side_a
FROM nigeria_conflict_events
WHERE side_a IS NOT NULL

UNION

SELECT side_b
FROM nigeria_conflict_events
WHERE side_b IS NOT NULL;

ALTER TABLE nigeria_conflict_events
    ADD COLUMN side_a_participant_id INT NULL,
    ADD COLUMN side_b_participant_id INT NULL;
   
   UPDATE nigeria_conflict_events AS e
LEFT JOIN participants AS pa
    ON e.side_a = pa.participant_name
LEFT JOIN participants AS pb
    ON e.side_b = pb.participant_name
SET
    e.side_a_participant_id = pa.participant_id,
    e.side_b_participant_id = pb.participant_id
WHERE e.id IS NOT NULL;

ALTER TABLE nigeria_conflict_events
    ADD CONSTRAINT fk_events_side_a_participant
        FOREIGN KEY (side_a_participant_id)
        REFERENCES participants (participant_id),
    ADD CONSTRAINT fk_events_side_b_participant
        FOREIGN KEY (side_b_participant_id)
        REFERENCES participants (participant_id);
        
CREATE TABLE locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(100),
    admin_level_1 VARCHAR(150),
    admin_level_2 VARCHAR(150)
);

INSERT INTO locations (country, admin_level_1, admin_level_2)
SELECT DISTINCT country, admin_level_1, admin_level_2
FROM nigeria_conflict_events;
ALTER TABLE nigeria_conflict_events
ADD COLUMN location_id INT NULL;

UPDATE nigeria_conflict_events AS e
JOIN locations AS l
    ON e.country <=> l.country
    AND e.admin_level_1 <=> l.admin_level_1
    AND e.admin_level_2 <=> l.admin_level_2
SET e.location_id = l.location_id
WHERE e.id >= '';
SELECT COUNT(*) AS events_without_location_id
FROM nigeria_conflict_events
WHERE location_id IS NULL;
ALTER TABLE nigeria_conflict_events
ADD CONSTRAINT fk_events_location
FOREIGN KEY (location_id)
REFERENCES locations (location_id);

SELECT
    e.id,
    e.date_start,
    vt.violence_type_name,
    c.conflict_name,
    pa.participant_name AS side_a,
    pb.participant_name AS side_b,
    l.country,
    l.admin_level_1,
    l.admin_level_2,
    e.latitude,
    e.longitude
FROM nigeria_conflict_events AS e
LEFT JOIN violence_types AS vt
    ON e.violence_type_code = vt.violence_type_code
LEFT JOIN conflicts AS c
    ON e.conflict_id = c.conflict_id
LEFT JOIN participants AS pa
    ON e.side_a_participant_id = pa.participant_id
LEFT JOIN participants AS pb
    ON e.side_b_participant_id = pb.participant_id
LEFT JOIN locations AS l
    ON e.location_id = l.location_id
LIMIT 5;

ALTER TABLE nigeria_conflict_events
    DROP COLUMN conflict_name,
    DROP COLUMN side_a,
    DROP COLUMN side_b,
    DROP COLUMN country,
    DROP COLUMN admin_level_1,
    DROP COLUMN admin_level_2;
    
    SHOW COLUMNS FROM nigeria_conflict_events;
    
SELECT COUNT(*) AS rows_where_year_differs
FROM nigeria_conflict_events
WHERE year IS NOT NULL
  AND date_start IS NOT NULL
  AND year <> YEAR(date_start);

SELECT
    year,
    COUNT(*) AS event_count
FROM nigeria_conflict_events
GROUP BY year
ORDER BY year;

SELECT
    year,
    COUNT(*) AS event_count,
    COUNT(best_fatality_estimate) AS events_with_best_estimate,
    SUM(low_fatality_estimate) AS total_low_estimate,
    SUM(best_fatality_estimate) AS total_best_estimate,
    SUM(high_fatality_estimate) AS total_high_estimate
FROM nigeria_conflict_events
GROUP BY year
ORDER BY year;

SELECT
    vt.violence_type_name,
    COUNT(*) AS event_count,
    COUNT(e.best_fatality_estimate) AS events_with_best_estimate,
    SUM(e.low_fatality_estimate) AS total_low_estimate,
    SUM(e.best_fatality_estimate) AS total_best_estimate,
    SUM(e.high_fatality_estimate) AS total_high_estimate
FROM nigeria_conflict_events AS e
JOIN violence_types AS vt
    ON e.violence_type_code = vt.violence_type_code
GROUP BY vt.violence_type_code, vt.violence_type_name
ORDER BY vt.violence_type_code;

SELECT
    l.country,
    l.admin_level_1,
    l.admin_level_2,
    COUNT(*) AS event_count
FROM nigeria_conflict_events AS e
JOIN locations AS l
    ON e.location_id = l.location_id
GROUP BY
    l.location_id,
    l.country,
    l.admin_level_1,
    l.admin_level_2
ORDER BY event_count DESC
LIMIT 10;

SELECT
    l.country,
    l.admin_level_1,
    l.admin_level_2,
    COUNT(*) AS event_count,
    COUNT(e.best_fatality_estimate) AS events_with_best_estimate,
    SUM(e.best_fatality_estimate) AS total_best_estimate
FROM nigeria_conflict_events AS e
JOIN locations AS l
    ON e.location_id = l.location_id
GROUP BY
    l.location_id,
    l.country,
    l.admin_level_1,
    l.admin_level_2
ORDER BY total_best_estimate DESC
LIMIT 10;