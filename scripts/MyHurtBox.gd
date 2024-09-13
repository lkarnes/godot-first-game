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
	if owner.has_method("take_damage") && "disabled" in hitbox && !hitbox.disabled:
		var hit_type = Constants.hit_type.DAMAGE;
		if hitbox.hit_type:
			hit_type = hitbox.hit_type;
		match hit_type:
			Constants.hit_type.DAMAGE:
				var damage = int((randf() * .25 * hitbox.damage_points) + hitbox.damage_points);
				const HITPOINT = preload('res://scenes/ui/player/hit_point_display/HitPoint.tscn')
				var hitpoint = HITPOINT.instantiate()
				hitpoint.value = damage;
				owner.add_child(hitpoint);
				owner.take_damage(damage);
			Constants.hit_type.DEBUFF:
				if owner.has_method('apply_debuff'):
					owner.apply_debuff(hitbox.debuff_object);
			Constants.hit_type.BUFF:
				if owner.has_method('apply_buff'):
					owner.apply_buff();
