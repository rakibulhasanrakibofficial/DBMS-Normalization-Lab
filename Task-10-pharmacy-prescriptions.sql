-- TASK 10: PHARMACY PRESCRIPTIONS
-- Question: Normalize RX_LINE into 1NF, 2NF and 3NF.
--
-- Functional dependencies:
-- RxID -> PatientID
-- PatientID -> PatientName
-- PatientID ->> Allergy (a patient can have multiple allergies)
-- MedID -> MedName
-- (RxID, MedID) -> Dose, Days
--
-- 1NF: Store one allergy per row; do not keep "Penicillin, Dust" in one cell.
-- 2NF: Remove attributes that depend on only part of the composite key.
-- 3NF: Remove transitive dependencies such as PatientID -> PatientName.

CREATE DATABASE IF NOT EXISTS DBMS_Normalization;
USE DBMS_Normalization;

-- Drop tables in child-to-parent order so the script can run again.
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

-- -------------------------
-- FIRST NORMAL FORM (1NF)
-- -------------------------
-- Each allergy is stored as a separate atomic value.
-- The same prescription medicine line repeats for each allergy.
-- "None" represents the patient with no recorded allergy in the source.

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

INSERT INTO t10_1nf VALUES
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

-- -------------------------
-- SECOND NORMAL FORM (2NF)
-- -------------------------
-- Prescription and medicine details are separated from the composite-key line.
-- PatientName remains with the prescription here; it is moved in 3NF.

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

INSERT INTO t10_2nf_prescription VALUES
('RX1','P1','Rina Sen'),
('RX2','P2','Jamal Uddin'),
('RX3','P1','Rina Sen');

INSERT INTO t10_2nf_medicine VALUES
('M1','Paracetamol 500'),
('M2','Azithromycin 250'),
('M3','Omeprazole 20');

INSERT INTO t10_2nf_prescription_medicine VALUES
('RX1','M1','1-1-1',5),
('RX1','M2','1-0-0',3),
('RX2','M1','1-0-1',4),
('RX3','M3','1-0-0',14),
('RX3','M1','0-0-1',3);

INSERT INTO t10_2nf_patient_allergy VALUES
('P1','Penicillin'),
('P1','Dust');

-- -------------------------
-- THIRD NORMAL FORM (3NF)
-- -------------------------
-- PatientName depends on PatientID, so patient details get their own table.
-- Each table stores facts about one entity or relationship.

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

INSERT INTO t10_patient VALUES
('P1','Rina Sen'),
('P2','Jamal Uddin');

INSERT INTO t10_patient_allergy VALUES
('P1','Penicillin'),
('P1','Dust');

INSERT INTO t10_medicine VALUES
('M1','Paracetamol 500'),
('M2','Azithromycin 250'),
('M3','Omeprazole 20');

INSERT INTO t10_prescription VALUES
('RX1','P1'),
('RX2','P2'),
('RX3','P1');

INSERT INTO t10_prescription_medicine VALUES
('RX1','M1','1-1-1',5),
('RX1','M2','1-0-0',3),
('RX2','M1','1-0-1',4),
('RX3','M3','1-0-0',14),
('RX3','M1','0-0-1',3);

-- Verify final 3NF tables
SELECT * FROM t10_patient;
SELECT * FROM t10_patient_allergy;
SELECT * FROM t10_medicine;
SELECT * FROM t10_prescription;
SELECT * FROM t10_prescription_medicine;
