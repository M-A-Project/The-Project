var buffer = argument[0];
var msgId = buffer_read(buffer, buffer_u8);

switch(msgId) {
    case 1: // Latency request
        var time = buffer_read(buffer, buffer_u32);
        latency = current_time - time;
    break;
    
    case 2: // Registration request
        var response = buffer_read(buffer, buffer_u8);
        
        switch(response) {
            case 0: // Failure
                scr_showNotification("Registration failed! Username already exists!");
            break;
            
            case 1: // Success
                room_goto(rm_level_1_lobby);
                scr_showNotification("Account Created!")
            break;
        }
    break;
    
    case 3: // Login request
        var response = buffer_read(buffer, buffer_u8);
        
        switch(response) {
            case 0: // Failure
                scr_showNotification("Login failed! Username doesn't exists or password is incorrect!");
            break;
            
            case 1: // Success
                room_goto(rm_level_1_lobby);
                scr_showNotification("Account Created!")
            break;
        }
    break;
    
    case 4:
        global.playerId = buffer_read(buffer, buffer_u32);
        scr_showNotification("Our playerId has been received!");
    break;
    
    case 5: // Logout
        var pId = buffer_read(buffer, buffer_u32);
        with (obj_remoteplayer) {
            if (remotePlayerId == pId) {
                instance_destroy();
            }
        }
    break;
    
    case 6:
        var pId = buffer_read(buffer, buffer_u32);
        var pName = buffer_read(buffer, buffer_string);
        
        var instance = noone;
        
        with (obj_remoteplayer) {
            if (remotePlayerId == pId) {
                instance = id;
            }
        }
        
        if (instance == noone) {
            // Only if we're in the gameworld
            if (instance_exists(obj_localplayer)) {
                // Create a remote player
                var remotePlayer = instance_create(room_width - 400, room_height - 750, obj_remoteplayer);
                remotePlayer.remotePlayerId = pId;
                remotePlayer.remotePlayerName = pName;
            }
        } else {
            with (instance) {
                instance_destroy();
                }
            }
    break;
}
