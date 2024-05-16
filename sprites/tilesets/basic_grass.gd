extends TileMap

var queue: Array = [];
var current_chunk: Dictionary;
var is_generating_tile = false;

func _physics_process(delta):
	if !is_generating_tile && queue.size() > 0:
		is_generating_tile = true;
		current_chunk = queue.pop_front()
		
	if is_generating_tile && !current_chunk.is_empty():
		if current_chunk.has('water_tiles'):
			set_cells_terrain_connect(0, current_chunk['water_tiles'], 0, 1, false); 
			current_chunk.erase('water_tiles');
		elif current_chunk.has('land_tiles'):
			set_cells_terrain_connect(0, current_chunk['land_tiles'], 0, 0, false); 
			current_chunk.erase('land_tiles');
		elif current_chunk.has('sand_tiles'):
			set_cells_terrain_connect(0, current_chunk['sand_tiles'], 0, 3, false); 
			current_chunk.erase('sand_tiles');
		elif current_chunk.has('cliff_tiles'):
			set_cells_terrain_connect(0, current_chunk['cliff_tiles'], 0, 2, false); 
			current_chunk.erase('cliff_tiles');
	
	if current_chunk.is_empty():
		is_generating_tile = false;
			
	
func push_to_queue(obj):
	queue.append(obj);

func generate_terrain(tiles_obj):
	# set the tiles using the tile arrays
	set_cells_terrain_connect(0, tiles_obj['water_tiles'], 0, 1, false); 
	set_cells_terrain_connect(0, tiles_obj['sand_tiles'], 0, 3, false);
	set_cells_terrain_connect(0, tiles_obj['land_tiles'], 0, 0, false);
	set_cells_terrain_connect(0, tiles_obj['cliff_tiles'], 0, 2, false);
