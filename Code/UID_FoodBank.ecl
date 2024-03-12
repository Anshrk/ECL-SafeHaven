IMPORT $;

foodbankDS := ($.File_AllData.foodbankDS);
foodbank_Layout := $.File_AllData.foodbankRec;

UID_foodbank_Layout := RECORD
    UNSIGNED4 UID;
    foodbank_Layout AND NOT [fid];
END;


UID_foodbank_Layout AssignUID(foodbank_Layout Le, UNSIGNED4 i) := TRANSFORM
    SELF := Le;
    SELF.UID := i;
END;

EXPORT UID_foodbank := PROJECT(foodbankDS, AssignUID(LEFT, COUNTER)) : PERSIST('~class::byteme::persist::uid_foodbank');
