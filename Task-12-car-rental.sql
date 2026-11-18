-- TASK 12: CAR RENTAL
-- Question: Normalize RENTAL_SHEET into 1NF, 2NF and 3NF.
--
-- Functional dependencies:
-- (CarID, StartDate) -> EndDate, CustID
-- CustID -> CustName
-- CarID -> Model
-- Model -> CarClass
-- CarClass -> DailyRate
--
-- 1NF: All values are atomic; (CarID, StartDate) identifies one rental.
-- 2NF: Move car details depending only on CarID out of the rental relation.
-- 3NF: Remove transitive dependencies CustID -> CustName,
--      Model -> CarClass and CarClass -> DailyRate.

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

-- Drop final tables in child-to-parent order.
DROP TABLE IF EXISTS t12_rental;
DROP TABLE IF EXISTS t12_car;
DROP TABLE IF EXISTS t12_model;
DROP TABLE IF EXISTS t12_car_class;
DROP TABLE IF EXISTS t12_customer;

DROP TABLE IF EXISTS t12_2nf_rental;
DROP TABLE IF EXISTS t12_2nf_car;
DROP TABLE IF EXISTS t12_1nf_rental_sheet;

-- -------------------------
-- FIRST NORMAL FORM (1NF)
-- -------------------------
CREATE TABLE t12_1nf_rental_sheet (
    car_id VARCHAR(10) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    customer_id VARCHAR(10) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    model VARCHAR(50) NOT NULL,
    car_class VARCHAR(30) NOT NULL,
    daily_rate DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (car_id, start_date)
);

INSERT INTO t12_1nf_rental_sheet VALUES
('CAR1','2026-09-01','2026-09-04','C1','Tahsin Ali','Zen 5','Compact',1800),
('CAR1','2026-09-10','2026-09-12','C2','Mina Das','Zen 5','Compact',1800),
('CAR2','2026-09-02','2026-09-06','C1','Tahsin Ali','Terra 7','SUV',3500),
('CAR3','2026-09-03','2026-09-05','C3','Joy Barua','Vela 3','Compact',1800),
('CAR2','2026-09-12','2026-09-15','C2','Mina Das','Terra 7','SUV',3500);

SELECT * FROM t12_1nf_rental_sheet;

-- -------------------------
-- SECOND NORMAL FORM (2NF)
-- -------------------------
-- CarID is only part of the composite key and determines car details.
-- Move those partially dependent details into a separate CAR table.
-- CustomerName is retained with rental here; CustID -> CustName is
-- a transitive dependency and will be removed in 3NF.

CREATE TABLE t12_2nf_car (
    car_id VARCHAR(10) PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    car_class VARCHAR(30) NOT NULL,
    daily_rate DECIMAL(10,2) NOT NULL
);

CREATE TABLE t12_2nf_rental (
    car_id VARCHAR(10) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    customer_id VARCHAR(10) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (car_id, start_date),
    FOREIGN KEY (car_id) REFERENCES t12_2nf_car(car_id)
);

INSERT INTO t12_2nf_car VALUES
('CAR1','Zen 5','Compact',1800),
('CAR2','Terra 7','SUV',3500),
('CAR3','Vela 3','Compact',1800);

INSERT INTO t12_2nf_rental VALUES
('CAR1','2026-09-01','2026-09-04','C1','Tahsin Ali'),
('CAR1','2026-09-10','2026-09-12','C2','Mina Das'),
('CAR2','2026-09-02','2026-09-06','C1','Tahsin Ali'),
('CAR3','2026-09-03','2026-09-05','C3','Joy Barua'),
('CAR2','2026-09-12','2026-09-15','C2','Mina Das');

SELECT * FROM t12_2nf_car;
SELECT * FROM t12_2nf_rental;

-- -------------------------
-- THIRD NORMAL FORM (3NF)
-- -------------------------
-- CustID -> CustName
-- CarID -> Model
-- Model -> CarClass
-- CarClass -> DailyRate

CREATE TABLE t12_customer (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

CREATE TABLE t12_car_class (
    car_class VARCHAR(30) PRIMARY KEY,
    daily_rate DECIMAL(10,2) NOT NULL
);

CREATE TABLE t12_model (
    model VARCHAR(50) PRIMARY KEY,
    car_class VARCHAR(30) NOT NULL,
    FOREIGN KEY (car_class) REFERENCES t12_car_class(car_class)
);

CREATE TABLE t12_car (
    car_id VARCHAR(10) PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    FOREIGN KEY (model) REFERENCES t12_model(model)
);

CREATE TABLE t12_rental (
    car_id VARCHAR(10) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    customer_id VARCHAR(10) NOT NULL,
    PRIMARY KEY (car_id, start_date),
    FOREIGN KEY (car_id) REFERENCES t12_car(car_id),
    FOREIGN KEY (customer_id) REFERENCES t12_customer(customer_id)
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

-- Verify final 3NF tables
SELECT * FROM t12_customer;
SELECT * FROM t12_car_class;
SELECT * FROM t12_model;
SELECT * FROM t12_car;
SELECT * FROM t12_rental;
