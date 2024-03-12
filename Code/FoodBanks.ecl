#OPTION('obfuscateOutput', TRUE);
import $;
import visualizer;
foodbanks := $.UID_FoodBank;
reducedlayout := RECORD
    foodbanks.uid;
    foodbanks.food_bank_name;
    foodbanks.address;
    foodbanks.city;
    foodbanks.state;
    foodbanks.zip_code;
    foodbanks.web_page;
    foodbanks.facebook_page;
    foodbanks.status;
END;
reducedtable := table(foodbanks,reducedlayout);
output(reducedtable,named('FoodBanks_Data'));
//Visualizer.Choropleth.USStates('usStatesFoodBanks',,'FoodBanks_Data')