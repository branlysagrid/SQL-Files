-- 1. Instructors earning more than 70000
SELECT name, dept_name, salary FROM instructor WHERE salary > 70000 ORDER BY salary DESC;

-- 2. Computer Science courses
SELECT title, credits FROM course WHERE dept_name = 'Computer Science' ORDER BY title ASC;

-- 3. Distinct buildings for Fall 2026 sections
SELECT DISTINCT building FROM section WHERE semester = 'Fall' AND year = 2026 ORDER BY building;

-- 4. Students whose names contain 'a'
SELECT id, name FROM student WHERE name LIKE '%a%' ORDER BY name;

-- 5. Students and their advisors
SELECT s.name AS student_name,
       (SELECT i.name
        FROM instructor i
        WHERE i.id = (
            SELECT a.i_id
            FROM advisor a
            WHERE a.s_id = s.id
        )) AS advisor_name
FROM student s
WHERE s.id IN (SELECT s_id FROM advisor)
ORDER BY s.name;

-- 6. Students who took CS201
SELECT id, name
FROM student
WHERE id IN (
    SELECT id
    FROM takes
    WHERE course_id = 'CS201'
)
ORDER BY id;

-- 7. Instructors and courses taught in Fall 2026
SELECT
    (SELECT name
     FROM instructor
     WHERE instructor.id = teaches.id) AS instructor_name,
    (SELECT title
     FROM course
     WHERE course.course_id = teaches.course_id) AS course_title
FROM teaches
WHERE semester = 'Fall'
  AND year = 2026
ORDER BY instructor_name, course_title;

-- 8. Courses and prerequisite courses
SELECT
    (SELECT title
     FROM course
     WHERE course.course_id = prereq.course_id) AS course_title,
    (SELECT title
     FROM course
     WHERE course.course_id = prereq.prereq_id) AS prerequisite_title
FROM prereq
ORDER BY course_title;
