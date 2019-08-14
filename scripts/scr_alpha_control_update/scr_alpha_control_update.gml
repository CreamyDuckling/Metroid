/// @description This script will adjust the alpha relative to the physics engine's updating speed (~60 time per
/// second). This will allow for any and all object's that use alpha control to be frame independent.
/// NOTE -- This script will only function if you place it in the object's end step event

// Don't allow this script to execute if it is being called outside of the end step event of an object
if (event_number != ev_step_end){
	return;	
}

// Increase/Decrease the alpha value accordingly
if (freezeOnPause){
	if (global.gameState == GAME_STATE.PAUSED){
		return;	
	}
}

if (fadingIn){
	if (alpha >= 1){ // Stop the alpha level from increasing past full opaque
		alpha = 1;
	} else{ // Smoothly fade the object into visibility
		alpha = scr_update_value_delta(alpha, alphaChangeVal);	
	}
} else{
	if (alpha <= 0){ // Stop the alpha level from decreasing past full transparency
		alpha = 0;
		if (destroyOnZero){ // Destroy the instance
			instance_destroy(self);
		}
	} else{ // Smoothly fade the object away
		alpha = scr_update_value_delta(alpha, -alphaChangeVal);	
	}
}