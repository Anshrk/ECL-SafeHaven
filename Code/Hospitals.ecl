import $;
import visualizer;
hospitals := $.UID_Hospital;
reducedlayout := record
    hospitals.uid;
    hospitals.name;
    hospitals.address;
    hospitals.city;
    hospitals.state;
    hospitals.zip;
    hospitals.telephone;
    hospitals.type;
    hospitals.status;
    hospitals.county;
    hospitals.countyfips;
    hospitals.website;
    hospitals.state_id;
    hospitals.owner
end;
reducedtable := table(hospitals,reducedlayout);
output(reducedtable,named('Hospital_Data'));

type_record := RECORD
    hospitals.type;
    typecount:= COUNT(group);
    
END;
type_table := TABLE(hospitals, type_record,type);
type_no_dup := DEDUP(SORT(type_table, type), type); // removing duplicates from the table
OUTPUT(type_no_dup,named('Type_of_Hospitals'));
Visualizer.twod.pie('Type of Hospitals',,'Type_of_Hospitals');


OUTPUT(REDUCEDTABLE(TYPE='CHILDREN'),NAMED('CHILDRENS_HOSPITALS'));
OUTPUT(REDUCEDTABLE(TYPE='CHRONIC DISEASE'),NAMED('CHRONIC_DISEASE_HOSPITALS'));
OUTPUT(REDUCEDTABLE(TYPE='CRITICAL ACCESS'),NAMED('CRITICAL_ACCESS_HOSPITALS'));
OUTPUT(REDUCEDTABLE(TYPE='GENERAL ACUTE CARE'),NAMED('GENERAL_ACUTE_CARE_HOSPITALS'));
OUTPUT(REDUCEDTABLE(TYPE='LONG TERM CARE'),NAMED('LONG_TERM_CARE_HOSPITALS'));
OUTPUT(REDUCEDTABLE(TYPE='MILITARY'),NAMED('MILITARY_HOSPITALS'));
OUTPUT(REDUCEDTABLE(TYPE='PSYCHIATRIC'),NAMED('PSYCHIATRIC_HOSPITALS'));
OUTPUT(REDUCEDTABLE(TYPE='REHABILITATION'),NAMED('REHABILITATION_HOSPITALS'));
OUTPUT(REDUCEDTABLE(TYPE='SPECIAL'),NAMED('SPECIAL_HOSPITALS'));
OUTPUT(REDUCEDTABLE(TYPE='WOMEN'),NAMED('WOMEN_HOSPITALS'));