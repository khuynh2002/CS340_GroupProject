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

    