IMPORT $, STD;

EXPORT CrimeRate_Per_100_000 := MODULE
    SHARED CrimeDS := DISTRIBUTE($.STD_CrimeRates.File);
    EXPORT CrimeRate_Per_100000_layout := RECORD
        STRING county_name := STD.sTr.ToUpperCase(CrimeDS.county_name);
        STRING state := STD.STR.ToUpperCase(CrimeDS.state);
        UNSIGNED3 county_fips := (UNSIGNED3)CrimeDS.county_fips;
        crime_rate := (DECIMAL)CrimeDS.crime_rate_per_100000;
    END;

    CrimesTable := TABLE(CrimeDS, CrimeRate_Per_100000_layout);

    EXPORT Sorted_CrimeRate := SORT(TABLE(CrimeDS, CrimeRate_Per_100000_layout), {crime_rate});
    EXPORT Total_Count := COUNT(Sorted_CrimeRate);
END;