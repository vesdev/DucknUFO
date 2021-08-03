if(surface_exists(surf))
{
	surface_set_target(surf);
		draw_clear_alpha(0,0);
	surface_reset_target();
}