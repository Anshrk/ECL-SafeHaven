IMPORT $;

fsdist := $.STD_fire.File;

EXPORT FireStations_Distribution := MODULE
    statename := record
        fsdist.state;
        unsigned num_firestations := count(group);
    end;
    export distribution_by_state :=table(fsdist,statename,state);
end;