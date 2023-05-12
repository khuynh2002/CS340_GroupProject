-- add a new patient
INSERT INTO Patients (first_name, last_name, date_of_birth, sex, gender, PCPs_pcp_id) VALUES
(:first_name_input, 
:last_name_input,
:date_of_birth_input, 
:sex_input, 
:gender_input, 
:pcp_id_from_dropdown_Input
);
