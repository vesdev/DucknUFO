function draw_sprite_shadow(_sprite, _subimg, _x, _y, _xscale=1, _yscale=1)
{
	/*
	var _i = 0;
	var _l = 5;
	repeat(_l)
	{
		draw_sprite_ext(_sprite, _subimg, _x+_i, _y+_i, _xscale, _yscale, 0, c_black, 1);
		_i++;
	}
	*/
}

function draw_sprite_rectangle(_x,_y,_x2,_y2,_color,_outline)
{

	if(!_outline)
	{
		draw_sprite_ext(spr_pixel, 0, _x, _y, _x2-_x, _y2-_y, 0, _color, 1);
	}
	else
	{
		draw_sprite_ext(spr_pixel, 0, _x, _y, _x2-_x, 1, 0, _color, 1);
		draw_sprite_ext(spr_pixel, 0, _x, _y, 1, _y2-_y, 0, _color, 1);
		
		draw_sprite_ext(spr_pixel, 0, _x, _y2, _x2-_x+1, 1, 0, _color, 1);
		draw_sprite_ext(spr_pixel, 0, _x2, _y, 1, _y2-_y, 0, _color, 1);
	}
}