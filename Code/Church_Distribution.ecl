import $;
churchdistribution := $.std_churches.file;

export church_distribution := module
    export churchstate := record
        churchdistribution.state;
        unsigned num_churches := count(group);
    end;
    export distribution_by_state := table(churchdistribution,churchstate,state);
end;