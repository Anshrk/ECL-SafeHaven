IMPORT $;

fsdist := $.STD_fire.File;

EXPORT FireStations_Distribution := MODULE
    export fsstate := record
        fsdist.state;
        unsigned num_firestations := count(group);
    end;
    export distribution_by_state :=table(fsdist,fsstate,state);
end;