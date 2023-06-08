SELECT @@profiling;
SET profiling = 1;

-- Queries A
SELECT housen.house, coursen.registered_course, COUNT(*) AS num_students
FROM studentn
JOIN housen ON studentn.house_id = housen.house_id
JOIN link ON studentn.student_id = link.student_id
JOIN coursen ON coursen.course_id=link.course_id
GROUP BY house, registered_course
ORDER BY num_students DESC;

-- Queries B
SELECT student_name, nb_courses
FROM (SELECT studentn.student_name, studentn.email, COUNT(link.course_id) AS nb_courses
FROM studentn 
JOIN link ON studentn.student_id=link.student_id GROUP BY studentn.student_name, studentn.email) x
WHERE nb_courses = 0;

-- Queries C
SELECT housen.house, COUNT(*) AS nb_stud
FROM studentn
JOIN housen ON studentn.house_id = housen.house_id
WHERE EXISTS (
SELECT *
FROM coursen JOIN link ON coursen.course_id=link.course_id 
AND studentn.student_id=link.student_id
WHERE registered_course IN ('Potions', 'Sortilèges', 'Botanique')
AND coursen.course_id = link.course_id
)
GROUP BY housen.house;

-- Queries D
SELECT a.student_name, a.email
FROM studentn a
JOIN (
SELECT studentn.student_id, year, COUNT(DISTINCT course_id) AS
num_courses
FROM studentn
JOIN link ON studentn.student_id=link.student_id
GROUP BY studentn.student_id, year
) AS sub
ON a.student_id = sub.student_id AND a.year = sub.year
JOIN (
SELECT year, COUNT(DISTINCT course_id) AS num_courses
FROM studentn
JOIN link ON studentn.student_id=link.student_id
GROUP BY year
) AS total
ON a.year = total.year AND sub.num_courses =
total.num_courses
WHERE sub.num_courses = total.num_courses;