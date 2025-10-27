CREATE DATABASE IF NOT EXISTS healthcare_src;
USE healthcare_src;

DROP TABLE IF EXISTS appointments_src;
DROP TABLE IF EXISTS rooms_src;
DROP TABLE IF EXISTS insurance_src;

CREATE TABLE rooms_src (
  room_id       INT PRIMARY KEY,
  room_number   VARCHAR(10) NOT NULL,
  department    VARCHAR(50) NOT NULL,
  floor_number  INT NOT NULL
);

CREATE TABLE insurance_src (
  insurance_id   INT PRIMARY KEY,
  provider_name  VARCHAR(50) NOT NULL,
  plan_type      VARCHAR(30) NOT NULL,
  coverage_level VARCHAR(20) NOT NULL
);

CREATE TABLE appointments_src (
  appointment_id    INT PRIMARY KEY,
  doctor_id         INT NOT NULL,
  patient_id        INT NOT NULL,
  room_id           INT NOT NULL,
  insurance_id      INT NOT NULL,
  appointment_ts    DATETIME NOT NULL,
  visit_type        VARCHAR(50) NOT NULL,
  duration_minutes  INT NOT NULL,
  cost_usd          DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (room_id) REFERENCES rooms_src(room_id),
  FOREIGN KEY (insurance_id) REFERENCES insurance_src(insurance_id)
);

INSERT INTO rooms_src (room_id, room_number, department, floor_number) VALUES
(1, 'A101', 'Cardiology', 1),
(2, 'B202', 'Neurology', 2),
(3, 'C303', 'Orthopedics', 3);

INSERT INTO insurance_src (insurance_id, provider_name, plan_type, coverage_level) VALUES
(1, 'BlueCross', 'PPO', 'High'),
(2, 'UnitedHealth', 'HMO', 'Medium'),
(3, 'Aetna', 'EPO', 'Low');

INSERT INTO appointments_src
(appointment_id, doctor_id, patient_id, room_id, insurance_id,
 appointment_ts, visit_type, duration_minutes, cost_usd)
VALUES
(1, 101, 201, 1, 1, '2025-01-03 09:00:00', 'checkup',   30, 120.00),
(2, 101, 202, 2, 2, '2025-01-03 10:00:00', 'follow-up', 20,  85.00),
(3, 102, 203, 3, 1, '2025-02-14 13:30:00', 'consult',   45, 200.00),
(4, 103, 204, 2, 3, '2025-03-01 08:45:00', 'checkup',   30, 115.00),
(5, 102, 205, 1, 2, '2025-03-15 11:15:00', 'follow-up', 25,  95.00),
(6, 101, 206, 3, 1, '2025-04-22 15:00:00', 'consult',   60, 260.00);

SELECT 'rooms_src' AS table_name, COUNT(*) AS rows_in_table FROM rooms_src
UNION ALL
SELECT 'insurance_src', COUNT(*) FROM insurance_src
UNION ALL
SELECT 'appointments_src', COUNT(*) FROM appointments_src;

SELECT a.appointment_id, a.appointment_ts, r.department, i.provider_name, a.cost_usd
FROM appointments_src a
JOIN rooms_src r USING (room_id)
JOIN insurance_src i USING (insurance_id)
ORDER BY a.appointment_ts;
