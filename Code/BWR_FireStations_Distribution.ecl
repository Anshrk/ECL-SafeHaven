#option('obfuscateOutput', true);
IMPORT $, Visualizer;
PD_state := $.FireStations_Distribution.Distribution_by_state;
OUTPUT(PD_state,,'~safe::byteme::out::firestations_dist_state', OVERWRITE);
Visualizer.Choropleth.USStates('FireStations_Per_State','~safe::byteme::out::firestations_dist_state');