bgPartTimer++;

if(bgPartTimer >= bgPartTime)
{
	var _cam = obj_camera.camera;
	var _xx = random(_cam.width);
	var _yy = random(_cam.height);
	part_particles_create(global.PartSys, _cam.x-_cam.width/2+_xx,_cam.y-_cam.height/2+_yy, global.PartBgDust, 1);
	bgPartTimer = 0;
}

if (!audio_is_playing(snd_theme)) audio_play_sound(snd_theme, 0, true);

if (MOBILE)
{
	dragUp = false;
	dragLeft = false;
	dragRight = false;
	
	if mouse_check_button_pressed(mb_left)
	{
		pressX = mouse_x;
		pressY = mouse_y;
	}
	
	if mouse_check_button_released(mb_left)
	{
		draggedUp = false;
	}
	
	if mouse_check_button(mb_left)
	{
		if (!draggedUp && abs(pressY-mouse_y) > TILESIZE)
		{
			dragUp = true;
			draggedUp = true;
		}
		
		if (pressX-mouse_x < -TILESIZE)
		{
			dragRight = true;
		}
		else if (pressX-mouse_x > TILESIZE)
		{
			dragLeft = true;
		}
	}
	
	
}

map.Update();