
 import $;
firestations := $.UID_Fire;
reducedlayout := record
    firestations.uid;
    firestations.fcode;
    firestations.name;
    firestations.address;
    firestations.city;
    firestations.state;
    firestations.zipcode;
END;
reducedtable := table(firestations,reducedlayout);
output(reducedtable,named('FireStation_Data'));

STATE_RECORD := RECORD
    FIRESTATIONS.STATE;
    STATE_COUNT:= COUNT(group);
END;
STATE_TABLE := TABLE(FIRESTATIONS,STATE_RECORD,STATE);
STATE_NO_DUP := DEDUP(SORT(STATE_TABLE, STATE), STATE);

// States := ['AK', 'AL', 'AR', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL', 'GA', 'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MI', 'MN', 'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 'NY', 'OH', 'OK', 'OR', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VA', 'VI', 'VT', 'WA', 'WI', 'WV', 'WY' ];
// output(reducedtable(state in states),named('State'));
