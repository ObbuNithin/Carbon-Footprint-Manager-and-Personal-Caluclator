-- Disable foreign key checks
SET foreign_key_checks = 0;

-- Drop the existing tables (if they exist) in the correct order
DROP TABLE IF EXISTS Emission_Sources;
DROP TABLE IF EXISTS Carbon_Offsets;
DROP TABLE IF EXISTS Transportation;
DROP TABLE IF EXISTS USER;
DROP TABLE IF EXISTS ROLE;
DROP TABLE IF EXISTS Process;
DROP TABLE IF EXISTS Industries;
DROP TABLE IF EXISTS users_calc;
DROP TABLE IF EXISTS footprints;
DROP TABLE IF EXISTS dailyentry;

-- Re-enable foreign key checks
SET foreign_key_checks = 1;

-- Create Database
CREATE DATABASE IF NOT EXISTS icfms_new;

-- Use Database
USE icfms_new;

-- Create Industries table
CREATE TABLE Industries (
  industry_id int NOT NULL AUTO_INCREMENT,
  industry_name varchar(100) NOT NULL,
  location varchar(100) DEFAULT NULL,
  industry_type varchar(50) DEFAULT NULL,
  username varchar(50) DEFAULT NULL, -- Allow username to be NULL
  PRIMARY KEY (industry_id)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create Process table
CREATE TABLE Process (
  process_id int NOT NULL AUTO_INCREMENT,
  process_name varchar(100) DEFAULT NULL,
  energy_consumption decimal(10,2) DEFAULT NULL,
  emission_factor decimal(10,2) DEFAULT NULL,
  industry_id int DEFAULT NULL,
  process_date date DEFAULT NULL,
  username varchar(50) DEFAULT NULL, -- Allow username to be NULL
  PRIMARY KEY (process_id),
  KEY fk_industry_id (industry_id),
  CONSTRAINT fk_industry_id FOREIGN KEY (industry_id) REFERENCES Industries (industry_id) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create Emission_Sources table
CREATE TABLE Emission_Sources (
  source_id int NOT NULL AUTO_INCREMENT,
  source_type varchar(50) DEFAULT NULL,
  emission_value decimal(10,2) DEFAULT NULL,
  emission_date date DEFAULT NULL,
  process_id int DEFAULT NULL,
  industry_id int DEFAULT NULL,
  username varchar(50) DEFAULT NULL, -- Allow username to be NULL
  PRIMARY KEY (source_id),
  KEY process_id (process_id),
  CONSTRAINT emission_sources_ibfk_1 FOREIGN KEY (process_id) REFERENCES Process (process_id),
  CONSTRAINT fk_emission_sources_industry FOREIGN KEY (industry_id) REFERENCES Industries (industry_id)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create Carbon_Offsets table
CREATE TABLE Carbon_Offsets (
  offset_id int NOT NULL AUTO_INCREMENT,
  offset_type varchar(50) DEFAULT NULL,
  amount_offset decimal(10,2) DEFAULT NULL,
  date_purchased date DEFAULT NULL,
  provider_details varchar(100) DEFAULT NULL,
  industry_id int NOT NULL,
  username varchar(50) DEFAULT NULL, -- Allow username to be NULL
  PRIMARY KEY (offset_id),
  KEY fk_carbon_offsets_industry_id (industry_id),
  CONSTRAINT fk_carbon_offsets_industry_id FOREIGN KEY (industry_id) REFERENCES Industries (industry_id)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create ROLE table
CREATE TABLE ROLE (
  role_id int NOT NULL AUTO_INCREMENT,
  role_name varchar(50) NOT NULL,
  PRIMARY KEY (role_id)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create Transportation table
CREATE TABLE Transportation (
  transport_id int NOT NULL AUTO_INCREMENT,
  vehicle_type varchar(50) DEFAULT NULL,
  distance_travelled decimal(10,2) DEFAULT NULL,
  fuel_consumption decimal(10,2) DEFAULT NULL,
  date date DEFAULT NULL,
  industry_id int DEFAULT NULL,
  username varchar(50) DEFAULT NULL, -- Allow username to be NULL
  PRIMARY KEY (transport_id),
  KEY fk_transportation_industry_id (industry_id),
  CONSTRAINT fk_transportation_industry_id FOREIGN KEY (industry_id) REFERENCES Industries (industry_id)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create USER table
CREATE TABLE USER (
  user_id int NOT NULL AUTO_INCREMENT,
  username varchar(50) DEFAULT NULL, -- Allow username to be NULL
  email varchar(50) DEFAULT NULL,
  password varchar(255) NOT NULL,
  role_id int DEFAULT NULL,
  industry_id int DEFAULT NULL,
  warned int DEFAULT 0, -- Added warned field
  warn_emi int DEFAULT 0, -- Added warn_emi field
  PRIMARY KEY (user_id),
  KEY role_id (role_id),
  KEY fk_user_industry_id (industry_id),
  CONSTRAINT fk_user_industry_id FOREIGN KEY (industry_id) REFERENCES Industries (industry_id),
  CONSTRAINT user_ibfk_1 FOREIGN KEY (role_id) REFERENCES ROLE (role_id)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create users_calc table
CREATE TABLE users_calc (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) DEFAULT NULL, -- Allow username to be NULL
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(15) NOT NULL,
  age INT NOT NULL,
  password VARCHAR(100) NOT NULL
);

-- Create footprints table
CREATE TABLE footprints (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  
  -- Transportation fields
  car_type VARCHAR(50) DEFAULT 'Gasoline',
  car_miles FLOAT DEFAULT 0,
  bus_miles FLOAT DEFAULT 0,
  train_miles FLOAT DEFAULT 0,
  flight_miles FLOAT DEFAULT 0,
  
  -- Water usage fields
  showers_per_week INT DEFAULT 0,
  time_in_shower INT DEFAULT 0,
  loads_of_laundry INT DEFAULT 0,
  
  -- Energy usage fields
  laptop_hours INT DEFAULT 0,
  tv_hours INT DEFAULT 0,
  ac_hours INT DEFAULT 0,
  heater_usage INT DEFAULT 0,
  
  -- Emissions fields with precision
  transportation_emissions DECIMAL(10,2) DEFAULT 0.00,
  water_emissions DECIMAL(10,2) DEFAULT 0.00,
  electricity_emissions DECIMAL(10,2) DEFAULT 0.00,
  total DECIMAL(10,2) DEFAULT 0.00,
  
  -- Metadata
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  -- Foreign key constraint
  FOREIGN KEY (user_id) REFERENCES users_calc(user_id) ON DELETE CASCADE,
  
  -- Indexes for better performance
  INDEX idx_user_created (user_id, created_at),
  INDEX idx_emissions (transportation_emissions, water_emissions, electricity_emissions)
);

-- Add some constraints to ensure valid data
ALTER TABLE footprints
    ADD CONSTRAINT chk_positive_miles 
    CHECK (car_miles >= 0 AND bus_miles >= 0 AND train_miles >= 0 AND flight_miles >= 0),
    
    ADD CONSTRAINT chk_positive_usage 
    CHECK (showers_per_week >= 0 AND time_in_shower >= 0 AND loads_of_laundry >= 0),
    
    ADD CONSTRAINT chk_positive_hours 
    CHECK (laptop_hours >= 0 AND tv_hours >= 0 AND ac_hours >= 0 AND heater_usage >= 0),
    
    ADD CONSTRAINT chk_positive_emissions 
    CHECK (transportation_emissions >= 0 AND water_emissions >= 0 AND electricity_emissions >= 0 AND total >= 0);

-- Create a trigger to update total emissions automatically
DELIMITER //
CREATE TRIGGER before_footprint_insert 
BEFORE INSERT ON footprints
FOR EACH ROW
BEGIN
    SET NEW.total = NEW.transportation_emissions + NEW.water_emissions + NEW.electricity_emissions;
END//
DELIMITER ;

-- Create a trigger to update total emissions on update
DELIMITER //
CREATE TRIGGER before_footprint_update
BEFORE UPDATE ON footprints
FOR EACH ROW
BEGIN
    SET NEW.total = NEW.transportation_emissions + NEW.water_emissions + NEW.electricity_emissions;
END//
DELIMITER ;

-- Dumping data for table Industries
INSERT INTO Industries VALUES (1,'KGF','7th main road','gold industry', 'krishm'),(2,'MTR pvt lmt','8th main road','food', 'gagan');

-- Dumping data for table Carbon_Offsets
INSERT INTO Carbon_Offsets VALUES (1,'rev',23.12,'2024-11-08','env',1, 'krishm');

-- Dumping data for table Emission_Sources
INSERT INTO Emission_Sources (source_id, source_type, emission_value, emission_date, industry_id, username)  
VALUES (1, 'gas', 21.00, NULL, 1, 'krishm');

-- Dumping data for table Process
INSERT INTO Process VALUES (1,'comb',12.30,2.45,2, '2023-01-01', 'gagan'),(2,'rbst',21.50,7.90,1, '2023-01-01', 'krishm');

-- Dumping data for table ROLE
INSERT INTO ROLE VALUES (1,'Admin'),(2,'Industry Manager'),(3,'Auditor'),(4,'Public User');

-- Dumping data for table Transportation
INSERT INTO Transportation VALUES (2,'car',234.00,33.00,'2023-01-01',1,'test_user');

-- Dumping data for table USER
INSERT INTO USER VALUES (1,'krishm','kir@gmail.com','dywpuv-4tafdi-sagNyn',3,NULL, 0, 0),(3,'gagan','gag14krish@gmail.com','abc123',1,NULL, 0, 0),(4,'rocky','rocky@gmail.com','rocky123',2,1, 0, 0),(5,'murthy','murthy@gmail.com','murthy123',2,2, 0, 0);
-- 1. First, let's see all duplicates
SELECT user_id, username, email, role_id, industry_id
FROM USER 
WHERE email IN (
    SELECT email 
    FROM USER 
    WHERE email IS NOT NULL
    GROUP BY email 
    HAVING COUNT(*) > 1
)
OR username IN (
    SELECT username 
    FROM USER 
    WHERE username IS NOT NULL
    GROUP BY username 
    HAVING COUNT(*) > 1
)
ORDER BY email, username, user_id;

-- 2. Update duplicate emails
UPDATE USER u1
JOIN (
    SELECT user_id, email
    FROM USER 
    WHERE email IN (
        SELECT email 
        FROM USER 
        GROUP BY email 
        HAVING COUNT(*) > 1
    )
) u2 ON u1.user_id = u2.user_id
SET u1.email = CONCAT(SUBSTRING_INDEX(u2.email, '@', 1), '_', u2.user_id, '@', SUBSTRING_INDEX(u2.email, '@', -1))
WHERE u1.user_id != (
    SELECT MIN(user_id) 
    FROM USER u3 
    WHERE u3.email = u2.email
);

-- 3. Update duplicate usernames
UPDATE USER u1
JOIN (
    SELECT user_id, username
    FROM USER 
    WHERE username IN (
        SELECT username 
        FROM USER 
        GROUP BY username 
        HAVING COUNT(*) > 1
    )
) u2 ON u1.user_id = u2.user_id
SET u1.username = CONCAT(u2.username, '_', u2.user_id)
WHERE u1.user_id != (
    SELECT MIN(user_id) 
    FROM USER u3 
    WHERE u3.username = u2.username
);

-- 4. Verify no more duplicates exist
SELECT email, COUNT(*) as count 
FROM USER 
WHERE email IS NOT NULL
GROUP BY email 
HAVING count > 1;

SELECT username, COUNT(*) as count 
FROM USER 
WHERE username IS NOT NULL
GROUP BY username 
HAVING count > 1;

-- 5. Add unique constraints
ALTER TABLE USER ADD CONSTRAINT unique_username UNIQUE (username);
ALTER TABLE USER ADD CONSTRAINT unique_email UNIQUE (email);

-- 6. Final verification
SELECT 'Constraints added successfully!' as Status;