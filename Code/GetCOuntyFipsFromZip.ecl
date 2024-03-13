IMPORT $;

CitiesDS := $.File_AllData.City_DS;
SlimCityDS := TABLE(
    CitiesDS, 
    {CitiesDS.county_fips, CitiesDS.zips}
);



EXPORT GetCountyFipsFromZip(UNSIGNED zipcode) := FUNCTION
    
END;
    