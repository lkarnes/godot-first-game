extends StaticBody2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer;
var health: int = 100;
var type = "foliage";

func take_damage(damage):
	health = health - damage;
	
	if health <= 0:
		handle_death();
	else:
		animation_player.play('hit');

func handle_death():
	animation_player.play('death');
	await animation_player.animation_finished;
	
	var drop_item = Actions.weighted_random_drop(Drops.full_list.foliage.pine);
	if drop_item:
		Actions.drop_loot(drop_item.src, 10, 1, global_position, get_parent());
	queue_free();
	
	
