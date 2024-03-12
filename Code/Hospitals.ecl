import $;
hospitals := $.File_AllData.HospitalDS;
reducedlayout := record
    hospitals.id;
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
output(reducedtable);

type_record := RECORD
    hospitals.type;
    
END;
type_table := TABLE(hospitals, type_record);
type_no_dup := DEDUP(SORT(type_table, type), type); // removing duplicates from the table
OUTPUT(type_no_dup);