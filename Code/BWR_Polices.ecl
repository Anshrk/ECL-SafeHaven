#option('obfuscateOutput', true);

IMPORT $;

CleanPolice_RECORD := RECORD
    UNSIGNED4 UID;
    STRING15 name;
    STRING25 city;
END;

UID_Police_Layout := RECORD
    UNSIGNED4 UID;
    $.File_AllData.PoliceRec AND NOT [objectid];
END;

CleanPolices := PROJECT($.STD_Police.File, TRANSFORM($.STD_Police.STD_PoliceRec,
                                                SELF.UID := LEFT.uid,
                                                SELF.name := LEFT.name,
                                                SELF.city := LEFT.city));

WritePolices := OUTPUT(CleanPolices,, '~safe::byteme::out::Polices', OVERWRITE);
CleanPolicesDS := DATASET('~safe::byteme::out::Polices',CleanPolice_RECORD , FLAT);

CleanPolices_City_IDX := INDEX(CleanPolicesDS, {city}, {CleanPolicesDS}, '~safe::byteme::idx::Polices_c');
//CleanPolices_Type_City_IDX := INDEX(CleanPolicesDS, {city, type}, {CleanPolicesDS}, '~safe::byteme::idx::Polices_ct');
BuildPolices_City_IDX := BUILD(cleanPolices_city_idx, OVERWRITE);
//BuildPolices_Type_City_IDX := BUILD(cleanPolices_type_city_idx, OVERWRITE);

SEQUENTIAL(WritePolices,
           BuildPolices_City_IDX);