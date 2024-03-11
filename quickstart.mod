//Import:ecl:SafeHaven.BWR_AllInputData
IMPORT $;
SAFE := $.File_AllData; //See this file for you data dictionary (field names and data sources)
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

// This file will help yopu get to know the data
//Import:ecl:SafeHaven.BWR_CleanChurches
IMPORT $,STD;
//This file is used to demonstrate how to "clean" a raw dataset (Churches) and create an index to be used in a ROXIE service
Churches := $.File_AllData.ChurchDS;
Cities   := $.File_AllData.City_DS;


//First, determine what fields you want to clean:
CleanChurchRec := RECORD
    STRING70  name;
    STRING35  street;
    STRING22  city;
    STRING2   state;
    UNSIGNED3 zip;
    UNSIGNED1 affiliation; 
    UNSIGNED3 PrimaryFIPS; //New - will be added from Cities DS
END;
//PROJECT is used to transform one data record to another.
CleanChurch := PROJECT(Churches,TRANSFORM(CleanChurchRec,
                                          SELF.name                := STD.STR.ToUpperCase(LEFT.name),
                                          SELF.street              := STD.STR.ToUpperCase(LEFT.street),
                                          SELF.city                := STD.STR.ToUpperCase(LEFT.city),
                                          SELF.State               := STD.STR.ToUpperCase(LEFT.state),
                                          SELF.zip                 := LEFT.zip,
                                          SELF.affiliation         := LEFT.affiliation,
                                          SELF.PrimaryFIPS         := 0));
//JOIN is used to combine data from different datasets 
CleanChurchFIPS :=       JOIN(CleanChurch,Cities,
                           LEFT.city  = STD.STR.ToUpperCase(RIGHT.city) AND
                           LEFT.state = RIGHT.state_id,
                           TRANSFORM(CleanChurchRec,
                                     SELF.PrimaryFIPS := (UNSIGNED3)RIGHT.county_fips,
                                     SELF             := LEFT),LEFT OUTER,LOOKUP);
//Write out the new file and then define it using DATASET
WriteChurches      := OUTPUT(CleanChurchFIPS,,'~SAFE::OUT::Churches',OVERWRITE);                                          
CleanChurchesDS    := DATASET('~SAFE::OUT::Churches',CleanChurchRec,FLAT);

//Declare and Build Indexes (special datasets that can be used in the ROXIE data delivery cluster
CleanChurchIDX     := INDEX(CleanChurchesDS,{city,state},{CleanChurchesDS},'~SAFE::IDX::Church::CityPay');
CleanChurchFIPSIDX := INDEX(CleanChurchesDS,{PrimaryFIPS},{CleanChurchesDS},'~SAFE::IDX::Church::FIPSPay');
BuildChurchIDX     := BUILD(CleanChurchIDX,OVERWRITE);
BuildChurchFIPSIDX := BUILD(CleanChurchFIPSIDX,OVERWRITE);

//SEQUENTIAL is similar to OUTPUT, but executes the actions in sequence instead of the default parallel actions of the HPCC
SEQUENTIAL(WriteChurches,BuildChurchIDX,BuildChurchFIPSIDX);



//Import:ecl:SafeHaven.BWR_CreateCoreExample
// Let's create a core "risk" file that the county code (FIPS) and the primary city.
// We can extra ct this data from the Cities file.
IMPORT $;
CityDS := $.File_AllData.City_DS;
Crime  := $.File_AllData.CrimeDS;

//CityDS(county_fips = 5035); Test to verify data accuracy for the crime score


// Declare our core RECORD:
RiskRec := RECORD
    STRING45  city;
    STRING2   state_id;
    STRING20  state_name;
    UNSIGNED3 county_fips;
    STRING30  county_name;
END;

BaseInfo := PROJECT(CityDS,RiskRec);
OUTPUT(BaseInfo,NAMED('BaseData'));

RiskPlusRec := RECORD
 BaseInfo;
 EducationScore  := 0;
 PovertyScore    := 0;
 PopulationScore := 0;
 CrimeScore      := 0;
 Total           := 0;
END; 
 
RiskTbl := TABLE(BaseInfo,RiskPlusRec);
OUTPUT(RiskTbl,NAMED('BuildTable'));

//Let's add a Crime Score!

