IMPORT $, STD;

Upper(STRING txt) := STd.STR.ToUpperCase(txt);

ChurchesDS := $.Churches;


EXPORT STD_Churches := MODULE

EXPORT Layout := RECORD
    ChurchesDS.UID;
    STRING70 name := Upper(ChurchesDS.name);
    STRING35 street := Upper(ChurchesDS.street);
    STRING22 city := Upper(ChurchesDS.city);
    STRING2  state := Upper(ChurchesDS.state);
    churchesDS.zip;
    STRING13 region := Upper(ChurchesDS.region);
END;

EXPORT File := TABLE(ChurchesDS, Layout) : PERSIST('~safe::byteme::persist::churches');

END;
