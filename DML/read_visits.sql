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