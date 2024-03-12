IMPORT $;

fireDS := ($.File_AllData.fireDS);
fire_Layout := $.File_AllData.fireRec;

UID_fire_Layout := RECORD
    UNSIGNED4 UID;
    fire_Layout AND NOT [objectid];
END;


UID_fire_Layout AssignUID(fire_Layout Le, UNSIGNED4 i) := TRANSFORM
    SELF := Le;
    SELF.UID := i;
END;

EXPORT UID_fire := PROJECT(fireDS, AssignUID(LEFT, COUNTER)) : PERSIST('~class::byteme::persist::uid_fire');
