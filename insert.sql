-- Insert example data into tables

INSERT INTO Person VALUES
    ('Anne', '1 Alpha Street', 'Glasgow', 'G11AA', '0111'),
    ('Bob', '2 Beta Road', 'Glasgow', 'G22BB', '0222'),
    ('Cathy', '3 Gamma Avenue', 'Greenock', 'PA11AA', '0333');

-- Do some tests to ensure that invalid values cannot be inserted
INSERT INTO Person VALUES
    ('XXX', 'XXX', 'XXX', 'XX'); -- this should produce postcode error

INSERT INTO Customer VALUES
    (1, '2021-01-01');

SELECT * FROM Person, Customer WHERE Person.person_id = Customer.person_id;

INSERT INTO Staff VALUES
    (3, 'Vet', 'AA111111A', 30000, '2015-06-06');

