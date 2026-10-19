CREATE DATABASE salon; -- Create Database

\c salon

-- Create Tables
CREATE TABLE customers(
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR(50) UNIQUE,
  "name" VARCHAR(200)
);

CREATE TABLE services(
  service_id SERIAL PRIMARY KEY,
  "name" VARCHAR(200)
);

CREATE TABLE appointments(
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(customer_id),
  service_id INT REFERENCES services(service_id),
  "time" VARCHAR(20)
);
-- Adding Record to Services Table
INSERT INTO services("name") VALUES
  ('cut'),
  ('color'),
  ('perm'),
  ('style'),
  ('trim');