-- TASK 2: UNIVERSITY ENROLLMENT
CREATE TABLE t02_student (student_id VARCHAR(10) PRIMARY KEY, student_name VARCHAR(100) NOT NULL);
CREATE TABLE t02_course (course_id VARCHAR(10) PRIMARY KEY, course_title VARCHAR(100) NOT NULL);
CREATE TABLE t02_instructor (instructor_id VARCHAR(10) PRIMARY KEY, instructor_name VARCHAR(100) NOT NULL);
CREATE TABLE t02_course_offering (course_id VARCHAR(10) NOT NULL, semester VARCHAR(20) NOT NULL, instructor_id VARCHAR(10) NOT NULL, PRIMARY KEY (course_id, semester), FOREIGN KEY (course_id) REFERENCES t02_course(course_id), FOREIGN KEY (instructor_id) REFERENCES t02_instructor(instructor_id));
CREATE TABLE t02_enrollment (student_id VARCHAR(10) NOT NULL, course_id VARCHAR(10) NOT NULL, semester VARCHAR(20) NOT NULL, grade VARCHAR(5) NOT NULL, PRIMARY KEY (student_id, course_id, semester), FOREIGN KEY (student_id) REFERENCES t02_student(student_id), FOREIGN KEY (course_id, semester) REFERENCES t02_course_offering(course_id, semester));
INSERT INTO t02_student VALUES ('S1001','Anika Rahman'),('S1002','Imran Hossain'),('S1003','Farhana Akter');
INSERT INTO t02_course VALUES ('CSE301','Database Systems'),('CSE305','Operating Systems'),('EEE201','Circuits');
INSERT INTO t02_instructor VALUES ('T01','Dr. Mahmud'),('T02','Dr. Chowdhury'),('T03','Dr. Rafiq'),('T05','Dr. Salma');
INSERT INTO t02_course_offering VALUES ('CSE301','Fall-2025','T01'),('CSE305','Fall-2025','T02'),('EEE201','Spring-2026','T05'),('CSE301','Spring-2026','T03');
INSERT INTO t02_enrollment VALUES ('S1001','CSE301','Fall-2025','A'),('S1001','CSE305','Fall-2025','B+'),('S1002','CSE301','Fall-2025','B'),('S1002','EEE201','Spring-2026','A-'),('S1003','CSE301','Spring-2026','A');
