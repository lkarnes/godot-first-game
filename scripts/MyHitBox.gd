extends Area2D

class_name MyHitBox

@export var damage_points: int = 40;
@export var disabled: bool = true;
@export var collision_arr: Array;
@export var hit_type: String;

func _ready():
	for layer in collision_arr:
		set_collision_layer_value(layer, true);
		collision_mask = 0;

func set_disabled_val(val):
	disabled = val;
