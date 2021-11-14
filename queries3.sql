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
    AND NOT (Appointment.end_dt < '2021-10-15 09:00'
                OR
                Appointment.start_dt > '2021-10-15 10:00'
    )
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
    AND NOT (Appointment.end_dt < '2021-10-15 09:00'
                OR
                Appointment.start_dt > '2021-10-15 10:00'
    )
);

-- Get the number of appointments in a day and the average length of an appointment