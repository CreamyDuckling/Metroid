/// @description Player Movement/Collision Handling
// You can write your code in this editor

#region Keyboard Input

keyRight = keyboard_check(vk_right);				// When true, Samus should move to the right OR will stand up from crouching.
keyLeft = keyboard_check(vk_left);					// When true, Samus should move to the left OR will stand up from crouching.
keyJump = keyboard_check_pressed(ord("X"));			// When true, Samus will jump into the air. With the Space Jump, Samus will be able to jump again while airbourne
keyStopJump = keyboard_check_released(ord("X"));	// When true, Samus' total jump height will be able to be controlled.
keyUp = keyboard_check(vk_up);						// When true, Samus will either aim upward, exit morphball, or stand up.
keyDown = keyboard_check(vk_down);					// When true, Samus will either aim downward, start crouching, or enter morphball.
keyShoot = keyboard_check_pressed(ord("Z"));		// When true, Samus will fire her currently equipped weapon OR will deploy the currently equipped bomb.

#endregion

#region When the Player Is Idle or Cannot Move

// Stop the player from updating if they cannot move
if (!canMove){
	return;	
}

if (!hasStarted){
	if (keyRight || keyLeft){
		hasStarted  = true;	
	}
	return;	
}

#endregion

#region Gravity and Jumping Logic

// Calling the gravity script
scr_entity_gravity();

// Setting the player's state based on if they are on or off the ground
if (onGround){
	// Reset the hspd penalty
	hspdPenalty = 0;
	// Stopping Samus from getting stuck in the ground
	if (mask_index == spr_jumping_mask){
		if (gravDir == 270) {y -= 8;}
		else {y += 8;}
		mask_index = spr_standing_mask;
		// Make the impact more noticable by stopping Samus when she touches the ground
		if (keyRight || keyLeft) {hspd = 0;}
		// Set Samus's somersaulting and aiming down variables to false
		jumpspin = false;
		down = false;
		// Reset Samus's vertical speed
		vspd = 0;
	} 
	if (inMorphball){ // Making the morphball bounce
		if (vspdRecoil < 0){
			vspd = vspdRecoil;
			hspd = sign(hspd);
		} else{ // Reset the variable used for bomb jumping
			jumpspin = false;	
		}
	}
} else{ // Calculating how far the morphball will bounce
	if (inMorphball){
		if (vspd > 2){
			vspdRecoil = -(vspd / 2);
		} else{
			vspdRecoil = 0;	
		}
	}
}

// Handling jumping
if (keyJump){
	if (!inMorphball){
		// Only allow the player to jump if they aren't standing right beneath a block
		if (!place_meeting(x, y - 1, par_block)){
			if (onGround){
				vspd = lengthdir_y(jumpSpd + (vspdPenalty / 2), gravDir);
				onGround = false;
				crouching = false;
				hasPressedDown = false;
				// Setting the subState to somersaulting if the player is moving before they jump
				if (!isShooting){
					if ((hspd >= 1 || hspd <= -1) && !up && !down){
						jumpspin = true;
					}
				}
			} else{
				// Somersaulting while airbourne
				if (!jumpspin && !isShooting){
					jumpspin = true;
					hspd = sign(image_xscale);
					vspd = 0;
				} else if (global.item[ITEM.SPACE_JUMP]){ // The Space Jump
					if (vspd >= 3){
						vspd = jumpSpd;	
					}
				}
			}
		}
	} else{ // The Spring Ball's jump
		if (onGround && global.item[ITEM.SPRING_BALL]){
			vspd = jumpSpd * 0.8;
		}
	}
}
// Allows for user-control of how high the player will jump
if (keyStopJump){
	if ((vspd < 0 && gravDir == 270) || (vspd > 0 && gravDir == 90)){
		vspd /= 2;	
	}
}

#endregion

#region Horizontal Movement

