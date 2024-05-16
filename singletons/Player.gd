extends Node


var player: CharacterBody2D;
var health: float = 100;
var mana: float = 100;
var position: Vector2 = Vector2.ZERO
var active_tool_slot: int = 1;

var player_toolbar = {
	'1': null,
	'2': null,
	'3': null,
	'4': null,
	'5': null,
};

func set_position(pos: Vector2 = Vector2.ZERO):
	if player:
		player.global_position = pos;
		player.z_index = 0;
