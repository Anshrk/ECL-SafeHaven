IMPORT $;

EXPORT CrimeRate_Per_100_000 := MODULE
    CrimeDS := $.File_AllData.CrimeDS;
    EXPORT CrimeRate_Per_100000_layout := RECORD
        STRING county_name := '';
        UNSIGNED1 st_fips := (UNSIGNED1)CrimeDS.FIPS_ST;
        UNSIGNED3 county_fips := (UNSIGNED3)CrimeDS.FIPS_CTY;
        crime_rate := (DECIMAL)CrimeDS.crime_rate_per_100000;
    END;

    CrimesTable := TABLE($.File_AllData.CrimeDS, CrimeRate_Per_100000_layout);

    EXPORT Sorted_CrimeRate := SORT(CrimesTable, {crime_rate});
    EXPORT Total_Count := COUNT(Sorted_CrimeRate);
END;