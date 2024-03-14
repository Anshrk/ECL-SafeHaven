#option('obfuscateOutput', true);

IMPORT $, Visualizer;

SR := $.State_Rating;

OUTPUT(SR,, '~safe::byteme::out::state_rating', OVERWRITE);
Visualizer.Choropleth.USStates('State_Rating', '~safe::byteme::out::state_rating');