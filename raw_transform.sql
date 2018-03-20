\timing on

CREATE TABLE test.ts AS (

    WITH tokenized AS ( 
	SELECT
	    regexp_split_to_array(rawrecord, '\|') as fields
	FROM test.raw_ts
	--LIMIT 10
    ),

    valid AS (
	SELECT
	    fields[1]::int as sid,
	    to_date(fields[2], 'DD/MM/YY') as measure_date, 
	    to_timestamp(fields[3], 'HH12:MIAM')::time as measure_time, 
	    regexp_replace(regexp_replace(fields[4], 'kWh', ''), '-', NULL)::float as energy_kwh, 
	    regexp_replace(regexp_replace(fields[5], 'kWh/kW', ''), '-', NULL)::float as efficiency_kwh_per_kw, 
	    regexp_replace(regexp_replace(regexp_replace(fields[6], 'W', ''), ',', ''), '-', NULL)::float as power_w, 
	    regexp_replace(regexp_replace(regexp_replace(fields[7], 'W', ''), ',', ''), '-', NULL)::float as average_power_w, 
	    regexp_replace(regexp_replace(fields[8], 'kW/kW', ''), '-', NULL)::float as normalized_power_kw_per_kw, 
	    regexp_replace(regexp_replace(fields[9], 'C', ''), '-', NULL)::float as temperature_c, 
	    regexp_replace(regexp_replace(fields[10], 'V', ''), '-', NULL)::float as voltage_v,
	    regexp_replace(fields[11], '-', NULL)::float as energy_consumed_kwh, 
	    regexp_replace(fields[12], '-', NULL)::float as power_consumed_kw 
	FROM
	    tokenized
	WHERE
	    array_upper(fields, 1) = 13
    )
    -- END CTE

    SELECT * FROM valid
);
-- END CTAS
