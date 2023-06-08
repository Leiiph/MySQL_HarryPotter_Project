-- PART 1: INDEX
-- Count number of students in Gryffindor (with profile)
SELECT @@profiling;
SET profiling=1;
SELECT COUNT(student_id) FROM studentN WHERE house_id = 1;
SHOW PROFILES;

-- Add index on house_id
CREATE INDEX index_hi ON studentN(house_id);

-- Count again the nb of students in Gryffindor with profile & index
SELECT @@profiling;
SET profiling=1;
SELECT COUNT(student_name) FROM studentN WHERE house_id = 1;
SHOW PROFILES;

-- PART 2: VIEW 
-- Creation of the view
CREATE VIEW potion_stud AS
SELECT a.student_name, a.email, a.house_id FROM studentN a
JOIN link b ON a.student_id = b.student_id
JOIN courseN c ON b.course_id = c.course_id
WHERE c.registered_course = 'Potion';

-- Test of the vew
SELECT * FROM potion_stud;

INSERT INTO studentN(student_name, email, year, house_id) VALUE ("Michaela Blankenheim", "michaela.blankenheim@gmail.com", 2, 4);
INSERT INTO link(student_id, course_id) VALUE (34, 2);
INSERT INTO studentN(student_name, email, year, house_id) VALUE ("Runic Tunic", "runic.tunic@gmail.com", 1, 1);
INSERT INTO link(student_id, course_id) VALUE (35, 2);

SELECT * FROM potion_stud;

-- house_student_count view
CREATE VIEW house_student_count AS
SELECT houseN.house AS house_name, COUNT(studentn.student_id) AS student_count
FROM studentn
INNER JOIN houseN ON studentn.house_id = housen.house_id
GROUP BY houseN.house;

SELECT * FROM house_student_count;

UPDATE VIEW set student_count = 10 WHERE house_name = "Gryffondor";


-- PART 3: STORED PROCEDURE & TRIGGER
-- The table for the pseudo view

CREATE TABLE IF NOT EXISTS house_student_count_materialized(
	house_name VARCHAR(50) PRIMARY KEY,
    student_count INT
);

-- The procedure
delimiter //
CREATE PROCEDURE refresh_house_student_count_materialized()
BEGIN
	TRUNCATE TABLE house_student_count_materialized;
    
    INSERT INTO house_student_count_materialized(house_name, student_count)
	SELECT houseN.house AS house_name, COUNT(studentn.student_id) AS student_count
	FROM studentn
	INNER JOIN houseN ON studentn.house_id = housen.house_id
	GROUP BY houseN.house;
END //
delimiter ;

-- Call the procedure to inizialise it & check if it's working correctly

CALL refresh_house_student_count_materialized();
SELECT * FROM house_student_count_materialized;

-- Update of the procedure
INSERT INTO studentn (student_name, email, year, house_id)  VALUES ("Iris Python", 'iris.python@gmail.com', 3, 2);
SELECT * FROM house_student_count_materialized;
CALL refresh_house_student_count_materialized();
SELECT * FROM house_student_count_materialized;

-- Trigger on the materialized view

delimiter //
CREATE TRIGGER update_auto AFTER INSERT ON studentn
FOR EACH ROW
BEGIN
	DELETE FROM house_student_count_materialized WHERE house_name != "anti-safe-mode";
    INSERT INTO house_student_count_materialized(house_name, student_count)
    SELECT houseN.house AS house_name, COUNT(studentn.student_id) AS student_count
    FROM studentn
    INNER JOIN houseN ON studentn.house_id = housen.house_id
    GROUP BY houseN.house;
END //
delimiter ;

delimiter //
CREATE TRIGGER delete_auto AFTER DELETE ON studentn
FOR EACH ROW
BEGIN
	DELETE FROM house_student_count_materialized WHERE house_name != "anti-safe-mode";    
    INSERT INTO house_student_count_materialized(house_name, student_count)
	SELECT houseN.house AS house_name, COUNT(studentn.student_id) AS student_count
	FROM studentn
	INNER JOIN houseN ON studentn.house_id = housen.house_id
	GROUP BY houseN.house;
END //
delimiter ;


-- Final part: Testing the triggers
-- We display our materialized view to check the number in each house
SELECT * FROM house_student_count_materialized;
-- We add a new student in the studentn table 
INSERT INTO studentn(student_name, email, year, house_id) VALUES ("Leif Laez", 'leif.laez@gmail.com', 5, 4);
-- We display again our materialized view to see if it was updated
SELECT * FROM house_student_count_materialized;
-- We display our studentn table to get the ID of the newly added student
SELECT * FROM studentn;
-- We delete the newly added student
DELETE FROM studentn WHERE student_id = 57;
-- We check that the materialized view was correctly updated
SELECT * FROM house_student_count_materialized;