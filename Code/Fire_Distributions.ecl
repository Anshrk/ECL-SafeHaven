IMPORT $;

FireDS := $.STD_Fire.File;

EXPORT Fire_Distribution := MODULE

    PD_County_Fip := RECORD
        FireDS.county_name;
        FireDS.county_fips;
        UNSIGNED num_Fire_stations := COUNT(GROUP);
    END;

    EXPORT Distribution_by_county := TABLE(FireDS, PD_County_Fip, county_fips);

    PD_State := RECORD
        FireDS.state;
        UNSIGNED num_Fire_stations := COUNT(GROUP);
    END;

    EXPORT Distribution_by_state := TABLE(FireDS, PD_State, state);

    PD_City := RECORD
        FireDS.City;
        UNSIGNED num_Fire_stations := COUNT(GROUP);
    END;

    EXPORT Distribution_by_city := TABLE(FireDS, PD_city, city);
END;