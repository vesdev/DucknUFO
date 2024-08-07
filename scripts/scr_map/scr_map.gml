#macro TILESIZE 16


function Map(players=1, tutorial=true) constructor
{
	x = 0;
	y = 64;
	width = 5;
	height = 8;
	
	self.players = players;
	loser = 0;
	
	disableUpdate = false;
	disableFalling = false;
	disableInput = false;
	mapData = array_create(width, undefined);
	
	entities = [];
	
	mapMatrix = [
		1,0,0,0,
		0,1,0,0,
		0,0,1,0,
		0,0,0,1,
	];

	currentScore = 0;
	
	inTutorial = tutorial;
	lineAnimation = 0;
	
	var _i = 0; repeat(array_length(mapData))
	{
		mapData[_i] = array_create(height, undefined);
		
		_i++;
	}
	
	static Draw = function()
	{
		draw_set_font(fnt_basic);
		var _mat = matrix_get(matrix_world);
		mapMatrix[12] = x;
		mapMatrix[13] = y;
		matrix_set(matrix_world, matrix_multiply(_mat, mapMatrix));
		
		//draw_sprite_shadow(spr_pixel, 0, 0, 0, width*TILESIZE, height*TILESIZE);
		//draw_sprite_rectangle(0,0, width*TILESIZE, height*TILESIZE, 0x1A1113, false);
		
		draw_set_halign(fa_center);
			draw_text_color(width/2*TILESIZE, -2*TILESIZE, string(currentScore), 0x4210b3,0x4210b3,0x4210b3,0x4210b3,1);
		draw_set_halign(fa_left);
		
		
		var _i = 0; 
		repeat(width*height)
		{
			if(mapData[_i % width][_i div width] != undefined) mapData[_i % width][_i div width].DrawBegin();
			_i++;
		}
		
		var _i = 0; 
		while(_i < array_length(entities))
		{ 
			entities[_i].DrawBegin();
			_i++;
		}
		
		if (inTutorial)
		{
			draw_set_alpha(.8);
				draw_rectangle_color(0,0, width*TILESIZE, height*TILESIZE, c_black, c_black, c_black, c_black, false);
			draw_set_alpha(1);
			
			draw_set_halign(fa_center);
				if (players == 1) draw_text_transformed(width/2*TILESIZE, height/2*TILESIZE, "Duck 'n\nUFO", .7, .7, 0);
				if (players == 2) draw_text_transformed(width/2*TILESIZE, height/2*TILESIZE, "Ducks 'n\nUFO", .7, .7, 0);
			draw_set_halign(fa_left);
		}
		
		var _i = 0; 
		repeat(width*height)
		{
			if(mapData[_i % width][_i div width] != undefined) mapData[_i % width][_i div width].Draw();
			_i++;
		}
		
		lineAnimation = lerp(lineAnimation, 0, .1);
		if(lineAnimation > .1)
		{
			var _s = 5;
			obj_camera.camera.x += random_range(-_s,_s);
			obj_camera.camera.y += random_range(-_s,_s);
			draw_sprite_rectangle(0,(height-1+(1-lineAnimation)*.5)*TILESIZE,width*TILESIZE, (height-(1-lineAnimation)*.5)*TILESIZE,0x19b546,false);
		}
		
		var _i = 0; 
		while(_i < array_length(entities))
		{ 
			entities[_i].Draw();
			_i++;
		}
		
		draw_sprite_rectangle(-2,-1, width*TILESIZE+1, height*TILESIZE, 0x4210b3, true);
		draw_sprite_rectangle(-1,0, width*TILESIZE, height*TILESIZE-1, 0x4210b3, true);
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		if(disableUpdate)
		{	
			if (global.highscore < currentScore) global.highscore = currentScore;
			
			draw_set_alpha(.8);
			draw_rectangle_color(0,0, width*TILESIZE, height*TILESIZE, c_black, c_black, c_black, c_black, false);
			draw_set_alpha(1);
			if (players = 1)
			{
				if (MOBILE)
				{
					draw_text_transformed(width/2*TILESIZE, height/2*TILESIZE, "Score:\n" + string(currentScore) + "\nRecord:\n" + string(global.highscore) + "\nClick to restart", .7, .7, 0);
					if(mouse_check_button_pressed(mb_left)) room_restart();
				}
				else
				{
					draw_text_transformed(width/2*TILESIZE, height/2*TILESIZE, "Score:\n" + string(currentScore) + "\nRecord:\n" + string(global.highscore) + "\nR to restart", .7, .7, 0);
				}
			}
			else
			{
				var _base = loser == 0 ? "Tie" : (loser == 1 ? "Green Won" : "Red Won");
				
				draw_text_transformed(width/2*TILESIZE, height/2*TILESIZE, _base + "\nScore:\n" + string(currentScore) + "\n R to restart", .7, .7, 0);
			}
			
			
		}
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		matrix_set(matrix_world, _mat);
		
	}
	
	static Update = function()
	{
		
		if(keyboard_check_pressed(ord("R"))) room_restart();
		if (!disableUpdate)
		{
			var _n = 2+currentScore*0.00001;
			currentScore++;
			repeat(_n)
			{
				//clear bottom line
				var _c = 0, _i = 0;
				repeat(width)
				{
					if mapData[_i][height-1] _c++;
					_i++;
				}
		
				if (_c == width){
					var _i = 0;
					repeat(width)
					{	
						var _b = new BgTile( global.BlockSprites[mapData[_i][height-1].blockType]);
						_b.x = obj_camera.camera.x - obj_camera.camera.width/2 + _i/width*obj_camera.camera.width;
						AddEntity(_b);
						mapData[_i][height-1] = undefined;
						_i++;
					}
					currentScore += 1000;
					lineAnimation = 1;
					audio_play_sound(snd_line, 0, 0);
				}
				
				//update
				var _i = width*height-1; 
				repeat(width*height)
				{
					if(mapData[_i % width][_i div width] != undefined) mapData[_i % width][_i div width].Update();
					_i--;
				}
				
				var _i = 0; 
				while(_i < array_length(entities))
				{ 
					entities[_i].Update();
					_i++;
				}
			
				var _i = 0; 
				while(_i < array_length(entities))
				{ 
					entities[_i].UpdateEnd();
					_i++;
				}
			}
		}
	}
	
	static AddEntity = function(entity)
	{
		array_push(entities, entity)
	}
	
	static RemoveEntity = function(entity)
	{
		var _i = 0;
		repeat(array_length(entities))
		{
			if(entities[_i] == entity) 
			{	
				array_delete(entities, _i, 1);
				break;
			}
			_i++;
		}
		
		
	}
	
	var _i = 0; repeat(players)
	{
		AddEntity(new Player(floor(width/2), height-1-_i, _i+1));
		_i++;
	}
	
}