CrimeRec := RECORD
CrimeRate := TRUNCATE((INTEGER)Crime.crime_rate_per_100000);
Crime.fips_st;
fips_cty := (INTEGER)Crime.fips_cty;
Fips := Crime.fips_st + INTFORMAT(Crime.fips_cty,3,1);
END;

CrimeTbl := TABLE(Crime,CrimeRec);
OUTPUT(CrimeTbl,NAMED('BuildCrimeTable'));

JoinCrime := JOIN(CrimeTbl,RiskTbl,
                  LEFT.fips = (STRING5)RIGHT.county_fips,
                  TRANSFORM(RiskPlusRec,
                            SELF.CrimeScore := LEFT.crimerate,
                            SELF            := RIGHT),
                            RIGHT OUTER);
                            
OUTPUT(SORT(JoinCrime,-CrimeScore),NAMED('AddedCrimeScore')); 

//Now go out and get the others! Good like with your challenge! 
//After you complete the other scores, make sure to OUTPUT to a file and then create a DATASET so
//that you can reference and deliver it to the judges.                           




//Import:ecl:SafeHaven.BWR_Tips
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

//Import:ecl:SafeHaven.Codes
// POVALL_2021	Estimate of people of all ages in poverty 2021
// CI90LBALL_2021	90 percent confidence interval lower bound of estimate of people of all ages in poverty 2021
// CI90UBALL_2021	90 percent confidence interval upper bound of estimate of people of all ages in poverty 2021
// PCTPOVALL_2021	Estimated percent of people of all ages in poverty 2021
// CI90LBALLP_2021	90 percent confidence interval lower bound of estimate of percent of people of all ages in poverty 2021
// CI90UBALLP_2021	90 percent confidence interval upper bound of estimate of percent of people of all ages in poverty 2021
// POV017_2021	Estimate of people age 0-17 in poverty 2021
// CI90LB017_2021	90 percent confidence interval lower bound of estimate of people age 0-17 in poverty 2021
// CI90UB017_2021	90 percent confidence interval upper bound of estimate of people age 0-17 in poverty 2021
// PCTPOV017_2021	Estimated percent of people age 0-17 in poverty 2021
// CI90LB017P_2021	90 percent confidence interval lower bound of estimate of percent of people age 0-17 in poverty 2021
// CI90UB017P_2021	90 percent confidence interval upper bound of estimate of percent of people age 0-17 in poverty 2021
// POV517_2021	Estimate of related children age 5-17 in families in poverty 2021
// CI90LB517_2021	90 percent confidence interval lower bound of estimate of related children age 5-17 in families in poverty 2021
// CI90UB517_2021	90 percent confidence interval upper bound of estimate of related children age 5-17 in families in poverty 2021
// PCTPOV517_2021	Estimated percent of related children age 5-17 in families in poverty 2021
// CI90LB517P_2021	90 percent confidence interval lower bound of estimate of percent of related children age 5-17 in families in poverty 2021
// CI90UB517P_2021	90 percent confidence interval upper bound of estimate of percent of related children age 5-17 in families in poverty 2021
// MEDHHINC_2021	Estimate of median household income 2021
// CI90LBINC_2021	90 percent confidence interval lower bound of estimate of median household income 2021
// CI90UBINC_2021	90 percent confidence interval upper bound of estimate of median household income 2021
// POV04_2021	Estimate of children ages 0 to 4 in poverty 2021 (available for the U.S. and State total only)
// CI90LB04_2021	90 percent confidence interval lower bound of estimate of children ages 0 to 4 in poverty 2021 (available for the U.S. and State total only)
// CI90UB04_2021	90 percent confidence interval upper bound of estimate of children ages 0 to 4 in poverty 2021 (available for the U.S. and State total only)
// PCTPOV04_2021	Estimated percent of children ages 0 to 4 in poverty 2021 (available for the U.S. and State total only)
// CI90LB04P_2021	90 percent confidence interval lower bound of estimate of percent of children ages 0 to 4 in poverty 2021 (available for the U.S. and State total only)
// CI90UB04P_2021	90 percent confidence interval upper bound of estimate of percent of children ages 0 to 4 in poverty 2021 (available for the U.S. and State total only)
//Import:ecl:SafeHaven.File_AllData
EXPORT File_AllData := MODULE
//The datasets proivided in this challenge are all in the public domain and free for you to use. 
//The links to the downloads and specific license info is provided below.


