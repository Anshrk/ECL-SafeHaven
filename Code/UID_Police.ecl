IMPORT $;

PoliceDS := ($.File_AllData.PoliceDS);
PoliceLayout := $.File_AllData.PoliceRec;

UID_Police_Layout := RECORD
    UNSIGNED4 UID;
    PoliceLayout AND NOT [objectid];
END;

UID_Police_Layout AssignUID(PoliceLayout l, UNSIGNED4 i) := TRANSFORM
    SELF.UID := i;
    SELF := l;
END;

EXPORT UID_Police := PROJECT(PoliceDS, AssignUID(LEFT, COUNTER)) : PERSIST('~class::byteme::persist::uid_police');