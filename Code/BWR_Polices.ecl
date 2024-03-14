#option('obfuscateOutput', true);

IMPORT $;

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

UID_Police_Layout := RECORD
    UNSIGNED4 UID;
    $.File_AllData.PoliceRec AND NOT [objectid];
END;

// CleanPolices := PROJECT($.STD_Police.File, TRANSFORM($.STD_Police.STD_PoliceRec,
//                                                 SELF.UID := LEFT.uid,
//                                                 SELF.name := LEFT.name,
//                                                 SELF.city := LEFT.city));

CleanPolices := TABLE(PoliceDS, CleanPolice_RECORd);

WritePolices := OUTPUT(CleanPolices,, '~safe::byteme::out::Polices', OVERWRITE);
CleanPolicesDS := DATASET('~safe::byteme::out::Polices',CleanPolice_RECORD , FLAT);

CleanPolices_City_IDX := INDEX(CleanPolicesDS, {city}, {CleanPolicesDS}, '~safe::byteme::idx::Polices_c');
CleanPolices_County_IDX := INDEX(CleanPolicesDS, {county_name}, {CleanPolicesDS}, '~safe::byteme::idx::Polices_county');
CleanPolices_State_IDX := INDEX(CleanPolicesDS, {state}, {CleanPolicesDS}, '~safe::byteme::idx::state');
CleanPolice_Fips_IDX := INDEX(CleanPolicesDS, {county_fips}, {CleanPolicesDS}, '~safe::byteme::idx::Polices_fips');

BuildPolices_City_IDX := BUILD(cleanPolices_city_idx, OVERWRITE);
BuildPolices_State_IDX := BUILD(CleanPolices_State_IDX, OVERWRITE);
BuildPolices_County_IDX := BUILD(CleanPolices_County_IDX, OVERWRITE);
BuildPolices_Fips_IDX := BUILD(CleanPolice_Fips_IDX, OVERWRITE);


SEQUENTIAL(WritePolices,
           BuildPolices_City_IDX,
           BuildPolices_State_IDX,
           BuildPolices_County_IDX,
           BuildPolices_Fips_IDX);