// Moving to the right
if (keyRight){
	if (!left){
		facingRight = true;
		// Reset the hspd if it is positive (Only when on the ground)
		if (hspd < 0 && onGround) {hspd = 0;}
	}
	// Smoothly accelerate (Half-speed while airbourne)
	if (onGround) {hspd += accel;}
	else {hspd += accel / 2;}
	// Prevent the horizontal speed from becoming too large
	if (hspd > maxHspd - hspdPenalty){
		hspd = maxHspd - hspdPenalty;
	}
	right = true;
} else{ // The right key is no longer being pressed down
	right = false;	
}
// Moving to the left
if (keyLeft){
	if (!right){
		facingRight = false;
		// Reset the hspd if it is positive (Only when on the ground)
		if (hspd > 0 && onGround) {hspd = 0;}
	}
	// Smoothly accelerate (Half-speed while airbourne)
	if (onGround) {hspd -= accel;} 
	else {hspd -= accel / 2;}
	// Prevent the horizontal speed from becoming too large
	if (hspd < -(maxHspd - hspdPenalty)){
		hspd = -(maxHspd - hspdPenalty);
	}
	left = true;
} else{ // The left key is no longer being pressed down
	left = false;	
}
// Stopping horizontal movement
if ((keyRight && keyLeft) || (!keyRight && !keyLeft)){
	if (onGround || (!onGround && !jumpspin)){
		if (hspd < -accel){ // Slowing down while moving left
			hspd += accel;
		} else if (hspd > accel){ // Slowing down while moving right
			hspd -= accel;
		} else{
			// Setting a penalty for horizontal movement in the air
			if (!onGround) {hspdPenalty = 1;}
			hspd = 0;
		}
	}
}
// Stop Samus from moving while crouching
if (crouching){
	hspd = 0;
	// Decrement the timer for Samus to stand up when pressing either left or right
	if ((keyRight && !keyLeft) || (keyLeft && !keyRight)){
		standTimer--;
		if (standTimer <= 0){
			standTimer = 8;
			crouching = false;
		}
	} else{
		// Reset the timer
		standTimer = 8;
	}
}

#endregion

#region Other Player Abilities (Crouching, Aiming Up and Down, etc.)

// Aiming Upward/Stnading Up/Exiting Morphball
if (keyUp && !down){
	if (!hasPressedUp){
		hasPressedUp = true;
		if (inMorphball){ // Exiting Morphball Mode
			if (!place_meeting(x, y - 8, par_block)){
				inMorphball = false;
				vspdRecoil = 0;
				if (!onGround) {vspd = 0;}
				else {crouching = true;}
			}
		} else if (crouching){ // Standing Up
			if (!place_meeting(x, y - 8, par_block)){
				crouching = false;
			}
		} else{ // Aiming Upward
			jumpspin = false;
			up = true;	
		}
	}
} else{ // Aiming Forward once again
	hasPressedUp = false;
	up = false;
}

// Aiming Downward/Crouching/Entering Morphball
if (keyDown && !up){
	if (!hasPressedDown){
		hasPressedDown = true;
		if (onGround){
			if (!inMorphball && !crouching){ // Crouching
				crouching = true;
			} else if (crouching && global.item[ITEM.MORPHBALL]){ // Entering Morphball
				crouching = false;
				inMorphball = true;	
			}
		} else{ // Aiming Downward (Only while airbourne)
			jumpspin = false;
			down = true;	
		}
	}
} else{
	hasPressedDown = false;
	down = false;
}

