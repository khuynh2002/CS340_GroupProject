/* THIS WILL BE THE ADMIN'S MAIN LANDING PAGE. 
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
    