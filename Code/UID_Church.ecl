IMPORT $;

churchDS := ($.File_AllData.churchDS);
church_Layout := $.File_AllData.churchRec;

UID_church_Layout := RECORD
    UNSIGNED4 UID;
    church_Layout AND NOT [___objectid];
END;


UID_church_Layout AssignUID(church_Layout Le, UNSIGNED4 i) := TRANSFORM
    SELF := Le;
    SELF.UID := i;
END;

EXPORT UID_church := PROJECT(churchDS, AssignUID(LEFT, COUNTER)) : PERSIST('~class::byteme::persist::uid_church');
