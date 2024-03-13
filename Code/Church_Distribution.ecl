import $;
churchdistribution := $.std_churches.file;

export church_distribution := module
    statecount := record
        churchdistribution.state;
        unsigned num_churches := count(group);
    end;
    export distribution_by_state := table(churchdistribution,statecount,state);
end;