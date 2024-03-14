IMPORT $;

FoodbanksDS := DISTRIBUTE($.foodbanks_Distribution.Distribution_by_state);
SortedDS := SORT(FoodbanksDS, num_foodbanks);
DedupDS := DEDUP(SortedDS, LEFT.state=RIGHT.state);


MedianValue := DedupDS[ROUND(COUNT(SortedDS) / 2)].num_foodbanks;

EXPORT foodbanksDensity := MODULE

EXPORT Layout := RECORD
    STRING2 state := FoodBanksDS.state;
    INTEGER density;
END;


Layout RatefoodbanksDensityInStates($.foodbanks_Distribution.foodbankstate L) := TRANSFORM
    SELF := L;
    isDense := L.num_foodbanks > MedianValue;
    SELF.density := IF(isDense,
                        1,
                        0);
END;

EXPORT File := PROJECT(DedupDS, RatefoodbanksDensityInStates(LEFT), LOCAL) : PERSIST('~safe::byteme::persist::foodbank_density');

END;



