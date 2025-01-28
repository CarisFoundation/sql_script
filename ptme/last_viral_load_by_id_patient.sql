SELECT 
    t.id_patient,
    t.viral_load_date,
    t.viral_load_collection_date,
    t.viral_load_count,
    t.viral_load_indetectable
FROM
    tracking_motherfollowup t
INNER JOIN (
    SELECT 
        id_patient,
        MAX(viral_load_date) AS last_viral_load_date
    FROM 
        tracking_motherfollowup
    GROUP BY 
        id_patient
) last_record ON t.id_patient = last_record.id_patient 
              AND t.viral_load_date = last_record.last_viral_load_date;