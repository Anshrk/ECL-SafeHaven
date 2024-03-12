IMPORT $, STD;

Upper(STRING txt) := Std.Str.ToUpperCase(txt);

UID_Hospitals := $.Hospitals;

EXPORT STD_Hospital := MODULE

EXPORT STD_HospitalRec := RECORD
    UID_Hospitals.UID;
    UID_Hospitals.name;
    STRING80  address := Upper(UID_Hospitals.name);
    STRING35  city := Upper(UID_Hospitals.city);
    STRING2   state := Upper(UID_Hospitals.state);
    UNSIGNED3 zip   := (UNSIGNED3)(UID_Hospitals.zip);
    UNSIGNED4 telephone := (UNSIGNED4)(UID_Hospitals.telephone);
    STRING20  type := Upper(UID_Hospitals.type);
    STRING6   status := Upper(UID_Hospitals.status);
    STRING20  county := Upper(UID_Hospitals.county);
    UNSIGNED3 countyfips := (UNSIGNED3)(UID_Hospitals.countyfips);
    UID_Hospitals.website;
    UID_Hospitals.state_id;
    UID_Hospitals.owner;
END;

EXPORT File := TABLE(UID_Hospitals, STD_HospitalRec) : PERSIST('~safe::byteme::persist::hospitals');

END;