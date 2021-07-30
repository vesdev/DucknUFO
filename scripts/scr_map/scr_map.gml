#macro TILESIZE 16


function Map() constructor
{
	
	x = 0;
	y = 64;
	width = 10;
	height = 20;
	
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
		
		
		draw_rectangle(0,0, width*TILESIZE, height*TILESIZE, true);
		
		draw_set_halign(fa_center);
		draw_text(width/2*TILESIZE, -2*TILESIZE, string(currentScore));
		draw_set_halign(fa_left);
		matrix_set(matrix_world, _mat);
		
	}
	
	static Update = function()
	{
		currentScore++;
		var _i = 0; 
		while(_i < array_length(entities))
		{ 
			entities[_i].Update();
			_i++;
		}
		
		var _i = 0; 
		repeat(width*height)
		{
			if(mapData[_i % width][_i div width] != undefined) mapData[_i % width][_i div width].Update();
			_i++;
		}
		
		
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
	
}

function Player(xx=0,yy=0) constructor
{
	x = xx;
	y = yy;
	smoothX = x;
	smoothY = y;
	
	pushingBlock = undefined;
	pushingDir = 0;
	
	static _OnGround = function()
	{
		var _map = obj_game.map;
		return (y == _map.height-1 || _map.mapData[x][y+1] != undefined);
	}
	
	static _MoveRight = function()
	{
		var _map = obj_game.map;
		if (x < _map.width-1)
		{
			
			if (_map.mapData[x+1][y] == undefined)
			{
				x++;
			}
			//push block
			else if (_OnGround() && _map.mapData[x+1][y-1] == undefined && x != _map.width-2 && _map.mapData[x+2][y] == undefined)
			{
				pushingBlock = _map.mapData[x+1][y];
				_map.mapData[x+1][y] = undefined;
				pushingDir = 1;
				x++;
			}
		}
	}
	
	static _MoveLeft = function()
	{
		var _map = obj_game.map;
		if (x > 0)
		{
			if (_map.mapData[x-1][y] == undefined)
			{
				x--;
			}
			else if (_OnGround() && _map.mapData[x-1][y-1] == undefined && x != 1 && _map.mapData[x-2][y] == undefined)
			{
				pushingBlock = _map.mapData[x-1][y];
				_map.mapData[x-1][y] = undefined;
				pushingDir = -1;
				x--;
			}
		}
	}
	
	static _MoveDown = function()
	{
		var _map = obj_game.map;
		if (y < _map.height-1 && !_map.mapData[x][y+1])
		{
			y++;
		}
	}
	
	static _MoveUp = function()
	{
		var _map = obj_game.map;
		if (y > 0 && !_map.mapData[x][y-1])
		{
			y--;
		}
	}
	
	static Draw = function()
	{
		if (pushingBlock != undefined) pushingBlock.Draw();
		draw_sprite(spr_player, 0, smoothX*TILESIZE, smoothY*TILESIZE);
	}
	
	static Update = function()
	{
		var _map = obj_game.map;
		if(_map.mapData[x][y] != undefined) 
		{
			if (!_OnGround())
			{
				_map.mapData[x][y] = undefined;
			}
			else
			{
				room_restart();
			}
		}
	
		if (pushingBlock != undefined)
		{
			pushingBlock.x = smoothX+pushingDir;
			pushingBlock.y = smoothY;
		}
		
		if (abs(x-smoothX) < .1 && abs(y-smoothY) < .1)
		{
			
			
			if (pushingBlock != undefined)
			{
				var _blk = new FallingBlock(x+pushingDir,y, pushingBlock.blockType);
				_map.AddEntity(_blk);
				pushingBlock = undefined;
				pushingDir = 0;
			}
			else
			{
				if keyboard_check(vk_right) _MoveRight();
				else if keyboard_check(vk_left) _MoveLeft();
				else _MoveDown();
			
				if (keyboard_check_pressed(vk_up) && _OnGround()) _MoveUp();
			}
			
		}
		
		
		x = clamp(x, 0, obj_game.map.width-1);
		y = clamp(y, 0, obj_game.map.height-1);
		
		smoothX = lerp(smoothX, x, .1);
		smoothY = lerp(smoothY, y, .1);
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
		collisionBlock.x = smoothX;
		collisionBlock.y = smoothY;
	
		
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
		
		smoothX = lerp(smoothX, x, .1);
		smoothY = lerp(smoothY, y, .1);

	}
}

function Block(type = 1) constructor
{
	x = 0;
	y = 0;
	
	blockType = type;
	updateDisabled = false;
	
	static Draw = function()
	{
		
		draw_sprite(spr_block, blockType, x*TILESIZE, y*TILESIZE);
	}
	
	static Update = function()
	{
		if (!updateDisabled)
		{
			var _map = obj_game.map;
		
			if (y < _map.height-1 && _map.mapData[x][y+1] == undefined)
			{
				_map.mapData[x][y] = undefined;
				_map.AddEntity(new FallingBlock(x,y, blockType));
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
				x = lerp(x, dropX, .01+_map.currentScore*.0001);
				y = lerp(y, 0, .01+_map.currentScore*.0001);
				
				if (abs(dropX-x) < .1 && abs(y) < .1)
				{
				
					var _blk = new FallingBlock(dropX,0);
					obj_game.map.AddEntity(_blk);
					state = BossState.pickup;
					
				}
				
				break;
		
			case BossState.pickup:
				
				x = lerp(x, dropX,.01+ _map.currentScore*.0001);
				y = lerp(y, -4, .01+_map.currentScore*.0001);
				
				if (y < -3.9)
				{
					dropX = irandom(_map.width-1);
					state = BossState.drop;
				}
				
				break;
		}
		
	}
}