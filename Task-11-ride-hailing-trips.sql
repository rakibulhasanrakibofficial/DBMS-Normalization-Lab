-- TASK 11: RIDE-HAILING TRIPS
-- Question: Normalize TRIP_LOG into 1NF, 2NF and 3NF.
--
-- Functional dependencies:
-- TripID -> TripDate, RiderID, VehicleID
-- RiderID -> RiderName
-- VehicleID -> Model
-- Model -> Category
-- Category -> FarePerKm
--
-- 1NF: Every column contains one atomic value.
-- 2NF: TripID is a single-column primary key, so there can be no partial
--      dependency. Therefore the 2NF relation is unchanged from 1NF.
-- 3NF: Separate Rider, Vehicle, Model and Category facts to remove
--      transitive dependencies.

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

-- Drop final tables in child-to-parent order.
DROP TABLE IF EXISTS t11_trip;
DROP TABLE IF EXISTS t11_vehicle;
DROP TABLE IF EXISTS t11_model;
DROP TABLE IF EXISTS t11_category;
DROP TABLE IF EXISTS t11_rider;

DROP TABLE IF EXISTS t11_2nf_trip_log;
DROP TABLE IF EXISTS t11_1nf_trip_log;

-- -------------------------
-- FIRST NORMAL FORM (1NF)
-- -------------------------
CREATE TABLE t11_1nf_trip_log (
    trip_id VARCHAR(10) PRIMARY KEY,
    trip_date DATE NOT NULL,
    rider_id VARCHAR(10) NOT NULL,
    rider_name VARCHAR(100) NOT NULL,
    vehicle_id VARCHAR(10) NOT NULL,
    model VARCHAR(50) NOT NULL,
    category VARCHAR(30) NOT NULL,
    fare_per_km DECIMAL(8,2) NOT NULL
);

INSERT INTO t11_1nf_trip_log VALUES
('T01','2026-10-10','R1','Mitu Akter','V1','Comfy 500','Premium',30),
('T02','2026-10-10','R2','Pavel Roy','V2','Eco 100','Economy',20),
('T03','2026-10-11','R1','Mitu Akter','V3','Eco 120','Economy',20),
('T04','2026-10-11','R3','Lopa Khatun','V2','Eco 100','Economy',20),
('T05','2026-10-12','R2','Pavel Roy','V1','Comfy 500','Premium',30);

SELECT * FROM t11_1nf_trip_log;

-- -------------------------
-- SECOND NORMAL FORM (2NF)
-- -------------------------
-- No partial dependency exists because the primary key is TripID alone.
-- This table is structurally the same as the 1NF table.

CREATE TABLE t11_2nf_trip_log (
    trip_id VARCHAR(10) PRIMARY KEY,
    trip_date DATE NOT NULL,
    rider_id VARCHAR(10) NOT NULL,
    rider_name VARCHAR(100) NOT NULL,
    vehicle_id VARCHAR(10) NOT NULL,
    model VARCHAR(50) NOT NULL,
    category VARCHAR(30) NOT NULL,
    fare_per_km DECIMAL(8,2) NOT NULL
);

INSERT INTO t11_2nf_trip_log
SELECT * FROM t11_1nf_trip_log;

SELECT * FROM t11_2nf_trip_log;

-- -------------------------
-- THIRD NORMAL FORM (3NF)
-- -------------------------
-- RiderID -> RiderName
-- VehicleID -> Model
-- Model -> Category
-- Category -> FarePerKm

CREATE TABLE t11_rider (
    rider_id VARCHAR(10) PRIMARY KEY,
    rider_name VARCHAR(100) NOT NULL
);

CREATE TABLE t11_category (
    category VARCHAR(30) PRIMARY KEY,
    fare_per_km DECIMAL(8,2) NOT NULL
);

CREATE TABLE t11_model (
    model VARCHAR(50) PRIMARY KEY,
    category VARCHAR(30) NOT NULL,
    FOREIGN KEY (category) REFERENCES t11_category(category)
);

CREATE TABLE t11_vehicle (
    vehicle_id VARCHAR(10) PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    FOREIGN KEY (model) REFERENCES t11_model(model)
);

CREATE TABLE t11_trip (
    trip_id VARCHAR(10) PRIMARY KEY,
    trip_date DATE NOT NULL,
    rider_id VARCHAR(10) NOT NULL,
    vehicle_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (rider_id) REFERENCES t11_rider(rider_id),
    FOREIGN KEY (vehicle_id) REFERENCES t11_vehicle(vehicle_id)
);

INSERT INTO t11_rider VALUES
('R1','Mitu Akter'),
('R2','Pavel Roy'),
('R3','Lopa Khatun');

INSERT INTO t11_category VALUES
('Premium',30),
('Economy',20);

INSERT INTO t11_model VALUES
('Comfy 500','Premium'),
('Eco 100','Economy'),
('Eco 120','Economy');

INSERT INTO t11_vehicle VALUES
('V1','Comfy 500'),
('V2','Eco 100'),
('V3','Eco 120');

INSERT INTO t11_trip VALUES
('T01','2026-10-10','R1','V1'),
('T02','2026-10-10','R2','V2'),
('T03','2026-10-11','R1','V3'),
('T04','2026-10-11','R3','V2'),
('T05','2026-10-12','R2','V1');

-- Verify final 3NF tables
SELECT * FROM t11_rider;
SELECT * FROM t11_category;
SELECT * FROM t11_model;
SELECT * FROM t11_vehicle;
SELECT * FROM t11_trip;
