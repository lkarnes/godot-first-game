extends Node



func change_scene(scene: PackedScene, player_coords: Vector2 = Vector2.ZERO):
	var p = Player.player.duplicate();
	get_tree().change_scene_to_packed(scene);
	p.global_position = player_coords;
	await get_tree().process_frame;
	get_tree().current_scene.add_child(p);
	
	
