extends Node


var player: CharacterBody2D;
var health: float = 100;
var mana: float = 100;
var position: Vector2 = Vector2.ZERO
var active_tool_slot: int = 1;
var is_submerged = true;

var player_toolbar: Dictionary = {
	'1': null,
	'2': null,
	'3': null,
	'4': null,
	'5': null,
};

var player_inventory = {}

func set_position(pos: Vector2 = Vector2.ZERO):
	if player && is_instance_valid(player):
		player.global_position = pos;
		
# adds a item to the players inventory;
func add_to_player_inventory(item):
	
	if item && player_inventory.has(item.name):
		if typeof(player_inventory[item.name]) == TYPE_ARRAY:
			player_inventory[item.name].append(item);
			return true;
	elif item && player_inventory.size() < 21:
		player_inventory[item.name] = [item];
		return true;
	return false;
			
