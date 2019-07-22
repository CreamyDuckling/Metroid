/// @description Displaying the Prompt
// You can write your code in this editor

#region Some local variables for holding values relating to the text being displayed

var txtHalfWidth, txtHalfHeight;
draw_set_font(font_gui_xSmall);
txtHalfWidth = floor(string_width(displayTxt) / 2);
txtHalfHeight = floor(string_height(displayTxt) / 2);

#endregion

#region Drawing to the screen

if (alpha > 0){
	// Drawing the prompt's background
	draw_set_alpha(alpha * 0.3);
	draw_set_color(c_black);
	draw_rectangle(0, 0, global.camWidth, global.camHeight, false);
	draw_set_color(c_dkgray);
	// The background behind the item's description
	draw_rectangle(0, 112 - txtHalfHeight - 10, global.camWidth, 112 + txtHalfHeight + 10, false);
	draw_rectangle(0, 112 - txtHalfHeight - 4, global.camWidth, 112 + txtHalfHeight + 4, false);
	
	// Checking if the text needs to be scrolled or not
	if (displayTxt != curDisplayedStr){
		if (scrollingText){
			curDisplayedStr += string_char_at(displayTxt, nextChar);
			nextChar++;	
		} else{
			curDisplayedStr	= displayTxt;
		}
	}
	
	// Drawing the item's description
	draw_set_alpha(alpha);
	draw_set_halign(txtAlignment);
	if (txtAlignment == fa_center) {txtHalfWidth = 0;}
	draw_text_outline((global.camWidth / 2) - txtHalfWidth, 112 - txtHalfHeight, curDisplayedStr, txtCol, txtOCol);
	draw_set_halign(fa_center);
	
	// Drawing the item's name
	draw_set_font(font_gui_large);
	draw_text_outline(global.camWidth / 2, 60, itemName, nameCol, nameOCol);
	draw_set_halign(fa_left);
	
	// Return the alpha back to normal
	draw_set_alpha(1);
}

#endregion