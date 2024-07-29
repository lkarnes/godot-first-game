extends CharacterBody2D

const SPEED = 250;
@onready var animation_player: AnimationPlayer = %AnimationPlayer;
const WEAPON = preload("res://scenes/objects/weapons/serrated_sword.tscn"); 
var orientation = 'right';
var in_animation = false;

func _physics_process(delta):
	if !Player.player || !is_instance_valid(Player.player):
		Player.player = self;
		var weapon = WEAPON.instantiate();
		Player.player_toolbar['1'] = weapon;
	var primary_attack = Input.is_action_just_pressed('primary_attack');
	var secondary_attack = Input.is_action_just_pressed('secondary_attack');
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down");
	velocity = direction * SPEED;
	
	var mouse_direction = get_mouse_direction();
	
	if 'left' in mouse_direction:
		orientation = 'left';
	elif 'right' in mouse_direction:
		orientation = 'right';
	if !in_animation:
		var item_in_hand = %PrimaryHand.get_child(0);
		if item_in_hand && item_in_hand.get_node('HitBox'):
			item_in_hand.get_node('HitBox').disabled = true;
		move_and_slide();
	else:
		var item_in_hand = %PrimaryHand.get_child(0);
		if item_in_hand && item_in_hand.get_node('HitBox'):
			item_in_hand.get_node('HitBox').disabled = false;
	handle_animations(primary_attack, secondary_attack, direction);
	
func handle_animations(primary_attack, secondary_attack, direction):
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
	if secondary_attack && animation_player.animation_finished:
		const PROJECTILE = preload('res://scenes/objects/projectiles/fire_ball_1.tscn');
		var projectile = PROJECTILE.instantiate()
		add_child(projectile);
		projectile.global_position = %ProjectileSummonPoint.global_position;
		print('fire: ', projectile.global_position);
	
	if !primary_attack && !secondary_attack && !in_animation:
		if direction.x < 0:
			animation_player.play('run_left');
		elif direction.x > 0:
			animation_player.play('run_right');
		elif direction.y != 0:
			if orientation == 'left':
				animation_player.play('run_left');
			else:
				animation_player.play('run_right');
		else:
			animation_player.play('idle-' + orientation);
	
func get_mouse_direction():
	var mouse_pos = get_global_mouse_position()
	var node_pos = global_position
	var direction = mouse_pos - node_pos;

	if direction.x == 0 and direction.y == 0:
		print("Mouse is at the node position")
		return

	var angle = direction.angle()
	if angle > -PI/8 and angle <= PI/8:
		return 'right';
	elif angle > PI/8 and angle <= 3*PI/8:
		return 'bottom-right';
	elif angle > 3*PI/8 and angle <= 5*PI/8:
		return 'bottom';
	elif angle > 5*PI/8 and angle <= 7*PI/8:
		return 'bottom-left';
	elif angle <= -PI/8 and angle > -3*PI/8:
		return 'top-right';
	elif angle <= -3*PI/8 and angle > -5*PI/8:
		return 'top';
	elif angle <= -5*PI/8 and angle > -7*PI/8:
		return 'top-left';
	else:
		return 'left'
