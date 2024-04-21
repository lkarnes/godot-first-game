extends Node2D

var wid = 100;
var hght = 100;
var player_set: bool = false;
@onready var tileMap: TileMap = %Dungeon;

func _ready():
	await create_backdrop();

func create_backdrop():
	var coords_array: Array = [];
	for y in hght:
		for x in wid:
			coords_array.append(Vector2i(x - (x/2),y - (y/2)));
	tileMap.set_cells_terrain_connect(0, coords_array, 0, 1);
	var path = build_path();
	tileMap.set_cells_terrain_connect(0, path, 0, 0);
	
	
func build_path():
	var path_arr: Array[Vector2i] = [Vector2i(10, hght/2)]
	var current = Vector2i(15, 15);
	var moves = 5;
	
	while moves > 0:
		moves -= 1;
		var possible_moves: Array = []
		var random_length = randf_range(1,10);
		if current.x + random_length < wid:
			possible_moves.append(Vector2i(current.x + 1, current.y));
		if current.x - random_length > 0:
			possible_moves.append(Vector2i(current.x - 1, current.y));
		if current.y + random_length < hght:
			possible_moves.append(Vector2i(current.x, current.y + 1))
		if current.y - random_length > 0:
			possible_moves.append(Vector2i(current.x, current.y - 1))
		current = possible_moves.pick_random()
		add_line(path_arr, random_length, current);
	return path_arr;
		
func add_line(path_arr: Array, rng, current):
	
	var prev = path_arr[path_arr.size() - 1]
	var dif = Vector2(prev.x - current.x, prev.y - current.y);
	var dir: String;
	print('dif', dif);
	#find path direction
	if dif.x < 0:
		dir = 'left';
	elif dif.x > 0:
		dir = 'right';
	elif dif.y < 0:
		dir = 'up';
	else:
		dir = 'down';
	match dir:
		'up':
			for i in range(rng):
				path_arr.append(Vector2i(current.x, current.y - i));
		'down':
			for i in range(rng):
				path_arr.append(Vector2i(current.x, current.y - i));
		'left':
			for i in range(rng):
				path_arr.append(Vector2i(current.x - i, current.y));
		'right':
			for i in range(rng):
				path_arr.append(Vector2i(current.x + i, current.y));
			
	

func _physics_process(delta):
	if !player_set:
		player_set = true;
		Player.set_position(Vector2(15 * 8, (hght / 2) * 8));

