bgPartTimer++;

if(bgPartTimer >= bgPartTime)
{
	var _cam = obj_camera.camera;
	var _xx = random(_cam.width);
	var _yy = random(_cam.height);
	part_particles_create(global.PartSys, _cam.x-_cam.width/2+_xx,_cam.y-_cam.height/2+_yy, global.PartBgDust, 1);
	bgPartTimer = 0;
}



map.Update();