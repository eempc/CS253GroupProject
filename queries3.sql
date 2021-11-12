-- Write at least 3 queries
---

-- Get a list of vets who are available between the two times specified in the query
SELECT *
FROM Staff, Person
WHERE Staff.person_id = Person.person_id
WHERE Staff.position = 'Vet'
WHERE Staff.person_id NOT IN (
    SELECT StaffAssignment.person_id
    FROM Appointment, StaffAssignment
    WHERE Appointment.appointment_id = StaffAssignment.appointment_id
    WHERE NOT (Appointment.end < '2021-01-01 09:00'
                OR
                Appointment.start > '2021-01-01 10:00'
    )
);