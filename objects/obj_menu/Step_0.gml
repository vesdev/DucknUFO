if (keyboard_check_pressed(ord("1"))) 
{
	global.playerCount = 1;
	room_goto(rm_game);
}
if (keyboard_check_pressed(ord("2")))
{
	global.playerCount = 2;
	room_goto(rm_game);
}