-- TASK 14: CLASS TIMETABLE
-- Normalize TIMETABLE_FLAT into 1NF, 2NF and 3NF.
--
-- Functional dependencies:
-- Section -> CourseCode
-- CourseCode -> CourseTitle
-- Room -> Capacity
-- (Section, Day, Slot) -> Room
-- Room ->> Equipment (a room can have multiple equipment items)
--
-- 1NF: Each equipment item is stored as a separate atomic value.
-- 2NF: Section/course, room, and meeting facts are separated from repeating meeting rows.
-- 3NF: CourseTitle and Capacity are stored with their own determinant tables.
-- Room equipment is stored in a separate relation because it is multivalued.

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

-- Remove old tables so this script can be executed again.
DROP TABLE IF EXISTS t14_room_equipment;
DROP TABLE IF EXISTS t14_meeting;
DROP TABLE IF EXISTS t14_section;
DROP TABLE IF EXISTS t14_room;
DROP TABLE IF EXISTS t14_course;

-- 3NF tables
CREATE TABLE t14_course (
    course_code VARCHAR(10) PRIMARY KEY,
    course_title VARCHAR(100) NOT NULL
);

CREATE TABLE t14_section (
    section VARCHAR(20) PRIMARY KEY,
    course_code VARCHAR(10) NOT NULL,
    FOREIGN KEY (course_code) REFERENCES t14_course(course_code)
);

CREATE TABLE t14_room (
    room VARCHAR(10) PRIMARY KEY,
    capacity INT NOT NULL
);

CREATE TABLE t14_meeting (
    section VARCHAR(20) NOT NULL,
    day_name VARCHAR(10) NOT NULL,
    slot TIME NOT NULL,
    room VARCHAR(10) NOT NULL,
    PRIMARY KEY (section, day_name, slot),
    FOREIGN KEY (section) REFERENCES t14_section(section),
    FOREIGN KEY (room) REFERENCES t14_room(room)
);

CREATE TABLE t14_room_equipment (
    room VARCHAR(10) NOT NULL,
    equipment VARCHAR(50) NOT NULL,
    PRIMARY KEY (room, equipment),
    FOREIGN KEY (room) REFERENCES t14_room(room)
);

-- Sample data from the given TIMETABLE_FLAT table
INSERT INTO t14_course VALUES
('CSE301', 'Database Systems'),
('CSE305', 'Operating Systems');

INSERT INTO t14_section VALUES
('CSE301-A', 'CSE301'),
('CSE301-B', 'CSE301'),
('CSE305-A', 'CSE305');

INSERT INTO t14_room VALUES
('R-301', 60),
('R-205', 40),
('R-110', 90);

INSERT INTO t14_meeting VALUES
('CSE301-A', 'Sun', '09:00:00', 'R-301'),
('CSE301-A', 'Tue', '09:00:00', 'R-301'),
('CSE301-B', 'Mon', '09:00:00', 'R-205'),
('CSE305-A', 'Sun', '10:00:00', 'R-205'),
('CSE305-A', 'Mon', '10:00:00', 'R-110');

INSERT INTO t14_room_equipment VALUES
('R-301', 'Projector'),
('R-301', 'AC'),
('R-205', 'Projector'),
('R-110', 'Projector'),
('R-110', 'Sound system');

-- Verify normalized data
SELECT * FROM t14_course;
SELECT * FROM t14_section;
SELECT * FROM t14_room;
SELECT * FROM t14_meeting;
SELECT * FROM t14_room_equipment;
