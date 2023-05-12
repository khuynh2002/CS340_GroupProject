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