# Clinic Booking System Database (MySQL)

## Project Overview
This deliverable implements a full relational database for a **Clinic Booking System** using MySQL.  
The single SQL file `clinic_schema.sql` contains everything required to create the database, tables, constraints, and optional sample data.

---

## Deliverable
- **`clinic_schema.sql`**
  - `CREATE DATABASE` statement  
  - `USE` statement to select the database  
  - `CREATE TABLE` statements for all entities  
  - Primary keys, foreign keys, unique constraints, not nulls, and indexes  
  - Optional seed data (sample rows) to help with testing  

---

## Use Case Summary
The Clinic Booking System manages patients, doctors, services, appointments, and prescriptions.  

### Relationships:
- One patient can have many appointments.  
- One doctor can have many appointments.  
- Many doctors can offer many services (many-to-many via `doctor_services`).  
- Appointments can have multiple prescriptions linked.  

---

## Schema Summary (Tables and Purpose)
- **`patients`** → patient personal details and contact info.  
- **`doctors`** → doctor names, specialty, contact.  
- **`services`** → clinic services, duration and price.  
- **`doctor_services`** → junction table mapping doctors to services (many-to-many).  
- **`appointments`** → scheduled visits with patient, doctor, service, datetime, duration, and status.  
- **`prescriptions`** → medicines prescribed, linked to appointments.  

---

## Key Constraints and Rules
- **Primary Keys**: every table uses an integer `AUTO_INCREMENT` primary key (except junction tables which use composite PKs).  
- **Foreign Keys**:
  - `patients -> appointments`: `ON DELETE CASCADE`  
  - `doctors -> appointments`: `ON DELETE RESTRICT`  
  - `services -> appointments`: `ON DELETE RESTRICT`  
  - `doctor_services`: `ON DELETE CASCADE`  
- **Unique Constraints**:
  - `patients.email` and `doctors.email` are unique.  
  - `(doctor_id, appointment_datetime)` unique to avoid double booking at the same time.  
- **Not Null**: applied to required fields (names, datetime, foreign keys).  
- **ENUM**: `appointments.status` → `('scheduled','checked_in','completed','cancelled','no_show')`.  

---

## How to Run
1. Ensure MySQL server is installed and running.  
2. Open terminal and run:  
   ```bash
   mysql -u <your_mysql_user> -p < clinic_schema.sql
