///scr_move()
hspd = 20;
vspd = 20;

if (keyboard_check(global.key_up)) {
    y -= 4;
}

if (keyboard_check(global.key_down)) {
    y += 4;
}

if (keyboard_check(global.key_left)) {
    x -= hspd;
}

if (keyboard_check(global.key_right)) {
    x += hspd;
}

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
