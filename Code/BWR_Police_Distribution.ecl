#option('obfuscateOutput', true);
IMPORT $, Visualizer;

PD_County := $.Police_Distribution.Distribution_by_county;
PD_state := $.Police_Distribution.Distribution_by_state;
PD_city := $.Police_Distribution.Distribution_by_city;

OUTPUT(TABLE(PD_County, {PD_County.county_fips, PD_County.num_police_stations}),,'~safe::byteme::out::police_distribution', OVERWRITE);
OUTPUT(PD_state,NAMED('Police_Distribution_by_State'));
OUTPUT(PD_city,NAMED('Police_Distribution_by_City'));

Visualizer.Choropleth.USStates('Police_Stations_Per_State',,'Police_Distribution_by_State');
Visualizer.Choropleth.USCounties('Police_Stations_Per_County','~safe::byteme::out::police_distribution');