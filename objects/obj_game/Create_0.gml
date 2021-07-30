randomize();

map = new Map();
var _h = map.height*TILESIZE+64;
camera = new Camera(map.width*TILESIZE, _h, map.width*TILESIZE, _h);
camera.x = map.width*TILESIZE/2;
camera.y = _h/2;
camera.ScaleWindow(2);

camera.Set();

map.AddEntity(new Player(map.width/2, map.height-1));
map.AddEntity(new Boss());