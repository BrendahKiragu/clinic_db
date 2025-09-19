-- clinic_schema.sql
-- Clinic Booking System schema
-- Run: mysql -u root -p < clinic_schema.sql

DROP DATABASE IF EXISTS clinic_db;
CREATE DATABASE clinic_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE clinic_db;

-- Patients table
CREATE TABLE patients (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(20),
  dob DATE,
  address VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Doctors table
CREATE TABLE doctors (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  specialty VARCHAR(100),
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Services table (e.g., Consultation, X-ray, Vaccination)
CREATE TABLE services (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  description TEXT,
  duration_minutes INT NOT NULL DEFAULT 30,
  price DECIMAL(10,2) DEFAULT 0.00,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Many-to-many: doctors <-> services (which doctor offers which service)
CREATE TABLE doctor_services (
  doctor_id INT NOT NULL,
  service_id INT NOT NULL,
  PRIMARY KEY (doctor_id, service_id),
  FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Appointments table
CREATE TABLE appointments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  doctor_id INT NOT NULL,
  service_id INT NOT NULL,
  appointment_datetime DATETIME NOT NULL,
  duration_minutes INT NOT NULL,
  status ENUM('scheduled','checked_in','completed','cancelled','no_show') DEFAULT 'scheduled',
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Prevent double-booking a doctor at the same exact datetime
-- (Assumes appointments are identified by start time; for production you'd also consider overlapping intervals)
CREATE UNIQUE INDEX ux_doctor_datetime ON appointments(doctor_id, appointment_datetime);

-- Prescriptions (optional: linked to appointment)
CREATE TABLE prescriptions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT NOT NULL,
  medication VARCHAR(255) NOT NULL,
  dosage VARCHAR(100),
  instructions TEXT,
  prescribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Sample seed data (optional)
INSERT INTO doctors(first_name, last_name, specialty, email, phone)
VALUES ('Alice', 'Mwangi', 'General Practitioner', 'alice.mwangi@clinic.example', '+254700000001'),
       ('James', 'Otieno', 'Pediatrics', 'james.otieno@clinic.example', '+254700000002');

INSERT INTO services(name, description, duration_minutes, price)
VALUES ('General Consultation', 'Standard GP visit', 30, 20.00),
       ('Pediatric Checkup', 'Child wellness check', 30, 25.00),
       ('Vaccination', 'Routine vaccine administration', 15, 10.00);

-- Link doctors to services
INSERT INTO doctor_services(doctor_id, service_id) VALUES
(1, 1), (1, 3), -- Dr Alice: Consultation, Vaccination
(2, 2), (2, 3); -- Dr James: Pediatrics, Vaccination

-- A sample patient and appointment
INSERT INTO patients(first_name, last_name, email, phone, dob, address)
VALUES ('John', 'Kamau', 'john.kamau@example.com', '+254700000003', '1990-04-12', 'Nairobi');

INSERT INTO appointments(patient_id, doctor_id, service_id, appointment_datetime, duration_minutes, status, notes)
VALUES (1, 1, 1, '2025-09-30 10:00:00', 30, 'scheduled', 'First visit');