function Player(xx=0,yy=0, type=1) constructor
{
	x = xx;
	y = yy;
	smoothX = x;
	smoothY = y;
	
	sprite = spr_player;
	frame = 0;
	
	pushingBlock = undefined;
	pushingDir = 0;
	
	vinput = 0;
	hinput = 0;
	
	flying = false;
	flyDir = 0;
	
	facing = 1;
	self.type = type;
	
	collidable = true;
	
	tutorialJumpTimer = 10;
	
	static _MeetingEntities = function(xx,yy)
	{
		var _map = obj_game.map;
		var _i = 0;
		repeat(array_length(_map.entities))
		{
			var _ent = _map.entities[_i];
			if (_ent.collidable == true && floor(_ent.x) == floor(xx) && floor(_ent.y) == floor(yy)) return true;
			_i++;
		}
		return false;
	}
	
	static _OnGround = function()
	{
		var _map = obj_game.map;
		return (y == _map.height-1 || _map.mapData[x][y+1] != undefined || _MeetingEntities(x, y+1));
	}
	
	static _MoveRight = function()
	{
		var _map = obj_game.map;
		if (x < _map.width-1)
		{
			facing = 1;
			if (!_MeetingEntities(x+1, y))
			{
				if (_map.mapData[x+1][y] == undefined || _map.mapData[x+1][y].blockType == 5)
				{
					x++;
					frame++;
					if (frame >= 2) frame = 0;
					return true;
				}
				else if (_OnGround() && _map.mapData[x+1][y-1] == undefined && 
				x != _map.width-2 && _map.mapData[x+2][y] == undefined &&
				!_MeetingEntities(x+2, y) &&
				_map.mapData[x+1][y].fallingBlock == undefined &&
				_map.mapData[x+1][y].blockType != 5
				)
				{
					pushingBlock = _map.mapData[x+1][y];
					_map.disableFalling = true;
					_map.mapData[x+1][y] = undefined;
					pushingDir = 1;
					audio_play_sound(snd_push, 0, 0);
					x++;
					frame++;
					if (frame >= 2) frame = 0;
				
					pushingBlock.x = smoothX+pushingDir;
					pushingBlock.y = smoothY;
					return true;
				}
				
			}
			
		}
		return false;
	}
	
	static _MoveLeft = function()
	{
		var _map = obj_game.map;
		if (x > 0)
		{
			facing = -1;
			if (!_MeetingEntities(x-1, y))
			{
				if (_map.mapData[x-1][y] == undefined || _map.mapData[x-1][y].blockType == 5)
				{
					x--;
					frame++;
					if (frame >= 2) frame = 0;
					return true;
				}
				else if (_OnGround() && _map.mapData[x-1][y-1] == undefined && 
					x != 1 && _map.mapData[x-2][y] == undefined &&
					!_MeetingEntities(x-2, y) &&
					_map.mapData[x-1][y].fallingBlock == undefined &&
					_map.mapData[x-1][y].blockType != 5
					)
				{
					pushingBlock = _map.mapData[x-1][y];
					_map.disableFalling = true;
					_map.mapData[x-1][y] = undefined;
					pushingDir = -1;
					audio_play_sound(snd_push, 0, 0);
					x--;
					frame++;
					if (frame >= 2) frame = 0;
				
					pushingBlock.x = smoothX+pushingDir;
					pushingBlock.y = y;
					return true;
				}
			}
			
		}
		return false;
	}
	
	static _MoveDown = function()
	{
		var _map = obj_game.map;
		if (y < _map.height-1 && _map.mapData[x][y+1] == undefined &&
			!_MeetingEntities(x, y+1))
		{
			y++;
		}
	}
	
	static _MoveUp = function()
	{
		var _map = obj_game.map;
		if (y > 0 && _map.mapData[x][y-1] == undefined  &&
			!_MeetingEntities(x, y-1))
		{
			y--;
		}
	}
	
	static DrawBegin = function()
	{
		if (pushingBlock != undefined) pushingBlock.DrawBegin();
		draw_sprite_shadow(sprite, frame, smoothX*TILESIZE+TILESIZE/2, smoothY*TILESIZE, facing, 1);
	}
	
	static Draw = function()
	{
		if (pushingBlock != undefined) pushingBlock.Draw();
		draw_sprite_ext(sprite, frame, smoothX*TILESIZE+TILESIZE/2, smoothY*TILESIZE,facing,1,0, type == 1 ? 0x4210b3 : 0x19b546, 1);
	}
	
	
	static Update = function()
	{
		var _map = obj_game.map;
		if (pushingBlock != undefined)
		{
			pushingBlock.x = smoothX+pushingDir;
			pushingBlock.y = y;
		}
		
		#region //input
		if (!_map.inTutorial)
		{
			if (type = 1)
			{
				vinput = -(keyboard_check_pressed(vk_up));
				if(MOBILE) vinput = -obj_game.dragUp;
			}
			else
			{
				vinput = -keyboard_check_pressed(ord("W"));
			
			}
		
			if (abs(x-smoothX) < .1)
			{
				var _in = 0;
				if (type = 1)
				{
					_in = keyboard_check(vk_right)-keyboard_check(vk_left);
					if(MOBILE) _in = obj_game.dragRight-obj_game.dragLeft;
				}
				else
				{
					_in = keyboard_check(ord("D"))-keyboard_check(ord("A"));
				}
		
				if(_in != 0)
				{
					hinput = _in;
				}
			}
		}
		else
		{
			if(_map.mapData[x][y-2] != undefined)
			{
				tutorialJumpTimer--;
				if(tutorialJumpTimer <= 0 )
				{
					vinput = -1;
					_map.inTutorial = false;
					tutorialJumpTimer = 0;
				}
			}
		}
		#endregion	
		
		//override when breaking a block directly above player
		if(vinput == -1 && y > 0 && _map.mapData[x][y-1] != undefined)
		{
			y--;
			_BreakBlock();
		}
		
		//movement logic
		if (abs(x-smoothX) < .1 && abs(y-smoothY) < .1)
		{
			var _turnedInAir = false;
			if(flying && flyDir != hinput)
			{
				_turnedInAir = true;
				flying = false;
			}
			
			//block push animation finished
			if (pushingBlock != undefined)
			{
				var _blk = new FallingBlock(x+pushingDir,y, pushingBlock.blockType);
				_map.AddEntity(_blk);
				pushingBlock = undefined;
				_map.disableFalling = false;
				pushingDir = 0;
			}
			else if (!_map.disableInput) //move player
			{
				if (vinput = -1)
				{
					//jumping
					if (y < _map.height-1 && _map.mapData[x][y+1] != undefined && _map.mapData[x][y+1].blockType == 3)
					{
						//spring jump
						_map.mapData[x][y+1].frame = 1;
						_map.mapData[x][y+1].animationPlay = true;
						_map.mapData[x][y+1].frameTimer = 0;
						_MoveUp();
						UpdateEnd();
						_MoveUp();
						
						audio_play_sound(snd_spring, 0, 0);
						audio_play_sound(snd_jump, 0, 0);
						var _s = 2;
						obj_camera.camera.x += random_range(-_s,_s);
						obj_camera.camera.y += random_range(-_s,_s);
						vinput = 0;
					}
					else if (_OnGround())
					{
						//normal jump
						_MoveUp();
						vinput = 0;
						
						audio_play_sound(snd_jump, 0, 0);
					}
				}
				else
				{
					if (!_turnedInAir && hinput == 1)
					{
						var _moved = _MoveRight();
						hinput = 0;
						vinput = 0;
						
						if (!_OnGround())
						{
							flying = true;
							flyDir = 1;
							sprite = spr_player_fly;
							if(_moved) audio_play_sound(snd_flap,0,0);
						}
						else if(_moved)
						{
							audio_play_sound(snd_footstep1,0,0);
						}
					}
					else if (!_turnedInAir && hinput == -1)
					{
						var _moved = _MoveLeft();
						hinput = 0;
						vinput = 0;
						
						if (!_OnGround())
						{
							flying = true;
							flyDir = -1;
							sprite = spr_player_fly;
							if(_moved) audio_play_sound(snd_flap,0,0);
						}
						else if(_moved)
						{
							audio_play_sound(snd_footstep1,0,0);
						}
					}
					else _MoveDown();
					
					if (!flying) sprite = spr_player;
				}
			}
			
			vinput = 0;
		}
		
		x = clamp(x, 0, obj_game.map.width-1);
		y = clamp(y, 0, obj_game.map.height-1);
		
		
	}
	
	static _BreakBlock = function()
	{
		var _map = obj_game.map;
		if (_map.mapData[x][y] == undefined) return;
		if (_map.mapData[x][y].blockType == 5) return; //ladder
		if (_map.mapData[x][y].blockType == 2)
		{
			_map.disableUpdate = true;
			_map.loser = type;
			return;
		}
		
		var _s = 5;
		obj_camera.camera.x += random_range(-_s,_s);
		obj_camera.camera.y += random_range(-_s,_s);
		
		
		if(_map.mapData[x][y].blockType == 4 && y > 0)
		{
			if (x > 0)
			{
				_map.mapData[x-1][y-1] = undefined;
				repeat(5) part_particles_create(global.PartSys, (x-1)*TILESIZE+TILESIZE/2,y*TILESIZE+TILESIZE*4, global.PartDust, 1);
			}
			if (x < _map.width-1)
			{
				_map.mapData[x+1][y-1] = undefined;
				repeat(5) part_particles_create(global.PartSys, (x+1)*TILESIZE+TILESIZE/2,y*TILESIZE+TILESIZE*4, global.PartDust, 1);
			}
		}
		
		_map.mapData[x][y] = undefined;
		
		repeat(5) part_particles_create(global.PartSys, x*TILESIZE+TILESIZE/2,y*TILESIZE+TILESIZE*4, global.PartDust, 1);
		_MoveDown();
		audio_play_sound(snd_break, 0, 0);
	}
	
	static UpdateEnd = function()
	{
		var _map = obj_game.map;
		if(_map.mapData[x][y] != undefined) 
		{
			if (!_OnGround())
			{
				_BreakBlock();
			}
			else if(_map.mapData[x][y].blockType != 5)
			{
				_map.disableUpdate = true;
				_map.loser = type;
				return;
			}
		}
		
		smoothX = lerp(smoothX, x, .08);
		smoothY = lerp(smoothY, y, .08);
	}
}

