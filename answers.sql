-- USE ClinicBookingSystem;
-- CREATE DATABASE hospital;

USE hospital;
-- Patients table to Store information about patients
-- CREATE TABLE Patients (
--     patient_id INT AUTO_INCREMENT PRIMARY KEY,
--     first_name VARCHAR(50) NOT NULL,
--     last_name VARCHAR(50) NOT NULL,
--     date_of_birth DATE NOT NULL,
--     gender ENUM('Male', 'Female', 'Other') NOT NULL,
--     address VARCHAR(100),
--     city VARCHAR(50),
--     state VARCHAR(50),
--     postal_code VARCHAR(20),
--     country VARCHAR(50) DEFAULT 'United States',
--     phone VARCHAR(20) NOT NULL,
--     email VARCHAR(100) UNIQUE,
--     insurance_provider VARCHAR(50),
--     insurance_policy_number VARCHAR(50),
--     registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
--     CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
-- ); -- 'Stores patient demographic and contact information';



-- Doctors table: Stores information about healthcare providers
-- CREATE TABLE Doctors (
-- doctor_id INT AUTO_INCREMENT PRIMARY KEY,
--     first_name VARCHAR(50) NOT NULL,
--     last_name VARCHAR(50) NOT NULL,
--     specialization VARCHAR(100) NOT NULL,
--     phone VARCHAR(20) NOT NULL,
--     email VARCHAR(100) UNIQUE NOT NULL,
--     license_number VARCHAR(50) UNIQUE NOT NULL,
--     hire_date DATE NOT NULL,
--     status ENUM('Active', 'On Leave', 'Inactive') DEFAULT 'Active',
--     bio TEXT,
--     CONSTRAINT chk_doctor_email CHECK (email LIKE '%@%.%')
-- ); -- To Store information about doctors and their specialties;



-- -- Clinics table: Stores information about clinic locations
-- CREATE TABLE Clinics (
--     clinic_id INT AUTO_INCREMENT PRIMARY KEY,
--     clinic_name VARCHAR(100) NOT NULL,
--     address VARCHAR(100) NOT NULL,
--     city VARCHAR(50) NOT NULL,
--     state VARCHAR(50) NOT NULL,
--     postal_code VARCHAR(20) NOT NULL,
--     country VARCHAR(50) DEFAULT 'United States',
--     phone VARCHAR(20) NOT NULL,
--     email VARCHAR(100),
--     opening_time TIME NOT NULL,
--     closing_time TIME NOT NULL,
--     CONSTRAINT chk_clinic_hours CHECK (closing_time > opening_time)
-- ); -- Stores information about clinic locations and operating hours;



-- -- Doctor_Clinic_Assignments table: Manages many-to-many relationship between doctors and clinics
-- CREATE TABLE Doctor_Clinic_Assignments (
--     assignment_id INT AUTO_INCREMENT PRIMARY KEY,
--     doctor_id INT NOT NULL,
--     clinic_id INT NOT NULL,
--     day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
--     start_time TIME NOT NULL,
--     end_time TIME NOT NULL,
--     CONSTRAINT fk_dca_doctor FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
--     CONSTRAINT fk_dca_clinic FOREIGN KEY (clinic_id) REFERENCES Clinics(clinic_id) ON DELETE CASCADE,
--     CONSTRAINT chk_assignment_hours CHECK (end_time > start_time),
--     CONSTRAINT uc_doctor_clinic_schedule UNIQUE (doctor_id, clinic_id, day_of_week, start_time)
-- ); -- Manages which doctors work at which clinics and their schedules';



-- -- Appointments table: Tracks patient appointments
-- CREATE TABLE Appointments (
--     appointment_id INT AUTO_INCREMENT PRIMARY KEY,
--     patient_id INT NOT NULL,
--     doctor_id INT NOT NULL,
--     clinic_id INT NOT NULL,
--     appointment_date DATE NOT NULL,
--     start_time TIME NOT NULL,
--     end_time TIME NOT NULL,
--     status ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
--     reason VARCHAR(255) NOT NULL,
--     notes TEXT,
--     created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
--     updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--     CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
--     CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
--     CONSTRAINT fk_appointment_clinic FOREIGN KEY (clinic_id) REFERENCES Clinics(clinic_id) ON DELETE CASCADE,
--     CONSTRAINT chk_appointment_duration CHECK (end_time > start_time),
--     CONSTRAINT uc_doctor_time_slot UNIQUE (doctor_id, appointment_date, start_time)
-- ); -- Tracks all scheduled appointments with patients;



