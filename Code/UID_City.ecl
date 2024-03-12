IMPORT $;

cityDS := ($.File_AllData.City_DS);
city_Layout := $.File_AllData.CitiesRec;

UID_city_Layout := RECORD
    UNSIGNED4 UID;
    city_Layout;
END;


UID_city_Layout AssignUID(city_Layout Le, UNSIGNED4 i) := TRANSFORM
    SELF := Le;
    SELF.UID := i;
END;

EXPORT UID_city := PROJECT(cityDS, AssignUID(LEFT, COUNTER)) : PERSIST('~class::byteme::persist::uid_city');
