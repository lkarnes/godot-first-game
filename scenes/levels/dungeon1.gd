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
	build_path();
	
	
func build_path():
	var path_arr: Array[Vector2i] = [Vector2i(10, hght/2)]
	var current = Vector2i(15, 15);
	var moves = 100;
	
	while moves > 0:
		moves -= 1;
		var possible_moves: Array = [
			Vector2i(current.x + 1, current.y),
			Vector2i(current.x - 1, current.y),
			Vector2i(current.x, current.y + 1),
			Vector2i(current.x, current.y - 1)
		];
		var direction_arr = [];
		var random_length = randf_range(4,10);
		if current.x + random_length < wid:
			direction_arr.append('right');
		if current.x - random_length > 0:
			direction_arr.append('left');
		if current.y + random_length < hght:
			direction_arr.append('down');
		if current.y - random_length > 0:
			direction_arr.append('up');
		var rand_direction = direction_arr.pick_random()
		match rand_direction:
			'right':
				current = possible_moves[0]
			'left':
				current = possible_moves[1]
			'down':
				current = possible_moves[2]
			'up':
				current = possible_moves[3]
		add_line(path_arr, random_length, current, rand_direction);
	tileMap.set_cells_terrain_connect(0, path_arr, 0, 0);

		
func add_line(path_arr: Array, rng, current, dir):
	var prev = path_arr[path_arr.size() - 1]
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

