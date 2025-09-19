-- clinic_schema.sql
-- Clinic Booking System schema with sample data
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

-- Services table
CREATE TABLE services (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  description TEXT,
  duration_minutes INT NOT NULL DEFAULT 30,
  price DECIMAL(10,2) DEFAULT 0.00,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Many-to-many: doctors <-> services
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

CREATE UNIQUE INDEX ux_doctor_datetime ON appointments(doctor_id, appointment_datetime);

-- Prescriptions
CREATE TABLE prescriptions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT NOT NULL,
  medication VARCHAR(255) NOT NULL,
  dosage VARCHAR(100),
  instructions TEXT,
  prescribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================
-- SEED DATA
-- ==============================

-- 20 Patients
INSERT INTO patients(first_name, last_name, email, phone, dob, address) VALUES
('John','Kamau','john.kamau@example.com','+254700000001','1990-01-12','Nairobi'),
('Mary','Wanjiru','mary.wanjiru@example.com','+254700000002','1988-05-22','Nakuru'),
('Peter','Otieno','peter.otieno@example.com','+254700000003','1992-11-15','Mombasa'),
('Alice','Mwangi','alice.mwangi@example.com','+254700000004','1985-07-10','Kisumu'),
('James','Mutua','james.mutua@example.com','+254700000005','1993-03-09','Thika'),
('Grace','Achieng','grace.achieng@example.com','+254700000006','1991-02-14','Eldoret'),
('Samuel','Maina','samuel.maina@example.com','+254700000007','1989-12-01','Naivasha'),
('Rose','Njeri','rose.njeri@example.com','+254700000008','1994-09-20','Nanyuki'),
('David','Mworia','david.mworia@example.com','+254700000009','1990-04-11','Meru'),
('Ann','Chebet','ann.chebet@example.com','+254700000010','1987-08-18','Kericho'),
('Joseph','Barasa','joseph.barasa@example.com','+254700000011','1992-06-29','Kakamega'),
('Esther','Nyambura','esther.nyambura@example.com','+254700000012','1991-05-13','Kiambu'),
('Michael','Koech','michael.koech@example.com','+254700000013','1986-10-24','Bomet'),
('Caroline','Atieno','caroline.atieno@example.com','+254700000014','1990-12-02','Kisii'),
('Daniel','Njenga','daniel.njenga@example.com','+254700000015','1989-07-30','Machakos'),
('Lucy','Mumbi','lucy.mumbi@example.com','+254700000016','1993-01-17','Nyeri'),
('George','Omollo','george.omollo@example.com','+254700000017','1985-04-25','Siaya'),
('Janet','Kimutai','janet.kimutai@example.com','+254700000018','1992-09-14','Kerugoya'),
('Patrick','Mwangi','patrick.mwangi@example.com','+254700000019','1988-02-05','Murang’a'),
('Diana','Mutiso','diana.mutiso@example.com','+254700000020','1991-03-19','Kitui');

-- 20 Doctors
INSERT INTO doctors(first_name, last_name, specialty, email, phone) VALUES
('Alice','Mwangi','General Practitioner','alice.mwangi@clinic.com','+254711111001'),
('James','Otieno','Pediatrics','james.otieno@clinic.com','+254711111002'),
('Sarah','Kariuki','Dermatology','sarah.kariuki@clinic.com','+254711111003'),
('David','Njoroge','Cardiology','david.njoroge@clinic.com','+254711111004'),
('Jane','Wambui','Dentistry','jane.wambui@clinic.com','+254711111005'),
('Paul','Mwangi','Orthopedics','paul.mwangi@clinic.com','+254711111006'),
('Emily','Chebet','Gynecology','emily.chebet@clinic.com','+254711111007'),
('Brian','Omolo','Neurology','brian.omolo@clinic.com','+254711111008'),
('Grace','Mutheu','ENT','grace.mutheu@clinic.com','+254711111009'),
('Daniel','Koech','Oncology','daniel.koech@clinic.com','+254711111010'),
('Catherine','Nyaga','Ophthalmology','catherine.nyaga@clinic.com','+254711111011'),
('Peter','Kariuki','General Practitioner','peter.kariuki@clinic.com','+254711111012'),
('Lucy','Njoroge','Pediatrics','lucy.njoroge@clinic.com','+254711111013'),
('Michael','Mworia','Dermatology','michael.mworia@clinic.com','+254711111014'),
('Beatrice','Atieno','Cardiology','beatrice.atieno@clinic.com','+254711111015'),
('Joseph','Muriithi','Dentistry','joseph.muriithi@clinic.com','+254711111016'),
('Esther','Kibera','Orthopedics','esther.kibera@clinic.com','+254711111017'),
('Samuel','Kimani','Gynecology','samuel.kimani@clinic.com','+254711111018'),
('Caroline','Wairimu','Neurology','caroline.wairimu@clinic.com','+254711111019'),
('Anthony','Mugo','ENT','anthony.mugo@clinic.com','+254711111020');

-- 20 Services
INSERT INTO services(name, description, duration_minutes, price) VALUES
('General Consultation','Standard GP visit',30,20.00),
('Pediatric Checkup','Child wellness check',30,25.00),
('Vaccination','Routine vaccine administration',15,10.00),
('Dental Cleaning','Teeth cleaning service',45,50.00),
('Eye Exam','Vision test and eye health check',30,40.00),
('Skin Screening','Full body skin check',30,35.00),
('Cardiac Screening','Heart health evaluation',60,70.00),
('Orthopedic Exam','Joint and bone check',45,60.00),
('Gynecology Visit','Women’s health consultation',40,55.00),
('Neurology Consultation','Brain and nerve exam',60,75.00),
('ENT Consultation','Ear, nose, and throat exam',30,30.00),
('Oncology Consultation','Cancer screening',60,80.00),
('Lab Blood Test','Routine blood test',20,15.00),
('X-ray','Radiology service',30,45.00),
('MRI Scan','Detailed imaging service',90,200.00),
('Ultrasound','Imaging service',40,70.00),
('Physiotherapy Session','Therapy for physical recovery',50,65.00),
('Nutrition Consultation','Diet planning',30,35.00),
('Mental Health Counseling','Psychology consultation',60,60.00),
('Allergy Testing','Comprehensive allergy test',45,55.00);

-- Assign doctors to services randomly (at least 2 services each)
INSERT INTO doctor_services(doctor_id, service_id) VALUES
(1,1),(1,3),(1,13),
(2,2),(2,3),(2,18),
(3,6),(3,19),
(4,7),(4,13),
(5,4),(5,14),
(6,8),(6,17),
(7,9),(7,16),
(8,10),(8,15),
(9,11),(9,20),
(10,12),(10,14),
(11,5),(11,15),
(12,1),(12,13),
(13,2),(13,3),
(14,6),(14,7),
(15,4),(15,13),
(16,8),(16,17),
(17,9),(17,16),
(18,10),(18,15),
(19,11),(19,20),
(20,12),(20,19);

-- 20 Appointments (distributed across patients/doctors/services)
INSERT INTO appointments(patient_id, doctor_id, service_id, appointment_datetime, duration_minutes, status, notes) VALUES
(1,1,1,'2025-09-25 09:00:00',30,'scheduled','Initial visit'),
(2,2,2,'2025-09-25 10:00:00',30,'scheduled','Child checkup'),
(3,5,4,'2025-09-25 11:00:00',45,'completed','Dental cleaning'),
(4,4,7,'2025-09-26 09:30:00',60,'scheduled','Cardiac screening'),
(5,3,6,'2025-09-26 11:00:00',30,'cancelled','Skin check rescheduled'),
(6,7,9,'2025-09-27 09:00:00',40,'scheduled','Gynecology appointment'),
(7,8,10,'2025-09-27 10:00:00',60,'scheduled','Neurology consultation'),
(8,9,11,'2025-09-27 11:00:00',30,'scheduled','ENT visit'),
(9,10,12,'2025-09-28 09:30:00',60,'scheduled','Oncology screening'),
(10,11,5,'2025-09-28 10:30:00',30,'completed','Eye exam'),
(11,6,8,'2025-09-28 11:30:00',45,'scheduled','Orthopedic exam'),
(12,15,4,'2025-09-29 09:00:00',45,'scheduled','Dental cleaning'),
(13,16,17,'2025-09-29 10:00:00',50,'scheduled','Physiotherapy'),
(14,17,9,'2025-09-29 11:00:00',40,'scheduled','Women’s health'),
(15,18,10,'2025-09-30 09:30:00',60,'scheduled','Neurology follow-up'),
(16,19,11,'2025-09-30 10:30:00',30,'scheduled','ENT exam'),
(17,20,12,'2025-09-30 11:30:00',60,'scheduled','Oncology check'),
(18,13,2,'2025-10-01 09:00:00',30,'scheduled','Child visit'),
(19,14,6,'2025-10-01 10:00:00',30,'scheduled','Skin check'),
(20,12,1,'2025-10-01 11:00:00',30,'scheduled','General consultation');

