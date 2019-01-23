/// @description Destroy if Samus has already collected the Gravity Suit
// You can write your code in this editor

// Modifying the variables
itemIndex = 8;
subIndex = -1;
itemName = "Gravity Suit";
itemDescription = "A unique modification to the Power Suit.\nAllows for complete and unhindered movement\ncapabilities while submerged in water.";

color = c_fuchsia;

if (global.gravitySuit){
	giveReward = false;
	instance_destroy(self);
}