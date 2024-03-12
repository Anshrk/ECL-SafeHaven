IMPORT $;

EXPORT CrimeRate_Per_100_000 := MODULE
    CrimeDS := $.File_AllData.CrimeDS;
    EXPORT CrimeRate_Per_100000_layout := RECORD
        STRING county_name := '';
        fip_code := (UNSIGNED4)((STRING1)CrimeDS.FIPS_ST + (STRING3)CrimeDS.FIPS_CTY);
        crime_rate := (DECIMAL)CrimeDS.crime_rate_per_100000;
    END;

    CrimesTable := TABLE($.File_AllData.CrimeDS, CrimeRate_Per_100000_layout);

    EXPORT Sorted_CrimeRate := SORT(CrimesTable, {crime_rate});
    EXPORT Total_Count := COUNT(Sorted_CrimeRate);
END;