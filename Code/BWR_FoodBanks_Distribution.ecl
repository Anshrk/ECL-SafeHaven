#option('obfuscateOutput', true);
IMPORT $, Visualizer;
PD_state := $.FoodBanks_Distribution.Distribution_by_state;
OUTPUT(PD_state,,'~safe::byteme::out::foodbanks_dist_state', OVERWRITE);
Visualizer.Choropleth.USStates('FoodBanks_Per_State','~safe::byteme::out::foodbanks_dist_state');