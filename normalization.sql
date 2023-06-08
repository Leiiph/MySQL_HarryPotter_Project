-- Creation of the tables for the normalization following the design pattern
CREATE TABLE IF NOT EXISTS studentN AS SELECT DISTINCT student_name, email, year FROM project ORDER BY year ASC;
ALTER TABLE studentn ADD COLUMN student_id INT AUTO_INCREMENT PRIMARY KEY FIRST;

CREATE TABLE IF NOT EXISTS houseN AS SELECT DISTINCT house FROM project ORDER BY house ASC;
ALTER TABLE housen ADD COLUMN house_id INT AUTO_INCREMENT PRIMARY KEY FIRST;

CREATE TABLE IF NOT EXISTS courseN AS SELECT DISTINCT registered_course FROM project ORDER BY registered_course ASC;
ALTER TABLE coursen ADD COLUMN course_id INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- We use this table to link coursen and studentn
CREATE TABLE IF NOT EXISTS link(
	student_id INT NOT NULL,
    course_id INT NOT NULL,
    FOREIGN KEY(student_id) REFERENCES studentn(student_id),
    FOREIGN KEY (course_id) REFERENCES coursen(course_id)
);

-- Check that all the tables have been successfully created
SELECT * FROM studentn, housen;
ALTER TABLE studentn ADD COLUMN house_id INT;
ALTER TABLE link ADD COLUMN link_id INT AUTO_INCREMENT PRIMARY KEY FIRST;
ALTER TABLE housen ADD COLUMN prefet VARCHAR(50);
UPDATE housen studentN set prefet = 'Help' WHERE house = 'Serdaigle' AND house_id!=-1;
	
-- Add the foreign keys
ALTER TABLE studentn ADD CONSTRAINT house_id FOREIGN KEY (house_id) REFERENCES houseN (house_id);

-- Filling the newly created foreign keys columns and columns
INSERT INTO link(student_id, course_id) SELECT DISTINCT b.student_id, c.course_id FROM project a 
JOIN studentN b ON a.student_name=b.student_name 
JOIN courseN c ON a.registered_course=c.registered_course;

UPDATE studentN
INNER JOIN project ON studentN.student_name=project.student_name INNER JOIN houseN ON houseN.house=project.house
set studentN.house_id = houseN.house_id
WHERE studentN.student_id != -1;