-- -- Medical_Records table: Stores patient medical history
-- CREATE TABLE Medical_Records (
--     record_id INT AUTO_INCREMENT PRIMARY KEY,
--     patient_id INT NOT NULL,
--     doctor_id INT NOT NULL,
--     appointment_id INT,
--     record_date DATETIME DEFAULT CURRENT_TIMESTAMP,
--     diagnosis TEXT NOT NULL,
--     treatment TEXT,
--     prescription TEXT,
--     notes TEXT,
--     CONSTRAINT fk_mr_patient FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
--     CONSTRAINT fk_mr_doctor FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
--     CONSTRAINT fk_mr_appointment FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE SET NULL
-- ); -- Stores patient medical records and treatment history;



-- -- Prescriptions table: Tracks prescribed medications
-- CREATE TABLE Prescriptions (
--     prescription_id INT AUTO_INCREMENT PRIMARY KEY,
--     record_id INT NOT NULL,
--     medication_name VARCHAR(100) NOT NULL,
--     dosage VARCHAR(50) NOT NULL,
--     frequency VARCHAR(50) NOT NULL,
--     start_date DATE NOT NULL,
--     end_date DATE,
--     instructions TEXT,
--     refills_remaining INT DEFAULT 0,
--     CONSTRAINT fk_prescription_record FOREIGN KEY (record_id) REFERENCES Medical_Records(record_id) ON DELETE CASCADE
-- ); -- Tracks prescribed medications for patients';



-- Billing table: Manages patient invoices and payments
-- CREATE TABLE Billing (
--     bill_id INT AUTO_INCREMENT PRIMARY KEY,
--     patient_id INT NOT NULL,
--     appointment_id INT,
--     total_amount DECIMAL(10, 2) NOT NULL,
--     insurance_covered DECIMAL(10, 2) DEFAULT 0,
--     patient_owed DECIMAL(10, 2) GENERATED ALWAYS AS (total_amount - insurance_covered) STORED,
--     payment_status ENUM('Unpaid', 'Partially Paid', 'Paid in Full') DEFAULT 'Unpaid',
--     billing_date DATETIME DEFAULT CURRENT_TIMESTAMP,
--     due_date DATE NOT NULL,
--     CONSTRAINT fk_billing_patient FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
--     CONSTRAINT fk_billing_appointment FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE SET NULL,
--     CONSTRAINT chk_amounts CHECK (total_amount >= 0 AND insurance_covered >= 0)
-- ); -- Manages patient billing information;



-- -- Payments table: Records payments made by patients
-- CREATE TABLE Payments (
--     payment_id INT AUTO_INCREMENT PRIMARY KEY,
--     bill_id INT NOT NULL,
--     payment_amount DECIMAL(10, 2) NOT NULL,
--     payment_method ENUM('Cash', 'Credit Card', 'Debit Card', 'Insurance', 'Check', 'Bank Transfer') NOT NULL,
--     payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
--     transaction_reference VARCHAR(100),
--     notes TEXT,
--     CONSTRAINT fk_payment_bill FOREIGN KEY (bill_id) REFERENCES Billing(bill_id) ON DELETE CASCADE,
--     CONSTRAINT chk_payment_amount CHECK (payment_amount > 0)
-- ); -- Records payments made against patient bills';



-- -- Staff table: Stores information about clinic staff (non-doctors)
-- CREATE TABLE Staff (
--     staff_id INT AUTO_INCREMENT PRIMARY KEY,
--     first_name VARCHAR(50) NOT NULL,
--     last_name VARCHAR(50) NOT NULL,
--     role VARCHAR(50) NOT NULL,
--     phone VARCHAR(20) NOT NULL,
--     email VARCHAR(100) UNIQUE NOT NULL,
--     hire_date DATE NOT NULL,
--     status ENUM('Active', 'On Leave', 'Inactive') DEFAULT 'Active',
--     clinic_id INT,
--     CONSTRAINT fk_staff_clinic FOREIGN KEY (clinic_id) REFERENCES Clinics(clinic_id) ON DELETE SET NULL,
--     CONSTRAINT chk_staff_email CHECK (email LIKE '%@%.%')
-- ); -- Stores information about clinic administrative staff;



-- -- Inventory table: Tracks medical supplies and equipment
-- CREATE TABLE Inventory (
--     item_id INT AUTO_INCREMENT PRIMARY KEY,
--     clinic_id INT NOT NULL,
--     item_name VARCHAR(100) NOT NULL,
--     category VARCHAR(50) NOT NULL,
--     quantity INT NOT NULL DEFAULT 0,
--     reorder_level INT DEFAULT 5,
--     last_restocked DATE,
--     supplier VARCHAR(100),
--     CONSTRAINT fk_inventory_clinic FOREIGN KEY (clinic_id) REFERENCES Clinics(clinic_id) ON DELETE CASCADE,
--     CONSTRAINT chk_quantity CHECK (quantity >= 0)
-- ); -- Tracks inventory of medical supplies at each clinic';