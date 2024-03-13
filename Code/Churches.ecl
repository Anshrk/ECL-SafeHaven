import $;
import visualizer;
UID_churches := $.UID_Church;
reducedlayout := record
    UID_churches.uid;
    UID_churches.name;
    UID_churches.street;
    UID_churches.city;
    UID_churches.state;
    UID_churches.zip;
    UID_churches.region;
END;
reducedtable := table(UID_churches,reducedlayout);
EXPORT Churches := reducedtable;