-- TASK 11: RIDE-HAILING TRIPS
CREATE TABLE t11_rider (rider_id VARCHAR(10) PRIMARY KEY, rider_name VARCHAR(100) NOT NULL);
CREATE TABLE t11_category (category VARCHAR(30) PRIMARY KEY, fare_per_km DECIMAL(8,2) NOT NULL);
CREATE TABLE t11_model (model VARCHAR(50) PRIMARY KEY, category VARCHAR(30) NOT NULL, FOREIGN KEY (category) REFERENCES t11_category(category));
CREATE TABLE t11_vehicle (vehicle_id VARCHAR(10) PRIMARY KEY, model VARCHAR(50) NOT NULL, FOREIGN KEY (model) REFERENCES t11_model(model));
CREATE TABLE t11_trip (trip_id VARCHAR(10) PRIMARY KEY, trip_date DATE NOT NULL, rider_id VARCHAR(10) NOT NULL, vehicle_id VARCHAR(10) NOT NULL, FOREIGN KEY (rider_id) REFERENCES t11_rider(rider_id), FOREIGN KEY (vehicle_id) REFERENCES t11_vehicle(vehicle_id));
INSERT INTO t11_rider VALUES ('R1','Mitu Akter'),('R2','Pavel Roy'),('R3','Lopa Khatun');
INSERT INTO t11_category VALUES ('Premium',30),('Economy',20);
INSERT INTO t11_model VALUES ('Comfy 500','Premium'),('Eco 100','Economy'),('Eco 120','Economy');
INSERT INTO t11_vehicle VALUES ('V1','Comfy 500'),('V2','Eco 100'),('V3','Eco 120');
INSERT INTO t11_trip VALUES ('T01','2026-10-10','R1','V1'),('T02','2026-10-10','R2','V2'),('T03','2026-10-11','R1','V3'),('T04','2026-10-11','R3','V2'),('T05','2026-10-12','R2','V1');