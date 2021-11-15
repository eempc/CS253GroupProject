-- Create Tables

-- Drop triggers here
DROP TRIGGER IF EXISTS DetectReceptionist ON StaffAssignment;

--- Drop tables here
DROP TABLE IF EXISTS StaffAssignment;
DROP TABLE IF EXISTS PetAssignment;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Cat;
DROP TABLE IF EXISTS Dog;
DROP TABLE IF EXISTS OtherPet;
DROP TABLE IF EXISTS Pet;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Person;

--- Create Tables Here
CREATE TABLE Person (
    person_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    address_first_line VARCHAR(100),
    city VARCHAR(20) DEFAULT 'Glasgow',
    postcode VARCHAR(8),
    mobile_phone CHAR(11) UNIQUE
);

CREATE TABLE Staff (
    staff_id INT PRIMARY KEY REFERENCES Person(person_id),
    position VARCHAR(20) NOT NULL, -- ideally should be an enum from the back end code
    ni_number CHAR(9) NOT NULL UNIQUE,
    salary NUMERIC NOT NULL CHECK (salary > 0),
    start_date DATE NOT NULL
);

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY REFERENCES Person(person_id),
    registration_date DATE NOT NULL
);

CREATE TABLE Pet (
    pet_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL DEFAULT 'Unknown',
    belongs_to INT REFERENCES Customer(customer_id),
    date_of_birth DATE,
    sex CHAR(1) CHECK (sex IN ('M', 'F'))
);

CREATE TABLE Cat (
    cat_id INT PRIMARY KEY REFERENCES Pet(pet_id),
    is_indoor BOOLEAN,
    subtype VARCHAR(20)
);

CREATE TABLE Dog (
    dog_id INT PRIMARY KEY REFERENCES Pet(pet_id),
    pure_breed BOOLEAN,
    breed VARCHAR(50)
);

CREATE TABLE OtherPet (
    otherpet_id INT PRIMARY KEY REFERENCES Pet(pet_id),
    species VARCHAR(50)
);

CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    customer_id INT REFERENCES Customer(customer_id),
    start_dt TIMESTAMP NOT NULL CHECK (start_dt < end_dt),
    end_dt TIMESTAMP NOT NULL CHECK (start_dt < end_dt)
);

CREATE TABLE PetAssignment (
    appointment_id INT REFERENCES Appointment(appointment_id),
    pet_id INT REFERENCES Pet(pet_id),
    PRIMARY KEY(pet_id, appointment_id)
);

CREATE TABLE StaffAssignment (
    appointment_id INT REFERENCES Appointment(appointment_id),
    staff_id INT REFERENCES Staff(staff_id),
    PRIMARY KEY(staff_id, appointment_id)
);

--- Alter Tables if necessary, add triggers and functions
CREATE OR REPLACE FUNCTION PreventReceptionist()
RETURNS trigger AS
$$
BEGIN
    IF (SELECT position FROM Staff WHERE NEW.staff_id = staff.staff_id) = 'Receptionist' THEN
        RAISE EXCEPTION 'Meow, you cannot have receptionists assigned to an appointment';
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER DetectReceptionist
BEFORE INSERT
ON StaffAssignment
FOR EACH ROW 
EXECUTE PROCEDURE PreventReceptionist();