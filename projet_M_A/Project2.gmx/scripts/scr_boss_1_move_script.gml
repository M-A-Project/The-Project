/// scr_boss_1_move_script()
var step_counter = 180;
var hspd = 0;
var dir = -1;
var movespeed = 6;

hspd = dir * movespeed;
step_counter--;

if (step_counter) ==0 {
    hspd = 0;
} else {
    step_counter = 180;
}
