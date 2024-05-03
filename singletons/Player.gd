extends Node


var player: CharacterBody2D;
var health: float = 100;
var mana: float = 100;
var position: Vector2 = Vector2.ZERO

func set_position(pos: Vector2 = Vector2.ZERO):
	if player:
		player.global_position = pos;
