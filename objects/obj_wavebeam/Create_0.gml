/// @description Editing the Damage and Speed Variables
// You can write your code in this editor

// Calling the parent's create event
event_inherited();

// The new damage and speed variables
maxHspd = 11;
maxVspd = 11;
damage = 2;

// Unique variables for the Wave Beam
increment = 4;
maxAmplitude = increment * 2;
movingUp = false;

// Enable the Wave Beam to pass through walls
destroyOnWallCollide = false;