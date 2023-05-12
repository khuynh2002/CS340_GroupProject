-- update a PCP's data based on submission of the Update PCP form
UPDATE PCPs 
SET 
first_name = :first_name_input
, last_name= :last_name_input
, pcp_specialty = :pcp_specialty_input 
WHERE
id= :PCP_ID_from_the_update_form;