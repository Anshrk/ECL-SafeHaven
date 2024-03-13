IMPORT $;

DS := $.File_AllData.HospitalDS;

TDS := TABLE(
    DS, {st_fips, state}
);

SortedTable := SORT(DS, st_fips);
DedupedStates := DEDUP(SortedTable, LEFt.st_fips=RIGHT.st_fips AND LEFT.state=RIGHT.state);
EXPORT States := DedupedStates;