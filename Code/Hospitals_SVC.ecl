
IMPORT $, STD;
Upper(STRING txt) := Std.Str.ToUpperCase(txt);

HospitalDS := $.STD_Hospital.File;

CleanHospital_RECORD := RECORD
    hospitalDS.uid;
    HospitalDS.name;
    hospitalDS.type;
    HospitalDS.city;
    HospitalDS.county_fips;
    hospitalDS.county_name;
END;

ReducedTable := TABLE(hospitalDS, CleanHospital_RECORD);
CleanHospitals_City_IDX := INDEX(ReducedTable, {city}, {ReducedTable}, '~safe::byteme::idx::hospitals_c');
CleanHospitals_City_Type_IDX := INDEX(ReducedTable, {city, type}, {ReducedTable}, '~safe::byteme::idx::hospitals_ct');
Hospitals_Fips_IDX := INDEX(ReducedTable, {county_fips, type}, {ReducedTable}, '~safe::byteme::idx::hospitals_fips');

EXPORT Hospitals_SVC(FipsVal, STRING CityVal, STRING TypeVal) := FUNCTION
    TheHospital := IF(FipsVal = 0, 
                        OUTPUT(CleanHospitals_City_Type_IDX(City=Upper(CityVal), Type=Upper(TypeVal))),
                        OUTPUT(Hospitals_Fips_IDX(County_Fips=FipsVal, Type=Upper(TypeVal)) )
                        );
    RETURN TheHospital;
END;

