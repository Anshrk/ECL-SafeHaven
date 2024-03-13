IMPORT $;

HospitalDS := DISTRIBUTE($.Hospital_Distribution.Distribution_by_state);
SortedDS := SORT(HospitalDS, num_hospital);


MedianValue := SortedDS[ROUND(COUNT(SortedDS) / 2)].num_hospital;

EXPORT hospitalDensity := MODULE

EXPORT Layout := RECORD
    $.Hospital_Distribution.Distribution_by_state;
    STRING density;
END;


Layout RatehospitalDensityInStates($.Hospital_Distribution.HD_State L) := TRANSFORM
    SELF := L;
    isDense := L.num_hospital > MedianValue;
    SELF.density := IF(isDense,
                        'DENSE',
                        'SPARSE');
END;

EXPORT File := PROJECT(SortedDS, RatehospitalDensityInStates(LEFT), LOCAL);

END;



