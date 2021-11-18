-- Write at least 3 queries
---

-- Get a list of vets who are available between the two times specified in the query
SELECT *
FROM Staff, Person
WHERE Staff.staff_id = Person.person_id
AND Staff.position = 'Vet'
AND Staff.staff_id NOT IN (
    SELECT StaffAssignment.staff_id
    FROM Appointment, StaffAssignment
    WHERE Appointment.appointment_id = StaffAssignment.appointment_id
    AND NOT (Appointment.end_dt < '2021-10-15 09:00' OR Appointment.start_dt > '2021-10-15 10:00')
);

-- Get a list of vets who are busy between the two times in the query
SELECT *
FROM Staff, Person
WHERE Staff.staff_id = Person.person_id
AND Staff.position = 'Vet'
AND Staff.staff_id IN (
    SELECT StaffAssignment.staff_id
    FROM Appointment, StaffAssignment
    WHERE Appointment.appointment_id = StaffAssignment.appointment_id
    AND NOT (Appointment.end_dt < '2021-10-15 09:00' OR Appointment.start_dt > '2021-10-15 10:00')
);

-- Get longest, shortest and average length of appointment
SELECT AVG(end_dt - start_dt), MAX(end_dt - start_dt), MIN(end_dt - start_dt)
FROM Appointment;

-- How many males cats and female cats?
SELECT Pet.sex, COUNT(*) AS CatCount
FROM Pet, Cat
WHERE Pet.pet_id = Cat.cat_id
GROUP BY Pet.sex;

SELECT Pet.sex, COUNT(*) AS CatCount
FROM Pet, Cat
WHERE Pet.pet_id = Cat.cat_id
GROUP BY Pet.sex
HAVING COUNT(*) > 1;

-- Average salary of each position

SELECT position, AVG(salary) AS AvgSalary
FROM Staff
GROUP BY position;


-- Any pets ever only been to one appointment?
SELECT Pet.name, COUNT(*) 
FROM Pet, PetAssignment 
WHERE Pet.pet_id = PetAssignment.pet_id 
GROUP BY Pet.name 
HAVING COUNT(*) = 1;

-- Which staff members are slacking off and have never been on an appointment?
-- Do not include receptionists as they should be at their desk at all times
-- The return number 1 is for efficiency, you can use * instead but it makes no difference to the row count
SELECT staff_id, name, position, salary
FROM Staff, Person
WHERE Staff.staff_id = Person.person_id
AND Staff.position <> 'Receptionist'
AND NOT EXISTS (
    SELECT 1 
    FROM StaffAssignment 
    WHERE Staff.staff_id = StaffAssignment.staff_id 
);

SELECT *
FROM Staff
WHERE EXISTS (
    SELECT 1 FROM StaffAssignment WHERE Staff.staff_id = StaffAssignment.staff_id
);