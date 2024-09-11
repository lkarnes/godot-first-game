extends ReferenceRect


func _physics_process(delta: float):
	var old_slot = Player.active_spell
	set_items_to_slots();
	
	for i in range(1, 4):  # Iterate over tool slots 1 to 5
		if Input.is_action_just_pressed("spell_slot_" + str(i)) && old_slot != i:
			Player.active_spell = i
			change_slot(old_slot)
			break

func change_slot(old_slot = null):
	const SELECTION = preload('res://scenes/ui/player/tool_bar/tool_slot.tscn');
	var selection = SELECTION.instantiate();
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
			
	match Player.active_spell:
		1:
			%Slot1.add_child(selection)
		2:
			%Slot2.add_child(selection)
		3:
			%Slot3.add_child(selection)
	handle_item_swap()
			
func set_items_to_slots():
	if Player.player_spellbar['1'] != null && %Slot1.get_children().size() < 2:
		var weapon_texture: CompressedTexture2D = Player.player_spellbar['1'].get_node('Sprite2D').texture;
		%Slot1/Sprite2D.texture = weapon_texture;
	if Player.player_spellbar['2'] != null && %Slot2.get_children().size() < 2:
		var weapon_texture: CompressedTexture2D = Player.player_spellbar['2'].get_node('Sprite2D').texture;
		%Slot2/Sprite2D.texture = weapon_texture;
	if Player.player_spellbar['3'] != null && %Slot3.get_children().size() < 2:
		var weapon_texture: CompressedTexture2D = Player.player_spellbar['3'].get_node('Sprite2D').texture;
		%Slot3/Sprite2D.texture = weapon_texture;
		
func handle_item_swap():
	var active_slot = str(Player.active_spell);
	var item = Player.player_spellbar[active_slot];
	
