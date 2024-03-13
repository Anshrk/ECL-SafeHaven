#option('obfuscateOutput', true);

IMPORT $;

HospitalDS := $.STD_Hospital.File;

CleanHospital_RECORD := RECORD
    hospitalDS.uid;
    HospitalDS.name;
    hospitalDS.type;
    HospitalDS.city;
    HospitalDS.county_fips;
    hospitalDS.county_name;
END;


UID_Hospital_Layout := RECORD
    $.STD_Hospital.STD_HospitalRec;
END;

CleanHospitals := TABLE(hospitalDS, CleanHospital_RECORD);
WriteHospitals := OUTPUT(CleanHospitals,, '~safe::byteme::out::hospitals', OVERWRITE);
CleanHospitalsDS := DATASET('~safe::byteme::out::hospitals',CleanHospital_RECORD , FLAT);

CleanHospitals_City_IDX := INDEX(CleanHospitalsDS, {city}, {CleanHospitalsDS}, '~safe::byteme::idx::hospitals_c');

CleanHospitals_Type_City_IDX := INDEX(CleanHospitalsDS, {city, type}, {CleanHospitalsDS}, '~safe::byteme::idx::hospitals_ct');
CleanHospitals_Fips_IDX := INDEX(CleanHospitalsDS, {county_fips, type}, {CleanHospitalsDS}, '~safe::byteme::idx::hospitals_fips');

BuildHospitals_City_IDX := BUILD(cleanHospitals_city_idx, OVERWRITE);
BuildHospitals_Type_City_IDX := BUILD(cleanHospitals_type_city_idx, OVERWRITE);
Buildhospitals_Fips_IDX := BUILD(CleanHospitals_Fips_IDX, OVERWRITE);

SEQUENTIAL(WriteHospitals,
           BuildHospitals_City_IDX, BuildHospitals_Type_city_idx, Buildhospitals_Fips_IDX);