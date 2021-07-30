global.playerCount = 0;

#macro G global

G.PartSys = part_system_create();
part_system_depth(G.PartSys, -1);

G.PartDust = part_type_create();
part_type_sprite(G.PartDust, spr_dust, false, false, false);
part_type_size(G.PartDust, 1,1,-.1,0);
part_type_life(G.PartDust, 10,10);
part_type_direction(G.PartDust, 0, 360, 0, 0);
part_type_speed(G.PartDust, 1, 2, 0, 0);



