IMPORT $;

HospitalDS := $.STD_Hospital.File;

EXPORT Hospital_Distribution := MODULE

    PD_County_Fip := RECORD
        HospitalDS.county_name;
        HospitalDS.county_fips;
        UNSIGNED num_Hospital := COUNT(GROUP);
    END;

    EXPORT Distribution_by_county := TABLE(HospitalDS, PD_County_Fip, county_fips);

    PD_State := RECORD
        HospitalDS.state;
        UNSIGNED num_Hospital := COUNT(GROUP);
    END;

    EXPORT Distribution_by_state := TABLE(HospitalDS, PD_State, state);

    PD_City := RECORD
        HospitalDS.City;
        UNSIGNED num_Hospital := COUNT(GROUP);
    END;

    EXPORT Distribution_by_city := TABLE(HospitalDS, PD_city, city);
END;