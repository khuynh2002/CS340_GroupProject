SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;
-- CREATE SCHEMA IF NOT EXISTS `cs340_palsa` DEFAULT CHARACTER SET utf8 ;
--USE `cs340_palsa` ; commenting out for now, per feedback

-- -----------------------------------------------------
-- Table `cs340_palsa`.`PCPs`
/* This is our PCP table, with attributes first_name, last_name, and pcp_specialty */ 
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PCPs`; 

CREATE TABLE IF NOT EXISTS `PCPs` (
  `pcp_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `pcp_specialty` VARCHAR(45) NULL,
  PRIMARY KEY (`pcp_id`))
ENGINE = InnoDB;

INSERT INTO `PCPs` (first_name, last_name, pcp_specialty)
VALUES 
("Albert", "Einstein", "Internal Medicine"), 
("Rafa", "Nadal", "General Medicine"), 
("Roger", "Federer", "Family Medicine");


-- -----------------------------------------------------
-- Table `Patients`
/* this is our Patients tables, with attributes dedicated to the Patient. 
If a PCP (PCPs_pcp_id) is dropped, that column would be set to null */
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Patients`;

CREATE TABLE IF NOT EXISTS `Patients` (
  `patient_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `sex` VARCHAR(45) NOT NULL,
  `gender` VARCHAR(45) NULL,
  `PCPs_pcp_id` INT NOT NULL,
  PRIMARY KEY (`patient_id`, `PCPs_pcp_id`),
  INDEX `fk_Patients_PCPs1_idx` (`PCPs_pcp_id` ASC),
  CONSTRAINT `fk_Patients_PCPs1`
    FOREIGN KEY (`PCPs_pcp_id`)
    REFERENCES `PCPs` (`pcp_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

INSERT INTO `Patients` (first_name, last_name, date_of_birth, sex, gender, PCPs_pcp_id)
VALUES 
("Sandip", "Pal", "1992-05-29", "M", "M", 1), 
("Kevin", "Huynh", "1996-12-25", "M", "M", 2), 
("Mary", "Poppins", "1929-01-01", "F", "F", 3),
("Santa", "Claus", "1902-05-01", "M", "M", 1);


-- -----------------------------------------------------
-- Table `Locations`
/* all attributes relate to PK location_id */
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Locations`; 

CREATE TABLE IF NOT EXISTS `Locations` (
  `location_id` INT NOT NULL AUTO_INCREMENT,
  `location_name` VARCHAR(45) NOT NULL,
  `location_city` VARCHAR(45) NOT NULL,
  `location_state` VARCHAR(45) NOT NULL,
  `location_zip` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`location_id`))
ENGINE = InnoDB;

INSERT INTO `Locations` (location_name, location_city, location_state, location_zip)
VALUES 
("United Center", "Chicago", "IL", "60605"), 
("OSU Hospital", "Corvallis", "OR", "12345"), 
("Gotham Outpatient Clinic", "New York City", "NY", "02345");


-- -----------------------------------------------------
-- Table `Visits`
/* attributes related to the visit, we left visit_date , length, diagnosis, and meds prescribed 
intentionally on this table, rather than creating a separate visits_detail table, also if the FKs are 
deleted we want the record of the visit to still exist, so hence the "SET NULL", also intentionally bringing in the Patients PCP ID
for visibility of the doctor without needing to join to Patients table. 

This is an intentional business decision to stray from normalization, but we may change this later. We may only want to store the 
Patient ID and bring in the doctor information via a join, but in our opinion having both details on the Visits table makes sense */
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Visits`; 

CREATE TABLE IF NOT EXISTS `Visits` (
  `visit_id` INT NOT NULL AUTO_INCREMENT,
  `visit_date` DATE NOT NULL,
  `visit_length` VARCHAR(45) NOT NULL,
  `diagnosis` VARCHAR(255) NULL,
  `med_prescribed` VARCHAR(255) NULL,
  `Patients_patient_id` INT NOT NULL,
  `Patients_PCPs_pcp_id` INT NOT NULL,
  `Locations_location_id` INT NOT NULL,
  PRIMARY KEY (`visit_id`, `Patients_patient_id`, `Patients_PCPs_pcp_id`, `Locations_location_id`),
  INDEX `fk_Visits_Patients1_idx` (`Patients_patient_id` ASC, `Patients_PCPs_pcp_id` ASC),
  INDEX `fk_Visits_Locations1_idx` (`Locations_location_id` ASC),
  CONSTRAINT `fk_Visits_Patients1`
    FOREIGN KEY (`Patients_patient_id` , `Patients_PCPs_pcp_id`)
    REFERENCES `Patients` (`patient_id` , `PCPs_pcp_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Visits_Locations1`
    FOREIGN KEY (`Locations_location_id`)
    REFERENCES `Locations` (`location_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

INSERT INTO `Visits` (visit_date, visit_length, diagnosis, med_prescribed, Patients_patient_id, Patients_PCPs_pcp_id, Locations_location_id)
VALUES 
("2023-05-03", "15 minutes", "common cold", "advil", (SELECT patient_id FROM Patients WHERE patient_id = 1), (SELECT PCPs_pcp_id FROM Patients WHERE patient_id = 1), 3),
("2023-05-04", "30 minutes", "flu", "flu shot", (SELECT patient_id FROM Patients WHERE patient_id = 2), (SELECT PCPs_pcp_id FROM Patients WHERE patient_id = 2), 2),
("2023-05-04", "45 minutes", "headache", "aspirin", (SELECT patient_id FROM Patients WHERE patient_id = 3), (SELECT PCPs_pcp_id FROM Patients WHERE patient_id = 3), 1), 
("2023-05-05", "15 minutes", "common cold", NULL, (SELECT patient_id FROM Patients WHERE patient_id = 1), (SELECT PCPs_pcp_id FROM Patients WHERE patient_id = 1), 2);


-- -----------------------------------------------------
-- Table `PCPs_Locations`

/* Intersection table of PCPs and their Locations, in this case 
we've added a unique Primary Key for each record (auto incremented) and used CASCADE
as we don't need Locations or PCPs in this table if they no longer exist */
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PCPs_Locations`; 

CREATE TABLE IF NOT EXISTS `PCPs_Locations` (
  `pcp_locations_pk_id` INT NOT NULL AUTO_INCREMENT,
  `PCPs_pcp_id` INT NOT NULL,
  `Locations_location_id` INT NOT NULL,
  INDEX `fk_PCPs_has_Locations_Locations1_idx` (`Locations_location_id` ASC),
  INDEX `fk_PCPs_has_Locations_PCPs_idx` (`PCPs_pcp_id` ASC),
  PRIMARY KEY (`pcp_locations_pk_id`),
  CONSTRAINT `fk_PCPs_has_Locations_PCPs`
    FOREIGN KEY (`PCPs_pcp_id`)
    REFERENCES `PCPs` (`pcp_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_PCPs_has_Locations_Locations1`
    FOREIGN KEY (`Locations_location_id`)
    REFERENCES `Locations` (`location_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

INSERT INTO `PCPs_Locations` (PCPs_pcp_id, Locations_location_id)
VALUES
(1, 1), (1, 2), (1, 3), 
(2, 1), (2,2), (2,3), 
(3, 1), (3, 2), (3, 3); 


SET FOREIGN_KEY_CHECKS = 1; 
COMMIT; 

-- SET SQL_MODE=@OLD_SQL_MODE;
-- SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
-- SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
