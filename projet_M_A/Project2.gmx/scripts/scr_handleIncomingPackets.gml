var buffer = argument[0];
var msgId = buffer_read(buffer, buffer_u8);

switch(msgId) {
    case 1: // Latency request
        var time = buffer_read(buffer, buffer_u32);
        latency = current_time - time;
    break;
}
