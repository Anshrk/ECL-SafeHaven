#option('obfuscateOutput', true);
IMPORT $, Visualizer;
PD_state := $.Church_Distribution.Distribution_by_state;
OUTPUT(PD_state,,'~safe::byteme::out::church_dist_state', OVERWRITE);
Visualizer.Choropleth.USStates('Churches_Per_State','~safe::byteme::out::church_dist_state');