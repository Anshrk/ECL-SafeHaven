IMPORT $;

police := $.UID_Police;
reducedlayout := RECORD
    police.uid;
    police.name;
    police.address;
    police.city;
    police.telephone;
    police.state;
    police.countyfips;
    police.county;
END;

reducedtable := table(police, reducedlayout);
EXPORT Polices := reducedtable;
