///scr_move()

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

// React to inputs
move = kLeft + kRight;
hspd = move * movespeed;
if (vspd < 10) vspd += grav;

if (place_meeting(x, y + 1, obj_cave_ground)) {
    vspd = kJump * -jumpspeed;
}

// Horizontal Collision
if (place_meeting(x + hspd, y, obj_cave_ground)) {
    while (!place_meeting(x + sign(hspd), y, obj_cave_ground)) {
        x += sign(hspd);
    }
    hspd = 0;
}

// Vertical Collision
if (place_meeting(x, y + vspd, obj_cave_ground)) {
    while (!place_meeting(x, y + sign(vspd), obj_cave_ground)) {
        y += sign(vspd);
    }
    vspd = 0;
}

x += hspd;
y += vspd;


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
