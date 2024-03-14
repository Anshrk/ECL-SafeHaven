IMPORT $;

PoliceDensity := ($.PoliceDensity.File);
HospitalDensity := ($.HospitalDensity.File);
FoodBankDensity := ($.FoodbanksDensity.File);
CrimesSeverity := ($.CrimeRates);

CrimeDensity := TABLE(CrimesSeverity, {
    STRING2 state := CrimesSeverity.state,
    INTEGER density := ROUND(AVE(GROUP, CrimesSeverity.density))
}, state);

DS := SORT(PoliceDensity + HospitalDensity + FoodBankDensity + CrimeDensity, state);

Layout := RECORD
    STRING2 state;
    UNSIGNED rating;
END;

PH_Rating(STRING density) := IF(density='DENSE', 1, 0);
Crime_Rating(STRING sev) := MAP(sev='LOW' => 0, sev='MODERATE' => 1, 2);


StateRating_Layout := RECORD
    STRING2 state := DS.state;
    INTEGER rating := SUM(GROUP, DS.density);
END;

EXPORT State_Rating := TABLE(DS, StateRating_Layout, state);
