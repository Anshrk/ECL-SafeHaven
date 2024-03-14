#option('obfuscateOutput', true);
IMPORT $, Visualizer;

PD_County := TABLE($.Hospital_Distribution.Distribution_by_county, {
    $.Hospital_Distribution.Distribution_by_county.county_fips,
    $.Hospital_Distribution.Distribution_by_county.num_Hospital
});
PD_state := $.Hospital_Distribution.Distribution_by_state;
PD_city := $.Hospital_Distribution.Distribution_by_city;

OUTPUT(PD_County,,'~safe::byteme::out::hospital_dist_county', OVERWRITE);
OUTPUT(PD_state,,'~safe::byteme::out::hospital_dist_state', OVERWRITE);
// OUTPUT(PD_city,,'~safe::byteme::out::hospital_dist_county', OVERWRITE);

Visualizer.Choropleth.USStates('Hospitals_Per_State','~safe::byteme::out::hospital_dist_state');
Visualizer.Choropleth.USCounties('Hospitals_Per_County','~safe::byteme::out::hospital_dist_county');