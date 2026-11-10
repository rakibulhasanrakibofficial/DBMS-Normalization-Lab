-- TASK 14: CLASS TIMETABLE
CREATE TABLE t14_course (course_code VARCHAR(10) PRIMARY KEY, course_title VARCHAR(100) NOT NULL);
CREATE TABLE t14_section (section VARCHAR(20) PRIMARY KEY, course_code VARCHAR(10) NOT NULL, FOREIGN KEY (course_code) REFERENCES t14_course(course_code));
CREATE TABLE t14_room (room VARCHAR(10) PRIMARY KEY, capacity INT NOT NULL);
CREATE TABLE t14_meeting (section VARCHAR(20) NOT NULL, day_name VARCHAR(10) NOT NULL, slot TIME NOT NULL, room VARCHAR(10) NOT NULL, PRIMARY KEY (section,day_name,slot), FOREIGN KEY (section) REFERENCES t14_section(section), FOREIGN KEY (room) REFERENCES t14_room(room));
CREATE TABLE t14_room_equipment (room VARCHAR(10) NOT NULL, equipment VARCHAR(50) NOT NULL, PRIMARY KEY (room,equipment), FOREIGN KEY (room) REFERENCES t14_room(room));
INSERT INTO t14_course VALUES ('CSE301','Database Systems'),('CSE305','Operating Systems');
INSERT INTO t14_section VALUES ('CSE301-A','CSE301'),('CSE301-B','CSE301'),('CSE305-A','CSE305');
INSERT INTO t14_room VALUES ('R-301',60),('R-205',40),('R-110',90);
INSERT INTO t14_meeting VALUES ('CSE301-A','Sun','09:00:00','R-301'),('CSE301-A','Tue','09:00:00','R-301'),('CSE301-B','Mon','09:00:00','R-205'),('CSE305-A','Sun','10:00:00','R-205'),('CSE305-A','Mon','10:00:00','R-110');
INSERT INTO t14_room_equipment VALUES ('R-301','Projector'),('R-301','AC'),('R-205','Projector'),('R-110','Projector'),('R-110','Sound system');