function FallingBlock(xx, yy, type = 1) constructor
{
	x = xx;
	y = yy;
	smoothX = x;
	smoothY = y;
	
	blockType = type;
	collisionBlock = new Block(type);
	collisionBlock.updateDisabled = true;
	var _map = obj_game.map;
	_map.mapData[x][y] = collisionBlock;
	
	collidable = false;
	hasFallen = false;
	mute = false;
	
	static _OnGround = function()
	{
		var _map = obj_game.map;
		return (y == _map.height-1 || _map.mapData[x][y+1] != undefined);
	}
	
	static DrawBegin = function()
	{
		
		
	}
	
	static Draw = function()
	{
		
		//collisionBlock.Draw();
	}
	
	static Update = function()
	{
		var _map = obj_game.map;
		if (!_map.disableFalling)
		{
			if (abs(y-smoothY) < .1)
			{
		
				var _map = obj_game.map;
			
				if (!_OnGround() && _map.mapData[x][y] != undefined)
				{
					_map.mapData[x][y] = undefined;
					y++;
					_map.mapData[x][y] = collisionBlock;
					hasFallen = true;
				}
				else
				{
					collisionBlock.x = x;
					collisionBlock.y = y;
					collisionBlock.updateDisabled = false;
					collisionBlock.fallingBlock = undefined;
					
					if(hasFallen)
					{
						var _s = 1;
						obj_camera.camera.x += random_range(-_s,_s);
						obj_camera.camera.y += random_range(-_s,_s);
						collisionBlock.flashAlpha = 1;
						if(!mute) audio_play_sound(snd_block, 0, 0);
					}
					
					//repeat(4) part_particles_create(global.PartSys, x*TILESIZE+random(TILESIZE),y*TILESIZE+TILESIZE*5, global.PartDustBlock, 1);
					_map.RemoveEntity(self);
				}
			
			
			}
		}
	}
	
	static UpdateEnd = function()
	{
		collisionBlock.x = smoothX;
		collisionBlock.y = smoothY;
		
		smoothX = lerp(smoothX, x, .08);
		smoothY = lerp(smoothY, y, .08);
	}
}

