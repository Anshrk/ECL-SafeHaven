#option('obfuscateOutput', true);

IMPORT $;

ChurchDS := $.STD_Churches.File;

CleanChurch_RECORD := RECORD
    ChurchDS.uid;
    ChurchDS.name;
    ChurchDS.city;
    ChurchDS.state;
END;


UID_Church_Layout := RECORD
    $.STD_Churches.Layout;
END;

CleanChurchs := TABLE(ChurchDS, CleanChurch_RECORD);
WriteChurchs := OUTPUT(CleanChurchs,, '~safe::byteme::out::Churchs', OVERWRITE);
CleanChurchsDS := DATASET('~safe::byteme::out::Churchs',CleanChurch_RECORD , FLAT);

CleanChurchs_City_IDX := INDEX(CleanChurchsDS, {city}, {CleanChurchsDS}, '~safe::byteme::idx::Churchs_c');
BuildChurchs_City_IDX := BUILD(cleanChurchs_city_idx, OVERWRITE);

SEQUENTIAL(WriteChurchs,
           BuildChurchs_City_IDX);