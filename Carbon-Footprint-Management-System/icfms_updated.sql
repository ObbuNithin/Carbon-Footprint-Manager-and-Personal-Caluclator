-- Disable foreign key checks
SET foreign_key_checks = 0;

-- Drop the existing tables (if they exist) in the correct order
DROP TABLE IF EXISTS `Emission_Sources`;
DROP TABLE IF EXISTS `Carbon_Offsets`;
DROP TABLE IF EXISTS `Transportation`;
DROP TABLE IF EXISTS `USER`;
DROP TABLE IF EXISTS `ROLE`;
DROP TABLE IF EXISTS `Process`;
DROP TABLE IF EXISTS `Industries`;

-- Re-enable foreign key checks
SET foreign_key_checks = 1;

-- Create Industries table first
CREATE TABLE `Industries` (
  `industry_id` int NOT NULL AUTO_INCREMENT,
  `industry_name` varchar(100) NOT NULL,
  `location` varchar(100) DEFAULT NULL,
  `industry_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`industry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create Process table (depends on Industries)
CREATE TABLE `Process` (
  `process_id` int NOT NULL AUTO_INCREMENT,
  `process_name` varchar(100) DEFAULT NULL,
  `energy_consumption` decimal(10,2) DEFAULT NULL,
  `emission_factor` decimal(10,2) DEFAULT NULL,
  `industry_id` int DEFAULT NULL,
  PRIMARY KEY (`process_id`),
  KEY `fk_industry_id` (`industry_id`),
  CONSTRAINT `fk_industry_id` FOREIGN KEY (`industry_id`) REFERENCES `Industries` (`industry_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create Emission_Sources table (depends on Process)
CREATE TABLE `Emission_Sources` (
  `source_id` int NOT NULL AUTO_INCREMENT,
  `source_type` varchar(50) DEFAULT NULL,
  `emission_value` decimal(10,2) DEFAULT NULL,
  `process_id` int DEFAULT NULL,
  `industry_id` int DEFAULT NULL,
  PRIMARY KEY (`source_id`),
  KEY `process_id` (`process_id`),
  CONSTRAINT `emission_sources_ibfk_1` FOREIGN KEY (`process_id`) REFERENCES `Process` (`process_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Create other tables here...


-- Create other tables after the dependent ones are created (Industries, Process)
CREATE TABLE `Carbon_Offsets` (
  `offset_id` int NOT NULL AUTO_INCREMENT,
  `offset_type` varchar(50) DEFAULT NULL,
  `amount_offset` decimal(10,2) DEFAULT NULL,
  `date_purchased` date DEFAULT NULL,
  `provider_details` varchar(100) DEFAULT NULL,
  `industry_id` int NOT NULL,
  PRIMARY KEY (`offset_id`),
  KEY `fk_carbon_offsets_industry_id` (`industry_id`),
  CONSTRAINT `fk_carbon_offsets_industry_id` FOREIGN KEY (`industry_id`) REFERENCES `Industries` (`industry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Other table creation follows here...
-- Table structure for table `ROLE`
DROP TABLE IF EXISTS `ROLE`;
CREATE TABLE `ROLE` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table structure for table `Transportation`
DROP TABLE IF EXISTS `Transportation`;
CREATE TABLE `Transportation` (
  `transport_id` int NOT NULL AUTO_INCREMENT,
  `vehicle_type` varchar(50) DEFAULT NULL,
  `distance_travelled` decimal(10,2) DEFAULT NULL,
  `fuel_consumption` decimal(10,2) DEFAULT NULL,
  `industry_id` int DEFAULT NULL,
  PRIMARY KEY (`transport_id`),
  KEY `fk_transportation_industry_id` (`industry_id`),
  CONSTRAINT `fk_transportation_industry_id` FOREIGN KEY (`industry_id`) REFERENCES `Industries` (`industry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table structure for table `USER`
DROP TABLE IF EXISTS `USER`;
CREATE TABLE `USER` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role_id` int DEFAULT NULL,
  `industry_id` int DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `role_id` (`role_id`),
  KEY `fk_user_industry_id` (`industry_id`),
  CONSTRAINT `fk_user_industry_id` FOREIGN KEY (`industry_id`) REFERENCES `Industries` (`industry_id`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `ROLE` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table `Industries`
INSERT INTO `Industries` VALUES (1,'KGF','7th main road','gold industry '),(2,'MTR pvt lmt','8th main road ','food');

-- Dumping data for table `Carbon_Offsets`
INSERT INTO `Carbon_Offsets` VALUES (1,'rev',23.12,'2024-11-08','env',1);

-- Dumping data for table `Emission_Sources`
INSERT INTO `Emission_Sources` VALUES (1,'gas',21.00,NULL,1);

-- Dumping data for table `Process`
INSERT INTO `Process` VALUES (1,'comb',12.30,2.45,2),(2,'rbst',21.50,7.90,1);

-- Dumping data for table `ROLE`
INSERT INTO `ROLE` VALUES (1,'Admin'),(2,'Industry Manager'),(3,'Auditor'),(4,'Public User');

-- Dumping data for table `Transportation`
INSERT INTO `Transportation` VALUES (2,'car',234.00,33.00,1);

-- Dumping data for table `USER`
INSERT INTO `USER` VALUES (1,'krishm','kir@gmail.com','dywpuv-4tafdi-sagNyn',3,NULL),(3,'gagan','gag14krish@gmail.com','abc123',1,NULL),(4,'rocky','rocky@gmail.com','rocky123',2,1),(5,'murthy','mruthy@gmail.com','murthy123',2,2);


