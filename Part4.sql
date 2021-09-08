-- Coder: Enigma Zhang --

USE SCHOOL;

-- 4.2 --
SELECT ID, COUNT(sec_id)
FROM instructor
         NATURAL LEFT OUTER JOIN teaches
GROUP BY ID;

SELECT instructor.ID,
       (
           SELECT COUNT(sec_id)
           FROM teaches
           WHERE teaches.ID = instructor.ID
       ) AS sec_count
FROM instructor;

SELECT course_id, sec_id, ID, name
FROM teaches NATURAL LEFT OUTER JOIN instructor
WHERE year = 2018 AND semester = "Spring";