global.BlockSprites = [
	spr_empty,
	spr_block_basic,
	spr_block_unbreakable,
	spr_block_spring,
	spr_block_explosive,
	spr_block_ladder
];

function Block(type = 1) constructor
{
	x = 0;
	y = 0;
	
	blockType = type;
	updateDisabled = false;
	frame = 0;
	
	frameTime = 20;
	frameTimer = 0;
	
	loop = type != 3;
	animationPlay = false;
	
	fallingBlock = undefined;
	
	flashAlpha = 0;
	
	static DrawBegin = function()
	{
		draw_sprite_shadow(global.BlockSprites[blockType], frame, x*TILESIZE, y*TILESIZE);
	}
	
	static Draw = function()
	{
		draw_sprite(global.BlockSprites[blockType], frame, x*TILESIZE, y*TILESIZE);
		
		if (flashAlpha > .1)
		{
			shader_set(sha_flash);
				draw_sprite_ext(global.BlockSprites[blockType], frame, x*TILESIZE, y*TILESIZE, 1, 1, 0, 0x19b546, flashAlpha);
			shader_reset();
		}
	}
	
	static Update = function()
	{
		frameTimer++;
		if (frameTimer >= frameTime)
		{
			frameTimer = 0;
			if (loop || animationPlay)
			{
				frame++;
				animationPlay = true;
			}
			
			if(frame >= sprite_get_number(global.BlockSprites[blockType]))
			{	
				frame = 0;
				animationPlay = false;
			}
		}
		
		flashAlpha = lerp(flashAlpha, 0, .5);
		
		if (!updateDisabled)
		{
			var _map = obj_game.map;
			
			
			if (blockType == 5 && y > 0 && _map.mapData[x][y-1] != undefined && _map.mapData[x][y-1].blockType != 5) 
			
			{
				
				_map.mapData[x][y] = undefined;
				repeat(5) part_particles_create(global.PartSys, x*TILESIZE+TILESIZE/2,y*TILESIZE+TILESIZE*4, global.PartDust, 1);
			}
			
			if (y < _map.height-1 && _map.mapData[x][y+1] == undefined)
			{
				_map.mapData[x][y] = undefined;
				var _blk = new FallingBlock(x,y, blockType);
				_map.AddEntity(_blk);
				_blk.mute = true;
				_blk.Update();
				fallingBlock = _blk;
			}
		}
	}
}

