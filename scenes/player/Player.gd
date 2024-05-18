extends CharacterBody2D

const SPEED = 250;
@onready var animation_player: AnimationPlayer = %AnimationPlayer;
const WEAPON = preload("res://scenes/objects/weapons/serrated_sword.tscn"); 
var orientation = 'right';
var in_animation = false;

func _physics_process(delta):
	handle_player_primary()
	if !Player.player:
		Player.player = self;
		var weapon = WEAPON.instantiate();
		Player.player_toolbar['1'] = weapon;
	var primary_attack = Input.is_action_just_pressed('primary_attack');
	var secondary_attack = Input.is_action_just_pressed('secondary_attack');
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down");
	velocity = direction * SPEED;
	if !in_animation:
		move_and_slide();
	
	if primary_attack && animation_player.animation_finished:
		if orientation == 'left':
			in_animation = true;
			animation_player.play('swing_left');
			await animation_player.animation_finished;
			in_animation = false;
		else:
			in_animation = true;
			animation_player.play('swing_right');
			await animation_player.animation_finished;
			in_animation = false;
	
	if !primary_attack && !secondary_attack && !in_animation:
		if direction.x < 0:
			orientation = 'left';
			animation_player.play('run_left');
		elif direction.x > 0:
			orientation = 'right';
			animation_player.play('run_right');
		elif direction.y != 0:
			if orientation == 'left':
				animation_player.play('run_left');
			else:
				animation_player.play('run_right');
		else:
			animation_player.play('idle');
			
func handle_player_primary():
	print(Player.player_toolbar[str(Player.active_tool_slot)]);
	if Player.player_toolbar.has(str(Player.active_tool_slot)) && $PrimaryHand.get_children().size() < 2:
		$PrimaryHand.add_child(Player.player_toolbar[str(Player.active_tool_slot)])
	
	
	
