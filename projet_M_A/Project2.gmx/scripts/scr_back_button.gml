/// scr_back_button()
if (room == rm_settings) {
    if !(instance_exists(obj_keyController)) {
        room_goto(rm_menu);
    }
} else {
    room_goto(rm_menu);
}
