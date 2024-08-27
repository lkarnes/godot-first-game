extends CharacterBody2D

const SPEED = 250;
@onready var animation_player: AnimationPlayer = %AnimationPlayer;
const WEAPON = preload("res://scenes/objects/weapons/serrated_sword.tscn"); 
var in_animation = false;

func _physics_process(delta):
	if !Player.player || !is_instance_valid(Player.player):
		Player.player = self;
	var primary_attack = Input.is_action_just_pressed('primary_attack');
	var secondary_attack = Input.is_action_just_pressed('secondary_attack');
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down");
	velocity = direction * SPEED;
	
	var mouse_direction = get_mouse_direction();
	
	if 'left' in mouse_direction:
		Player.orientation = 'left';
	elif 'right' in mouse_direction:
		Player.orientation = 'right';
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
	aim_primary();

func aim_primary():
	if !in_animation:
		var mouse_pos = get_global_mouse_position();
		var angle = (mouse_pos - global_position).angle();
		%PrimaryPivot.rotation = angle;

# Create a function to calculate the new position based on the angle
func get_position_for_angle(angle_degrees):
	var angle_radians = deg_to_rad(angle_degrees)
	var radius = 180;
	return global_position + Vector2(radius * cos(angle_radians), radius * sin(angle_radians))

	
func handle_animations(primary_attack, secondary_attack, direction):
	if primary_attack and not in_animation:
		in_animation = true;
		var tween = get_tree().create_tween()
		%PrimaryPivot.rotation = %PrimaryPivot.rotation - 2;
		# Get the current rotation in degrees
		var current_rotation = %PrimaryPivot.rotation - 2;

		# Calculate the target rotation, which is current_rotation + 180 degrees
		var target_rotation = current_rotation + 6;

		# Tween the rotation to the target rotation
		tween.tween_property($PrimaryPivot, "rotation", target_rotation, 0.2)
		tween.play()
		
		# Wait for the tween to finish
		await tween.step_finished
		in_animation = false;
		
	if secondary_attack && animation_player.animation_finished:
		const PROJECTILE = preload('res://scenes/objects/projectiles/fire_ball_1.tscn');
		var projectile = PROJECTILE.instantiate()
		projectile.global_position = %ProjectileSummonPoint.global_position;
		get_parent().add_child(projectile);
	
	if !primary_attack && !secondary_attack && !in_animation:
		if direction.x < 0:
			animation_player.play('run_left');
		elif direction.x > 0:
			animation_player.play('run_right');
		elif direction.y != 0:
			if Player.orientation == 'left':
				animation_player.play('run_left');
			else:
				animation_player.play('run_right');
		else:
			animation_player.play('idle-' + Player.orientation);
	
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
