IMPORT $, STD;

Upper(STRING txt) := Std.Str.ToUpperCase(txt);

UID_Foodbanks := $.Foodbanks;

EXPORT STD_Foodbanks := MODULE

EXPORT STD_Foodbanks_rec := RECORD
    UID_Foodbanks.UID;
    UID_Foodbanks.food_bank_name;
    STRING80  address := Upper(UID_FoodBanks.address);
    STRING35  city := Upper(UID_FoodBanks.city);
    STRING2   state := Upper(UID_FoodBanks.state);
    UNSIGNED3 zip   := (UNSIGNED3)(UID_FoodBanks.zip_code);
    STRING6   status := Upper(UID_Foodbanks.status);
END;

EXPORT File := TABLE(UID_Foodbanks, STD_FoodBanks_rec) : PERSIST('~safe::byteme::persist::Foodbanks');

END;