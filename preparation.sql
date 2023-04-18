-- QA: Display all tables
SELECT * FROM project;

-- QB: Display the columns of the project table
SHOW COLUMNS FROM project;

-- QC: Display the number of students in the database
SELECT COUNT(student_name) FROM project;

-- QD: Display the different available course in the database (assuming we don't want repetition)
SELECT distinct registered_course FROM project;

-- QE: Display all different houses in the database
SELECT distinct house FROM project;

-- QF: Display all different prefects in the database
SELECT distinct prefet FROM project;

-- QG: Who is the prefet of each house?
SELECT distinct house, prefet FROM project;

-- QH: Count the number of students for each year
SELECT year, COUNT(student_name) FROM project GROUP BY year;

-- QI: Display the name and email of students taking the "potion" class
-- Note: We could have also selected registered_course to check that our query was right
SELECT student_name, email FROM project WHERE registered_course = "potion";

-- QJ: Displau all students who have a year higher than 2
-- Note: Here again we could have selected year to check if our query is right
SELECT student_name FROM project WHERE year>2;
-- OR (if we want all information)
SELECT * FROM project WHERE year>2;

-- QK: Sort the students by alphabetical order
SELECT * FROM project ORDER BY student_name ASC;

-- QL: Find the number of students of each house that are taking the potion class
SELECT house, COUNT(*) FROM project WHERE registered_course="potion" GROUP BY house;	

-- QM: Display the number of student for each house and the associated house
SELECT house, COUNT(*) FROM project GROUP BY house;

-- QN: Display the number of course for each year
SELECT year, COUNT(registered_course) FROM project GROUP BY year;

-- QO: Display the number of students enrolled in each course
SELECT registered_course, COUNT(*) FROM project GROUP BY registered_course;

-- QP: Display the courses in which students from each houses are enrolled in
-- NOTE: If we want to sort it, we can add a ORDER BY house ASC
SELECT house, registered_course FROM project GROUP BY house, registered_course;

-- QQ: Dsplay the number of students in each years for each house
-- NOTE: If we want to sort it, we can add a ORDER BY house ASC
SELECT house, COUNT(*), year FROM project GROUP BY house, year;

-- QR: Display the courses in which students in each years are enrolled in
SELECT year, registered_course FROM project GROUP BY year, registered_course ORDER BY year ASC;

-- QS: Display the number of students in each house by descending order
SELECT house, COUNT(*) AS nb_stud FROM project GROUP BY house ORDER BY nb_stud DESC;

-- QT: Display the number of students enrolled in each course, sorted in descending order
SELECT registered_course, COUNT(*) AS nb_stud FROM project GROUP BY registered_course ORDER BY nb_stud DESC;

-- QU: Display the prefects of each house sorted alphabetically by house
SELECT house, prefet FROM project GROUP BY house ORDER BY house ASC;
