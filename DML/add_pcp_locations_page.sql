-- associate a character with a certificate (M-to-M relationship addition)
INSERT INTO PCPs_Locations (PCPs_pcp_id, Locations_location_id) VALUES
(:pcp_id_from_dropdown_Input, :location_id_from_dropdown_Input);
