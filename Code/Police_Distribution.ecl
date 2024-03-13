IMPORT $;

PoliceDS := $.STD_Police.File;

EXPORT Police_Distribution := MODULE

    EXPORT PD_County_Fip := RECORD
        PoliceDS.county_name;
        PoliceDS.county_fips;
        UNSIGNED num_police_stations := COUNT(GROUP);
    END;

    EXPORT Distribution_by_county := TABLE(PoliceDS, PD_County_Fip, county_fips);

    EXPORT PD_State := RECORD
        PoliceDS.state;
        UNSIGNED num_police_stations := COUNT(GROUP);
    END;

    EXPORT Distribution_by_state := TABLE(PoliceDS, PD_State, state);

    EXPORT PD_City := RECORD
        PoliceDS.City;
        UNSIGNED num_police_stations := COUNT(GROUP);
    END;

    EXPORT Distribution_by_city := TABLE(PoliceDS, PD_city, city);
END;