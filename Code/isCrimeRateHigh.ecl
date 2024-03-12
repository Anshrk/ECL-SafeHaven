IMPORT $;

EXPORt isCrimeRateHigh := MODULE
    CrimeRate_60_percentile := $.CrimeRate_Per_100_000.Sorted_CrimeRate[ROUND(0.6 * $.CrimeRate_Per_100_000.Total_Count)].crime_rate;
    isAbove60Percentile := $.CrimeRate_Per_100_000.Sorted_CrimeRate.crime_rate > CrimeRate_60_percentile;
    EXPORT isCrimeRateHigh := isAbove60Percentile;
END;