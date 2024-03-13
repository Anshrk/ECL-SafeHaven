IMPORT $;

ChurchesDS := DISTRIBUTE($.church_Distribution.Distribution_by_state);
SortedDS := SORT(ChurchesDS, num_churches);


MedianValue := SortedDS[ROUND(COUNT(SortedDS) / 2)].num_churches;

EXPORT church_density := MODULE

EXPORT Layout := RECORD
    $.church_Distribution.Distribution_by_state;
    STRING density;
END;


Layout RateChurchDensityInStates($.church_Distribution.churchstate L) := TRANSFORM
    SELF := L;
    isDense := L.num_churches > MedianValue;
    SELF.density := IF(isDense,
                        'DENSE',
                        'SPARSE');
END;

EXPORT File := PROJECT(SortedDS, RateChurchDensityInStates(LEFT), LOCAL);

END;



