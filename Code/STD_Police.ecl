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
        UNSIGNED4 telephone := (UNSIGNED4)(Police.telephone);
        UNSIGNED3 countyfips := (UNSIGNED3)(Police.countyfips);
    END;
    EXPORT File := TABLE(Police, STD_PoliceRec) : PERSIST('~safe::byteme::persist::Polices');
END;