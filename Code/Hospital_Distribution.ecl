IMPORT $;

HospitalDS := $.STD_Hospital.File;

EXPORT Hospital_Distribution := MODULE

    HD_County_Fip := RECORD
        HospitalDS.county_name;
        HospitalDS.county_fips;
        UNSIGNED num_Hospital := COUNT(GROUP);
    END;

    EXPORT Distribution_by_county := TABLE(HospitalDS, HD_County_Fip, county_fips);

    HD_State := RECORD
        HospitalDS.state;
        UNSIGNED num_Hospital := COUNT(GROUP);
    END;

    EXPORT Distribution_by_state := TABLE(HospitalDS, HD_State, state);

    HD_City := RECORD
        HospitalDS.City;
        UNSIGNED num_Hospital := COUNT(GROUP);
    END;

    EXPORT Distribution_by_city := TABLE(HospitalDS, HD_city, city);
END;