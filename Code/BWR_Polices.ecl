#option('obfuscateOutput', true);

IMPORT $;

CleanHospital_RECORD := RECORD
    UNSIGNED4 UID;
    STRING15 name;
    STRING25 city;
    STRING20 type;
    INTEGER2 ttl_staff;
    INTEGER2 beds;
END;

UID_Hospital_Layout := RECORD
    UNSIGNED4 UID;
    $.File_AllData.HospitalRec AND NOT [objectid];
END;

CleanPolices := PROJECT($.UID_Hospital, TRANSFORM(CleanHospital_RECORD,
                                                SELF.UID := LEFT.uid,
                                                SELF.name := LEFT.name,
                                                SELF.city := LEFT.city,
                                                SELF.type := LEFt.type;
                                                SELF.ttl_staff := LEFT.ttl_staff,
                                                SELF.beds := LEFT.beds));

WritePolices := OUTPUT(CleanPolices,, '~safe::byteme::out::Polices', OVERWRITE);
CleanPolicesDS := DATASET('~safe::byteme::out::Polices',CleanHospital_RECORD , FLAT);

CleanPolices_City_IDX := INDEX(CleanPolicesDS, {city}, {CleanPolicesDS}, '~safe::byteme::idx::Polices_c');
CleanPolices_Type_City_IDX := INDEX(CleanPolicesDS, {city, type}, {CleanPolicesDS}, '~safe::byteme::idx::Polices_ct');
BuildPolices_City_IDX := BUILD(cleanPolices_city_idx, OVERWRITE);
BuildPolices_Type_City_IDX := BUILD(cleanPolices_type_city_idx, OVERWRITE);

SEQUENTIAL(WritePolices,
           BuildPolices_City_IDX, BuildPolices_Type_city_idx);