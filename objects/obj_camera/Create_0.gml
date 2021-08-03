camera = new Camera(80, 192, 400, 400);

centerX = 80/2;
centerY = camera.height/2;
camera.x = centerX;
camera.y = centerY;
camera.ScaleWindow(3);

application_surface_draw_enable(false);
u_texel = shader_get_uniform(sha_rim, "texel");

surf = -1;

room_goto(rm_menu);
