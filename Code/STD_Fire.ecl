IMPORT $, STD;

FireDS := $.UID_Fire;
Upper(STRING txt) := STD.STR.ToUpperCase(txt);

EXPORT STD_Fire := MODULE

EXPORT Layout := RECORD
    FireDS.UID;
    STRING name := Upper(FireDS.name);
    FireDS.state;
    string cITY := uPPER(FireDS.City);
    FireDS.Xcoor;
    FireDS.YCoor;
    FireDS.zipcode;
END;

EXPORT File := TABLE(FireDS, Layout);

END;