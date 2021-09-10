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

SELECT course_id, sec_id, ID, COALESCE(name, '-') AS name
FROM section
         NATURAL LEFT OUTER JOIN teaches
         NATURAL LEFT OUTER JOIN instructor
WHERE year = 2018
  AND semester = 'Spring';

SELECT dept_name, COUNT(ID)
FROM department
         NATURAL LEFT OUTER JOIN instructor
GROUP BY dept_name;

-- 4.3 --
(
    SELECT ID, name, dept_name, tot_cred, course_id, sec_id, semester, year, grade
    FROM student
             NATURAL JOIN takes
)
UNION
(
    SELECT ID,
           name,
           dept_name,
           tot_cred,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL
    FROM student
    WHERE student.ID
              NOT IN (SELECT ID
                      FROM student
                               NATURAL JOIN takes)
);

(
    SELECT *
    FROM student
             NATURAL JOIN takes
)
UNION
(
    SELECT ID,
           name,
           dept_name,
           tot_cred,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL
    FROM student
    WHERE student.ID
              NOT IN (SELECT ID
                      FROM student
                               NATURAL JOIN takes)
)
UNION
(
    SELECT ID, NULL, NUll, NULL, course_id, sec_id, semester, year, grade
    FROM takes
    WHERE takes.ID
              NOT IN (SELECT ID
                      FROM student
                               NATURAL JOIN takes)
);

-- 4.6 --
DROP VIEW student_grades;
CREATE VIEW student_grades(ID, GPA) AS
WITH join_table AS
         (
             SELECT *
             FROM student
                      NATURAL LEFT OUTER JOIN takes
                      NATURAL JOIN course
                      NATURAL LEFT OUTER JOIN grade_points
         )
    (
        SELECT S.ID, S.GPA
        FROM (
            -- Inner IF is to handle grade is NULL --
            -- Outside IF is to handle SUM is 0
                 SELECT ID,
                        SUM(credits * points) /
                        IF(SUM(IF(grade IS NULL, 0, credits)) = 0, NULL, SUM(IF(grade IS NULL, 0, credits))) AS GPA
                 FROM join_table
                 GROUP BY ID
             ) AS S
    )
UNION
(
    SELECT ID, NULL
    FROM join_table
    WHERE ID NOT IN (SELECT takes.ID FROM takes)
);


-- 4.8 --
SELECT ID, name, sec_id, semester, year, time_slot_id, COUNT(DISTINCT building, room_number)
FROM
     instructor
    NATURAL JOIN teaches
    NATURAL JOIN section
GROUP BY ID, name, sec_id, semester, year, time_slot_id
HAVING COUNT(DISTINCT building, room_number) > 1;