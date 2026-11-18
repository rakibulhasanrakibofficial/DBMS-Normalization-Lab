-- TASK 14: CLASS TIMETABLE
-- Source relation: TIMETABLE_FLAT
-- Question: Normalize TIMETABLE_FLAT into 1NF, 2NF and 3NF.
--
-- Business rules:
-- 1. A section meets on a given day and time slot in exactly one room,
--    and meets several times a week.
-- 2. A section belongs to one course; a course has one title.
-- 3. A room has one capacity and a set of equipment items (zero or more).
--
-- Functional dependencies:
-- Section -> CourseCode
-- CourseCode -> CourseTitle
-- (Section, Day, Slot) -> Room
-- Room -> Capacity
-- Room ->> Equipment (multivalued dependency: a room may have many items)
--
-- 1NF: Split the Equipment list into one equipment item per row.
-- 2NF: Separate facts that depend on only part of the composite key.
-- 3NF: Separate CourseTitle from Section through CourseCode.
--      Keep room capacity and room equipment in room-related tables.

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

-- Drop all Task 14 tables in child-to-parent order.
DROP TABLE IF EXISTS t14_room_equipment;
DROP TABLE IF EXISTS t14_meeting;
DROP TABLE IF EXISTS t14_section;
DROP TABLE IF EXISTS t14_room;
DROP TABLE IF EXISTS t14_course;

DROP TABLE IF EXISTS t14_2nf_room_equipment;
DROP TABLE IF EXISTS t14_2nf_meeting;
DROP TABLE IF EXISTS t14_2nf_section;
DROP TABLE IF EXISTS t14_2nf_room;

DROP TABLE IF EXISTS t14_1nf_timetable;

-- =====================================================
-- FIRST NORMAL FORM (1NF)
-- =====================================================
-- Equipment is atomic: one equipment item per row.
-- The composite key includes Section, Day, Slot and Equipment.

CREATE TABLE t14_1nf_timetable (
    section VARCHAR(20) NOT NULL,
    day_name VARCHAR(10) NOT NULL,
    slot TIME NOT NULL,
    room VARCHAR(10) NOT NULL,
    capacity INT NOT NULL,
    equipment VARCHAR(50) NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    course_title VARCHAR(100) NOT NULL,
    PRIMARY KEY (section, day_name, slot, equipment)
);

-- The original rows are expanded where a room has multiple equipment items.
INSERT INTO t14_1nf_timetable VALUES
('CSE301-A','Sun','09:00:00','R-301',60,'Projector','CSE301','Database Systems'),
('CSE301-A','Sun','09:00:00','R-301',60,'AC','CSE301','Database Systems'),
('CSE301-A','Tue','09:00:00','R-301',60,'Projector','CSE301','Database Systems'),
('CSE301-A','Tue','09:00:00','R-301',60,'AC','CSE301','Database Systems'),
('CSE301-B','Mon','09:00:00','R-205',40,'Projector','CSE301','Database Systems'),
('CSE305-A','Sun','10:00:00','R-205',40,'Projector','CSE305','Operating Systems'),
('CSE305-A','Mon','10:00:00','R-110',90,'Projector','CSE305','Operating Systems'),
('CSE305-A','Mon','10:00:00','R-110',90,'Sound system','CSE305','Operating Systems');

SELECT * FROM t14_1nf_timetable;

-- =====================================================
-- SECOND NORMAL FORM (2NF)
-- =====================================================
-- Remove partial dependencies from the 1NF composite key:
-- Section determines CourseCode and CourseTitle.
-- Room determines Capacity and its set of equipment.
-- A meeting is identified by (Section, Day, Slot).
-- CourseCode -> CourseTitle is a transitive dependency and is kept
-- for the 3NF decomposition.

CREATE TABLE t14_2nf_section (
    section VARCHAR(20) PRIMARY KEY,
    course_code VARCHAR(10) NOT NULL,
    course_title VARCHAR(100) NOT NULL
);

CREATE TABLE t14_2nf_room (
    room VARCHAR(10) PRIMARY KEY,
    capacity INT NOT NULL
);

CREATE TABLE t14_2nf_meeting (
    section VARCHAR(20) NOT NULL,
    day_name VARCHAR(10) NOT NULL,
    slot TIME NOT NULL,
    room VARCHAR(10) NOT NULL,
    PRIMARY KEY (section, day_name, slot),
    FOREIGN KEY (section) REFERENCES t14_2nf_section(section),
    FOREIGN KEY (room) REFERENCES t14_2nf_room(room)
);

CREATE TABLE t14_2nf_room_equipment (
    room VARCHAR(10) NOT NULL,
    equipment VARCHAR(50) NOT NULL,
    PRIMARY KEY (room, equipment),
    FOREIGN KEY (room) REFERENCES t14_2nf_room(room)
);

INSERT INTO t14_2nf_section VALUES
('CSE301-A','CSE301','Database Systems'),
('CSE301-B','CSE301','Database Systems'),
('CSE305-A','CSE305','Operating Systems');

INSERT INTO t14_2nf_room VALUES
('R-301',60),
('R-205',40),
('R-110',90);

INSERT INTO t14_2nf_meeting VALUES
('CSE301-A','Sun','09:00:00','R-301'),
('CSE301-A','Tue','09:00:00','R-301'),
('CSE301-B','Mon','09:00:00','R-205'),
('CSE305-A','Sun','10:00:00','R-205'),
('CSE305-A','Mon','10:00:00','R-110');

INSERT INTO t14_2nf_room_equipment VALUES
('R-301','Projector'),
('R-301','AC'),
('R-205','Projector'),
('R-110','Projector'),
('R-110','Sound system');

SELECT * FROM t14_2nf_section;
SELECT * FROM t14_2nf_room;
SELECT * FROM t14_2nf_meeting;
SELECT * FROM t14_2nf_room_equipment;

-- =====================================================
-- THIRD NORMAL FORM (3NF)
-- =====================================================
-- Remove the transitive dependency:
-- Section -> CourseCode -> CourseTitle
-- CourseTitle is stored only in the COURSE table.

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

INSERT INTO t14_course VALUES
('CSE301','Database Systems'),
('CSE305','Operating Systems');

INSERT INTO t14_section VALUES
('CSE301-A','CSE301'),
('CSE301-B','CSE301'),
('CSE305-A','CSE305');

INSERT INTO t14_room VALUES
('R-301',60),
('R-205',40),
('R-110',90);

INSERT INTO t14_meeting VALUES
('CSE301-A','Sun','09:00:00','R-301'),
('CSE301-A','Tue','09:00:00','R-301'),
('CSE301-B','Mon','09:00:00','R-205'),
('CSE305-A','Sun','10:00:00','R-205'),
('CSE305-A','Mon','10:00:00','R-110');

INSERT INTO t14_room_equipment VALUES
('R-301','Projector'),
('R-301','AC'),
('R-205','Projector'),
('R-110','Projector'),
('R-110','Sound system');

-- Verify final 3NF tables.
SELECT * FROM t14_course;
SELECT * FROM t14_section;
SELECT * FROM t14_room;
SELECT * FROM t14_meeting;
SELECT * FROM t14_room_equipment;
