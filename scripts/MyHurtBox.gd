extends Area2D

class_name MyHurtBox
@export var mask_arr = [2];

func _ready():
	collision_layer = 0
	for layer in mask_arr:
		collision_mask = layer;
	connect("area_entered", self._on_area_entered)

func _on_area_entered(hitbox: Area2D): 
	print('hit: ', hitbox);
	if hitbox == null:
		return;
	if owner.has_method("take_damage") && !hitbox.disabled:
		var type = Enums.hit_type.DAMAGE;
		if hitbox.type:
			type = hitbox.type;
		print('type: ', type)
		match type:
			Enums.hit_type.DAMAGE:
				var damage = int((randf() * .25 * hitbox.damage_points) + hitbox.damage_points);
				const HITPOINT = preload('res://scenes/ui/player/hit_point_display/HitPoint.tscn')
				var hitpoint = HITPOINT.instantiate()
				hitpoint.value = damage;
				owner.add_child(hitpoint);
				owner.take_damage(damage);
			Enums.hit_type.DEBUFF:
				print('debuff')
				if owner.has_method('apply_debuff'):
					print('caught a debuff');
					owner.apply_debuff(hitbox.debuff_object);
			Enums.hit_type.BUFF:
				if owner.has_method('apply_buff'):
					owner.apply_buff();
