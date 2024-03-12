IMPORT $, STD;

Upper(STRING txt) := Std.Str.ToUpperCase(txt);

UID_Hospitals := $.UID_Hospital;

STD_HospitalRec := RECORD
    UID_Hospitals.UID;
    UID_Hospitals.xCoor;
    UID_Hospitals.yCoor;
    UNSIGNED4  id := (UNSIGNED4)UID_Hospitals.id;
    UID_Hospitals.name;
    STRING80  address := Upper(UID_Hospitals.name);
    STRING35  city := Upper(UID_Hospitals.city);
    STRING2   state := Upper(UID_Hospitals.state);
    UNSIGNED2 zip   := (UNSIGNED2)(UID_Hospitals.zip);
    UNSIGNED4 zip4  := (UNSIGNED4)(UID_Hospitals.zip4);
    UNSIGNED4 telephone := (UNSIGNED4)(UID_Hospitals.telephone);
    STRING20  type := Upper(UID_HOspitals.type);
    STRING6   status := Upper(UID_Hospitals.status);
    UID_Hospitals.population;
    STRING20  county := Upper(UID_Hospitals.county);
    UNSIGNED3 countyfips := (UNSIGNED3)(UID_Hospitals.countyfips);
    STRING3   country := Upper(UID_Hospitals.country);
    UID_Hospitals.latitude;
    UID_Hospitals.longitude;
    UID_Hospitals.naics_code;
    UID_Hospitals.naics_desc;
    UID_Hospitals.source;
    UID_Hospitals.sourcedate;
    UID_Hospitals.val_method;
    UID_Hospitals.val_date;
    UID_Hospitals.website;
    UID_Hospitals.state_id;
    UID_Hospitals.alt_name;
    UNSIGNED2 st_fips := (UNSIGNED2)(UID_Hospitals.st_fips);
    UID_Hospitals.owner;
    UID_Hospitals.ttl_staff;
    UID_Hospitals.beds;
    UID_Hospitals.trauma;
    UID_Hospitals.helipad; // Y, NOT AVAILABLE, N
END;

EXPORT STD_Hospital := TABLE(UID_Hospitals, STD_HospitalRec) : PERSIST('~safe::byteme::persist::hospitals');