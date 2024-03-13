IMPORT $;

PoliceDS := $.STD_Police.File;

EXPORT Police_Distribution := MODULE

    PD_County_Fip := RECORD
        PoliceDS.county_name;
        PoliceDS.county_fips;
        UNSIGNED num_police_stations := COUNT(GROUP);
    END;

    EXPORT Distribution_by_county := TABLE(PoliceDS, PD_County_Fip, county_fips);

    PD_State := RECORD
        PoliceDS.state;
        UNSIGNED num_police_stations := COUNT(GROUP);
    END;

    EXPORT Distribution_by_state := TABLE(PoliceDS, PD_State, state);

    PD_City := RECORD
        PoliceDS.City;
        UNSIGNED num_police_stations := COUNT(GROUP);
    END;

    EXPORT Distribution_by_city := TABLE(PoliceDS, PD_city, city);
END;