extends Node



func change_scene(scene: PackedScene, player_coords: Vector2 = Vector2.ZERO):
	const PLAYER = preload("res://scenes/player/player.tscn");
	get_tree().change_scene_to_packed(scene);
	var player = PLAYER.instantiate();
	player.global_position= player_coords;
	add_child(player);
	
	
