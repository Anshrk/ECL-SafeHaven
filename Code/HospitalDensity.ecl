IMPORT $;

HospitalDS := DISTRIBUTE($.Hospital_Distribution.Distribution_by_state);
SortedDS := SORT(HospitalDS, num_hospital);
DedupDS := DEDUP(SortedDS, LEFT.state=RIGHT.state);

MedianValue := SortedDS[ROUND(COUNT(SortedDS) / 2)].num_hospital;

EXPORT hospitalDensity := MODULE

EXPORT Layout := RECORD
    STRING2 state := HospitalDS.state;
    INTEGER density;
END;


Layout RatehospitalDensityInStates($.Hospital_Distribution.HD_State L) := TRANSFORM
    SELF := L;
    isDense := L.num_hospital > MedianValue;
    SELF.density := IF(isDense,
                        1,
                        -1);
END;

EXPORT File := PROJECT(SortedDS, RatehospitalDensityInStates(LEFT), LOCAL) : PERSIST('~safe::byteme::persist::hospital_density');

END;



