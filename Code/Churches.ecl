#OPTION('obfuscateOutput', TRUE);
import $;
import visualizer;
churches := $.UID_Church;
reducedlayout := record
    churches.uid;
    churches.name;
    churches.street;
    churches.city;
    churches.state;
    churches.zip;
    churches.region;
END;
reducedtable := table(churches,reducedlayout);
output(reducedtable,named('Churches_Data'));