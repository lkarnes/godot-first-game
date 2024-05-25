extends Area2D

class_name MyHitBox

@export var damage_points: int = 10

func _init():
	collision_layer = 2
	collision_mask = 0
