/// @description Colliding with the Player
// You can write your code in this editor

#region Preventing Object Function When Player Cannot Move (Ex. Cutscene, in a menu, etc.)

// Don't allow the player to collide with an interactable object whent the game is paused
if (global.gameState != GAME_STATE.IN_GAME){
	image_speed = 0;
	return;	
}
image_speed = 1;

#endregion

#region Destroy when collected

if (place_meeting(x, y, obj_player)){
	global.item[index] = true;
	// TODO -- Create an item screen prompt object to display item information.
	instance_destroy(self);
}

#endregion