/// @description Handles collision between a dynamic entity and a wall.
/// @param useSlopes
/// @param stopMovement
/// @param destroyOnCollision

var useSlopes, stopMovement, destroyOnCollision;
useSlopes = argument0;
stopMovement = argument1;
destroyOnCollision = argument2;

// Horizontal Collision
repeat(round(abs(hspd))){
	if (!place_meeting(x + sign(hspd), y + lengthdir_y(1, gravDir), par_block) && onGround && useSlopes){
		x += sign(hspd);
		y += lengthdir_y(1, gravDir);
	} else if (!place_meeting(x + sign(hspd), y, par_block) || (!stopMovement && !destroyOnCollision)){
		x += sign(hspd);
	} else if (!place_meeting(x + sign(hspd), y + lengthdir_y(1, gravDir - 180), par_block) && useSlopes){
		x += sign(hspd);
		y += lengthdir_y(1, gravDir - 180);
	} else{
		// Deleting the object if it is destroyed upon collision
		if (destroyOnCollision){
			var block = instance_place(x + sign(hspd), y, par_block);
			if (block.isGeneric) {instance_destroy(self);}
		} else{
			// Stopping horizontal movement
			hspd = 0;
		}
	}
}
// Vertical collision
repeat(round(abs(vspd))){
	if (!place_meeting(x, y + sign(vspd), par_block) || (!stopMovement && !destroyOnCollision)){
		y += sign(vspd);
	} else{
		// Deleting the object if it is destroyed upon collision
		if (destroyOnCollision){
			var block = instance_place(x, y + sign(vspd), par_block);
			if (block.isGeneric) {instance_destroy(self);}
		} else{
			// Stopping vertical movement
			vspd = 0;
		}
	}
}