#option('obfuscateOutput', true);
IMPORT $, Visualizer;

PD_County := TABLE($.CRIME_distribution.Distribution_by_county, {
    $.CRIME_distribution.Distribution_by_county.county_fips,
    $.CRIME_distribution.Distribution_by_county.num_crimeincounty
});
PD_state := $.CRIME_distribution.Distribution_by_state;

OUTPUT(PD_County,,'~safe::byteme::out::crime_dist_county', OVERWRITE);
OUTPUT(PD_state,,'~safe::byteme::out::crime_dist_state', OVERWRITE);

Visualizer.Choropleth.USStates('CrimeRates_Per_State','~safe::byteme::out::crime_dist_state');
Visualizer.Choropleth.USCounties('CrimeRates_Per_County','~safe::byteme::out::crime_dist_county');