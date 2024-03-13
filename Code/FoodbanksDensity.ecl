IMPORT $;

FoodbanksDS := DISTRIBUTE($.foodbanks_Distribution.Distribution_by_state);
SortedDS := SORT(FoodbanksDS, num_foodbanks);


MedianValue := SortedDS[ROUND(COUNT(SortedDS) / 2)].num_foodbanks;

EXPORT foodbanksDensity := MODULE

EXPORT Layout := RECORD
    $.foodbanks_Distribution.Distribution_by_state;
    STRING density;
END;


Layout RatefoodbanksDensityInStates($.foodbanks_Distribution.foodbankstate L) := TRANSFORM
    SELF := L;
    isDense := L.num_foodbanks > MedianValue;
    SELF.density := IF(isDense,
                        'DENSE',
                        'SPARSE');
END;

EXPORT File := PROJECT(SortedDS, RatefoodbanksDensityInStates(LEFT), LOCAL);

END;



