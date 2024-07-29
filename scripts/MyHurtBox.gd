extends Area2D

class_name MyHurtBox

func _init():
	collision_layer = 0
	collision_mask = 2

func _ready():
	connect("area_entered", self._on_area_entered)

func _on_area_entered(hitbox: Area2D): 
	if hitbox == null:
		return

	if owner.has_method("take_damage") && !hitbox.disabled:
		const HITPOINT = preload('res://scenes/ui/player/hit_point_display/HitPoint.tscn')
		var hitpoint = HITPOINT.instantiate()
		hitpoint.value = hitbox.damage_points
		owner.add_child(hitpoint);
		owner.take_damage(hitbox.damage_points)
