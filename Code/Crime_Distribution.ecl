import $;
CRIMEDISTR := $.std_crimerates.file;

export CRIME_distribution := module
    statecount := record
        crimedistr.state;
        unsigned num_crimeinstate := count(group);
    end;

    export distribution_by_state := table(crimedistr,statecount,state);

     PD_County_Fip := RECORD
        crimedistr.county_fips;
        UNSIGNED num_crimeincounty := COUNT(GROUP);
    END;
    EXPORT Distribution_by_county := TABLE(crimedistr, PD_County_Fip, county_fips);
end;