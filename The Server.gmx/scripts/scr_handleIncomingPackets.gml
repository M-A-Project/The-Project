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
        
        // TEMP RESPONSE!
        // response = 1;
        // TEMP RESPONSE!
        
        // Check if player already exists
        ini_open("users.ini");
        var playerExists = ini_read_string("uesrs", playerUsername, "false");
        if (playerExists == "false") {
            // Register a new player
            ini_write_string("user", playerUsername, passwordHash);
            ini_close();
            
            response = 1;
            scr_showNotification("A new player has registered!");
        }
        
        // Send response to the client
        buffer_seek(global.buffer, buffer_seek_start, 0);//seek to the beginning of the read buffer
        buffer_write(global.buffer, buffer_u8, 2);//write a tag to the global write buffer
        buffer_write(global.buffer, buffer_u8, response);//write the time receieved the the global write buffer
        network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
        
        
        
    break;
}
