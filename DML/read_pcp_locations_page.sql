--see the names of the pcp/location relationships

SELECT 
    CONCAT(p.first_name, " ", p.last_name) PCP_full_name, 
    l.location_name
FROM 
    PCPs_Locations pl
INNER JOIN PCPs p ON pl.PCPs_pcp_id = p.pcp_id
INNER JOIN Locations l ON pl.Locations_location_id = l.location_id