//Unemployment Rates
//Not used in challenge, just interesting info!
EXPORT unemp_rates := RECORD
    STRING Year;
    STRING Jan;
    STRING Feb;
    STRING Mar;
    STRING Apr;
    STRING May;
    STRING Jun;
    STRING Jul;
    STRING Aug;
    STRING Sep;
    STRING Oct;
    STRING Nov;
    STRING Dec;
END; 
EXPORT unemp_ratesDS := DATASET('~safe::in::us_unemploymentrates',unemp_rates,CSV(HEADING(1)));

//https://www.ers.usda.gov/data-products/county-level-data-sets/county-level-data-sets-download-data/
//Unemployment stats from 2000-2021
EXPORT unemp_byCounty := RECORD
    UNSIGNED3 FIPS_Code;
    STRING2   State;
    STRING50  Area_Name;
    STRING45  Attribute;
    REAL8     Value;
END;

EXPORT unemp_byCountyDS := DATASET('~safe::in::unemployment',unemp_byCounty,CSV(HEADING(1)));

EXPORT pov_estimates := RECORD
    UNSIGNED3 FIPS_Code;
    STRING2   State;
    STRING35  Area_name;
    STRING35  Attribute;
    REAL8     Value;
END;

EXPORT pov_estimatesDS := DATASET('~safe::in::poverty',pov_estimates,CSV(HEADING(1)));

EXPORT Education := RECORD
    UNSIGNED3 FIPS_Code; //Federal_Information_Processing_Standard
    STRING2   State;
    STRING45  Area_name;
    STRING75  Attribute;
    REAL8     Value;
END;

EXPORT EducationDS := DATASET('~safe::in::education',education,CSV(HEADING(1)));

EXPORT pop_estimates := RECORD
    UNSIGNED3 FIPS_Code;
    STRING2   State;
    STRING50  Area_Name;
    STRING35  Attribute;
    REAL8     Value;
END;

EXPORT pop_estimatesDS := DATASET('~safe::in::population',pop_estimates,CSV(HEADING(1)));

//https://hifld-geoplatform.hub.arcgis.com/datasets
//Fire Stations
//Available for public use. 
//None. Acknowledgement of the USGS is appreciated. This dataset is provided as is and intended for general mapping purposes. 
//The information contained in these data are dynamic and could change over time. USGS makes no warranty about content accuracy 
//or currentness of the data and assumes no liability for use of this data. 
//User assumes responsibility for appropriate use and interpretation of the dataset.
EXPORT FireRec := RECORD
    REAL8     Xcoor;
    REAL8     Ycoor;
    UNSIGNED3 objectid;
    STRING40  permanent_identifier;
    STRING30  source_featureid;
    STRING40  source_datasetid;
    STRING50  source_datadesc;
    STRING85  source_originator;
    UNSIGNED1 data_security;
    STRING2   distribution_policy;
    STRING25  loaddate;
    UNSIGNED2 ftype;
    UNSIGNED3 fcode;
    STRING100 name;
    UNSIGNED1 islandmark;
    UNSIGNED1 pointlocationtype;
    UNSIGNED1 admintype;
    STRING60  addressbuildingname;
    STRING65  address;
    STRING35  city;
    STRING2   state;
    STRING10  zipcode;
    UNSIGNED4 gnis_id;
    STRING    foot_id;
    STRING    complex_id;
    STRING38  globalid;
END;

EXPORT FireDS := DATASET('~safe::in::Fire',FireRec,CSV(HEADING(1)));

