IMPORT $;

HospitalDS := ($.File_AllData.HospitalDS);
Hospital_Layout := $.File_AllData.HospitalRec;

UID_Hospital_Layout := RECORD
    UNSIGNED4 UID;
    Hospital_Layout AND NOT [objectid];
END;


UID_Hospital_Layout AssignUID(Hospital_Layout Le, UNSIGNED4 i) := TRANSFORM
    SELF := Le;
    SELF.UID := i;
END;

EXPORT UID_Hospital := PROJECT(HospitalDS, AssignUID(LEFT, COUNTER)) : PERSIST('~class::byteme::persist::uid_hospital');
