extends StaticBody2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer;
var health: int = 100;

func take_damage(damage):
	health = health - damage;
	
	if health <= 0:
		handle_death();
	else:
		animation_player.play('hit');

func handle_death():
	animation_player.play('death');
	await animation_player.animation_finished;
	drop_loot();
	queue_free();

func drop_loot():
	print('dropping_loot');
	
