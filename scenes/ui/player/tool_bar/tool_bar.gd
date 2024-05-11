extends CanvasLayer

func _ready():
	change_slot();

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
	match old_slot:
		1:
			%Slot1.get_node('ToolSlot').queue_free();
		2:
			%Slot2.get_node('ToolSlot').queue_free();
		3:
			%Slot3.get_node('ToolSlot').queue_free();
		4:
			%Slot4.get_node('ToolSlot').queue_free();
		5:
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
			
func set_items_to_slots():
	if Player.player_toolbar.has('1') && %Slot1.get_children().size() < 2:
		Player.player_toolbar['1'].scale = Vector2(.25,.25);
		%Slot1.add_child(Player.player_toolbar['1'])
