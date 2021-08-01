#macro TILESIZE 16


function Map(players=1) constructor
{
	
	x = 0;
	y = 64;
	width = 10;
	height = 20;
	
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
	
	var _i = 0; repeat(array_length(mapData))
	{
		mapData[_i] = array_create(height, undefined);
		
		_i++;
	}
	
	static Draw = function()
	{
		var _mat = matrix_get(matrix_world);
		mapMatrix[12] = x;
		mapMatrix[13] = y;
		matrix_set(matrix_world, matrix_multiply(_mat, mapMatrix));
		
		draw_set_halign(fa_center);
			draw_text_color(width/2*TILESIZE, -2*TILESIZE, string(currentScore), 0x4210b3,0x4210b3,0x4210b3,0x4210b3,1);
		draw_set_halign(fa_left);
		
		var _i = 0; 
		repeat(width*height)
		{
			if(mapData[_i % width][_i div width] != undefined) mapData[_i % width][_i div width].Draw();
			_i++;
		}
		
		var _i = 0; 
		while(_i < array_length(entities))
		{ 
			entities[_i].Draw();
			_i++;
		}
		
		
		draw_rectangle_color(1,1, width*TILESIZE-2, height*TILESIZE-2, 0x4210b3, 0x4210b3, 0x4210b3,0x4210b3, true);
		
		draw_set_halign(fa_center);
		
		if(disableUpdate)
		{	
			draw_set_alpha(.8);
			draw_rectangle_color(0,0, width*TILESIZE, height*TILESIZE, c_black, c_black, c_black, c_black, false);
			draw_set_alpha(1);
			if (players = 1)
			{
				draw_text(width/2*TILESIZE, height/2*TILESIZE, "Score: \n" + string(currentScore) + "\n R to restart");
			}
			else
			{
				var _base = loser == 0 ? "Tie" : (loser == 1 ? "Green Won" : "Red Won");
				draw_text(width/2*TILESIZE, height/2*TILESIZE, _base + "\n Score: \n" + string(currentScore) + "\n R to restart");
			}
		}
		draw_set_halign(fa_left);
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
						mapData[_i][height-1] = undefined;
						_i++;
					}
					currentScore += 1000;
					
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
	
	static _MeetingEntities = function(xx,yy)
	{
		var _map = obj_game.map;
		var _i = 0;
		repeat(array_length(_map.entities))
		{
			var _ent = _map.entities[_i];
			if (floor(_ent.x) == floor(xx) && floor(_ent.y) == floor(yy)) return true;
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
			if (_map.mapData[x+1][y] == undefined &&
				!_MeetingEntities(x+1, y))
			{
				x++;
				frame++;
				if (frame >= 2) frame = 0;
				return true;
			}
			//push block
			else if (_OnGround() && _map.mapData[x+1][y-1] == undefined && 
				x != _map.width-2 && _map.mapData[x+2][y] == undefined &&
				!_MeetingEntities(x+1, y) &&
				!_MeetingEntities(x+2, y)
				)
			{
				pushingBlock = _map.mapData[x+1][y];
				_map.disableFalling = true;
				_map.mapData[x+1][y] = undefined;
				pushingDir = 1;
				x++;
				frame++;
				if (frame >= 2) frame = 0;
				return true;
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
			if (_map.mapData[x-1][y] == undefined &&
				!_MeetingEntities(x-1, y))
			{
				x--;
				frame++;
				if (frame >= 2) frame = 0;
				return true;
			}
			else if (_OnGround() && _map.mapData[x-1][y-1] == undefined && 
				x != 1 && _map.mapData[x-2][y] == undefined &&
				!_MeetingEntities(x-1, y) &&
				!_MeetingEntities(x-2, y))
			{
				pushingBlock = _map.mapData[x-1][y];
				_map.disableFalling = true;
				_map.mapData[x-1][y] = undefined;
				pushingDir = -1;
				x--;
				frame++;
				if (frame >= 2) frame = 0;
				return true;
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
			pushingBlock.y = smoothY;
		}
		
		if (type = 1)
		{
			if keyboard_check_pressed(vk_up) vinput = -1;
		}
		else
		{
			if keyboard_check_pressed(ord("W")) vinput = -1;
			
		}
		
		if (abs(x-smoothX) < .1)
		{
			var _in = 0;
			if (type = 1)
			{
				_in = keyboard_check(vk_right)-keyboard_check(vk_left);
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
		
		if (abs(x-smoothX) < .1 && abs(y-smoothY) < .1)
		{
			var _turnedInAir = false;
			if(flying && flyDir != hinput)
			{
				_turnedInAir = true;
				flying = false;
			}
			
			if (pushingBlock != undefined)
			{
				var _blk = new FallingBlock(x+pushingDir,y, pushingBlock.blockType);
				_map.AddEntity(_blk);
				pushingBlock = undefined;
				_map.disableFalling = false;
				pushingDir = 0;
			}
			else if (!_map.disableInput)
			{
				if (vinput = -1)
				{
					if (y < _map.height-1 && _map.mapData[x][y+1] != undefined && _map.mapData[x][y+1].blockType == 3)
					{
						_MoveUp();
						UpdateEnd();
						_MoveUp();
						
						vinput = 0;
					}
					else if (_OnGround())
					{
						_MoveUp();
						vinput = 0;
					}
				}
				else
				{
					if (!_turnedInAir && hinput == 1)
					{
						_MoveRight();
						hinput = 0;
						vinput = 0;
						
						if (!_OnGround())
						{
							flying = true;
							flyDir = 1;
							sprite = spr_player_fly;
						}
					}
					else if (!_turnedInAir && hinput == -1)
					{
						_MoveLeft();
						hinput = 0;
						vinput = 0;
						
						if (!_OnGround())
						{
							flying = true;
							flyDir = -1;
							sprite = spr_player_fly;
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
	
	static UpdateEnd = function()
	{
		var _map = obj_game.map;
		if(_map.mapData[x][y] != undefined) 
		{
			if (!_OnGround() && _map.mapData[x][y].blockType != 2)
			{
				//break block
				_map.mapData[x][y] = undefined;
				repeat(10) part_particles_create(global.PartSys, x*TILESIZE+TILESIZE/2,y*TILESIZE+TILESIZE*4, global.PartDust, 1);
				y++;
			}
			else
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
	
	static _OnGround = function()
	{
		var _map = obj_game.map;
		return (y == _map.height-1 || _map.mapData[x][y+1] != undefined);
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
				}
				else
				{
					collisionBlock.x = x;
					collisionBlock.y = y;
					collisionBlock.updateDisabled = false;
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
	spr_block_spring
];

function Block(type = 1) constructor
{
	x = 0;
	y = 0;
	
	blockType = type;
	updateDisabled = false;
	
	static Draw = function()
	{
		
		draw_sprite(spr_block, global.BlockSprites[blockType], x*TILESIZE, y*TILESIZE);
	}
	
	static Update = function()
	{
		if (!updateDisabled)
		{
			var _map = obj_game.map;
		
			if (y < _map.height-1 && _map.mapData[x][y+1] == undefined)
			{
				_map.mapData[x][y] = undefined;
				var _blk = new FallingBlock(x,y, blockType);
				_map.AddEntity(_blk);
				_blk.Update();
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
	
	static Draw = function()
	{
		
		draw_sprite(spr_boss, 0, x*TILESIZE+TILESIZE/2, y*TILESIZE);
	}
	
	static Update = function()
	{
		var _map = obj_game.map;
		switch(state)
		{
			case BossState.drop:
				x = lerp(x, dropX, .02+_map.currentScore*0.00001);
				y = lerp(y, 0, .02+_map.currentScore*0.00001);
				
				if (abs(dropX-x) < .1 && abs(y) < .1)
				{
					
					//choose block type
					var _t = 1;
					if (_map.currentScore > 2000)
					{
						if (random(100) < 10) _t = 3;
						else if (_map.currentScore > 5000)
						{
							if (random(100) < 20) _t = 2;
						}
					}
					
					
					var _blk = new FallingBlock(dropX,0, _t);
					obj_game.map.AddEntity(_blk);
					state = BossState.pickup;
					
				}
				
				break;
		
			case BossState.pickup:
				
				x = lerp(x, dropX,.02+_map.currentScore*0.00001);
				y = lerp(y, -4, .02+_map.currentScore*0.00001);
				
				if (y < -3.9)
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
						else
						{
							break;
						}
					}
					state = BossState.drop;
				}
				
				break;
		}
		
	}
	
	static UpdateEnd = function()
	{

	}
}