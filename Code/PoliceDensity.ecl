IMPORT $;

PoliceDS := DISTRIBUTE($.Police_Distribution.Distribution_by_state);
SortedDS := SORT(PoliceDS, num_Police_stations);


MedianValue := SortedDS[ROUND(COUNT(SortedDS) / 2)].num_Police_stations;

EXPORT PoliceDensity := MODULE

EXPORT Layout := RECORD
    $.Police_Distribution.Distribution_by_state;
    STRING density;
END;


Layout RatePoliceDensityInStates($.Police_Distribution.PD_State L) := TRANSFORM
    SELF := L;
    isDense := L.num_Police_stations > MedianValue;
    SELF.density := IF(isDense,
                        'DENSE',
                        'SPARSE');
END;

EXPORT File := PROJECT(SortedDS, RatePoliceDensityInStates(LEFT), LOCAL);

END;



