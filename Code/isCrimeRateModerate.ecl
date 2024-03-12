IMPORT $;

EXPORT isCrimeRateModerate := MODULE

CrimeRate_40_percentile := $.CrimeRate_Per_100_000.Sorted_CrimeRate[ROUND(0.4 * $.CrimeRate_Per_100_000.Total_Count)].crime_rate;
CrimeRate_60_percentile := $.CrimeRate_Per_100_000.Sorted_CrimeRate[ROUND(0.6 * $.CrimeRate_Per_100_000.Total_Count)].crime_rate;
isAbove40Percentile := $.CrimeRate_Per_100_000.Sorted_CrimeRate.crime_rate >= CrimeRate_40_percentile;
isBelow60Percentile := $.CrimeRate_Per_100_000.Sorted_CrimeRate.crime_rate < CrimeRate_40_percentile;
EXPORT isCrimeRateModerate := isAbove40Percentile AND isBelow60Percentile;

END;