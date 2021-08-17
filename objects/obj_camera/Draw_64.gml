draw_clear(0x1A1113);
if(instance_exists(obj_game))
{
	var _x = -camera.x+camera.width/2,_y = -camera.y+camera.height/2+12*TILESIZE;
	draw_sprite_rectangle(_x,_y,_x+obj_game.map.width*TILESIZE, _y-obj_game.map.height*TILESIZE, 0x2D2023, false);
}
/*
var _i = 0, _n = ceil(camera.height / TILESIZE)+2,
	_yy = frac(current_time*0.001);

repeat(_n) 
{
	draw_sprite(spr_bg,0,camera.width/2,(_i-1)*TILESIZE+_yy*TILESIZE);
	_i++;
}
*/
if(!surface_exists(surf))
{
	surf = surface_create(window_get_width(), window_get_height());
	view_set_surface_id(0, surf);
}

shader_set(sha_rim);
	shader_set_uniform_f(u_texel, 1/camera.width, 1/camera.height);
	draw_surface_stretched(surf, 0, 0, camera.width, camera.height);
shader_reset();