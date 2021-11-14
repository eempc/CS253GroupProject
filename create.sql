-- Create Tables

--- Drop Tables Here
DROP TABLE IF EXISTS StaffAssignment;
DROP TABLE IF EXISTS PetAssignment;
DROP TABLE IF EXISTS Appointment
DROP TABLE IF EXISTS Pet;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Person;
DROP TRIGGER IF EXISTS DetectReceptionist;

--- Create Tables Here
CREATE TABLE Person (
    person_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    address_first_line VARCHAR(100),
    city VARCHAR(20) DEFAULT 'Glasgow',
    postcode VARCHAR(8), -- Could try to constrain characters, or create a new table for postcodes
    mobile_phone CHAR(4) UNIQUE
);

CREATE TABLE Staff (
    person_id INT PRIMARY REFERENCES Person(person_id),
    position VARCHAR(20) NOT NULL, -- ideally should be an enum from the back end code
    ni_number CHAR(9) NOT NULL UNIQUE,
    salary NUMERIC NOT NULL CHECK (salary > 0),
    start_date DATE NOT NULL
);

CREATE TABLE Customer (
    person_id INT PRIMARY KEY REFERENCES Person(person_id),
    registration_date DATE NOT NULL
);

CREATE TABLE Pet (
    pet_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL DEFAULT 'Unknown',
    belongs_to INT REFERENCES Customer(person_id),
    date_of_birth DATE,
    sex CHAR(1) NOT NULL CHECK (sex IN ('M', 'F'))
);

CREATE TABLE Cat (
    pet_id INT PRIMARY KEY REFERENCES Pet(pet_id),
    is_indoor BOOLEAN,
    subtype VARCHAR(20)
);

CREATE TABLE Dog (
    pet_id INT PRIMARY KEY REFERENCES Pet(pet_id),
    pure_breed BOOLEAN,
    breed VARCHAR(50)
);

CREATE TABLE OtherPet (
    pet_id INT PRIMARY KEY REFERENCES Pet(pet_id),
    species VARCHAR(50)
);

CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    customer_id INT REFERENCES Customer(person_id),
    start_dt DATETIME NOT NULL,
    end_dt DATETIME NOT NULL
);

CREATE TABLE PetAssignment (
    pet_id INT REFERENCES Pet(pet_id),
    appointment_id INT REFERENCES Appointment(appointment_id),
    PRIMARY KEY(pet_id, appointment_id)
);

CREATE TABLE StaffAssignment (
    person_id INT REFERENCES Staff(person_id),
    appointment_id INT REFERENCES Appointment(appointment_id),
    PRIMARY KEY(person_id, appointment_id)
);

--- Alter Tables if necessary

CREATE OR REPLACE FUNCTION PreventReceptionist()
RETURNS trigger AS
$$
BEGIN
    IF (SELECT position FROM Staff WHERE NEW.person_id = staff.person_id) = 'Receptionist' THEN
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

CREATE OR REPLACE FUNCTION PreventInvalidAppointment()
RETURNS trigger AS
$$
BEGIN
    IF NEW.end < NEW.start THEN
        RAISE EXCEPTION 'Meow, you seem to have mixed up start and end date times';
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER DetectInvalidAppointment
BEFORE INSERT OR UPDATE
ON Appointment
FOR EACH ROW
EXECUTE PROCEDURE PreventInvalidAppointment();