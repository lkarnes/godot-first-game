extends RigidBody2D

@export var next_scene: PackedScene;
var entered = false;

func _on_player_in_range_body_entered(body):
	entered = true;


func _on_player_in_range_body_exited(body):
	entered = false;
	
	
func _process(delta):
	if Input.is_action_just_pressed("interact") && entered:
		NavFunctions.change_scene(next_scene);
