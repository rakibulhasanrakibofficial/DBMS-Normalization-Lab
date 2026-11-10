-- TASK 5: AIRLINE TICKETS
CREATE TABLE t05_flight (flight_no VARCHAR(10) PRIMARY KEY, route VARCHAR(20) NOT NULL);
CREATE TABLE t05_passenger (passenger_id VARCHAR(10) PRIMARY KEY, passenger_name VARCHAR(100) NOT NULL);
CREATE TABLE t05_aircraft (aircraft_id VARCHAR(10) PRIMARY KEY, aircraft_model VARCHAR(50) NOT NULL);
CREATE TABLE t05_flight_operation (flight_no VARCHAR(10) NOT NULL, flight_date DATE NOT NULL, aircraft_id VARCHAR(10) NOT NULL, PRIMARY KEY (flight_no, flight_date), FOREIGN KEY (flight_no) REFERENCES t05_flight(flight_no), FOREIGN KEY (aircraft_id) REFERENCES t05_aircraft(aircraft_id));
CREATE TABLE t05_ticket (flight_no VARCHAR(10) NOT NULL, flight_date DATE NOT NULL, passenger_id VARCHAR(10) NOT NULL, seat_no VARCHAR(10) NOT NULL, PRIMARY KEY (flight_no, flight_date, passenger_id), FOREIGN KEY (flight_no, flight_date) REFERENCES t05_flight_operation(flight_no, flight_date), FOREIGN KEY (passenger_id) REFERENCES t05_passenger(passenger_id));
INSERT INTO t05_flight VALUES ('XY435','DAC-CXB'),('XY141','DAC-CGP');
INSERT INTO t05_passenger VALUES ('PX1','Ayesha Siddiqua'),('PX2','Omar Faruk'),('PX3','Lamia Noor'),('PX4','Rafiul Islam');
INSERT INTO t05_aircraft VALUES ('AC-101','Dash 8'),('AC-102','Dash 8'),('AC-205','Boeing 737');
INSERT INTO t05_flight_operation VALUES ('XY435','2026-11-02','AC-101'),('XY435','2026-11-03','AC-102'),('XY141','2026-11-02','AC-205');
INSERT INTO t05_ticket VALUES ('XY435','2026-11-02','PX1','12A'),('XY435','2026-11-02','PX2','12B'),('XY435','2026-11-03','PX1','3C'),('XY141','2026-11-02','PX3','7F'),('XY141','2026-11-02','PX4','7E');
