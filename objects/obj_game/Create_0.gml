randomize();

global.PartSys = part_system_create();
part_system_depth(global.PartSys, 100);

global.PartDust = part_type_create();
part_type_sprite(global.PartDust, spr_dust, true, false, false);
part_type_size(global.PartDust, 1,1,-.1,0);
part_type_life(global.PartDust, 10,10);
part_type_direction(global.PartDust, 0, 360, 0, 0);
part_type_speed(global.PartDust, 1, 2, 0, 0);

global.PartDustBlock = part_type_create();
part_type_sprite(global.PartDustBlock, spr_dust, false, false, false);
part_type_size(global.PartDustBlock, 1,1,-.2,0);
part_type_life(global.PartDustBlock, 10,10);
part_type_direction(global.PartDustBlock, 0, 180, 0, 0);
part_type_speed(global.PartDustBlock, 1, 2, 0, 0);

global.PartBgDust = part_type_create();
part_type_sprite(global.PartBgDust, spr_sparkle, false, false, true);
part_type_size(global.PartBgDust, 1,1,0,0);
part_type_alpha2(global.PartBgDust, 1,0);
part_type_life(global.PartBgDust, 1000,1000);
part_type_direction(global.PartBgDust, 45, 135, 0, 0);
part_type_speed(global.PartBgDust, .01, .05, 0, 0);
part_type_color2(global.PartBgDust,0x5BC5F9,0x19B546);
part_type_blend(global.PartBgDust, true);
map = new Map(global.playerCount, global.showTutorial);
global.showTutorial = false; //dont show again after first attempt

var _h = map.height*TILESIZE+64;


map.AddEntity(new Boss());

bgPartTime = 40;
bgPartTimer = 0;

dragUp = false;
dragLeft = false;
dragRight = false;

draggedUp = false;

pressX = 0;
pressY = 0;

if (!audio_is_playing(snd_theme)) audio_play_sound(snd_theme, 0, true);
