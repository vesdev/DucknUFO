
camera = new Camera(192, 192, browser_width, browser_height);

centerX = 80/2;
centerY = camera.height/2;
camera.x = centerX;
camera.y = centerY;
camera.SetFullscreen(true, browser_width, browser_height);

lastW = browser_width;
lastH = browser_height;

application_surface_draw_enable(false);
u_texel = shader_get_uniform(sha_rim, "texel");

surf = -1;

room_goto(rm_menu);
