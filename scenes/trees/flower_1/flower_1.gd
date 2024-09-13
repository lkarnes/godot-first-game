extends StaticBody2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer;
var health: int = 10;
var type := Constants.foliage.WILD_PLANT;
var broken_by := [Constants.tool_type.AXE, Constants.tool_type.HOE, Constants.tool_type.SWORD]
var display_name = 'Tulip';


func take_damage(damage):
	health = health - damage;
	
	if health <= 0:
		handle_death();
	else:
		animation_player.play('hit');

func handle_death():
	animation_player.play('death');
	await animation_player.animation_finished;
	Actions.drop_loot("res://scenes/objects/items/fiber/fiber.tscn", 1, 1, global_position, get_parent());
	queue_free();
