IMPORT $;

FirestationDS := DISTRIBUTE($.firestations_Distribution.Distribution_by_state);
SortedDS := SORT(FirestationDS, num_firestations);


MedianValue := SortedDS[ROUND(COUNT(SortedDS) / 2)].num_firestations;

EXPORT firestation_density := MODULE

EXPORT Layout := RECORD
    $.firestations_Distribution.Distribution_by_state;
    STRING density;
END;


Layout RateFirestationDensityInStates($.firestations_Distribution.fsstate L) := TRANSFORM
    SELF := L;
    isDense := L.num_firestations > MedianValue;
    SELF.density := IF(isDense,
                        'DENSE',
                        'SPARSE');
END;

EXPORT File := PROJECT(SortedDS, RateFirestationDensityInStates(LEFT), LOCAL);

END;



