extends Node2D

var player_set: bool = false;
var terrain_set: bool = false;
var trees_set: bool = false;
@export var noise_height_text: NoiseTexture2D;
var noise: Noise;
@onready var tileMap: TileMap = %BasicGrass;

var width: int = 8;
var height: int = 8;
var edge_size = 0;
var chunks = 100;
var all_land_tiles = [];

var sand_range = [-0.1, 0.0];
var land_range = [0, .35];
var cliff_range = [.35, 100];

var chunk_cache = {};
var grid_position: Vector2i;

var noise_val_arr = []

func _ready():
	noise_height_text.width = width * sqrt(chunks);
	noise_height_text.height = height * sqrt(chunks);
	noise = noise_height_text.noise
	noise.seed = randf() * 100;
	
func _physics_process(delta):
	if !terrain_set:
		%LoadingScreen.loading_text = 'Generating Terrain...'
		terrain_set = true;
		generate_terrain()
	
	if !trees_set && terrain_set:
		%LoadingScreen.loading_text = 'Generating Trees...'
		trees_set = true;
		generate_trees()
	elif !player_set:
		%LoadingScreen.loading_text = 'Setting Spawn...'
		player_set = true;
		Player.set_position(find_spawn_position());
	elif has_node("LoadingScreen"):
		remove_child(%LoadingScreen)
		
	if player_set:
		var new_grid_position = tileMap.local_to_map(
			Vector2i(
				snapped(Player.player.global_position.x, width * 32), 
				snapped(Player.player.global_position.y, height * 32))
		);
		if new_grid_position != grid_position:
			#print('position_change:', new_grid_position)
			get_chunks_in_range();
			grid_position = new_grid_position;
		
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
	var unloaded_chunks = chunks;
	var dimensions: int = sqrt(chunks);
	var chunk_arr: Array = [];
	
	for x in dimensions:
		for y in dimensions:
			chunk_arr.append(Vector2(x * width, y * height))

	while unloaded_chunks > 0:
		unloaded_chunks = unloaded_chunks - 1;
		generate_chunk(chunk_arr.pop_front())
		

func generate_chunk(starting_coords: Vector2):
	var water_tiles: Array = []
	var sand_tiles: Array = []
	var land_tiles: Array = []
	var cliff_tiles: Array = []
	for x in range(starting_coords.x, starting_coords.x + width + 1):
		for y in range(starting_coords.y, starting_coords.y + height + 1):
			water_tiles.append(Vector2i(x,y))
			var noise_val = noise.get_noise_2d(x, y);
			# assign the tiles based off the noise value
			if noise_val > sand_range[0] && noise_val <= sand_range[1]:
				sand_tiles.append(Vector2i(x,y))
			elif !( noise_val > cliff_range[0] && noise_val <= cliff_range[1]) && noise_val > sand_range[1]:
				land_tiles.append(Vector2i(x,y))

			if noise_val > cliff_range[0]:
				cliff_tiles.append(Vector2i(x,y))
				var adjacent = tileMap.get_surrounding_cells(Vector2i(x,y))
	# update the chunk cache
	chunk_cache[str(starting_coords)] = {
		'water_tiles' : water_tiles,
		'sand_tiles': sand_tiles,
		'land_tiles': land_tiles,
		'cliff_tiles': cliff_tiles, 
	}
	# set the tiles using the tile arrays
	tileMap.set_cells_terrain_connect(0, water_tiles, 0, 1);
	tileMap.set_cells_terrain_connect(0, sand_tiles, 0, 3);
	tileMap.set_cells_terrain_connect(0, land_tiles, 0, 0);
	tileMap.set_cells_terrain_connect(0, cliff_tiles, 0, 2);
	all_land_tiles.append_array(land_tiles);
	# temp logging
	#print('sand tiles: ', sand_tiles.size());
	#print('land tiles: ', land_tiles.size());
	#print('cliff tiles: ', cliff_tiles.size())
	#print('tile count: ', sand_tiles.size() + land_tiles.size() + cliff_tiles.size() + water_tiles.size())
	#print('______________________________________')

func get_chunks_in_range():
	for x in sqrt(chunks):
		for y in sqrt(chunks):
			var x_pos_change = (x * width + grid_position.x) - (sqrt(chunks) / 2) * width;
			var y_pos_change = (y * height + grid_position.y) - (sqrt(chunks) / 2) * height;
			var new_coord = Vector2i(x_pos_change, y_pos_change);

			if !chunk_cache.has(str(new_coord)):
				#print('not exists');
				generate_chunk(new_coord);

func generate_trees():
	const PINE = preload('res://scenes/trees/pine/pine_tree.tscn');
	const PLANT1 = preload("res://scenes/trees/plant-1/plant_1.tscn");
	const FLOWER1 = preload("res://scenes/trees/flower_1/flower_1.tscn");
	var tree_tiles: Array = [];
	var plant_tiles: Array = [];
	
	for coords: Vector2i in all_land_tiles:
		var noise_val = noise.get_noise_2d(coords.x, coords.y);
		var jittered_spawn = abs(noise_val / 2) + randf();

		if  jittered_spawn > .97 && jittered_spawn < .98:
			plant_tiles.append(coords)
			var new_flower_1 = FLOWER1.instantiate()
			new_flower_1.global_position = tileMap.map_to_local(coords);
			new_flower_1.z_index = -1
			add_child(new_flower_1)
		elif jittered_spawn > .98 && jittered_spawn < 1:
			plant_tiles.append(coords)
			var new_plant_1 = PLANT1.instantiate()
			new_plant_1.global_position = tileMap.map_to_local(coords);
			new_plant_1.z_index = -1
			add_child(new_plant_1)
		elif jittered_spawn > 1 && jittered_spawn < 1.5 && !tree_tiles.has(coords):
			tree_tiles.append(coords)
			var new_pine = PINE.instantiate()
			new_pine.global_position =  tileMap.map_to_local(coords);
			new_pine.z_index = 1
			add_child(new_pine)
			
		
		
