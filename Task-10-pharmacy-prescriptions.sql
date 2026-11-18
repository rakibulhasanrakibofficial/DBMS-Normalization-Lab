-- TASK 10: PHARMACY PRESCRIPTIONS
-- Source relation: RX_LINE
-- Question: Normalize RX_LINE into 1NF, 2NF and 3NF.
--
-- BUSINESS RULES:
-- 1. One prescription belongs to one patient and contains one or more medicines.
-- 2. Each prescription-medicine line has its own Dose and Days.
-- 3. A patient has one name and zero or more allergies.
-- 4. A medicine has one name.
--
-- FUNCTIONAL DEPENDENCIES:
-- RxID -> PatientID
-- PatientID -> PatientName
-- PatientID ->> Allergy        (a patient may have multiple allergies)
-- MedID -> MedName
-- (RxID, MedID) -> Dose, Days
--
-- 1NF: Make Allergies atomic by storing one allergy per row.
-- 2NF: Remove partial dependencies from the composite key.
-- 3NF: Remove transitive dependency PatientID -> PatientName.
--
-- MySQL Shell:
-- Start MySQL Shell, enter SQL mode with: \sql
-- Then run this file with: \source path/to/Task-10-pharmacy-prescriptions.sql

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

-- Drop Task 10 tables in child-to-parent order (safe to rerun).
DROP TABLE IF EXISTS t10_prescription_medicine;
DROP TABLE IF EXISTS t10_prescription;
DROP TABLE IF EXISTS t10_patient_allergy;
DROP TABLE IF EXISTS t10_medicine;
DROP TABLE IF EXISTS t10_patient;

DROP TABLE IF EXISTS t10_2nf_prescription_medicine;
DROP TABLE IF EXISTS t10_2nf_patient_allergy;
DROP TABLE IF EXISTS t10_2nf_medicine;
DROP TABLE IF EXISTS t10_2nf_prescription;

DROP TABLE IF EXISTS t10_1nf;

-- =========================================================
-- FIRST NORMAL FORM (1NF)
-- =========================================================
-- The Allergies column in the source contains multiple values.
-- Store each allergy as a separate atomic value (one per row).
-- Therefore the 1NF key is (RxID, MedID, Allergy).
-- Dose and Days repeat for each allergy belonging to that patient.

CREATE TABLE t10_1nf (
    rx_id VARCHAR(10) NOT NULL,
    med_id VARCHAR(10) NOT NULL,
    patient_id VARCHAR(10) NOT NULL,
    patient_name VARCHAR(100) NOT NULL,
    allergy VARCHAR(100) NOT NULL,
    med_name VARCHAR(100) NOT NULL,
    dose VARCHAR(20) NOT NULL,
    days INT NOT NULL,
    PRIMARY KEY (rx_id, med_id, allergy)
);

INSERT INTO t10_1nf
    (rx_id, med_id, patient_id, patient_name, allergy, med_name, dose, days)
VALUES
('RX1','M1','P1','Rina Sen','Penicillin','Paracetamol 500','1-1-1',5),
('RX1','M1','P1','Rina Sen','Dust','Paracetamol 500','1-1-1',5),
('RX1','M2','P1','Rina Sen','Penicillin','Azithromycin 250','1-0-0',3),
('RX1','M2','P1','Rina Sen','Dust','Azithromycin 250','1-0-0',3),
('RX2','M1','P2','Jamal Uddin','None','Paracetamol 500','1-0-1',4),
('RX3','M3','P1','Rina Sen','Penicillin','Omeprazole 20','1-0-0',14),
('RX3','M3','P1','Rina Sen','Dust','Omeprazole 20','1-0-0',14),
('RX3','M1','P1','Rina Sen','Penicillin','Paracetamol 500','0-0-1',3),
('RX3','M1','P1','Rina Sen','Dust','Paracetamol 500','0-0-1',3);

SELECT * FROM t10_1nf;

-- =========================================================
-- SECOND NORMAL FORM (2NF)
-- =========================================================
-- Remove partial dependencies from (RxID, MedID, Allergy):
-- RxID determines PatientID and PatientName.
-- MedID determines MedName.
-- (RxID, MedID) determines Dose and Days.
-- Patient allergies are stored separately, one row per allergy.
--
-- PatientName is intentionally kept in the prescription table at 2NF.
-- PatientID -> PatientName is a transitive dependency, removed in 3NF.

CREATE TABLE t10_2nf_prescription (
    rx_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10) NOT NULL,
    patient_name VARCHAR(100) NOT NULL
);

CREATE TABLE t10_2nf_medicine (
    med_id VARCHAR(10) PRIMARY KEY,
    med_name VARCHAR(100) NOT NULL
);

CREATE TABLE t10_2nf_prescription_medicine (
    rx_id VARCHAR(10) NOT NULL,
    med_id VARCHAR(10) NOT NULL,
    dose VARCHAR(20) NOT NULL,
    days INT NOT NULL,
    PRIMARY KEY (rx_id, med_id),
    FOREIGN KEY (rx_id) REFERENCES t10_2nf_prescription(rx_id),
    FOREIGN KEY (med_id) REFERENCES t10_2nf_medicine(med_id)
);

CREATE TABLE t10_2nf_patient_allergy (
    patient_id VARCHAR(10) NOT NULL,
    allergy VARCHAR(100) NOT NULL,
    PRIMARY KEY (patient_id, allergy)
);

