extends Node

# Drops the loot into the scene
func drop_loot(item_path: String, drop_amount: int, drop_rate: float, position: Vector2, scene: Node):
	for i in range(drop_amount):
		# handle drop rate per item
		var dont_drop = randf() > drop_rate;
		if !dont_drop:
			var LOOT_MAGNET = load('res://scenes/objects/helpers/loot_magnet.tscn');
			var FIBER = load(item_path);
			if LOOT_MAGNET and FIBER:
				var magnet = LOOT_MAGNET.instantiate();
				var fiber = FIBER.instantiate();
				magnet.item = fiber;
				print(position);
				magnet.global_position = position + Vector2(randf() * drop_amount, randf() * drop_amount);
				scene.add_child(magnet);
