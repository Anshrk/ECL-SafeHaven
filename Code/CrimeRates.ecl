IMPORT $;

CrimeDS := $.CrimeRate_Per_100_000.Sorted_CrimeRate;
CrimeDS_Layout := $.CrimeRate_Per_100_000.CrimeRate_Per_100000_layout;

CrimeRateClassified_Layout := RECORD
    STRING2 state := CrimeDS.state;
    INTEGER density := 0;
END;

CrimeRate_40_percentile := $.CrimeRate_Per_100_000.Sorted_CrimeRate[ROUND(0.4 * $.CrimeRate_Per_100_000.Total_Count)].crime_rate;
CrimeRate_60_percentile := $.CrimeRate_Per_100_000.Sorted_CrimeRate[ROUND(0.6 * $.CrimeRate_Per_100_000.Total_Count)].crime_rate;

CrimeRateClassified_Layout ClassifyCrimeRates(CrimeDS_Layout CrimeRate) := TRANSFORM
    SELF.state := CrimeRate.state;

    isLow := CrimeRate.crime_rate < CrimeRate_40_percentile;
    isModerate := CrimeRate.crime_rate >= CrimeRate_40_percentile AND CrimeRate.crime_rate < CrimeRate_60_percentile;
    isHigh := CrimeRate.crime_rate >= CrimeRate_60_percentile;

    SELF.density := 2 * MAP(
        isLow => 0,
        isModerate => -1,
        -2
    );
END;

EXPORT CrimeRates := PROJECT(CrimeDS, ClassifyCrimeRates(LEFT)) : PERSIST('~class:byteme::persist::crimerates');