INSERT INTO t10_2nf_prescription
    (rx_id, patient_id, patient_name)
VALUES
('RX1','P1','Rina Sen'),
('RX2','P2','Jamal Uddin'),
('RX3','P1','Rina Sen');

INSERT INTO t10_2nf_medicine (med_id, med_name) VALUES
('M1','Paracetamol 500'),
('M2','Azithromycin 250'),
('M3','Omeprazole 20');

INSERT INTO t10_2nf_prescription_medicine
    (rx_id, med_id, dose, days)
VALUES
('RX1','M1','1-1-1',5),
('RX1','M2','1-0-0',3),
('RX2','M1','1-0-1',4),
('RX3','M3','1-0-0',14),
('RX3','M1','0-0-1',3);

INSERT INTO t10_2nf_patient_allergy (patient_id, allergy) VALUES
('P1','Penicillin'),
('P1','Dust');

-- P2 has no allergy in the given question, so P2 has no row in this table.
-- "None" is not stored as an actual allergy.

SELECT * FROM t10_2nf_prescription;
SELECT * FROM t10_2nf_medicine;
SELECT * FROM t10_2nf_prescription_medicine;
SELECT * FROM t10_2nf_patient_allergy;

-- =========================================================
-- THIRD NORMAL FORM (3NF)
-- =========================================================
-- Remove the transitive dependency:
-- RxID -> PatientID -> PatientName
--
-- Final 3NF relations:
-- PATIENT(PatientID, PatientName)
-- PATIENT_ALLERGY(PatientID, Allergy)
-- MEDICINE(MedID, MedName)
-- PRESCRIPTION(RxID, PatientID)
-- PRESCRIPTION_MEDICINE(RxID, MedID, Dose, Days)
--
-- Every non-key attribute depends on the key, the whole key,
-- and nothing but the key.

CREATE TABLE t10_patient (
    patient_id VARCHAR(10) PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL
);

CREATE TABLE t10_patient_allergy (
    patient_id VARCHAR(10) NOT NULL,
    allergy VARCHAR(100) NOT NULL,
    PRIMARY KEY (patient_id, allergy),
    FOREIGN KEY (patient_id) REFERENCES t10_patient(patient_id)
);

CREATE TABLE t10_medicine (
    med_id VARCHAR(10) PRIMARY KEY,
    med_name VARCHAR(100) NOT NULL
);

CREATE TABLE t10_prescription (
    rx_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES t10_patient(patient_id)
);

CREATE TABLE t10_prescription_medicine (
    rx_id VARCHAR(10) NOT NULL,
    med_id VARCHAR(10) NOT NULL,
    dose VARCHAR(20) NOT NULL,
    days INT NOT NULL,
    PRIMARY KEY (rx_id, med_id),
    FOREIGN KEY (rx_id) REFERENCES t10_prescription(rx_id),
    FOREIGN KEY (med_id) REFERENCES t10_medicine(med_id)
);

-- Insert patient records.
INSERT INTO t10_patient (patient_id, patient_name) VALUES
('P1','Rina Sen'),
('P2','Jamal Uddin');

-- Insert only actual allergies. P2 has no allergy listed in the question.
INSERT INTO t10_patient_allergy (patient_id, allergy) VALUES
('P1','Penicillin'),
('P1','Dust');

-- Insert medicine records.
INSERT INTO t10_medicine (med_id, med_name) VALUES
('M1','Paracetamol 500'),
('M2','Azithromycin 250'),
('M3','Omeprazole 20');

-- Insert prescription headers (one patient per prescription).
INSERT INTO t10_prescription (rx_id, patient_id) VALUES
('RX1','P1'),
('RX2','P2'),
('RX3','P1');

-- Insert prescription medicine lines.
INSERT INTO t10_prescription_medicine (rx_id, med_id, dose, days) VALUES
('RX1','M1','1-1-1',5),
('RX1','M2','1-0-0',3),
('RX2','M1','1-0-1',4),
('RX3','M3','1-0-0',14),
('RX3','M1','0-0-1',3);

-- =========================================================
-- 3NF VERIFICATION
-- =========================================================
SELECT * FROM t10_patient;
SELECT * FROM t10_patient_allergy;
SELECT * FROM t10_medicine;
SELECT * FROM t10_prescription;
SELECT * FROM t10_prescription_medicine;

-- Reconstruct the prescription details using JOINs.
SELECT
    pr.rx_id,
    pr.patient_id,
    p.patient_name,
    pm.med_id,
    m.med_name,
    pm.dose,
    pm.days
FROM t10_prescription AS pr
JOIN t10_patient AS p
    ON pr.patient_id = p.patient_id
JOIN t10_prescription_medicine AS pm
    ON pr.rx_id = pm.rx_id
JOIN t10_medicine AS m
    ON pm.med_id = m.med_id
ORDER BY pr.rx_id, pm.med_id;

-- Show each patient's allergies (P2 will have NULL because no allergy is listed).
SELECT
    p.patient_id,
    p.patient_name,
    pa.allergy
FROM t10_patient AS p
LEFT JOIN t10_patient_allergy AS pa
    ON p.patient_id = pa.patient_id
ORDER BY p.patient_id, pa.allergy;