enum BossState
{
	none,
	drop,
	pickup,
	count
}

function Boss() constructor
{
	var _map = obj_game.map;
	x = _map.width/2;
	y = -2;
	
	state = BossState.pickup;
	
	dropX = x;
	dropType = 0;
	
	collidable = false;
	tutorialBlockDropped = false;
	
	curve = animcurve_get(ac_ufo);
	curveChannel = curve.channels[0];
	
	animPos = 1;
	
	static _PickBlock = function()
	{
		var _map = obj_game.map;
		//choose block type
		var _t = 1;
		if (_map.currentScore > 500)
		{
			if (random(100) < 10) _t = 3;
			else if (_map.currentScore > 2000)
			{
				if (random(100) < 30) _t = 2;
				else if (random(100) < 25) _t = 5;
			}
		}
		
		return _t;
	}
	
	static DrawBegin = function()
	{
		draw_sprite_shadow(spr_boss, 0, x*TILESIZE+TILESIZE/2, y*TILESIZE);	
	}
	
	static Draw = function()
	{
		var _anim = animcurve_channel_evaluate(curveChannel, animPos);
		
		var _x = x*TILESIZE+TILESIZE/2;
		var _y = y*TILESIZE;
		var _dir = sin(current_time*0.01)*2+_anim*45;
		
		var _s = 1-y/-2;
		
		if (state == BossState.drop)
		{
			draw_sprite_ext(global.BlockSprites[dropType], 0, dropX*TILESIZE, 0, 1, 1, 0, c_white, 1);
			draw_sprite_ext(global.BlockSprites[dropType], 0, dropX*TILESIZE, 0, 1, 1, 0, 0x1A1113, .5);
		}
		

		draw_sprite_ext(global.BlockSprites[dropType], 0, x*TILESIZE+TILESIZE/2*(1.-_s), y*TILESIZE, _s, _s, 0, c_white, 1);

		shader_set(sha_flash);
			draw_sprite_ext(global.BlockSprites[dropType], 0, x*TILESIZE+TILESIZE/2*(1.-_s), y*TILESIZE, _s, _s, 0, 0x19b546, 1.-_s);
		shader_reset();
		
		draw_sprite_ext(spr_boss, state == BossState.pickup, _x, _y, 1, 1, _dir, c_white, 1);
	}
	
	static Update = function()
	{
		
		animPos = min(1, animPos+.01);
			
		var _map = obj_game.map;
		switch(state)
		{
			case BossState.drop:
				x = lerp(x, dropX, .02+_map.currentScore*0.000001);
				y = lerp(y, 0, .02+_map.currentScore*0.000001);
				
				if (abs(dropX-x) < .1 && abs(y) < .1)
				{
					var _blk = new FallingBlock(dropX,0, dropType);
					obj_game.map.AddEntity(_blk);
					animPos = 0;
					state = BossState.pickup;
					_blk.collisionBlock.fallingBlock = _blk;
					dropType = 0;
				}
				
				break;
		
			case BossState.pickup:
				
				x = lerp(x, floor(_map.width/2),.02+_map.currentScore*0.000005);
				y = lerp(y, -2, .02+_map.currentScore*0.000005);
				
				var _lastDropX = dropX;
				if (!tutorialBlockDropped && _map.inTutorial)
				{
					dropX = floor(_map.width/2);
					state = BossState.drop;
					tutorialBlockDropped = true;
					dropType = _PickBlock();
					break;
				}
				
				if (y < -1.9)
				{
					
					while(true)
					{
						dropX = irandom(_map.width-1);
						
						if (_map.mapData[dropX][0] != undefined)
						{
							var _i = 0;
							var _c = 0;
							repeat(_map.height)
							{
								if(_map.mapData[dropX][_i] != undefined) _c++;
								_i++;
							}
							
							if (_c == _map.height)
							{
								_map.disableUpdate = true;
								_map.loser = 0;
								return;
							}
						}
						else if(dropX != _lastDropX)
						{
							break;
						}
					}
					dropType = _PickBlock();
					state = BossState.drop;
				}
				
				break;
		}
		
	}
	
	static UpdateEnd = function()
	{

	}
}

function BgTile(sprt) constructor
{
	var _map = obj_game.map;
	x = 0
	y = -5*TILESIZE;

	collidable = false;
	sprite = sprt;
	
	rotSpeed = random_range(.1,1);
	moveSpeed = random_range(.1,1);
	static DrawBegin = function()
	{
		var _off = TILESIZE/2;
		var _ang = y*rotSpeed;
		var _xx = x - dcos(_ang) * _off;
		var _yy = y - dsin(_ang) * _off;
		draw_sprite_ext(sprite, 0, _xx, _yy, .5, .5, _ang, c_white, 1);
		
		draw_sprite_ext(sprite, 0, _xx, _yy, .5, .5, _ang, 0x1A1113, .8);
	}
	
	static Draw = function()
	{

	}
	
	static Update = function()
	{
		var _map = obj_game.map;
		y+=moveSpeed;
		if (y+32 > obj_camera.camera.height) _map.RemoveEntity(self);
	}
	
	static UpdateEnd = function()
	{

	}
}


