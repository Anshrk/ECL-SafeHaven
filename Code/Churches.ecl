import $;
churchesDS := $.UID_Church;
reducedlayout := record
    churchesDS.uid;
    churchesDS.name;
    churchesDS.street;
    churchesDS.city;
    churchesDS.state;
    churchesDS.zip;
    churchesDS.region;
END;
EXPORT Churches := table(churchesDS,reducedlayout);