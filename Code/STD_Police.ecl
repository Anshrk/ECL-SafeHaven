IMPORT $, STD;

Upper(STRING txt) := Std.Str.ToUpperCase(txt);

Police := $.Polices;



EXPORT STD_Police := MODULE
    EXPORT STD_PoliceRec := RECORD
        Police.UID;
        Police.name;
        STRING80  address := Upper(Police.name);
        STRING35  city := Upper(Police.city);
        STRING2   state := Upper(Police.state);
        (Police.telephone);
        UNSIGNED3 county_fips := (UNSIGNED3)(Police.countyfips);
        STRING25  county_name := Upper(Police.county);
        Police.latitude;
        Police.longitude;
    END;
    EXPORT File := TABLE(Police, STD_PoliceRec) : PERSIST('~safe::byteme::persist::Polices');
END;