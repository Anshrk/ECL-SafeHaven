IMPORT $, STD;

Upper(STRING txt) := Std.Str.ToUpperCase(txt);

CrimeDS := $.File_AllData.CrimeDS;
StatesDS := $.States;

EXPORT STD_CrimeRates := MODULE

PreLayout := RECORD
    STRING county_name := Upper(CrimeDS.county_name);
    CrimeDS.crime_rate_per_100000;
    UNSIGNED3 county_fips := CrimeDs.FIPS_CTY;
    UNSIGNED1 state_fips := CrimeDS.FIPS_ST;
END;

StatesLayout := RECORD
    UNSIGNED1 state_fips := (UNSIGNED1)StatesDS.st_fips;
    StatesDS.state;
END;

preStatesDS := TABLE(StatesDS, StatesLayout);

PreCrimesDS := TABLE(CrimeDS, PreLayout);

Layout := RECORD
    STRING county_name := Upper(CrimeDS.county_name);
    CrimeDS.crime_rate_per_100000;
    UNSIGNED3 county_fips := CrimeDs.FIPS_CTY;
    STRING2 state;
END;

Layout STDCrimes(PreLayout L, StatesLayout R) := TRANSFORM
    SELF.state := R.state;
END; 

EXPORT File := 
    JOIN(PreCrimesDS, preStatesDS, (UNSIGNED3) LEFT.state_fips=(UNSIGNED3)RIGHT.state_fips, STDCrimes(LEFT, RIGHT), INNER, LOCAL)
    : PERSIST('~safe::byteme::persist::crimerates');

END;