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