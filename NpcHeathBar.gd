extends ProgressBar


@onready var parent = get_parent();
@onready var timer: Timer = %Timer;
var prev_health;

func _physics_process(delta):
	if "max_health" in parent:
		max_value = parent.max_health;
	
	if "health" in parent:
		value = parent.health;
		if parent.health != prev_health:
			visible = true;
			prev_health = parent.health;
			timer.start();
	
func _on_timer_timeout():
	visible = false;
