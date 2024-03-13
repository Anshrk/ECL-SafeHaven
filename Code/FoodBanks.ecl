import $;
import visualizer;
UID_foodbanks := $.UID_FoodBank;
reducedlayout := RECORD
    UID_foodbanks.uid;
    UID_foodbanks.food_bank_name;
    UID_foodbanks.address;
    UID_foodbanks.city;
    UID_foodbanks.state;
    UID_foodbanks.zip_code;
    UID_foodbanks.web_page;
    UID_foodbanks.facebook_page;
    UID_foodbanks.status;
END;
reducedtable := table(UID_foodbanks,reducedlayout);
EXPORT FoodBanks := reducedtable;
//Visualizer.Choropleth.USStates('usStatesFoodBanks',,'FoodBanks_Data')