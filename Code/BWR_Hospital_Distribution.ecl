#option('obfuscateOutput', true);
IMPORT $, Visualizer;

PD_County := $.Hospital_Distribution.Distribution_by_county;
PD_state := $.Hospital_Distribution.Distribution_by_state;
PD_city := $.Hospital_Distribution.Distribution_by_city;

OUTPUT(PD_County);
OUTPUT(PD_state);
OUTPUT(PD_city);

// OUTPUT(COUNT(PD_County));
// Visualizer.Choropleth.USStates('Hospitals_Per_State',,'Hospital_Distribution_by_State');
// Visualizer.Choropleth.USCounties('Hospitals_Per_County',,'Hospital_Distribution_by_County');