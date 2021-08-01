camera = new Camera(room_width, room_height, room_width, room_height);
camera.x = room_width/2;
camera.y = room_height/2;
camera.ScaleWindow(2);

room_goto(rm_menu);

#macro HTML5:live_enabled 0
#macro Windows:live_enabled 1