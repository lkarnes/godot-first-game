extends CharacterBody2D

const SPEED = 500;
@onready var animation_player: AnimationPlayer = %AnimationPlayer;
var orientation = 'right';

func _physics_process(delta):
	if !Player.player:
		Player.player = self;
	var primary_attack = Input.is_action_pressed('primary_attack');
	var secondary_attack = Input.is_action_pressed('secondary_attack');
	
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down");
	velocity = direction * SPEED;
	move_and_slide();
	
	if primary_attack && animation_player.animation_finished:
		if orientation == 'left':
			animation_player.play('swing_left');
		else:
			animation_player.play('swing_right');
	
	
	
	if !primary_attack && !secondary_attack && animation_player.animation_finished:
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
	
	
