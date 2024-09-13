class_name Debuff
extends Node

var damage: Array;
var frequency: float;
var duration: float;
var type: String;

func _init(_damage: Array, _frequency: float, _duration: float, _type: String):
	damage = _damage;
	frequency = _frequency;
	duration = _duration;
	type = _type;
	
func validate(instance):
	if not (instance.has("damage") and instance.has("_frequency") and instance.has("duration") and instance.has("type")):
		return false
	return true
