extends ReferenceRect


func _physics_process(delta: float):
	var old_slot = Player.active_tool_slot
	set_items_to_slots();
	
	for i in range(1, 6):  # Iterate over tool slots 1 to 5
		if Input.is_action_just_pressed("slot_" + str(i)) && old_slot != i:
			Player.active_tool_slot = i
			change_slot(old_slot)
			break

func change_slot(old_slot = null):
	const SELECTION = preload('res://scenes/ui/player/tool_bar/tool_slot.tscn');
	var selection = SELECTION.instantiate();
	print(Player.player_toolbar)
	match old_slot:
		1:
			if %Slot1.get_node('ToolSlot'):
				%Slot1.get_node('ToolSlot').queue_free();
		2:
			if %Slot2.get_node('ToolSlot'):
				%Slot2.get_node('ToolSlot').queue_free();
		3:
			if %Slot3.get_node('ToolSlot'):
				%Slot3.get_node('ToolSlot').queue_free();
		4:
			if %Slot4.get_node('ToolSlot'):
				%Slot4.get_node('ToolSlot').queue_free();
		5:
			if %Slot5.get_node('ToolSlot'):
				%Slot5.get_node('ToolSlot').queue_free();
			
	match Player.active_tool_slot:
		1:
			%Slot1.add_child(selection)
		2:
			%Slot2.add_child(selection)
		3:
			%Slot3.add_child(selection)
		4:
			%Slot4.add_child(selection)
		5:
			%Slot5.add_child(selection)
	handle_item_swap()
			
func set_items_to_slots():
	if Player.player_toolbar['1'] != null && %Slot1.get_children().size() < 2:
		var weapon_texture: CompressedTexture2D = Player.player_toolbar['1'].get_node('Sprite2D').texture;
		%Slot1/Sprite2D.texture = weapon_texture;
	if Player.player_toolbar['2'] != null && %Slot2.get_children().size() < 2:
		var weapon_texture: CompressedTexture2D = Player.player_toolbar['2'].get_node('Sprite2D').texture;
		%Slot2/Sprite2D.texture = weapon_texture;
	if Player.player_toolbar['3'] != null && %Slot3.get_children().size() < 2:
		var weapon_texture: CompressedTexture2D = Player.player_toolbar['3'].get_node('Sprite2D').texture;
		%Slot3/Sprite2D.texture = weapon_texture;
	if Player.player_toolbar['4'] != null && %Slot4.get_children().size() < 2:
		var weapon_texture: CompressedTexture2D = Player.player_toolbar['4'].get_node('Sprite2D').texture;
		%Slot4/Sprite2D.texture = weapon_texture;
	if Player.player_toolbar['5'] != null && %Slot5.get_children().size() < 2:
		var weapon_texture: CompressedTexture2D = Player.player_toolbar['5'].get_node('Sprite2D').texture;
		%Slot5/Sprite2D.texture = weapon_texture;
		
func handle_item_swap():
	var active_slot = str(Player.active_tool_slot)
	var player_primary: Marker2D = Player.player.get_node('PrimaryHand');
	if player_primary.get_child(0):
		player_primary.remove_child(player_primary.get_child(0))
	var item = Player.player_toolbar[active_slot].duplicate();
	if item:
		player_primary.add_child(item);
	
