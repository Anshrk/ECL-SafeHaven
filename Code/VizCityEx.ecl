IMPORT $,Visualizer;

Cities := $.File_AllData.City_DS;

OUTPUT(CouNT(Cities));

//Build Table
DensityTbl := TABLE(Cities,{(INTEGER)county_fips,(INTEGER)density});

OUTPUT(DensityTbl,NAMED('DenFIPS'));

Visualizer.Choropleth.USCounties('Fips_demo',,'DenFIPS', , , DATASET([{'paletteID', 'Default'}], Visualizer.KeyValueDef));


