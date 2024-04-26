extends Node2D

var player_set: bool = false;
var terrain_set: bool = false;
var trees_set: bool = false;
@export var noise_height_text: NoiseTexture2D;
var noise: Noise;
@onready var tileMap: TileMap = %BasicGrass;

var width: int = 100;
var height: int = 100;
var edge_size = 0;


var water_tiles: Array = []
var sand_tiles: Array = []
var land_tiles: Array = []
var cliff_tiles: Array = []

var noise_val_arr = []

func _ready():
	noise = noise_height_text.noise
	noise.seed = randf() * 100;
	if !terrain_set:
		%LoadingScreen.loading_text = 'Generating Terrain...'
		terrain_set = true;
		generate_terrain()
	
func _physics_process(delta):
	if !trees_set && terrain_set:
		%LoadingScreen.loading_text = 'Generating Trees...'
		trees_set = true;
		generate_trees()
	elif !player_set:
		%LoadingScreen.loading_text = 'Setting Spawn...'
		player_set = true;
		Player.set_position(find_spawn_position());
	else:
		remove_child(%LoadingScreen)
	
func find_spawn_position():
	var good_coords;
	var idx = 0;
	while(!good_coords && idx < 100):
		idx += 1
		var x = randf() * width;
		var y = randf() * height;
		var rand_tile: TileData = tileMap.get_cell_tile_data(0, Vector2i(x, y));
		if rand_tile && rand_tile.terrain == 0:
			good_coords = tileMap.map_to_local(Vector2i(x,y))
		else:
			good_coords = Vector2i(100,100)
	return good_coords;

func generate_terrain():
	for x in range(width):
		for y in range(height):
			water_tiles.append(Vector2i(x,y))
			var noise_val = noise.get_noise_2d(x, y);
			if x < width - edge_size && x > edge_size && y < width - edge_size && y > edge_size:
				if noise_val > -.1 && noise_val <= 0:
					sand_tiles.append(Vector2i(x,y))
					var adjacent = tileMap.get_surrounding_cells(Vector2i(x,y))
					for tile in adjacent:
						sand_tiles.append(tile);
				elif noise_val > 0:
					land_tiles.append(Vector2i(x,y))
					var adjacent = tileMap.get_surrounding_cells(Vector2i(x,y))
					for tile in adjacent:
						land_tiles.append(tile);
				
				if noise_val > .15 && noise_val < .17:
					cliff_tiles.append(Vector2i(x,y))
	tileMap.set_cells_terrain_connect(0, water_tiles, 0, 1);
	tileMap.set_cells_terrain_connect(0, sand_tiles, 0, 3);
	tileMap.set_cells_terrain_connect(0, land_tiles, 0, 0);
	tileMap.set_cells_terrain_connect(0, cliff_tiles, 0, 2);
	
func generate_trees():
	const PINE = preload('res://scenes/trees/pine/pine_tree.tscn')
	var tree_tiles: Array = [];
	
	for coords: Vector2i in land_tiles:
		var noise_val = noise.get_noise_2d(coords.x, coords.y);
		var jittered_spawn = (noise_val / 2) + randf();

		if jittered_spawn > 1.1 && !tree_tiles.has(coords):
			tree_tiles.append(coords)
			var new_pine = PINE.instantiate()
			new_pine.global_position =  tileMap.map_to_local(coords);
			new_pine.z_index = 1
			add_child(new_pine)
			
		
		
