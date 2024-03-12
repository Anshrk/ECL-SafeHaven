
IMPORT $, STD;
Upper(STRING txt) := Std.Str.ToUpperCase(txt);

HospitalDS := $.UID_Hospital;

CleanHospital_RECORD := RECORD
    STRING15 name := '';
    STRING25 city := '';
    STRING20 type := '';
END;

ReducedTable := TABLE(hospitalDS, CleanHospital_RECORD);
CleanHospitals_City_Type_IDX := INDEX(ReducedTable, {city}, {ReducedTable}, '~safe::byteme::idx::hospitals_c');
CleanHospitals_Type_City_IDX := INDEX(ReducedTable, {city, type}, {ReducedTable}, '~safe::byteme::idx::hospitals_ct');

EXPORT Hospitals_SVC(STRING CityVal, STRING TypeVal) := FUNCTION
    TheHospital := OUTPUT(CleanHospitals_City_Type_IDX(City=Upper(CityVal), Type=Upper(TypeVal)));
    RETURN TheHospital;
END;

