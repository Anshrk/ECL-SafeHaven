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
    hospitals.source;
    hospitals.website;
    hospitals.state_id;
    hospitals.owner
end;
reducedtable := table(hospitals,reducedlayout);
output(reducedtable)

// naics_record := RECORD
//     hospitals.naics_code;hospitals
//     hospitals.naics_desc;
// END;
// naics_table := TABLE(hospitals, naics_record);
// Naics_no_dup := DEDUP(SORT(naics_table, naics_code), naics_code); // removing duplicates from the table
// OUTPUT(Naics_no_dup);