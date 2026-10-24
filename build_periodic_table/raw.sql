-- How to run this script
-- psql --username=freecodecamp --dbname=periodic_table
-- \i raw_sql.sql

-- weight to atomic_mass at properties table
ALTER TABLE properties
  RENAME COLUMN weight TO atomic_mass; 

-- melting_point to melting_point_celcius at properties table
ALTER TABLE properties
  RENAME COLUMN melting_point TO melting_point_celsius; 

-- boiling_point to boiling_point_celcius at properties table
ALTER TABLE properties
  RENAME COLUMN boiling_point TO boiling_point_celsius;

-- add Not Null Constraint to melting dan boiling point columns
ALTER TABLE properties
  ALTER COLUMN melting_point_celsius SET NOT NULL,
  ALTER COLUMN boiling_point_celsius SET NOT NULL;

-- add UNIQUE CONSTRAINT and NOT NULL to symbol and name in elements table
ALTER TABLE elements
  ADD CONSTRAINT unique_symbol UNIQUE (symbol),
  ADD CONSTRAINT unique_name UNIQUE ("name"),
  ALTER COLUMN symbol SET NOT NULL,
  ALTER COLUMN "name" SET NOT NULL;

-- Create FK from properties to elements by atomic_number
ALTER TABLE properties
  ADD CONSTRAINT fk_properties_elements
  FOREIGN KEY (atomic_number)
  REFERENCES elements(atomic_number);

-- create table types
CREATE TABLE IF NOT EXISTS types (
  type_id SERIAL PRIMARY KEY,
  "type" VARCHAR(100) NOT NULL UNIQUE
);

-- insert type to types table from properties table
INSERT INTO types ("type")
SELECT DISTINCT "type"
FROM properties
ON CONFLICT ("type") DO NOTHING;

-- create type_id in properties and make a relation to types
ALTER TABLE properties
  ADD COLUMN type_id INT REFERENCES types(type_id);

-- insert type_id in properties
UPDATE properties p
SET type_id = t.type_id
FROM types t
WHERE p.type = t.type;

-- Add Not Null Constraint to type_id
ALTER TABLE properties
  ALTER COLUMN type_id SET NOT NULL;

-- capitalize first letter in symbol at elements table
UPDATE elements
SET symbol = INITCAP(symbol);

-- Change atomic_mass to DECIMAL for removing the trailing zeros
ALTER TABLE properties
  ALTER COLUMN atomic_mass TYPE DECIMAL;

-- Add New Element Atomic Number 9
INSERT INTO elements(atomic_number, symbol, "name") 
VALUES (9, 'F', 'Fluorine')
ON CONFLICT (atomic_number) DO NOTHING;

INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) 
SELECT 9, 18.998, -220, -188.1, t.type_id 
FROM types t 
WHERE t.type = 'nonmetal'
ON CONFLICT (atomic_number) DO NOTHING;

-- Add New Element Atomic Number 10
INSERT INTO elements(atomic_number, symbol, "name") 
VALUES (10, 'Ne', 'Neon')
ON CONFLICT (atomic_number) DO NOTHING;

INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) 
SELECT 10, 20.18, -248.6, -246.1, t.type_id 
FROM types t 
WHERE t.type = 'nonmetal'
ON CONFLICT (atomic_number) DO NOTHING;

-- Remove Trailing Zero
UPDATE properties
SET atomic_mass = atomic_mass::float;
