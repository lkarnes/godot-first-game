extends Area2D

var current_overlapping_items: Dictionary = {};

func _physics_process(delta):
	global_position = get_global_mouse_position();

func _on_body_entered(body):
	current_overlapping_items[body.name] = body;

func _on_body_exited(body):
	current_overlapping_items.erase(body.name);
	
func check_for_foliage():
	var result: Array = [];
	for item_key in current_overlapping_items:
		if current_overlapping_items[item_key] && "type" in current_overlapping_items[item_key]:
			var type = current_overlapping_items[item_key].type;
			if type && type.to_upper() in Constants.foliage:
				result.append(current_overlapping_items[item_key]);
	return result;
