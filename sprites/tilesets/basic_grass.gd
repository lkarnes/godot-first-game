extends TileMap

var chunk_stack: Array = [];
var frame_count = 0;

func _physics_process(delta):
		#if frame_count == 1:
			#frame_count = 0;
	pull_from_queue()
		#else:
			#frame_count += 1;

func render_chunks(chunk_object):
		chunk_stack.append(chunk_object);

func pull_from_queue():
	if chunk_stack.size() > 0:
		var chunk = chunk_stack.pop_front()
		# set the tiles using the tile arrays
		set_cells_terrain_connect(0, chunk['water_tiles'], 0, 1, false);
		set_cells_terrain_connect(0, chunk['sand_tiles'], 0, 3, false);
		set_cells_terrain_connect(0, chunk['land_tiles'], 0, 0, false);
		set_cells_terrain_connect(0, chunk['cliff_tiles'], 0, 2, false);
