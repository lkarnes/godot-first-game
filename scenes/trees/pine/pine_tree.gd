extends StaticBody2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer;
@onready var sprite: Sprite2D = %Sprite2D;
var health: int = 100;
var type = "foliage";

func _physics_process(delta):
	if "global_position" in Player.player && global_position.distance_to(Player.player.global_position) < 40 && global_position.y > Player.player.global_position.y:
		sprite.modulate.a = 0.5;
	else:
		sprite.modulate.a = 1;

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
	
	
