extends Node2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer;
@onready var mouse_click_position = get_global_mouse_position()
var speed = 500;
var velocity = Vector2.ZERO;

func _ready():
	animation_player.play('rotate');
	var direction = global_position.direction_to(mouse_click_position)
	velocity = direction * speed
	
func _physics_process(delta):
	position += velocity * delta;


func _on_timer_timeout():
	queue_free();
