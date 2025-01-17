set @start_date='2024-10-01';
set @end_date='2024-12-31';
SELECT 
ln.name as network,
ld.name as departement,
lc.name as commune,
ls.name as section,
lh.name as hospital_name,
 p.patient_code,
 
    ts.*, TIMESTAMPDIFF(MONTH,date_of_birth,
        date_blood_taken
        ) as age_in_month,
TIMESTAMPDIFF(DAY,date_of_birth,
        date_blood_taken
        ) as age_in_day,
        lts.name as "pcr_result",
        ltw.name as "type de pcr"
FROM
    testing_specimen ts
    left join patient p on p.id=ts.id_patient
    left join lookup_testing_specimen_result lts on lts.id=ts.pcr_result
    left join lookup_testing_which_pcr ltw on ltw.id=ts.which_pcr
    left join lookup_hospital lh on lh.city_code=p.city_code and lh.hospital_code=p.hospital_code
    left join lookup_section ls on ls.id=lh.section
    left join lookup_commune lc on lc.id=lh.commune
    left join lookup_departement ld on ld.id=lh.departement
    left join lookup_network ln on ln.id=lh.network
WHERE
    date_blood_taken BETWEEN @start_date AND @end_date
