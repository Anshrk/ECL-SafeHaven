IMPORT $;
SAFE := $.File_AllData; //See this file for your data dictionary (field names and data sources)
//RISK:
OUTPUT(SAFE.unemp_byCountyDS,NAMED('Unemployment'));
OUTPUT(SAFE.EducationDS,NAMED('Education'));
OUTPUT(SAFE.pov_estimatesDS,NAMED('Poverty'));
OUTPUT(SAFE.pop_estimatesDS,NAMED('Population'));
OUTPUT(SAFE.CrimeDS,NAMED('Crime'));
//RESOURCES:
OUTPUT(SAFE.PoliceDS,NAMED('Police'));
OUTPUT(SAFE.FireDS,NAMED('Fire'));
OUTPUT(SAFE.HospitalDS,NAMED('Hospitals'));
OUTPUT(SAFE.ChurchDS,NAMED('Churches'));
OUTPUT(SAFE.FoodBankDS,NAMED('FoodBanks'));
//REFERENCE:
OUTPUT(SAFE.City_DS,NAMED('Cities'));
OUTPUT(SORT(SAFE.City_DS,county_fips),NAMED('FipsCities'));
OUTPUT(COUNT(SAFE.City_DS),NAMED('Cities_Cnt'));

// This file will help yop get to know the data