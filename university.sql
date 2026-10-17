PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS prereq;
DROP TABLE IF EXISTS takes;
DROP TABLE IF EXISTS teaches;
DROP TABLE IF EXISTS advisor;
DROP TABLE IF EXISTS section;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS instructor;
DROP TABLE IF EXISTS classroom;
DROP TABLE IF EXISTS time_slot;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS department;

CREATE TABLE department (
    dept_name TEXT PRIMARY KEY,
    building TEXT NOT NULL,
    budget REAL NOT NULL CHECK (budget >= 0)
);

CREATE TABLE instructor (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    dept_name TEXT NOT NULL,
    salary REAL NOT NULL CHECK (salary >= 0),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);

CREATE TABLE student (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    dept_name TEXT NOT NULL,
    tot_cred INTEGER NOT NULL DEFAULT 0 CHECK (tot_cred >= 0),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);

CREATE TABLE advisor (
    s_id INTEGER PRIMARY KEY,
    i_id INTEGER NOT NULL,
    FOREIGN KEY (s_id) REFERENCES student(id),
    FOREIGN KEY (i_id) REFERENCES instructor(id)
);

CREATE TABLE course (
    course_id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    dept_name TEXT NOT NULL,
    credits INTEGER NOT NULL CHECK (credits > 0),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);

CREATE TABLE teaches (
    id INTEGER NOT NULL,
    course_id TEXT NOT NULL,
    sec_id TEXT NOT NULL,
    semester TEXT NOT NULL,
    year INTEGER NOT NULL,
    PRIMARY KEY (id, course_id, sec_id, semester, year),
    FOREIGN KEY (id) REFERENCES instructor(id),
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year)
);

CREATE TABLE takes (
    id INTEGER NOT NULL,
    course_id TEXT NOT NULL,
    sec_id TEXT NOT NULL,
    semester TEXT NOT NULL,
    year INTEGER NOT NULL,
    grade TEXT,
    PRIMARY KEY (id, course_id, sec_id, semester, year),
    FOREIGN KEY (id) REFERENCES student(id),
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year)
);

CREATE TABLE classroom (
    building TEXT NOT NULL,
    room_number TEXT NOT NULL,
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    PRIMARY KEY (building, room_number)
);

CREATE TABLE time_slot (
    time_slot_id TEXT NOT NULL,
    day TEXT NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,
    PRIMARY KEY (time_slot_id, day, start_time),
    UNIQUE (time_slot_id)
);

CREATE TABLE section (
    course_id TEXT NOT NULL,
    sec_id TEXT NOT NULL,
    semester TEXT NOT NULL,
    year INTEGER NOT NULL,
    building TEXT NOT NULL,
    room_number TEXT NOT NULL,
    time_slot_id TEXT NOT NULL,
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (building, room_number) REFERENCES classroom(building, room_number),
    FOREIGN KEY (time_slot_id) REFERENCES time_slot(time_slot_id)
);

CREATE TABLE prereq (
    course_id TEXT NOT NULL,
    prereq_id TEXT NOT NULL,
    PRIMARY KEY (course_id, prereq_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (prereq_id) REFERENCES course(course_id),
    CHECK (course_id <> prereq_id)
);

INSERT INTO department VALUES
('Computer Science', 'North Hall', 750000),
('Electrical Engineering', 'Engineering Block', 680000),
('Mathematics', 'Science Building', 520000),
('Physics', 'Science Building', 490000);

INSERT INTO instructor VALUES
(101, 'Amina Yusuf', 'Computer Science', 72000),
(102, 'Daniel Kim', 'Electrical Engineering', 76000),
(103, 'Maya Patel', 'Mathematics', 69000),
(104, 'Omar Hassan', 'Computer Science', 74000);

INSERT INTO student VALUES
(1001, 'Lina Mensah', 'Computer Science', 42),
(1002, 'Ethan Cole', 'Electrical Engineering', 36),
(1003, 'Sofia Ndlovu', 'Mathematics', 54),
(1004, 'Noah Martin', 'Computer Science', 63),
(1005, 'Grace Okafor', 'Physics', 28),
(1006, 'Adam Chen', 'Electrical Engineering', 47);

INSERT INTO advisor VALUES
(1001, 101),
(1002, 102),
(1003, 103),
(1004, 104),
(1005, 103),
(1006, 102);

INSERT INTO course VALUES
('CS101', 'Introduction to Programming', 'Computer Science', 3),
('CS201', 'Data Structures', 'Computer Science', 4),
('CS301', 'Database Systems', 'Computer Science', 3),
('EE201', 'Digital Logic Design', 'Electrical Engineering', 3),
('MATH201', 'Linear Algebra', 'Mathematics', 3),
('PHYS101', 'General Physics', 'Physics', 4);

INSERT INTO classroom VALUES
('North Hall', '101', 40),
('North Hall', '202', 32),
('Engineering Block', '110', 48),
('Science Building', '205', 36);

INSERT INTO time_slot VALUES
('TS1', 'Monday', '09:00', '10:15'),
('TS2', 'Tuesday', '10:30', '11:45'),
('TS3', 'Wednesday', '13:00', '14:15'),
('TS4', 'Thursday', '14:30', '15:45');

INSERT INTO section VALUES
('CS101', '1', 'Fall', 2026, 'North Hall', '101', 'TS1'),
('CS201', '1', 'Fall', 2026, 'North Hall', '202', 'TS2'),
('CS301', '1', 'Fall', 2026, 'North Hall', '101', 'TS3'),
('EE201', '1', 'Fall', 2026, 'Engineering Block', '110', 'TS1'),
('MATH201', '1', 'Fall', 2026, 'Science Building', '205', 'TS4'),
('PHYS101', '1', 'Fall', 2026, 'Science Building', '205', 'TS2');

INSERT INTO teaches VALUES
(101, 'CS101', '1', 'Fall', 2026),
(104, 'CS201', '1', 'Fall', 2026),
(101, 'CS301', '1', 'Fall', 2026),
(102, 'EE201', '1', 'Fall', 2026),
(103, 'MATH201', '1', 'Fall', 2026),
(103, 'PHYS101', '1', 'Fall', 2026);

INSERT INTO takes VALUES
(1001, 'CS101', '1', 'Fall', 2026, 'A'),
(1002, 'EE201', '1', 'Fall', 2026, 'B+'),
(1003, 'MATH201', '1', 'Fall', 2026, 'A-'),
(1004, 'CS201', '1', 'Fall', 2026, 'B'),
(1005, 'PHYS101', '1', 'Fall', 2026, 'A'),
(1006, 'EE201', '1', 'Fall', 2026, 'B+'),
(1001, 'CS201', '1', 'Fall', 2026, 'A-'),
(1004, 'CS301', '1', 'Fall', 2026, 'A');

INSERT INTO prereq VALUES
('CS201', 'CS101'),
('CS301', 'CS201'),
('EE201', 'MATH201');

-- Verification queries:
SELECT dept_name, building, budget FROM department ORDER BY dept_name;
SELECT id, name, dept_name, tot_cred FROM student ORDER BY id;
SELECT course_id, title, credits FROM course ORDER BY course_id;

-- Duplicate primary-key test:
-- INSERT INTO department (dept_name, building, budget)
-- VALUES ('Computer Science', 'Duplicate Building', 100000);
