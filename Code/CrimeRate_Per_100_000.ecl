IMPORT $;

EXPORT CrimeRate_Per_100_000 := MODULE
    EXPORT CrimeRate_Per_100000_layout := RECORD
        STRING county_name := '';
        crime_rate := (DECIMAL)$.File_AllData.CrimeDS.crime_rate_per_100000;
    END;

    CrimesTable := TABLE($.File_AllData.CrimeDS, CrimeRate_Per_100000_layout);

    EXPORT Sorted_CrimeRate := SORT(CrimesTable, {crime_rate});
    EXPORT Total_Count := COUNT(Sorted_CrimeRate);
END;