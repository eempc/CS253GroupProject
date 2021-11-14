-- Insert example data into tables
-- 

INSERT INTO Person VALUES
    (1, 'Anne', '1 Alpha Street', 'Glasgow', 'G11AA', '0111'),
    (2, 'Bob', '2 Beta Road', 'Glasgow', 'G22BB', '0222'),
    (3, 'Cathy', '3 Gamma Avenue', 'Greenock', 'PA11AA', '0333'),
    (4, 'Dave', '4 Delta Road', 'Edinburgh', 'EH58BB', '0444'),
    (5, 'Enid', '5 Epsilon Lane', 'Stirling', 'S11AA', '0555');

INSERT INTO Customer VALUES
    (1, '2020-01-01'),
    (2, '2020-02-02'),
    (3, '2020-03-03');

INSERT INTO Staff VALUES
    (3, 'Receptionist', 'AA111111A', 30000, '2013-03-03'),
    (4, 'Technician', 'BB222222B', 20000, '2014-04-04'),
    (5, 'Vet', 'CC333333C', 20000, '2015-05-05');

INSERT INTO Pet VALUES
    (1, 'Mittens', 1, '2019-01-01', 'M'),
    (2, 'Waffles', 2, '2019-02-02', 'F'),
    (3, 'Kitty', 3, '2019-03-03', 'F');

INSERT INTO Cat VALUES
    (1, true, 'Tabby'),
    (2, false, 'Calico'),
    (3, true, 'Tortoiseshell');

INSERT INTO Appointment VALUES
    (1, 1, '2021-10-15 09:00', '2021-10-15 09:30');

INSERT INTO PetAssignment VALUES
    (1, 1);

INSERT INTO StaffAssignment VALUES
    (5, 1);

SELECT * FROM Person, Customer WHERE Person.person_id = Customer.person_id;
SELECT * FROM Person, Staff WHERE Person.person_id = Staff.person_id;
SELECT * FROM Pet, Cat WHERE Pet.pet_id = Cat.pet_id;

SELECT Appointment.appointment_id, Appointment.customer_id, Appointment.start_dt, PetAssignment.pet_id, StaffAssignment.person_id 
FROM Appointment, PetAssignment, StaffAssignment
WHERE Appointment.appointment_id = PetAssignment.appointment_id
AND Appointment.appointment_id = StaffAssignment.appointment_id;

-- Validity Checks
--- Check invalid salary
UPDATE Staff SET salary = -5000 WHERE person_id = 5;

-- Check invalid pet sex
UPDATE Pet SET sex = 'X' WHERE pet_id = 1;

--- Check invalid appointment date times
INSERT INTO Appointment VALUES (1000, 1, '2021-01-01 09:00', '2021-01-01 08:00');
UPDATE Appointment SET start_dt = '2021-10-15 09:30' WHERE appointment_id = 1;

--- Check adding a receptionist to appointments
INSERT INTO StaffAssignment VALUES (3, 1);