randomize();

global.PartSys = part_system_create();
part_system_depth(global.PartSys, -1);

global.PartDust = part_type_create();
part_type_sprite(global.PartDust, spr_dust, false, false, false);
part_type_size(global.PartDust, 1,1,-.1,0);
part_type_life(global.PartDust, 10,10);
part_type_direction(global.PartDust, 0, 360, 0, 0);
part_type_speed(global.PartDust, 1, 2, 0, 0);


map = new Map(global.playerCount);
var _h = map.height*TILESIZE+64;


map.AddEntity(new Boss());