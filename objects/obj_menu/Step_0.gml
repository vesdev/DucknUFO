

if (keyboard_check_pressed(vk_up))
{
	global.playerCount = 1;
	room_goto(rm_game);
}
if (keyboard_check_pressed(vk_down))
{
	global.playerCount = 2;
	room_goto(rm_game);
}