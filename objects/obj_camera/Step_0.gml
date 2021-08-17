if(lastW != browser_width || lastH != browser_height)
{
	camera = new Camera(192, 192, browser_width, browser_height);

	centerX = 80/2;
	centerY = camera.height/2;
	camera.x = centerX;
	camera.y = centerY;
	camera.SetFullscreen(true, browser_width, browser_height);
	
	lastW = browser_width;
	lastH = browser_height;
	
	camera.Set();
}


camera.x = lerp(camera.x, centerX, .2);
camera.y = lerp(camera.y, centerY, .2);

camera.Update();