/// @description Checking if any key has been pressed
// You can write your code in this editor

if (keyboard_check_pressed(vk_anykey) && alpha == 1){
	audio_play_sound(snd_pause, 1, false);
	keyPressed = true;
}

if (keyPressed){
	alpha -= 0.1;
	if (alpha == 0){
		var obj = instance_create_depth(0, 0, depth, obj_main_menu);
		obj.alpha = 0;
		instance_destroy(self);
	}	
}
else{
	if (alpha < 1){
		alpha += 0.1;
	}
}

// Play the menu theme
if (!audio_is_playing(music_main_menu)){
	audio_play_sound(music_main_menu, 0, false);	
}