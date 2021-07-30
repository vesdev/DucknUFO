
function Camera(width, height, displayWidth = display_get_width(), displayHeight = display_get_height()) constructor
{
	
	baseW = width;
	baseH = height;
	
	maxW = displayWidth;
	maxH = displayHeight;
	aspect = displayWidth / displayHeight;
	
	camera = camera_create();
	zoom = 1;
	
	x = 0;
	y = 0;
	
	if(maxW < maxH)
	{
		//portrait
		self.width = min(baseW, maxW);
		self.height =  self.width / aspect;
	}
	else
	{
		//landscape
		self.height = min(baseH, maxH);
		self.width = self.height * aspect;	
	}
	
	surface_resize(application_surface, self.width, self.height);
	window_set_size(self.width, self.height);
	display_set_gui_size(self.width,self.height)
	
	static ScaleWindow = function(n)
	{
		surface_resize(application_surface, width*n, height*n);
		window_set_size(width*n, height*n);
		//display_set_gui_maximize(n,n,0,0);
	}

	static SetFullscreen = function(flag, displayWidth = display_get_width(), displayHeight = display_get_height())
    {
        if (flag)
        {
            surface_resize(application_surface, displayWidth, displayHeight);
            window_set_size(displayWidth, displayHeight);
			//display_set_gui_maximize(displayWidth/width,displayHeight/height,0,0);
            window_set_fullscreen(true);
        }
        else
        {
            ScaleWindow(1);
            window_set_fullscreen(false);
        }
    }
    	
	static Resize = function(width, height, displayWidth = display_get_width(), displayHeight = display_get_height())
	{
		baseW = width;
		baseH = height;
	
		maxW = displayWidth;
		maxH = displayHeight;
		aspect = displayWidth / displayHeight;
	
		zoom = 1;

		if(maxW < maxH)
		{
			//portrait
			self.width = min(baseW, maxW);
			self.height =  self.width / aspect;
		}
		else
		{
			//landscape
			self.height = min(baseH, maxH);
			self.width = self.height * aspect;	
		}
	
		surface_resize(application_surface, self.width, self.height);
		window_set_size(self.width, self.height);
		display_set_gui_size(self.width,self.height)
	
	}

	static Set = function()
	{
		view_enabled = true;
		view_camera[0] = camera;
		view_visible[0] = true;
	}
	
	static Update = function()
	{
		
		var _lm = matrix_build_lookat(x, y, -9999, x, y, 0, 0, 1, 0);
		var _pm = matrix_build_projection_ortho(width*zoom, height*zoom, 1, 99999);
		
		camera_set_view_mat(camera, _lm);
		camera_set_proj_mat(camera, _pm);
	}
}
