IMPORT $;

PoliceDS := DISTRIBUTE($.Police_Distribution.Distribution_by_state);
SortedDS := SORT(PoliceDS, num_Police_stations);
DedupDS := DEDUP(SortedDS, LEFT.state=RIGHT.state);


MedianValue := SortedDS[ROUND(COUNT(SortedDS) / 2)].num_Police_stations;

EXPORT PoliceDensity := MODULE

EXPORT Layout := RECORD
    STRING2 state := PoliceDS.state;
    INTEGER density;
END;


Layout RatePoliceDensityInStates($.Police_Distribution.PD_State L) := TRANSFORM
    SELF := L;
    isDense := L.num_Police_stations > MedianValue;
    SELF.density := IF(isDense,
                        1,
                        -1);
END;

EXPORT File := PROJECT(SortedDS, RatePoliceDensityInStates(LEFT), LOCAL)  : PERSIST('~safe::byteme::persist::police_density');;

END;



