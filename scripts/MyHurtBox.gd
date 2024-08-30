extends Area2D

class_name MyHurtBox
@export var mask_arr = [2];

func _ready():
	collision_layer = 0
	for layer in mask_arr:
		collision_mask = layer;
	connect("area_entered", self._on_area_entered)

func _on_area_entered(hitbox: Area2D): 
	if hitbox == null:
		return;

	if owner.has_method("take_damage") && !hitbox.disabled:
		var damage = int((randf() * .25 * hitbox.damage_points) + hitbox.damage_points);
		const HITPOINT = preload('res://scenes/ui/player/hit_point_display/HitPoint.tscn')
		var hitpoint = HITPOINT.instantiate()
		hitpoint.value = damage;
		owner.add_child(hitpoint);
		owner.take_damage(damage)
