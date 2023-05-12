/* This query will be used when updating a Patient's PCP (Patient Update Page) , 
rather than selecting the pcp_id, the dropdown will let user 
pull them by their full name 
*/

SELECT 
    pcp_id, 
    CONCAT(first_name, " ", last_name) pcp_full_name
FROM 
    PCPs; 