//Local Law Enforcement Locations in US
//https://hifld-geoplatform.opendata.arcgis.com/datasets/local-law-enforcement-locations/explore
//License: None (Public Use). 
//Users are advised to read the data set's metadata thoroughly to understand appropriate use and data limitations.
EXPORT PoliceRec := RECORD
    REAL8     xCoor;
    REAL8     yCoor;
    UNSIGNED3 objectid;
    UNSIGNED4 id;
    STRING135 name;
    STRING80  address;
    STRING30  city;
    STRING2   state;
    STRING5   zip;
    STRING15  zip4;
    STRING15  telephone;
    STRING25  type;
    STRING15  status;
    INTEGER3  population;
    STRING25  county;
    STRING5   countyfips;
    STRING3   country;
    REAL8     latitude;
    REAL8     longitude;
    UNSIGNED3 naics_code;
    STRING20  naics_desc;
    STRING145 source;
    STRING25  sourcedate;
    STRING15  val_method;
    STRING25  val_date;
    STRING155 website;
    STRING15  ci_id;
    INTEGER4  csllea08id;
    INTEGER2  subtype1;
    INTEGER2  subtype2;
    INTEGER2  tribal;
    INTEGER2  numpre;
    INTEGER2  numfixsub;
    INTEGER2  nummobile;
    INTEGER3  ftsworn;
    INTEGER3  ftciv;
    INTEGER2  ptsworn;
    INTEGER2  ptciv;
END;

EXPORT PoliceDS := DATASET('~safe::in::Police',PoliceRec,CSV(HEADING(1)));

EXPORT HospitalRec := RECORD
    REAL8     xCoor;
    REAL8     yCoor;
    UNSIGNED2 objectid;
    STRING10  id;
    STRING95  name;
    STRING80  address;
    STRING35  city;
    STRING2   state;
    STRING5   zip;
    STRING15  zip4;
    STRING15  telephone;
    STRING20  type;
    STRING6   status;
    INTEGER2  population;
    STRING20  county;
    STRING5   countyfips;
    STRING3   country;
    REAL8     latitude;
    REAL8     longitude;
    UNSIGNED3 naics_code;
    STRING70  naics_desc;
    STRING165 source;
    STRING22  sourcedate;
    STRING13  val_method;
    STRING22  val_date;
    STRING206 website;
    STRING15  state_id;
    STRING110 alt_name;
    STRING2   st_fips;
    STRING31  owner;
    INTEGER2  ttl_staff;
    INTEGER2  beds;
    STRING45  trauma;
    STRING15  helipad;
END;

EXPORT HospitalDS := DATASET('~safe::in::Hospitals',HospitalRec,CSV(HEADING(1)));

//Cities Database
//Free Version: https://simplemaps.com/data/us-cities
//
EXPORT CitiesRec := RECORD
    STRING45  city;
    STRING45  city_ascii;
    STRING2   state_id;
    STRING20  state_name;
    UNSIGNED3 county_fips;
    STRING30  county_name;
    REAL4     lat;
    REAL8     lng;
    UNSIGNED4 population;
    REAL4     density;
    STRING5   source;
    STRING5   military;
    STRING5   incorporated;
    STRING30  timezone;
    UNSIGNED1 ranking;
    STRING1855 zips;
    UNSIGNED5 id;
END;

EXPORT City_DS := DATASET('~safe::IN::uscities',citiesrec,CSV(HEADING(1)));

//MORE DATA FROM Homeland Infrastructure Foundation-Level Data (HIFLD)
// https://hifld-geoplatform.opendata.arcgis.com/datasets/geoplatform::all-places-of-worship/explore
//Places of Worship

EXPORT ChurchRec := RECORD
    UNSIGNED3 ___objectid;
    UNSIGNED5 ein;
    STRING70 name;
    STRING35 street;
    STRING22 city;
    STRING2 state;
    UNSIGNED3 zip;
    UNSIGNED1 affiliation;
    UNSIGNED3 ruling;
    UNSIGNED1 foundation;
    UNSIGNED5 activity;
    UNSIGNED1 organization;
    UNSIGNED3 tax_period;
    UNSIGNED1 acct_pd;
    STRING13 ntee_cd;
    STRING13 sort_name;
    STRING13 loc_name;
    STRING1 geocoded_status;
    REAL8 score;
    STRING1 match_type;
    STRING75 match_addr;
    STRING13 addr_type;
    STRING13 addnum;
    STRING13 side;
    STRING13 stpredir;
    STRING19 stpretype;
    STRING29 stname;
    STRING13 sttype;
    STRING13 stdir;
    STRING37 staddr;
    STRING30 city_2;
    STRING23 subregion;
    STRING20 region;
    STRING13 regionabbr;
    STRING13 postal;
    STRING3 country;
    STRING13 langcode;
    UNSIGNED1 distance;
    REAL8 x;
    REAL8 y;
    REAL8 displayx;
    REAL8 displayy;
    REAL8 xmin;
    REAL8 xmax;
    REAL8 ymin;
    REAL8 ymax;
    STRING13 addnumfrom;
    STRING13 addnumto;
    STRING13 rank;
    STRING35 arc_address;
    STRING22 arc_city;
    STRING2 arc_region;
    UNSIGNED3 arc_postal;
