set @start_date=(NOW() - INTERVAL 12 MONTH);
set @end_date=NOW();
SELECT 
    ln.name AS network,
    ld.name AS departement,
    lc.name AS commune,
    ls.name AS section,
    lh.name AS hospital_name,
    p.patient_code,
    tmi.first_name,
    tmi.last_name,
    tmi.dob,
    tmf.id_patient,
    tmf.date AS followup_date,
    tmf.viral_load_date,
    tmf.viral_load_count,
    tmf.viral_load_indetectable,
    IF((tmf.viral_load_count < 1000
            OR tmf.viral_load_indetectable),
        'indetectable',
        'detectable') AS viral_load_status
FROM
    tracking_motherfollowup tmf
        JOIN
    (SELECT 
        id_patient, MAX(viral_load_date) AS latest_viral_load_date
    FROM
        tracking_motherfollowup
    WHERE
        viral_load_date BETWEEN @start_date AND @end_date
    GROUP BY id_patient) latest ON tmf.id_patient = latest.id_patient
        AND tmf.viral_load_date = latest.latest_viral_load_date
        LEFT JOIN
    patient p ON p.id = tmf.id_patient
        LEFT JOIN
    lookup_hospital lh ON lh.city_code = p.city_code
        AND lh.hospital_code = p.hospital_code
        LEFT JOIN
    lookup_section ls ON ls.id = lh.section
        LEFT JOIN
    lookup_commune lc ON lc.id = lh.commune
        LEFT JOIN
    lookup_departement ld ON ld.id = lh.departement
        LEFT JOIN
    lookup_network ln ON ln.id = lh.network
        LEFT JOIN
    tracking_motherbasicinfo tmi ON tmi.id_patient = tmf.id_patient
GROUP BY tmf.id_patient