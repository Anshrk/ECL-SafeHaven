IMPORT $;

EXPORT isCrimeRateLow := MODULE
    EXPORT CrimeRate_40_percentile := $.CrimeRate_Per_100_000.Sorted_CrimeRate[ROUND(0.4 * $.CrimeRate_Per_100_000.Total_Count)].crime_rate;
    isBelow40Percentile := $.CrimeRate_Per_100_000.Sorted_CrimeRate.crime_rate < CrimeRate_40_percentile;
    EXPORT isCrimeRateLow := isBelow40Percentile;
END;