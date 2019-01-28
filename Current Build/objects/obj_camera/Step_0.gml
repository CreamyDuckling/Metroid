/// @description Updates the camera position
// You can write your code in this editor

var viewX, viewY;
viewX = global.camWidth * scale;
viewY = global.camHeight * scale;
window_set_size(viewX, viewY);
surface_resize(application_surface, viewX, viewY);
window_center();

if (global.followPlayer && curObject = obj_samus){
	if (obj_samus.canMove){
		x += (xTo - x) / 5;
		y += (yTo - y) / 5;
	}
	// Setting camera bounds
	scr_camera_bounds(0, 0, room_width, room_height);
}

if (curObject != self){
	xTo = curObject.x;
	yTo = curObject.y;
}

// Deactivating objects outside of the camera's view
instance_deactivate_object(obj_star);
instance_deactivate_object(obj_warp);
instance_deactivate_object(obj_vertical_camera_lock);
instance_deactivate_object(obj_horizontal_camera_lock);
instance_activate_region(x - (global.camWidth / 2) - 16, y - (global.camHeight / 2) - 16, global.camWidth + 16, global.camHeight + 16, true);

var vm = matrix_build_lookat(x, y, -10, x, y, 0, 0, 1, 0);
camera_set_view_mat(camera, vm);

// Getting the x and y position of the camera
global.camX = obj_camera.x - (global.camWidth / 2);
global.camY = obj_camera.y - (global.camHeight / 2);

// Exiting the Game (For Debugging)
if (keyboard_check_pressed(ord("E"))){
	game_end();
}