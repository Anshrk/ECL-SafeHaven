IMPORT $;

City_Table := TABLE($.File_AllData.City_DS, {city});
City_Dedup := DEDUP(City_Table, LEFT.city = RIGHT.city);

OUTPUT(City_Dedup);
OUTPUT(COUNT(City_Dedup));
