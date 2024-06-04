extends Control


func _physics_process(delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		if visible == false:
			visible = true;
			load_inventory();
		else:
			visible = false;
			
func load_inventory():
	for slot_idx in range(0 ,19):
		var inventory: Array = Player.player_inventory.values()
		var slot = %GridContainer.get_child(slot_idx);
		if inventory.size() > slot_idx:
			var item_at_idx = inventory[slot_idx];
			if typeof(item_at_idx) == TYPE_ARRAY:
				slot.set_item_arr(item_at_idx);
			else:
				slot.set_item(item_at_idx);
