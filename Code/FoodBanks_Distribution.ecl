import $;
foodbanksdata := $.std_foodbanks.file;

export foodbanks_distribution := module
    export foodbankstate := record
        foodbanksdata.state;
        unsigned num_foodbanks := count(group);
    end;
    export distribution_by_state :=table(foodbanksdata,foodbankstate,state);
end;