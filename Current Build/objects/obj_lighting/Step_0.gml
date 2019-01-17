/// @description etting up the base surface
// You can write your code in this editor

// Don't try to setup the surface if the surface doesn't exist
if (!surface_exists(global.lighting)){
	return;	
}

// Drawing the dark rectangle for the lighting
surface_set_target(global.lighting);
draw_set_color(global.curLightingCol); // The lighter the color, the darker the surface
draw_rectangle(0, 0, global.camWidth, global.camHeight, false);
// Reset the surface to the Application Surface
surface_reset_target();