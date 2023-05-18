/*Read Patients - THIS WILL BE THE ADMIN'S MAIN LANDING PAGE. 
A LIST OF ALL PATIENTS AND THEIR ATTRIBUTES (AND THEIR PCP's ATTRIBUTES), WITH THE ABILITY
TO ADD A NEW EVENT TO A PATIENT AS A HTML BUTTON NEXT TO THE ROW. 
WE'LL ALSO WANT TO ADD AN 'EDIT' AND 'DELETE' BUTTON NEXT TO EACH PATIENT
*/

SELECT
    p.patient_id, 
    p.first_name, 
    p.last_name, 
    p.date_of_birth, 
    p.sex, 
    p.gender, 
    pcp.first_name pcp_first_name, 
    pcp.last_name pcp_last_name, 
    pcp.pcp_specialty
FROM 
    Patients p
INNER JOIN 
    PCPs pcp ON p.PCPs_pcp_id = pcp.pcp_id; 

--Page to look at all PCP columns and Location Name column 

SELECT
    p.pcp_id, 
    p.first_name, 
    p.last_name, 
    p.pcp_specialty, 
    l.location_name
FROM 
    PCPs p
INNER JOIN 
    PCPs_Locations pl ON p.pcp_id=pl.PCPs_pcp_id
INNER JOIN 
    locations l ON  pl.Locations_location_id = l.location_id; 

--see all of the locations in the system 

SELECT 
    location_id, 
    location_name, 
    location_city, 
    location_state, 
    location_zip
FROM 
    Locations; 

--see the names of the pcp/location relationships

SELECT 
    CONCAT(p.first_name, " ", p.last_name) PCP_full_name, 
    l.location_name
FROM 
    PCPs_Locations pl
INNER JOIN PCPs p ON pl.PCPs_pcp_id = p.pcp_id
INNER JOIN Locations l ON pl.Locations_location_id = l.location_id;

SELECT 
    visit_id, 
    visit_date, 
    visit_length, 
    diagnosis, 
    med_prescribed, 
    CONCAT(p.first_name, " ", p.last_name) patient_name,
    CONCAT(pcp.first_name, " " , p.last_name) pcp_name, 
    location_name 
FROM 
    Visits v 
INNER JOIN 
    Patients p ON v.Patients_patient_id = p.patient_id 
INNER JOIN 
    Locations l ON v.Locations_location_id=l.location_id; 

/* This query will be used to select the location name, 
when inputting location from a dropdown on the ENTER VISIT 
page for a patient, OR on the PCPs_Location page to enter a new 
PCP/Location relationship
*/

SELECT 
    location_id, 
    location_name
FROM 
    Locations; 

/* This query will be used when updating a Patient's PCP (Patient Update Page) , 
rather than selecting the pcp_id, the dropdown will let user 
pull them by their full name 
*/

SELECT 
    pcp_id, 
    CONCAT(first_name, " ", last_name) pcp_full_name
FROM 
    PCPs; 

-- update a patients's data based on submission of the Update Patient form
UPDATE Patients 
SET first_name = :first_name_input
, last_name= :last_name_input
, date_of_birth = :date_of_birth_input
, sex= :sex_input
, gender = :gender_input, 
, PCPs_pcp_id = :PCPs_pcp_id_from_pcp_names_dropdown 
WHERE
id= :patient_ID_from_the_update_form;

-- update a PCP's data based on submission of the Update PCP form
UPDATE PCPs 
SET 
first_name = :first_name_input
, last_name= :last_name_input
, pcp_specialty = :pcp_specialty_input 
WHERE
id= :PCP_ID_from_the_update_form;

-- add a new patient
INSERT INTO Patients (first_name, last_name, date_of_birth, sex, gender, PCPs_pcp_id) VALUES
(:first_name_input, 
:last_name_input,
:date_of_birth_input, 
:sex_input, 
:gender_input, 
:pcp_id_from_dropdown_Input
);

-- associate a character with a certificate (M-to-M relationship addition)
INSERT INTO PCPs_Locations (PCPs_pcp_id, Locations_location_id) VALUES
(:pcp_id_from_dropdown_Input, :location_id_from_dropdown_Input);

-- add a new pcp
INSERT INTO PCPs (first_name, last_name, pcp_specialty) VALUES
(:first_name_input, 
:last_name_input,
:pcp_specialty_input
);

--add visit form 
INSERT INTO Visits 
(visit_date, vist_length, diagnosis, med_prescribed, Patients_patient_id, Patients_PCPs_pcp_id, Locations_location_id) VALUES
(:visit_date_input, 
:visit_length_input,
:diagnosis_input, 
:med_prescribed_input, 
:Patients_patient_id_input, 
(SELECT PCPs_pcp_id FROM Patients WHERE patient_id = :Patients_patient_id_input)
);

--DELETE Patient
DELETE FROM Patients WHERE patient_id = :patient_id_selected_from_browse_patient_page;

--DELETE PCP
DELETE FROM PCPs WHERE pcp_id = :pcp_id_selected_from_browse_pcp_page;

--DELETE VISIT
DELETE FROM Visits WHERE visit_id = :visit_ID_selected_from_browse_visit_page;
