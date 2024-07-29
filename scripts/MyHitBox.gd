extends Area2D

class_name MyHitBox

@export var damage_points: int = 40
@export var disabled: bool = true;

func _init():
	collision_layer = 2
	collision_mask = 0

func set_disabled_val(val):
	disabled = val;
