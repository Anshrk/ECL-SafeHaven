IMPORT $,STD;

UNEMP     := $.File_AllData.unemp_byCountyDS;
EDU       := $.File_AllData.EducationDS;
POVTY     := $.File_AllData.pov_estimatesDS;


//Add Poverty Percentage ages 0-17 for FIPS area:
POVTBL := TABLE(POVTY((STD.Str.Find(attribute, 'PCTPOV017_2021',1) <> 0)),
                {Fips_Code,attribute,value});
OUTPUT(SORT(POVTBL,-value),NAMED('PovertyPct0to17'));

//Add Unemployment Rate for area:
CT_UNEMP := TABLE(UNEMP((STD.Str.Find(attribute, 'Unemployment_rate',1) <> 0)),
                {Fips_Code,cnt := ROUND(AVE(GROUP,value),2)},Fips_Code);
OUTPUT(SORT(CT_UNEMP,-cnt),NAMED('UNEMP_Rate'));

EDU_CT_FIPS := TABLE(EDU((STD.Str.Find(attribute, 'Percent of adults with less than a high school diploma',1) <> 0)),
                {Fips_Code,tot := ROUND(AVE(GROUP,value),2)},fips_code);
OUTPUT(SORT(EDU_CT_FIPS,-tot),NAMED('NoHighSch'));
