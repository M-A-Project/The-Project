var buffer = argument[0];
var socket = argument[1];
var msgId = buffer_read(buffer, buffer_u8);//find the tag

switch (msgId)
{
    case 1: // Latency request
        var time = buffer_read(buffer, buffer_u32)//read in the time from the client
        buffer_seek(global.buffer, buffer_seek_start, 0);//seek to the beginning of the read buffer
        buffer_write(global.buffer, buffer_u8, 1);//write a tag to the global write buffer
        buffer_write(global.buffer, buffer_u32, time);//write the time receieved the the global write buffer
        // Send back to player who sent this message
        network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
    break;
    
    case 2: // Registration request
        var playerUsername = buffer_read(buffer, buffer_string);
        var passwordHash = buffer_read(buffer, buffer_string);
        var response = 0;
        
        // Check if player already exists
        ini_open("users.ini");
        var playerExists = ini_read_string("users", playerUsername, "false");
        if (playerExists == "false") {
            // Register a new player
            ini_write_string("users", playerUsername, passwordHash);
            response = 1;
            scr_showNotification("A new player has registered!");
        }
        ini_close();
        
        // Send response to the client
        buffer_seek(global.buffer, buffer_seek_start, 0);//seek to the beginning of the read buffer
        buffer_write(global.buffer, buffer_u8, 2);//write a tag to the global write buffer
        buffer_write(global.buffer, buffer_u8, response);//write the time receieved the the global write buffer
        network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
    break;
    
    case 3: // Login request
        var pId = buffer_read(buffer, buffer_u32);
        var playerUsername = buffer_read(buffer, buffer_string);
        var passwordHash = buffer_read(buffer, buffer_string);
        var response = 0;
        
        // Check if player exists
        ini_open("users.ini");
        var playerStoredPassword = ini_read_string("users", playerUsername, "false");
        if (playerStoredPassword != "false") {
            if (passwordHash == playerStoredPassword) {
                response = 1;
                
                with (obj_player) {
                    if (playerIdentifier == pId) {
                        playerName = playerUsername;
                    }
                }
            }
        }
        ini_close();
        
        // Send a response
        buffer_seek(global.buffer, buffer_seek_start, 0);//seek to the beginning of the read buffer
        buffer_write(global.buffer, buffer_u8, 3);//write a tag to the global write buffer
        buffer_write(global.buffer, buffer_u8, response);//write the time receieved the the global write buffer
        network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
    break;
    
    case 6:
        var pId = buffer_read(buffer, buffer_u32);
        var pName = "";
        
        with (obj_player) {
            if (playerIdentifier == pId) {
                playerInGame = !playerInGame;
                pName = playerName;
            }
        }
        
        // Tell other players about this change
        for (var i = 0; i < ds_list_size(global.players); i++) {
            var storedPlayerSocket = ds_list_find_value(global.players, i);
            
            if (storedPlayerSocket != socket) {
            
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 6);
                buffer_write(global.buffer, buffer_u32, pId);
                buffer_write(global.buffer, buffer_string, pName);
                network_send_packet(storedPlayerSocket, global.buffer, buffer_tell(global.buffer));
            }
        }
        
        // Tell me about other players
        for (var i = 0; i < ds_list_size(global.players); i++) {
            var storedPlayerSocket = ds_list_find_value(global.players, i);
            
            if (storedPlayerSocket != socket) {
                var player = noone;
                with (obj_player) {
                    if (self.playerSocket == storedPlayerSocket) {
                        player = id;
                    }
                }
                if (player != noone) {
                    if (player.playerInGame) {
                        buffer_seek(global.buffer, buffer_seek_start, 0);
                        buffer_write(global.buffer, buffer_u8, 6);
                        buffer_write(global.buffer, buffer_u32, player.playerIdentifier);
                        buffer_write(global.buffer, buffer_string, player.playerName);
                        network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
                    }
                }
            }
        }
    break;
}
