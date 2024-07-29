extends StaticBody2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer;
var health: int = 10;

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
	var drop_amount = 3;
	for i in range(0,drop_amount):
		const LOOT_MAGNET = preload('res://scenes/objects/helpers/loot_magnet.tscn');
		const FIBER = preload("res://scenes/objects/items/fiber/fiber.tscn");
		var magnet = LOOT_MAGNET.instantiate();
		var fiber = FIBER.instantiate();
		magnet.item = fiber;
		magnet.global_position = global_position;
		get_parent().add_child(magnet);
		queue_free();
