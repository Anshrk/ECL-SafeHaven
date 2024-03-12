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

CleanHospitals := PROJECT($.UID_Hospital, TRANSFORM(CleanHospital_RECORD,
                                                SELF.UID := LEFT.uid,
                                                SELF.name := LEFT.name,
                                                SELF.city := LEFT.city,
                                                SELF.type := LEFt.type;
                                                SELF.ttl_staff := LEFT.ttl_staff,
                                                SELF.beds := LEFT.beds));

WriteHospitals := OUTPUT(CleanHospitals,, '~safe::byteme::out::hospitals', OVERWRITE);
CleanHospitalsDS := DATASET('~safe::byteme::out::hospitals',CleanHospital_RECORD , FLAT);

CleanHospitals_City_IDX := INDEX(CleanHospitalsDS, {city}, {CleanHospitalsDS}, '~safe::byteme::idx::hospitals_c');
CleanHospitals_Type_City_IDX := INDEX(CleanHospitalsDS, {city, type}, {CleanHospitalsDS}, '~safe::byteme::idx::hospitals_ct');
BuildHospitals_City_IDX := BUILD(cleanHospitals_city_idx, OVERWRITE);
BuildHospitals_Type_City_IDX := BUILD(cleanHospitals_type_city_idx, OVERWRITE);

SEQUENTIAL(WriteHospitals,
           BuildHospitals_City_IDX, BuildHospitals_Type_city_idx);