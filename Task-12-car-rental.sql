-- TASK 12: CAR RENTAL
-- Normalize RENTAL_SHEET into 1NF, 2NF and 3NF.
-- Run in MySQL Shell SQL mode.

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

-- Drop old Task 12 tables (safe to run again).
DROP TABLE IF EXISTS t12_rental;
DROP TABLE IF EXISTS t12_car;
DROP TABLE IF EXISTS t12_model;
DROP TABLE IF EXISTS t12_car_class;
DROP TABLE IF EXISTS t12_customer;
DROP TABLE IF EXISTS t12_rental_2nf;
DROP TABLE IF EXISTS t12_car_2nf;
DROP TABLE IF EXISTS t12_1nf;

-- ==================== 1NF ====================
-- All values are atomic.
-- Primary key: (CarID, StartDate)

CREATE TABLE t12_1nf (
    car_id VARCHAR(10),
    start_date DATE,
    end_date DATE,
    cust_id VARCHAR(10),
    cust_name VARCHAR(100),
    model VARCHAR(50),
    car_class VARCHAR(30),
    daily_rate DECIMAL(10,2),
    PRIMARY KEY (car_id, start_date)
);

INSERT INTO t12_1nf VALUES
('CAR1','2026-09-01','2026-09-04','C1','Tahsin Ali','Zen 5','Compact',1800),
('CAR1','2026-09-10','2026-09-12','C2','Mina Das','Zen 5','Compact',1800),
('CAR2','2026-09-02','2026-09-06','C1','Tahsin Ali','Terra 7','SUV',3500),
('CAR3','2026-09-03','2026-09-05','C3','Joy Barua','Vela 3','Compact',1800),
('CAR2','2026-09-12','2026-09-15','C2','Mina Das','Terra 7','SUV',3500);

SELECT * FROM t12_1nf;

-- ==================== 2NF ====================
-- Remove partial dependency:
-- CarID -> Model, Class, DailyRate
-- Keep CustName here; CustID -> CustName is removed in 3NF.

CREATE TABLE t12_car_2nf (
    car_id VARCHAR(10) PRIMARY KEY,
    model VARCHAR(50),
    car_class VARCHAR(30),
    daily_rate DECIMAL(10,2)
);

CREATE TABLE t12_rental_2nf (
    car_id VARCHAR(10),
    start_date DATE,
    end_date DATE,
    cust_id VARCHAR(10),
    cust_name VARCHAR(100),
    PRIMARY KEY (car_id, start_date),
    FOREIGN KEY (car_id) REFERENCES t12_car_2nf(car_id)
);

INSERT INTO t12_car_2nf VALUES
('CAR1','Zen 5','Compact',1800),
('CAR2','Terra 7','SUV',3500),
('CAR3','Vela 3','Compact',1800);

INSERT INTO t12_rental_2nf VALUES
('CAR1','2026-09-01','2026-09-04','C1','Tahsin Ali'),
('CAR1','2026-09-10','2026-09-12','C2','Mina Das'),
('CAR2','2026-09-02','2026-09-06','C1','Tahsin Ali'),
('CAR3','2026-09-03','2026-09-05','C3','Joy Barua'),
('CAR2','2026-09-12','2026-09-15','C2','Mina Das');

SELECT * FROM t12_car_2nf;
SELECT * FROM t12_rental_2nf;

-- ==================== 3NF ====================
-- Remove transitive dependencies:
-- CustID -> CustName
-- Model -> Class
-- Class -> DailyRate
-- CarID -> Model

CREATE TABLE t12_customer (
    cust_id VARCHAR(10) PRIMARY KEY,
    cust_name VARCHAR(100)
);

CREATE TABLE t12_car_class (
    car_class VARCHAR(30) PRIMARY KEY,
    daily_rate DECIMAL(10,2)
);

CREATE TABLE t12_model (
    model VARCHAR(50) PRIMARY KEY,
    car_class VARCHAR(30),
    FOREIGN KEY (car_class) REFERENCES t12_car_class(car_class)
);

CREATE TABLE t12_car (
    car_id VARCHAR(10) PRIMARY KEY,
    model VARCHAR(50),
    FOREIGN KEY (model) REFERENCES t12_model(model)
);

CREATE TABLE t12_rental (
    car_id VARCHAR(10),
    start_date DATE,
    end_date DATE,
    cust_id VARCHAR(10),
    PRIMARY KEY (car_id, start_date),
    FOREIGN KEY (car_id) REFERENCES t12_car(car_id),
    FOREIGN KEY (cust_id) REFERENCES t12_customer(cust_id)
);

INSERT INTO t12_customer VALUES
('C1','Tahsin Ali'),
('C2','Mina Das'),
('C3','Joy Barua');

INSERT INTO t12_car_class VALUES
('Compact',1800),
('SUV',3500);

INSERT INTO t12_model VALUES
('Zen 5','Compact'),
('Terra 7','SUV'),
('Vela 3','Compact');

INSERT INTO t12_car VALUES
('CAR1','Zen 5'),
('CAR2','Terra 7'),
('CAR3','Vela 3');

INSERT INTO t12_rental VALUES
('CAR1','2026-09-01','2026-09-04','C1'),
('CAR1','2026-09-10','2026-09-12','C2'),
('CAR2','2026-09-02','2026-09-06','C1'),
('CAR3','2026-09-03','2026-09-05','C3'),
('CAR2','2026-09-12','2026-09-15','C2');

-- Show the final 3NF tables.
SELECT * FROM t12_customer;
SELECT * FROM t12_car_class;
SELECT * FROM t12_model;
SELECT * FROM t12_car;
SELECT * FROM t12_rental;
