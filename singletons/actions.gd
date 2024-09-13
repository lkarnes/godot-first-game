extends Node

func weighted_random_drop(item_array):
	var sum = 0
	var valid_items = []
	
	# Calculate the total weight and collect valid items
	for item in item_array:
		if item.has("weight") and item.weight > 0:
			sum += item.weight
			valid_items.append(item)
	
	# Ensure there are valid items to choose from
	if valid_items.size() == 0:
		return null  # No valid items to choose from

	# Generate a random number in the range [0, sum)
	var random = randf_range(0, sum)
	var accumulated_weight = 0.0

	# Iterate through valid items and find the chosen item
	for item in valid_items:
		accumulated_weight += item.weight
		if random < accumulated_weight:
			return item
	
	# Fallback (should never be reached if weights and sums are correct)
	return valid_items[0]


# Drops the loot into the scene
func drop_loot(item_path: String, drop_amount: int, drop_rate: float, position: Vector2, scene: Node):
	for i in range(drop_amount):
		# handle drop rate per item
		var dont_drop = randf() > drop_rate;
		if !dont_drop:
			var LOOT_MAGNET = load('res://scenes/objects/helpers/loot_magnet.tscn');
			var ITEM = load(item_path);
			if LOOT_MAGNET and ITEM:
				var magnet = LOOT_MAGNET.instantiate();
				var item = ITEM.instantiate();
				magnet.item = item;
				magnet.global_position = position + Vector2(randf() * drop_amount, randf() * drop_amount);
				scene.add_child(magnet);
