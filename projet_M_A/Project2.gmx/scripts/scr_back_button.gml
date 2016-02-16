/// scr_back_button()
if (room == rm_sound || room == rm_controls) {
    if !(instance_exists(obj_keyController)) {
        room_goto(rm_settings);
    }
} else {
    room_goto(rm_menu);
}
