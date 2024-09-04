extends Area2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer;
var type = Enums.hit_type.DEBUFF;
var description = 'gives enemy a temporary status effect, 1-8 poison damage per second.'
var disabled = false;
var debuff_object = Debuff.new(range(1,8), 1, 5, Enums.effect_type.POISON);

func _ready():
	animation_player.play("default");
