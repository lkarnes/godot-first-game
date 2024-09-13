extends Node


var player: CharacterBody2D;
var health: float = 100;
var mana: float = 100;
var active_tool_slot: int = 1;
var active_spell: int = 1;
var is_submerged = true;
var orientation = 'left';

var player_toolbar: Dictionary = {
	'1':  preload("res://scenes/objects/weapons/serrated_sword.tscn").instantiate(),
	'2':  preload("res://scenes/objects/tools/hatchet.tscn").instantiate(),
	'3': null,
	'4': null,
	'5': null,
};

var player_spellbar: Dictionary = {
	'1':  preload("res://scenes/objects/projectiles/fire_ball_1.tscn").instantiate(),
	'2':  preload("res://scenes/objects/projectiles/poisonous_pool.tscn").instantiate(),
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

