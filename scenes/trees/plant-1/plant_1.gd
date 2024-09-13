extends StaticBody2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer;
var health: int = 10;
var type := Constants.foliage.WILD_PLANT;
var display_name = 'Weed';

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

func drop_loot():
	Actions.drop_loot("res://scenes/objects/items/fiber/fiber.tscn", 1, 1, global_position, get_parent());
	queue_free();
