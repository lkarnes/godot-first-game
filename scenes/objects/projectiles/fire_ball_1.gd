extends Node2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer;
@onready var mouse_click_position = get_global_mouse_position()
var speed = 500;
var velocity = Vector2.ZERO;
var type: Enums.hit_type = Enums.hit_type.DAMAGE;
var display_name = 'Minor Ball Of Fire'
var cast_type = Enums.cast_type.SHOOT;
var mana_cost = 5;

func _ready():
	animation_player.play('rotate');
	var direction = global_position.direction_to(mouse_click_position)
	velocity = direction * speed
	
func _physics_process(delta):
	position += velocity * delta;

func _on_timer_timeout():
	queue_free();
