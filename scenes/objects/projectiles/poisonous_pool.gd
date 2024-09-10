extends Area2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer;
@onready var timer: Timer = %Timer;
var type = Enums.hit_type.DEBUFF;
var cast_type = Enums.cast_type.DROP;
var display_name = "Pool of Unholy Blood";
var description = "gives enemy a temporary status effect, 1-8 poison damage per second."
var disabled = false;
var mana_cost = 1;
var debuff_object = Debuff.new(range(1,8), 1, 5, Enums.effect_type.POISON);
var duration: float = 10; 
func _ready():
	timer.wait_time = duration;
	timer.start();
	animation_player.play("default");


func _on_timer_timeout():
	queue_free();
