
IMPORT $, STD;
Upper(STRING txt) := Std.Str.ToUpperCase(txt);

PoliceDS := $.STD_Police.File;

CleanPolice_RECORD := RECORD
    PoliceDS.UID;
    PoliceDS.name;
    PoliceDS.address;
    PoliceDS.telephone;
    PoliceDS.latitude;
    PoliceDS.longitude;
    PoliceDS.county_name;
    PoliceDS.county_fips;
    PoliceDS.state;
    PoliceDS.city;
END;


CleanPolices_City_IDX := INDEX(PoliceDS, {city}, {PoliceDS}, '~safe::byteme::idx::Polices_c');
CleanPolices_County_IDX := INDEX(PoliceDS, {county_name}, {PoliceDS}, '~safe::byteme::idx::Polices_county');
CleanPolices_State_IDX := INDEX(PoliceDS, {state}, {PoliceDS}, '~safe::byteme::idx::state');
CleanPolice_Fips_IDX := INDEX(PoliceDS, {county_fips}, {PoliceDS}, '~safe::byteme::idx::Polices_fips');

EXPORT Police_SVC(FipsVal, STRING CityVal, STRING CountyNameVal, STRING StateNameVal) := FUNCTION
    ThePolice := MAP(
        FipsVal != 0 => OUTPUT(CleanPolice_Fips_IDX(county_fips=FipsVal)),
        CityVal != '' => OUTPUT(CleanPolices_City_IDX(City=Upper(CityVal))),
        CountyNameVal != '' => OUTPUT(CleanPolices_County_IDX(county_name=Upper(COUNTYNAMEVAL))),
        StateNameVal != '' => OUTPUT(CleanPolices_State_IDX(State=Upper(StateNameVal)))
    );
    RETURN ThePolice;
END;