END;

EXPORT ChurchDS := DATASET('~safe::in::churches',churchrec,CSV(HEADING(1)));

//FEMA: 
//https://gis-fema.hub.arcgis.com/datasets/da001dee68474719b934a166f7abdc46/explore
//Food banks
EXPORT FoodBankRec := RECORD
    REAL8 ___x;
    REAL8 y;
    UNSIGNED1 fema_region;
    STRING63 food_bank_name;
    UNSIGNED2 member_number;
    STRING42 address;
    STRING16 city;
    STRING2 state;
    STRING10 zip_code;
    STRING60 web_page;
    STRING100 facebook_page;
    UNSIGNED2 fid;
    STRING11 status;
    STRING36 globalid;
END;

EXPORT FoodBankDS := DATASET('~safe::in::foodbanks',foodbankrec,CSV(HEADING(1)));

EXPORT CrimeRec := RECORD
    STRING county_name;
    STRING crime_rate_per_100000;
    STRING index1;
    STRING EDITION;
    STRING PART;
    STRING IDNO;
    STRING CPOPARST;
    STRING CPOPCRIM;
    STRING AG_ARRST;
    STRING AG_OFF;
    STRING COVIND;
    STRING INDEX2;
    STRING MODINDX;
    STRING MURDER;
    STRING RAPE;
    STRING ROBBERY;
    STRING AGASSLT;
    STRING BURGLRY;
    STRING LARCENY;
    STRING MVTHEFT;
    STRING ARSON;
    STRING population;
    UNSIGNED1 FIPS_ST;
    UNSIGNED3 FIPS_CTY;
END;

EXPORT CrimeDS := DATASET('~safe::in::crime',crimerec,CSV(HEADING(1)));
END;
//Import:ecl:SafeHaven.Safe_Svc
IMPORT $,STD;
UpperIt(STRING txt) := Std.Str.ToUpperCase(txt);
//These INDEXes are created (built) in BWR_CleanChurches
CleanChurchRec := RECORD
    STRING70  name;
    STRING35  street;
    STRING22  city;
    STRING2   state;
    UNSIGNED3 zip;
    UNSIGNED1 affiliation; 
    UNSIGNED3 PrimaryFIPS; //New - will be added from Cities DS
END;
CleanChurchesDS    := DATASET('~SAFE::OUT::Churches',CleanChurchRec,FLAT);
CleanChurchIDX     := INDEX(CleanChurchesDS,{city,state},{CleanChurchesDS},'~SAFE::IDX::Church::CityPay');
CleanChurchFIPSIDX := INDEX(CleanChurchesDS,{PrimaryFIPS},{CleanChurchesDS},'~SAFE::IDX::Church::FIPSPay');

/* To Publish your Query:
   1. Change Target to ROXIE
   2. Compile ONLY
   3. Open ECL Watch and select the Publish tab to publish your query 
   4. Test and demonstarte using: http://training.us-hpccsystems-dev.azure.lnrsg.io:8002
    
*/
EXPORT Safe_Svc(FipsVal,STRING22 CityVal,STRING2 StateVal) := FUNCTION
MyChurch := IF(FipsVal = 0,
               OUTPUT(CleanChurchIDX(City=UpperIt(CityVal),State=UpperIt(StateVal))),
               OUTPUT(CleanChurchFIPSIDX(PrimaryFIPS=FipsVal)));
RETURN MyChurch;
END;



//Import:ecl:SafeHaven.TestMeHello
OUTPUT('Hello Hackers!');
//Import:ecl:SafeHaven.VizCityEx
IMPORT $,Visualizer;

Cities := $.File_AllData.City_DS;

//Build Table
DensityTbl := TABLE(Cities,{(INTEGER)county_fips,(INTEGER)density});

OUTPUT(DensityTbl,NAMED('DenFIPS'));

Visualizer.Choropleth.USCounties('Fips_demo',,'DenFIPS', , , DATASET([{'paletteID', 'Defaul;t'}], Visualizer.KeyValueDef));



