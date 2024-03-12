IMPORT $;

police := $.UID_Police;
reducedlayout := RECORD
    police.uid;
    police.name;
    police.address;
    police.city;
    police.telephone;
END;



OUTPUT(' ');
