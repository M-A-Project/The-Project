///scr_move()


// Key movement with bindings but without variables
/*if (keyboard_check(global.key_up)) {
    y -= vspd;
}

if (keyboard_check(global.key_down)) {
    y += vspd;
}

if (keyboard_check(global.key_left)) {
    x -= hspd;
}

if (keyboard_check(global.key_right)) {
    x += hspd;
}
*/

kRight = keyboard_check(global.key_right);
kLeft = -keyboard_check(global.key_left);
kJump = keyboard_check_pressed(global.key_jump);
kJumpHeld = keyboard_check(global.key_jump);
kDuck = keyboard_check(global.key_down);

// Sprite animation + idle

if (hspd < 0) {
    sprite_index = spr_player_walk_left;
    image_speed = .30;
} else if (!kRight and !kLeft and !kJumpHeld and !kJump) {
    image_speed = 0;
    image_index = 0;
}

if (hspd > 0) {
    sprite_index = spr_player_walk_right;
    image_speed = .30;
} else if (!kRight and kLeft and !kJumpHeld and !kJump) {
    image_speed = 0;
    image_index = 0;
}

if (kJump and kJumpHeld) {
}

//-----DUCKING-----
//-----------------
if (kDuck) {
    ducking = true;
} else {
    ducking = false;
}
// Display proper animations while on the ground
if (grounded) {
    if (hspd != 0) {
        // Moving
    } else if (ducking) {
        sprite_index = spr_player_ducking;
    } else {
        sprite_index = spr_player;
    }
}
// Display proper animations while in the air
else {
    if(ducking) {
    // If we are ducking while in the air
        sprite_index = spr_player_ducking;
    } else if (hspd > 0 && vspd != 0) {
        sprite_index = spr_player_jump_right;
    } else if (hspd < 0 && vspd != 0) {
        sprite_index = spr_player_jump_left;
    }
}

// React to inputs
move = kLeft + kRight;
hspd = move * movespeed;

// Sets gravity to vspd
if (vspd < 10) {
    vspd += grav;
}

// See if we are grounded

if (vspd = 0) {
    grounded = true;
    if (ducking) {
        hspd = 0;
    }
} else {
    grounded = false;
}


// ___Jump___
// Cave ground
if (place_meeting(x, y + 1, obj_cave_ground)) {
    jump = jumpmax;
    vspd = kJump * -jumpspeed;
} else {
    if (jump == jumpmax) jump -= 5;
}

// Forest ground
if (place_meeting(x, y + 1, obj_forest_ground)) {
    jump = jumpmax;
    vspd = kJump * -jumpspeed;
} else {
    if (jump == jumpmax) jump -= 5;
}

// Double jump
/*if (kJump) && (jump > 0) {
    jump -= 1;
    vspd = -jumpspeed;
}*/


if (vspd < 0) && (!kJumpHeld) vspd = max(vspd, -jumpspeed / 2);

hspd_carry = 0;
var hspd_final = hspd + hspd_carry;

// ___Horizontal Collision___
// Cave ground
if (place_meeting(x + hspd, y, obj_cave_ground)) {
    while (!place_meeting(x + sign(hspd), y, obj_cave_ground)) {
        x += sign(hspd);
    }
    hspd = 0;
}

// Forest ground
if (place_meeting(x + hspd, y, obj_forest_ground)) {
    while (!place_meeting(x + sign(hspd), y, obj_forest_ground)) {
        x += sign(hspd);
    }
    hspd = 0;
}

// ___Vertical Collision___
// Cave ground
if (place_meeting(x, y + vspd, obj_cave_ground)) {
    while (!place_meeting(x, y + sign(vspd), obj_cave_ground)) {
        y += sign(vspd);
    }
    vspd = 0;
}

// Forest ground
if (place_meeting(x, y + vspd, obj_forest_ground)) {
    while (!place_meeting(x, y + sign(vspd), obj_forest_ground)) {
        y += sign(vspd);
    }
    vspd = 0;
}

x += hspd;
y += vspd;

// Standard key movement
/*if (keyboard_check(vk_right)) {
    x+=4;
}

if (keyboard_check(vk_left)) {
    x-=4;
}

if (keyboard_check(vk_up)) {
    y-=4;
}

if (keyboard_check(vk_down)) {
    y+=4;
}
*/