// Firing Projectiles/Deploying Bombs
if (keyShoot){
	// Reset the shooting state and its timer
	isShooting = true;	
	shootStateTimer = 20;
	// Stop the player from Somersault if they are airbourne
	jumpspin = false;
	// Actually spawning in the projectile/bomb
	if (!inMorphball){
		if (isWeaponUnlocked[curWeaponIndex]){
			if (fireRateTimer <= 0){
				var projectile;
				projectile[0] = noone;
				switch(curWeaponIndex){
					case 0: // Power Beam
						projectile[0] = instance_create_depth(x, y, 310, obj_powerbeam);
						// Resetting the fireRateTimer variable
						fireRateTimer = powerBeamFR;
						break;
					case 1: // Ice Beam
						projectile[0] = instance_create_depth(x, y, 310, obj_icebeam);
						// Resetting the fireRateTimer variable
						fireRateTimer = iceBeamFR;
						break;
					case 2: // Wave Beam
						projectile[0] = instance_create_depth(x, y, 310, obj_wavebeam);
						projectile[1] = instance_create_depth(x, y, 310, obj_wavebeam);
						projectile[1].movingUp = true;
						// Resetting the fireRateTimer variable
						fireRateTimer = waveBeamFR;
						break;
					case 3: // Spazer Beam
						projectile[0] = instance_create_depth(x, y, 310, obj_spazerbeam);
						projectile[1] = instance_create_depth(x, y, 310, obj_spazerbeam);
						projectile[1].increment = 0;
						projectile[2] = instance_create_depth(x, y, 310, obj_spazerbeam);
						projectile[2].movingUp = true;
						// Resetting the fireRateTimer variable
						fireRateTimer = spazerBeamFR;
						break;
					case 4: // Plasma Beam
						projectile[0] = instance_create_depth(x, y, 310, obj_plasmabeam);
						// Resetting the fireRateTimer variable
						fireRateTimer = plasmaBeamFR;
						break;
					case 5: // Missiles
						projectile[0] = instance_create_depth(x, y, 310, obj_missile);
						// Resetting the fireRateTimer variable
						fireRateTimer = missileFR;
						break;
					case 6: // Super Missiles
						projectile[0] = instance_create_depth(x, y, 310, obj_sMissile);
						// Resetting the fireRateTimer variable
						fireRateTimer = sMissileFR;
						break;
				}
				// Setting the offset of the projectile correctly (If one exists)
				for (var i = 0; i < array_length_1d(projectile); i++){
					if (projectile[i] != noone){
						if (onGround){ // Firing on the Ground
							if (hspd >= 1  || hspd <= -1){ // Shooting while moving
								if (!up){ // Aiming Forward
									projectile[i].offsetX = 20 * sign(image_xscale);
									projectile[i].offsetY = -7;
								} else{ // Aiming Upward
									projectile[i].offsetX = 8 * sign(image_xscale);
									projectile[i].offsetY = -20;
								}
							} else{
								if (!up && !crouching){ // Aiming Forward
									projectile[i].offsetX = 10 * sign(image_xscale);
									projectile[i].offsetY = -3;
								} else if (up){ // Aiming Upward
									projectile[i].offsetX = 3 * sign(image_xscale);
									projectile[i].offsetY = -20;
								} else if (crouching){ // Crouching
									projectile[i].offsetX = 10 * sign(image_xscale);
									projectile[i].offsetY = 7;
								}
							}
						} else{ // Firing while Airbourne
							if (!up && !down){ // Aiming Forward
								projectile[i].offsetX = (12 + hspd) * sign(image_xscale);
								projectile[i].offsetY = -1 + vspd;
							} else if (up){ // Aiming Upward
								projectile[i].offsetX = (4 + hspd) * sign(image_xscale);
								projectile[i].offsetY = -20 + vspd;
							} else if (down){ // Aiming Downward
								projectile[i].offsetX = (5 + hspd) * sign(image_xscale);
								projectile[i].offsetY = 14 + vspd;
							}
						}
						// Setting the direction of the projectile
						if (!up && !down){
							if (facingRight) {projectile[i].right = true;}
							else {projectile[i].left = true;}
						} else{
							projectile[i].up = up;
							projectile[i].down = down;
						}
					}
				}
			}
		}
	} else{
		if (isWeaponUnlocked[curBombIndex]){
			switch(curBombIndex){
				case 7: // Deploying a Normal Bomb
					if (instance_number(obj_bomb) < 3){ // A maximum number of 3 bombs can be on-screen at once
						instance_create_depth(x, y + 14, depth - 1, obj_bomb);
					}
					break;
				case 8: // Deploying a Power Bomb
					if (!instance_exists(obj_pBomb)){ // A maximum number of one power bomb can be on-screen at once
						instance_create_depth(x, y + 14, depth - 1, obj_pBomb);
					}
					break;
			}
		} 
	}
}
// Counting doen the fire rate timer
if (fireRateTimer > 0){
	fireRateTimer--;	
}
// Counting down the timer that prevents the player from 
if (isShooting){
	shootStateTimer--;
	if (shootStateTimer <= 0){
		isShooting = false;
		shootStateTimer = 20;	
	}
}

#endregion

#region Handling Collision with the World and its' Hazards and Enemies

// Setting the player's collision box
if (onGround){
	if (!crouching && !inMorphball){
		mask_index = spr_standing_mask;
	} else if (crouching && !inMorphball){
		mask_index = spr_crouching_mask;
	} else if (inMorphball){
		mask_index = spr_morphball_mask;	
	}
} else{
	if (!inMorphball){
		mask_index = spr_jumping_mask;
	}
}

// Colliding with the Bomb Explosion to allow it to launch the user while in morphball mode
if (inMorphball){
	if (instance_exists(obj_bomb_explode)){
		var bomb = instance_nearest(x, y, obj_bomb_explode);
		// Make sure the player isn't below the bomb explosion
		if (bomb.y > y + 8){
			if (place_meeting(x, y, bomb)){
				vspd = -3;
				if (x < bomb.x - 3){
					jumpspin = true;
					hspd = -1;
				} else if (x >= bomb.x + 3){
					jumpspin = true;
					hspd = 1;	
				}
			}
		}
	}
}

// TODO -- Add in collision between the various interactable objects. (Ex. Enemies, Water, Lava, etc.)

// Calling the Entity Collision script
scr_entity_collision(true, true, false);

#endregion