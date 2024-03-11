IMPORT $,Visualizer;

Cities := $.File_AllData.City_DS;

//Build Table
DensityTbl := TABLE(Cities,{(INTEGER)county_fips,(INTEGER)density});

OUTPUT(DensityTbl,NAMED('DenFIPS'));

Visualizer.Choropleth.USCounties('Fips_demo',,'DenFIPS', , , DATASET([{'paletteID', 'Defaul;t'}], Visualizer.KeyValueDef));


