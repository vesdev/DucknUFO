draw_clear(0x1A1113);

if(!surface_exists(surf))
{
	surf = surface_create(window_get_width(), window_get_height());
	view_set_surface_id(0, surf);
}

shader_set(sha_rim);
	shader_set_uniform_f(u_texel, 1/camera.width, 1/camera.height);
	draw_surface_stretched(surf, 0, 0, camera.width, camera.height);
shader_reset();